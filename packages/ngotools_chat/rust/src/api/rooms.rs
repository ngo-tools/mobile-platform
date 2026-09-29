//! Room list driven by `RoomListService` (Simplified Sliding Sync).
//!
//! The list is streamed as diffs (`RoomListDiff`, 1:1 to `VectorDiff`), so
//! the app applies small changes instead of receiving the whole list. Filter
//! and paging commands reach the list task through a channel, which keeps the
//! SDK's dynamic-entries controller inside that task.

use futures_util::{pin_mut, StreamExt};
use matrix_sdk::RoomState;
use matrix_sdk_ui::{
    room_list_service::{
        filters::{
            new_filter_all, new_filter_category, new_filter_deduplicate_versions,
            new_filter_invite, new_filter_joined, new_filter_non_left, new_filter_read_receipts,
            BoxedFilterFn, ReadReceiptsCategory, RoomCategory,
        },
        RoomListItem,
    },
    timeline::{LatestEventValue, RoomExt, TimelineDetails},
};
use tokio::sync::mpsc;

use crate::{
    api::{
        client::ChatClient,
        error::ChatError,
        timeline::{message_preview, MessagePreview},
    },
    frb_generated::StreamSink,
    runtime::runtime,
};

const PAGE_SIZE: usize = 50;

pub enum RoomFilter {
    /// Joined rooms and invites.
    All,
    /// Direct messages.
    People,
    /// Group and event rooms.
    Groups,
    Invites,
    /// Rooms with unread messages.
    Unread,
}

pub enum RoomKind {
    Direct,
    Group,
}

pub enum Membership {
    Joined,
    Invited,
}

pub struct LatestEvent {
    pub sender_id: String,
    pub sender_name: Option<String>,
    pub is_own: bool,
    pub timestamp_ms: i64,
    pub preview: MessagePreview,
    /// A local echo that is still being sent or failed to send.
    pub is_unsent: bool,
}

pub struct RoomSummary {
    pub id: String,
    pub name: String,
    /// `mxc://` URI of the room avatar (fetch via the media API).
    pub avatar_url: Option<String>,
    pub kind: RoomKind,
    pub membership: Membership,
    pub is_encrypted: bool,
    pub unread_messages: u32,
    pub unread_mentions: u32,
    pub latest: Option<LatestEvent>,
}

pub enum RoomListDiff {
    Append { values: Vec<RoomSummary> },
    Clear,
    PushFront { value: RoomSummary },
    PushBack { value: RoomSummary },
    PopFront,
    PopBack,
    Insert { index: u32, value: RoomSummary },
    Set { index: u32, value: RoomSummary },
    Remove { index: u32 },
    Truncate { length: u32 },
    Reset { values: Vec<RoomSummary> },
}

pub(crate) enum RoomListCommand {
    Filter(RoomFilter),
    LoadMore,
}

impl ChatClient {
    /// Streams the room list as diffs. The first batch resets the list.
    /// Starting a new watch replaces the previous one.
    pub async fn watch_room_list(
        &self,
        sink: StreamSink<Vec<RoomListDiff>>,
    ) -> Result<(), ChatError> {
        let service = self.sync_service().await?;
        let (commands, mut command_receiver) = mpsc::unbounded_channel();
        let task = runtime().spawn(async move {
            let room_list_service = service.room_list_service();
            let all_rooms = match room_list_service.all_rooms().await {
                Ok(all_rooms) => all_rooms,
                Err(error) => {
                    tracing::error!("room list unavailable: {error}");
                    return;
                }
            };
            let (stream, controller) = all_rooms.entries_with_dynamic_adapters(PAGE_SIZE);
            controller.set_filter(filter_for(RoomFilter::All));
            pin_mut!(stream);

            loop {
                tokio::select! {
                    diffs = stream.next() => {
                        let Some(diffs) = diffs else { break };
                        let mut mapped = Vec::with_capacity(diffs.len());
                        for diff in diffs {
                            mapped.push(map_diff(diff).await);
                        }
                        if sink.add(mapped).is_err() {
                            break;
                        }
                    }
                    command = command_receiver.recv() => match command {
                        Some(RoomListCommand::Filter(filter)) => {
                            controller.set_filter(filter_for(filter));
                        }
                        Some(RoomListCommand::LoadMore) => controller.add_one_page(),
                        None => break,
                    },
                }
            }
        });

        *self.room_commands.lock().await = Some(commands);
        if let Some(previous) = self.room_task.lock().await.replace(task) {
            previous.abort();
        }
        Ok(())
    }

    /// Stops the room list stream; the Dart stream ends.
    pub async fn stop_room_list(&self) {
        self.room_commands.lock().await.take();
        if let Some(task) = self.room_task.lock().await.take() {
            task.abort();
        }
    }

    pub async fn set_room_filter(&self, filter: RoomFilter) -> Result<(), ChatError> {
        self.send_room_command(RoomListCommand::Filter(filter))
            .await
    }

    /// Extends the visible room list by one page.
    pub async fn load_more_rooms(&self) -> Result<(), ChatError> {
        self.send_room_command(RoomListCommand::LoadMore).await
    }

