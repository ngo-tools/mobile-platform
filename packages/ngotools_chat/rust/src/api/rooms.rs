//! Room list driven by `RoomListService` (Simplified Sliding Sync).
//!
//! The list is streamed as diffs (`RoomListDiff`, 1:1 to `VectorDiff`), so
//! the app applies small changes instead of receiving the whole list. Filter
//! and paging commands reach the list task through a channel, which keeps the
//! SDK's dynamic-entries controller inside that task.

use eyeball_im::Vector;
use futures_util::{pin_mut, StreamExt};
use matrix_sdk::{notification_settings::NotificationSettings, RoomState};
use matrix_sdk_ui::{
    room_list_service::{
        filters::{
            new_filter_all, new_filter_category, new_filter_deduplicate_versions,
            new_filter_invite, new_filter_joined, new_filter_read_receipts, BoxedFilterFn,
            ReadReceiptsCategory, RoomCategory,
        },
        RoomListItem,
    },
    timeline::{LatestEventValue, RoomExt, TimelineDetails},
};
use tokio::sync::{broadcast, mpsc};

use crate::{
    api::{
        client::ChatClient,
        error::ChatError,
        room::{from_sdk, NotificationMode},
        timeline::{message_preview, MessagePreview},
    },
    frb_generated::StreamSink,
    runtime::runtime,
};

const PAGE_SIZE: usize = 50;

#[derive(Clone, Copy)]
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
    /// Mode set by the user for this room; `None` follows the default.
    pub notification_mode: Option<NotificationMode>,
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

/// A running room list watch.
pub(crate) struct RoomListWatch {
    task: tokio::task::JoinHandle<()>,
    commands: mpsc::UnboundedSender<RoomListCommand>,
}

pub(crate) enum RoomListCommand {
    Filter(RoomFilter),
    LoadMore,
    /// Applies the active filter again: the SDK does not re-filter a room
    /// this device just left.
    Refilter,
}

impl ChatClient {
    /// Streams the room list as diffs. The first batch resets the list.
    /// Several lists may run at once, each with its own filter and paging,
    /// identified by [watch_id]; starting a watch with a used id replaces it.
    pub async fn watch_room_list(
        &self,
        watch_id: u64,
        sink: StreamSink<Vec<RoomListDiff>>,
    ) -> Result<(), ChatError> {
        let service = self.sync_service().await?;
        let client = self.client.clone();
        let settings = self.notification_settings.clone();
        let (commands, mut command_receiver) = mpsc::unbounded_channel();
        let task = runtime().spawn(async move {
            // Notification modes do not trigger room list updates in the SDK:
            // mirror the visible rooms and re-emit them when the push rules
            // change (on this device or via sync).
            let mut settings_changes = settings
                .get_or_init(|| async { client.notification_settings().await })
                .await
                .subscribe_to_changes();
            let mut settings_open = true;
            // The SDK's list does not drop rooms this account left (declined,
            // left or was removed): re-apply the filter when a sync reports
            // left rooms.
            let mut room_updates = client.subscribe_to_all_room_updates();
            let mut room_updates_open = true;
            let mut visible = Vector::new();
            let room_list_service = service.room_list_service();
            let all_rooms = match room_list_service.all_rooms().await {
                Ok(all_rooms) => all_rooms,
                Err(error) => {
                    tracing::error!("room list unavailable: {error}");
                    return;
                }
            };
            let (stream, controller) = all_rooms.entries_with_dynamic_adapters(PAGE_SIZE);
            let mut active_filter = RoomFilter::All;
            controller.set_filter(filter_for(active_filter));
            pin_mut!(stream);

            loop {
                tokio::select! {
                    diffs = stream.next() => {
                        let Some(diffs) = diffs else {
                            tracing::debug!("room list: entries stream ended");
                            break;
                        };
                        let mut mapped = Vec::with_capacity(diffs.len());
                        for diff in diffs {
                            diff.clone().apply(&mut visible);
                            mapped.push(map_diff(diff).await);
                        }
                        if sink.add(mapped).is_err() {
                            tracing::debug!("room list: sink closed");
                            break;
                        }
                    }
                    change = settings_changes.recv(), if settings_open => {
                        if matches!(change, Err(broadcast::error::RecvError::Closed)) {
                            settings_open = false;
                            continue;
                        }
                        let settings = settings.get().expect("initialized above");
                        for room in &visible {
                            refresh_notification_mode(settings, room).await;
                        }
                        let reset = RoomListDiff::Reset {
                            values: summarize_all(visible.iter()).await,
                        };
                        if sink.add(vec![reset]).is_err() {
                            break;
                        }
                    }
                    update = room_updates.recv(), if room_updates_open => match update {
                        Ok(update) if !update.left.is_empty() => {
                            tracing::debug!(left = update.left.len(), "room list: refilter after sync");
                            controller.set_filter(filter_for(active_filter));
                        }
                        Ok(_) => {}
                        Err(broadcast::error::RecvError::Lagged(_)) => {
                            controller.set_filter(filter_for(active_filter));
                        }
                        Err(broadcast::error::RecvError::Closed) => room_updates_open = false,
                    },
                    command = command_receiver.recv() => match command {
                        Some(RoomListCommand::Filter(filter)) => {
                            active_filter = filter;
                            controller.set_filter(filter_for(filter));
                        }
                        Some(RoomListCommand::Refilter) => {
                            tracing::debug!("room list: refilter after leave");
                            controller.set_filter(filter_for(active_filter));
                        }
                        Some(RoomListCommand::LoadMore) => controller.add_one_page(),
                        None => {
                            tracing::debug!("room list: command channel closed");
                            break;
                        }
                    },
                }
            }
        });

        let previous = self
            .room_lists
            .lock()
            .await
            .insert(watch_id, RoomListWatch { task, commands });
        if let Some(previous) = previous {
            previous.task.abort();
        }
        Ok(())
    }