    async fn send_room_command(&self, command: RoomListCommand) -> Result<(), ChatError> {
        self.room_commands
            .lock()
            .await
            .as_ref()
            .ok_or_else(|| ChatError::invalid("room list is not being watched"))?
            .send(command)
            .map_err(|_| ChatError::invalid("room list is not being watched"))
    }
}

fn filter_for(filter: RoomFilter) -> BoxedFilterFn {
    let visible: BoxedFilterFn = Box::new(new_filter_all(vec![
        Box::new(new_filter_non_left()),
        Box::new(new_filter_deduplicate_versions()),
    ]));
    let specific: BoxedFilterFn = match filter {
        RoomFilter::All => return visible,
        RoomFilter::People => Box::new(new_filter_category(RoomCategory::People)),
        RoomFilter::Groups => Box::new(new_filter_category(RoomCategory::Group)),
        RoomFilter::Invites => return Box::new(new_filter_invite()),
        RoomFilter::Unread => Box::new(new_filter_all(vec![
            Box::new(new_filter_joined()),
            Box::new(new_filter_read_receipts(ReadReceiptsCategory::Messages)),
        ])),
    };
    Box::new(new_filter_all(vec![visible, specific]))
}

async fn map_diff(diff: eyeball_im::VectorDiff<RoomListItem>) -> RoomListDiff {
    use eyeball_im::VectorDiff;

    match diff {
        VectorDiff::Append { values } => RoomListDiff::Append {
            values: summarize_all(values.iter()).await,
        },
        VectorDiff::Clear => RoomListDiff::Clear,
        VectorDiff::PushFront { value } => RoomListDiff::PushFront {
            value: summarize(&value).await,
        },
        VectorDiff::PushBack { value } => RoomListDiff::PushBack {
            value: summarize(&value).await,
        },
        VectorDiff::PopFront => RoomListDiff::PopFront,
        VectorDiff::PopBack => RoomListDiff::PopBack,
        VectorDiff::Insert { index, value } => RoomListDiff::Insert {
            index: to_u32(index),
            value: summarize(&value).await,
        },
        VectorDiff::Set { index, value } => RoomListDiff::Set {
            index: to_u32(index),
            value: summarize(&value).await,
        },
        VectorDiff::Remove { index } => RoomListDiff::Remove {
            index: to_u32(index),
        },
        VectorDiff::Truncate { length } => RoomListDiff::Truncate {
            length: to_u32(length),
        },
        VectorDiff::Reset { values } => RoomListDiff::Reset {
            values: summarize_all(values.iter()).await,
        },
    }
}

async fn summarize_all<'a>(rooms: impl Iterator<Item = &'a RoomListItem>) -> Vec<RoomSummary> {
    let mut summaries = Vec::new();
    for room in rooms {
        summaries.push(summarize(room).await);
    }
    summaries
}

/// Only uses stored room data: `Room::is_direct().await` blocks for invites,
/// so DMs are detected via the cached direct targets.
async fn summarize(room: &RoomListItem) -> RoomSummary {
    let name = room
        .cached_display_name()
        .map(|name| name.to_string())
        .unwrap_or_else(|| room.room_id().to_string());

    RoomSummary {
        id: room.room_id().to_string(),
        name,
        avatar_url: room.avatar_url().map(|url| url.to_string()),
        kind: if room.direct_targets_length() > 0 {
            RoomKind::Direct
        } else {
            RoomKind::Group
        },
        membership: if room.state() == RoomState::Invited {
            Membership::Invited
        } else {
            Membership::Joined
        },
        is_encrypted: room.encryption_state().is_encrypted(),
        unread_messages: to_u32(room.num_unread_messages()),
        unread_mentions: to_u32(room.num_unread_mentions()),
        latest: latest_event(room).await,
    }
}

async fn latest_event(room: &RoomListItem) -> Option<LatestEvent> {
    match room.latest_event().await {
        LatestEventValue::None | LatestEventValue::RemoteInvite { .. } => None,
        LatestEventValue::Remote {
            timestamp,
            sender,
            is_own,
            profile,
            content,
        } => Some(LatestEvent {
            sender_id: sender.to_string(),
            sender_name: display_name(&profile),
            is_own,
            timestamp_ms: i64::from(timestamp.0),
            preview: message_preview(&content),
            is_unsent: false,
        }),
        LatestEventValue::Local {
            timestamp,
            sender,
            profile,
            content,
            state,
        } => Some(LatestEvent {
            sender_id: sender.to_string(),
            sender_name: display_name(&profile),
            is_own: true,
            timestamp_ms: i64::from(timestamp.0),
            preview: message_preview(&content),
            is_unsent: !matches!(
                state,
                matrix_sdk_ui::timeline::LatestEventValueLocalState::HasBeenSent
            ),
        }),
    }
}

fn display_name(profile: &TimelineDetails<matrix_sdk_ui::timeline::Profile>) -> Option<String> {
    match profile {
        TimelineDetails::Ready(profile) => profile.display_name.clone(),
        _ => None,
    }
}

fn to_u32<T: TryInto<u32>>(value: T) -> u32 {
    value.try_into().unwrap_or(u32::MAX)
}