    /// Stops a room list stream; its Dart stream ends.
    pub async fn stop_room_list(&self, watch_id: u64) {
        if let Some(watch) = self.room_lists.lock().await.remove(&watch_id) {
            watch.task.abort();
        }
    }

    /// Stops all room list streams.
    pub(crate) async fn stop_room_lists(&self) {
        for (_, watch) in self.room_lists.lock().await.drain() {
            watch.task.abort();
        }
    }

    pub async fn set_room_filter(
        &self,
        watch_id: u64,
        filter: RoomFilter,
    ) -> Result<(), ChatError> {
        self.send_room_command(watch_id, RoomListCommand::Filter(filter))
            .await
    }

    /// Extends the visible room list by one page.
    pub async fn load_more_rooms(&self, watch_id: u64) -> Result<(), ChatError> {
        self.send_room_command(watch_id, RoomListCommand::LoadMore)
            .await
    }

    /// Re-filters all watched room lists.
    pub(crate) async fn refilter_room_lists(&self) {
        for watch in self.room_lists.lock().await.values() {
            let _ = watch.commands.send(RoomListCommand::Refilter);
        }
    }

    async fn send_room_command(
        &self,
        watch_id: u64,
        command: RoomListCommand,
    ) -> Result<(), ChatError> {
        self.room_lists
            .lock()
            .await
            .get(&watch_id)
            .ok_or_else(|| ChatError::invalid("room list is not being watched"))?
            .commands
            .send(command)
            .map_err(|_| ChatError::invalid("room list is not being watched"))
    }
}

async fn refresh_notification_mode(settings: &NotificationSettings, room: &RoomListItem) {
    match settings
        .get_user_defined_room_notification_mode(room.room_id())
        .await
    {
        Some(mode) => room.update_cached_user_defined_notification_mode(mode),
        None => room.clear_user_defined_notification_mode(),
    }
}

/// Like the SDK's non-left filter, but on the live room state: the SDK's
/// cached state does not change when this device leaves or declines a room.
fn not_left(room: &RoomListItem) -> bool {
    !matches!(room.state(), RoomState::Left | RoomState::Banned)
}

pub(crate) fn filter_for(filter: RoomFilter) -> BoxedFilterFn {
    let visible: BoxedFilterFn = Box::new(new_filter_all(vec![
        Box::new(not_left),
        Box::new(new_filter_deduplicate_versions()),
    ]));
    let specific: BoxedFilterFn = match filter {
        RoomFilter::All => return visible,
        RoomFilter::People => Box::new(new_filter_category(RoomCategory::People)),
        RoomFilter::Groups => Box::new(new_filter_category(RoomCategory::Group)),
        RoomFilter::Invites => Box::new(new_filter_invite()),
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
        notification_mode: room.cached_user_defined_notification_mode().map(from_sdk),
    }
}

/// Longest wait for a latest event: a stuck lookup must not stall the whole
/// room list.
const LATEST_EVENT_TIMEOUT: std::time::Duration = std::time::Duration::from_millis(500);

async fn latest_event(room: &RoomListItem) -> Option<LatestEvent> {
    let Ok(latest) = tokio::time::timeout(LATEST_EVENT_TIMEOUT, room.latest_event()).await else {
        tracing::warn!(room_id = %room.room_id(), "room list: latest event timed out");
        return None;
    };

    match latest {
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
