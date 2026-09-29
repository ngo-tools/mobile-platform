//! Room timelines: items streamed as diffs, back pagination and message
//! actions (send, reply, edit, redact, react, retry/cancel failed sends).

use std::{path::PathBuf, sync::Arc};

use flutter_rust_bridge::frb;
use futures_util::{pin_mut, StreamExt};
use matrix_sdk::{
    room::edit::EditedContent,
    ruma::{
        api::client::receipt::create_receipt::v3::ReceiptType,
        events::room::message::{
            MessageType, RoomMessageEventContentWithoutRelation, TextMessageEventContent,
        },
        EventId, OwnedEventId, OwnedTransactionId, OwnedUserId, RoomId, UserId,
    },
};
use matrix_sdk_ui::timeline::{
    AttachmentConfig, AttachmentSource, EmbeddedEvent, EventSendState, EventTimelineItem,
    MembershipChange, MsgLikeContent, MsgLikeKind, Profile, RoomExt, Timeline, TimelineDetails,
    TimelineEventItemId, TimelineFocus, TimelineItem as SdkTimelineItem, TimelineItemContent,
    TimelineItemKind as SdkTimelineItemKind, VirtualTimelineItem,
};
use tokio::{sync::Mutex, task::JoinHandle};

use crate::{
    api::{client::ChatClient, error::ChatError},
    frb_generated::StreamSink,
    runtime::{on_runtime, runtime, DropInRuntime},
};

/// Short, localizable description of a message (room list, notifications,
/// reply previews).
#[derive(Clone, Debug, PartialEq)]
pub enum MessagePreview {
    Text {
        body: String,
    },
    Image,
    Video,
    Audio,
    File,
    Location,
    Poll,
    Sticker,
    Redacted,
    UnableToDecrypt,
    /// State changes and anything the app does not render as a message.
    Other,
}

/// Identifies an event for actions: a local echo by its transaction id, a
/// remote event by its event id.
#[derive(Clone, Debug, PartialEq)]
pub enum EventKey {
    Local { transaction_id: String },
    Remote { event_id: String },
}

pub struct TimelineItem {
    /// Stable id of the item across diffs.
    pub id: String,
    pub kind: TimelineItemKind,
}

// Items are serialized across the FFI boundary; boxing would not save memory.
#[allow(clippy::large_enum_variant)]
pub enum TimelineItemKind {
    Event { event: EventItem },
    DateDivider { timestamp_ms: i64 },
    ReadMarker,
    TimelineStart,
}

pub struct EventItem {
    pub key: EventKey,
    pub event_id: Option<String>,
    pub sender: Sender,
    pub timestamp_ms: i64,
    pub is_own: bool,
    pub can_edit: bool,
    pub can_reply: bool,
    pub send_state: SendState,
    pub content: EventContent,
    pub reply_to: Option<ReplyPreview>,
    pub reactions: Vec<Reaction>,
    pub is_edited: bool,
    /// Set when this event belongs to a thread (event id of the root).
    pub thread_root: Option<String>,
    /// Set on a thread root: number of replies and the latest reply.
    pub thread: Option<ThreadSummary>,
}

pub struct Sender {
    pub id: String,
    pub name: Option<String>,
    /// `mxc://` URI of the avatar.
    pub avatar_url: Option<String>,
}

pub enum SendState {
    Sending,
    Sent,
    Failed { recoverable: bool },
}

pub enum EventContent {
    Text {
        body: String,
    },
    Image {
        caption: Option<String>,
        filename: String,
        /// Opaque media reference for the media API.
        media: String,
        width: Option<u32>,
        height: Option<u32>,
    },
    Video {
        caption: Option<String>,
        filename: String,
        media: String,
    },
    Audio {
        filename: String,
        media: String,
    },
    File {
        caption: Option<String>,
        filename: String,
        media: String,
        size: Option<u64>,
    },
    Redacted,
    UnableToDecrypt,
    Membership {
        user_id: String,
        change: MembershipKind,
    },
    ProfileChange {
        user_id: String,
    },
    RoomState {
        event_type: String,
    },
    Unsupported,
}

pub enum MembershipKind {
    Joined,
    Left,
    Invited,
    InvitationAccepted,
    InvitationRejected,
    Kicked,
    Banned,
    Other,
}

pub struct ReplyPreview {
    pub event_id: String,
    /// `None` until the replied-to event is loaded (see `load_reply_details`).
    pub sender: Option<Sender>,
    pub preview: Option<MessagePreview>,
}

pub struct Reaction {
    pub key: String,
    pub count: u32,
    pub by_me: bool,
}

pub struct ThreadSummary {
    pub reply_count: u32,
    pub latest_sender: Option<Sender>,
    pub latest_preview: Option<MessagePreview>,
}

pub enum TimelineDiff {
    Append { values: Vec<TimelineItem> },
    Clear,
    PushFront { value: TimelineItem },
    PushBack { value: TimelineItem },
    PopFront,
    PopBack,
    Insert { index: u32, value: TimelineItem },
    Set { index: u32, value: TimelineItem },
    Remove { index: u32 },
    Truncate { length: u32 },
    Reset { values: Vec<TimelineItem> },
}

/// The timeline of one room (later also of one thread).
#[frb(opaque)]
pub struct ChatTimeline {
    timeline: DropInRuntime<Arc<Timeline>>,
    own_user_id: OwnedUserId,
    watch_task: Mutex<Option<JoinHandle<()>>>,
}

impl ChatClient {
    /// Opens the live timeline of a room.
    pub async fn timeline(&self, room_id: String) -> Result<ChatTimeline, ChatError> {
        let room_id =
            RoomId::parse(&room_id).map_err(|error| ChatError::invalid(error.to_string()))?;
        let client = self.client.clone();
        let own_user_id = client
            .user_id()
            .ok_or(ChatError::SessionExpired)?
            .to_owned();
        let timeline = on_runtime(async move {
            let room = client.get_room(&room_id).ok_or(ChatError::NotFound)?;
            // Thread replies appear as summaries on their root and in the
            // thread timeline, not in the main timeline.
            let timeline = room
                .timeline_builder()
                .with_focus(TimelineFocus::Live {
                    hide_threaded_events: true,
                })
                .build()
                .await?;
            Ok(Arc::new(timeline))
        })
        .await?;

        Ok(ChatTimeline {
            timeline: DropInRuntime::new(timeline),
            own_user_id,
            watch_task: Mutex::new(None),
        })
    }

    /// Opens the timeline of one thread; messages sent through it (including
    /// replies) are sent into the thread.
    pub async fn thread_timeline(
        &self,
        room_id: String,
        root_event_id: String,
    ) -> Result<ChatTimeline, ChatError> {
        let room_id =
            RoomId::parse(&room_id).map_err(|error| ChatError::invalid(error.to_string()))?;
        let root_event_id = parse_event_id(&root_event_id)?;
        let client = self.client.clone();
        let own_user_id = client
            .user_id()
            .ok_or(ChatError::SessionExpired)?
            .to_owned();
        let timeline = on_runtime(async move {
            let room = client.get_room(&room_id).ok_or(ChatError::NotFound)?;
            let timeline = room
                .timeline_builder()
                .with_focus(TimelineFocus::Thread { root_event_id })
                .build()
                .await?;
            Ok(Arc::new(timeline))
        })
        .await?;

        Ok(ChatTimeline {
            timeline: DropInRuntime::new(timeline),
            own_user_id,
            watch_task: Mutex::new(None),
        })
    }
}

impl ChatTimeline {
    /// Streams the timeline as diffs; the first batch resets the list.
    /// Starting a new watch replaces the previous one.
    pub async fn watch(&self, sink: StreamSink<Vec<TimelineDiff>>) -> Result<(), ChatError> {
        let timeline = self.timeline.clone();
        let own_user_id = self.own_user_id.clone();
        let task = runtime().spawn(async move {
            let (initial, stream) = timeline.subscribe().await;
            let reset = TimelineDiff::Reset {
                values: initial
                    .iter()
                    .map(|item| map_item(item, &own_user_id))
                    .collect(),
            };
            if sink.add(vec![reset]).is_err() {
                return;
            }
            pin_mut!(stream);
            while let Some(diffs) = stream.next().await {
                let mapped = diffs
                    .into_iter()
                    .map(|diff| map_diff(diff, &own_user_id))
                    .collect();
                if sink.add(mapped).is_err() {
                    break;
                }
            }
        });
        if let Some(previous) = self.watch_task.lock().await.replace(task) {
            previous.abort();
        }
        Ok(())
    }

    /// Loads older events; returns true when the start of the room was reached.
    pub async fn paginate_back(&self, count: u16) -> Result<bool, ChatError> {
        let timeline = self.timeline.clone();
        on_runtime(async move { Ok(timeline.paginate_backwards(count).await?) }).await
    }

    /// Sends a plain-text message, optionally as a reply to `reply_to`.
    pub async fn send_text(&self, body: String, reply_to: Option<String>) -> Result<(), ChatError> {
        let reply_to = reply_to
            .map(|event_id| parse_event_id(&event_id))
            .transpose()?;
        let timeline = self.timeline.clone();
        on_runtime(async move {
            let content = RoomMessageEventContentWithoutRelation::text_plain(body);
            match reply_to {
                Some(event_id) => {
                    timeline.send_reply(content, event_id).await?;
                }
                None => {
                    timeline.send(content.with_relation(None).into()).await?;
                }
            }
            Ok(())
        })
        .await
    }

    pub async fn send_image(
        &self,
        file_path: String,
        mime_type: String,
        caption: Option<String>,
    ) -> Result<(), ChatError> {
        let mime: mime::Mime = mime_type
            .parse()
            .map_err(|_| ChatError::invalid("invalid mime type"))?;
        let timeline = self.timeline.clone();
        on_runtime(async move {
            let config = AttachmentConfig {
                caption: caption.map(TextMessageEventContent::plain),
                ..AttachmentConfig::default()
            };
            timeline
                .send_attachment(
                    AttachmentSource::File(PathBuf::from(file_path)),
                    mime,
                    config,
                )
                .await?;
            Ok(())
        })
        .await
    }

    /// Replaces the text of an own message.
    pub async fn edit(&self, key: EventKey, body: String) -> Result<(), ChatError> {
        let id = item_id(&key)?;
        let timeline = self.timeline.clone();
        on_runtime(async move {
            let content = RoomMessageEventContentWithoutRelation::text_plain(body);
            timeline
                .edit(&id, EditedContent::RoomMessage(content))
                .await?;
            Ok(())
        })
        .await
    }

    /// Deletes a message (own messages, or others' with moderation rights).
    pub async fn redact(&self, key: EventKey, reason: Option<String>) -> Result<(), ChatError> {
        let id = item_id(&key)?;
        let timeline = self.timeline.clone();
        on_runtime(async move {
            timeline.redact(&id, reason.as_deref()).await?;
            Ok(())
        })
        .await
    }

    /// Adds or removes an own reaction; returns true if it is now set.
    pub async fn toggle_reaction(
        &self,
        key: EventKey,
        reaction: String,
    ) -> Result<bool, ChatError> {
        let id = item_id(&key)?;
        let timeline = self.timeline.clone();
        on_runtime(async move { Ok(timeline.toggle_reaction(&id, &reaction).await?) }).await
    }

    /// Retries a local echo whose sending failed.
    pub async fn retry(&self, key: EventKey) -> Result<(), ChatError> {
        let handle = self.send_handle(&key).await?;
        on_runtime(async move {
            handle.unwedge().await?;
            Ok(())
        })
        .await
    }

    /// Cancels a pending or failed local echo; returns false if it was
    /// already sent.
    pub async fn cancel(&self, key: EventKey) -> Result<bool, ChatError> {
        let handle = self.send_handle(&key).await?;
        on_runtime(async move { Ok(handle.abort().await?) }).await
    }

    /// Moves the read receipt to the latest event.
    pub async fn mark_read(&self) -> Result<(), ChatError> {
        let timeline = self.timeline.clone();
        on_runtime(async move {
            timeline.mark_as_read(ReceiptType::Read).await?;
            Ok(())
        })
        .await
    }

    /// Loads the replied-to event of `event_id` so that its `reply_to`
    /// preview gets sender and content (arrives as a diff).
    pub async fn load_reply_details(&self, event_id: String) -> Result<(), ChatError> {
        let event_id = parse_event_id(&event_id)?;
        let timeline = self.timeline.clone();
        on_runtime(async move {
            timeline.fetch_details_for_event(&event_id).await?;
            Ok(())
        })
        .await
    }

    /// Stops streaming; the timeline can be watched again later.
    pub async fn close(&self) {
        if let Some(task) = self.watch_task.lock().await.take() {
            task.abort();
        }
    }

    async fn send_handle(
        &self,
        key: &EventKey,
    ) -> Result<matrix_sdk::send_queue::SendHandle, ChatError> {
        let EventKey::Local { transaction_id } = key else {
            return Err(ChatError::invalid(
                "only local echoes can be retried or cancelled",
            ));
        };
        let transaction_id: OwnedTransactionId = transaction_id.as_str().into();
        let items = self.timeline.items().await;
        items
            .iter()
            .filter_map(|item| item.as_event())
            .find(|event| event.transaction_id() == Some(&*transaction_id))
            .and_then(EventTimelineItem::local_echo_send_handle)
            .ok_or(ChatError::NotFound)
    }
}

impl Drop for ChatTimeline {
    fn drop(&mut self) {
        if let Ok(mut task) = self.watch_task.try_lock() {
            if let Some(task) = task.take() {
                task.abort();
            }
        }
    }
}

pub(crate) fn parse_event_id(event_id: &str) -> Result<OwnedEventId, ChatError> {
    EventId::parse(event_id).map_err(|error| ChatError::invalid(error.to_string()))
}

fn item_id(key: &EventKey) -> Result<TimelineEventItemId, ChatError> {
    Ok(match key {
        EventKey::Local { transaction_id } => {
            TimelineEventItemId::TransactionId(transaction_id.as_str().into())
        }
        EventKey::Remote { event_id } => TimelineEventItemId::EventId(parse_event_id(event_id)?),
    })
}

pub(crate) fn message_preview(content: &TimelineItemContent) -> MessagePreview {
    let TimelineItemContent::MsgLike(msg_like) = content else {
        return MessagePreview::Other;
    };
    match &msg_like.kind {
        MsgLikeKind::Message(message) => match message.msgtype() {
            MessageType::Image(_) => MessagePreview::Image,
            MessageType::Video(_) => MessagePreview::Video,
            MessageType::Audio(_) => MessagePreview::Audio,
            MessageType::File(_) => MessagePreview::File,
            MessageType::Location(_) => MessagePreview::Location,
            _ => MessagePreview::Text {
                body: message.body().to_owned(),
            },
        },
        MsgLikeKind::Sticker(_) => MessagePreview::Sticker,
        MsgLikeKind::Poll(_) => MessagePreview::Poll,
        MsgLikeKind::Redacted => MessagePreview::Redacted,
        MsgLikeKind::UnableToDecrypt(_) => MessagePreview::UnableToDecrypt,
        _ => MessagePreview::Other,
    }
}

fn map_diff(
    diff: eyeball_im::VectorDiff<Arc<SdkTimelineItem>>,
    own_user_id: &UserId,
) -> TimelineDiff {
    use eyeball_im::VectorDiff;

    let map = |item: &SdkTimelineItem| map_item(item, own_user_id);
    match diff {
        VectorDiff::Append { values } => TimelineDiff::Append {
            values: values.iter().map(|item| map(item)).collect(),
        },
        VectorDiff::Clear => TimelineDiff::Clear,
        VectorDiff::PushFront { value } => TimelineDiff::PushFront { value: map(&value) },
        VectorDiff::PushBack { value } => TimelineDiff::PushBack { value: map(&value) },
        VectorDiff::PopFront => TimelineDiff::PopFront,
        VectorDiff::PopBack => TimelineDiff::PopBack,
        VectorDiff::Insert { index, value } => TimelineDiff::Insert {
            index: to_u32(index),
            value: map(&value),
        },
        VectorDiff::Set { index, value } => TimelineDiff::Set {
            index: to_u32(index),
            value: map(&value),
        },
        VectorDiff::Remove { index } => TimelineDiff::Remove {
            index: to_u32(index),
        },
        VectorDiff::Truncate { length } => TimelineDiff::Truncate {
            length: to_u32(length),
        },
        VectorDiff::Reset { values } => TimelineDiff::Reset {
            values: values.iter().map(|item| map(item)).collect(),
        },
    }
}

pub(crate) fn map_item(item: &SdkTimelineItem, own_user_id: &UserId) -> TimelineItem {
    let id = item.unique_id().0.clone();
    let kind = match item.kind() {
        SdkTimelineItemKind::Virtual(VirtualTimelineItem::DateDivider(ts)) => {
            TimelineItemKind::DateDivider {
                timestamp_ms: i64::from(ts.0),
            }
        }
        SdkTimelineItemKind::Virtual(VirtualTimelineItem::ReadMarker) => {
            TimelineItemKind::ReadMarker
        }
        SdkTimelineItemKind::Virtual(VirtualTimelineItem::TimelineStart) => {
            TimelineItemKind::TimelineStart
        }
        SdkTimelineItemKind::Event(event) => TimelineItemKind::Event {
            event: map_event(event, own_user_id),
        },
    };
    TimelineItem { id, kind }
}

fn map_event(event: &EventTimelineItem, own_user_id: &UserId) -> EventItem {
    let key = match event.identifier() {
        TimelineEventItemId::TransactionId(transaction_id) => EventKey::Local {
            transaction_id: transaction_id.to_string(),
        },
        TimelineEventItemId::EventId(event_id) => EventKey::Remote {
            event_id: event_id.to_string(),
        },
    };
    let msg_like = match event.content() {
        TimelineItemContent::MsgLike(msg_like) => Some(msg_like),
        _ => None,
    };

    EventItem {
        key,
        event_id: event.event_id().map(ToString::to_string),
        sender: sender(event.sender(), event.sender_profile()),
        timestamp_ms: i64::from(event.timestamp().0),
        is_own: event.is_own(),
        can_edit: event.is_editable(),
        can_reply: event.can_be_replied_to(),
        send_state: match event.send_state() {
            None | Some(EventSendState::Sent { .. }) => SendState::Sent,
            Some(EventSendState::NotSentYet { .. }) => SendState::Sending,
            Some(EventSendState::SendingFailed { is_recoverable, .. }) => SendState::Failed {
                recoverable: *is_recoverable,
            },
        },
        content: event_content(event.content()),
        reply_to: msg_like.and_then(reply_preview),
        reactions: msg_like
            .map(|msg_like| reactions(msg_like, own_user_id))
            .unwrap_or_default(),
        is_edited: msg_like.is_some_and(|msg_like| match &msg_like.kind {
            MsgLikeKind::Message(message) => message.is_edited(),
            _ => false,
        }),
        thread_root: msg_like
            .and_then(|msg_like| msg_like.thread_root.as_ref())
            .map(ToString::to_string),
        thread: msg_like
            .and_then(|msg_like| msg_like.thread_summary.as_ref())
            .map(|summary| {
                let latest = ready(&summary.latest_event);
                ThreadSummary {
                    reply_count: summary.num_replies,
                    latest_sender: latest.map(|event| sender(&event.sender, &event.sender_profile)),
                    latest_preview: latest.map(|event| message_preview(&event.content)),
                }
            }),
    }
}

fn event_content(content: &TimelineItemContent) -> EventContent {
    match content {
        TimelineItemContent::MsgLike(msg_like) => match &msg_like.kind {
            MsgLikeKind::Message(message) => match message.msgtype() {
                MessageType::Image(image) => EventContent::Image {
                    caption: image.caption().map(ToOwned::to_owned),
                    filename: image.filename().to_owned(),
                    media: media_ref(&image.source),
                    width: image.info.as_ref().and_then(|info| info.width).map(to_u32),
                    height: image.info.as_ref().and_then(|info| info.height).map(to_u32),
                },
                MessageType::Video(video) => EventContent::Video {
                    caption: video.caption().map(ToOwned::to_owned),
                    filename: video.filename().to_owned(),
                    media: media_ref(&video.source),
                },
                MessageType::Audio(audio) => EventContent::Audio {
                    filename: audio.filename().to_owned(),
                    media: media_ref(&audio.source),
                },
                MessageType::File(file) => EventContent::File {
                    caption: file.caption().map(ToOwned::to_owned),
                    filename: file.filename().to_owned(),
                    media: media_ref(&file.source),
                    size: file.info.as_ref().and_then(|info| info.size).map(u64::from),
                },
                _ => EventContent::Text {
                    body: message.body().to_owned(),
                },
            },
            MsgLikeKind::Redacted => EventContent::Redacted,
            MsgLikeKind::UnableToDecrypt(_) => EventContent::UnableToDecrypt,
            _ => EventContent::Unsupported,
        },
        TimelineItemContent::MembershipChange(change) => EventContent::Membership {
            user_id: change.user_id().to_string(),
            change: match change.change() {
                Some(MembershipChange::Joined) => MembershipKind::Joined,
                Some(MembershipChange::Left) => MembershipKind::Left,
                Some(MembershipChange::Invited) => MembershipKind::Invited,
                Some(MembershipChange::InvitationAccepted) => MembershipKind::InvitationAccepted,
                Some(MembershipChange::InvitationRejected) => MembershipKind::InvitationRejected,
                Some(MembershipChange::Kicked) => MembershipKind::Kicked,
                Some(MembershipChange::Banned | MembershipChange::KickedAndBanned) => {
                    MembershipKind::Banned
                }
                _ => MembershipKind::Other,
            },
        },
        TimelineItemContent::ProfileChange(change) => EventContent::ProfileChange {
            user_id: change.user_id().to_string(),
        },
        TimelineItemContent::OtherState(state) => EventContent::RoomState {
            event_type: state.content().event_type().to_string(),
        },
        _ => EventContent::Unsupported,
    }
}

fn reply_preview(msg_like: &MsgLikeContent) -> Option<ReplyPreview> {
    let details = msg_like.in_reply_to.as_ref()?;
    let event = ready(&details.event);
    Some(ReplyPreview {
        event_id: details.event_id.to_string(),
        sender: event.map(|event| sender(&event.sender, &event.sender_profile)),
        preview: event.map(|event| message_preview(&event.content)),
    })
}

fn reactions(msg_like: &MsgLikeContent, own_user_id: &UserId) -> Vec<Reaction> {
    msg_like
        .reactions
        .iter()
        .map(|(key, senders)| Reaction {
            key: key.clone(),
            count: to_u32(senders.len()),
            by_me: senders.contains_key(own_user_id),
        })
        .collect()
}

fn ready(details: &TimelineDetails<Box<EmbeddedEvent>>) -> Option<&EmbeddedEvent> {
    match details {
        TimelineDetails::Ready(event) => Some(event),
        _ => None,
    }
}

pub(crate) fn sender(user_id: &UserId, profile: &TimelineDetails<Profile>) -> Sender {
    let (name, avatar_url) = match profile {
        TimelineDetails::Ready(profile) => (
            profile.display_name.clone(),
            profile.avatar_url.as_ref().map(ToString::to_string),
        ),
        _ => (None, None),
    };
    Sender {
        id: user_id.to_string(),
        name,
        avatar_url,
    }
}

fn media_ref(source: &matrix_sdk::ruma::events::room::MediaSource) -> String {
    serde_json::to_string(source).unwrap_or_default()
}

fn to_u32<T: TryInto<u32>>(value: T) -> u32 {
    value.try_into().unwrap_or(u32::MAX)
}

#[cfg(test)]
mod tests {
    use matrix_sdk_ui::timeline::TimelineEventItemId;

    use super::{item_id, EventKey};
    use crate::api::error::ChatError;

    #[test]
    fn maps_local_and_remote_keys() {
        let local = item_id(&EventKey::Local {
            transaction_id: "txn1".to_owned(),
        })
        .unwrap();
        assert!(matches!(local, TimelineEventItemId::TransactionId(id) if id.as_str() == "txn1"));

        let remote = item_id(&EventKey::Remote {
            event_id: "$event:example.invalid".to_owned(),
        })
        .unwrap();
        assert!(matches!(
            remote,
            TimelineEventItemId::EventId(id) if id.as_str() == "$event:example.invalid"
        ));
    }

    #[test]
    fn rejects_malformed_event_ids() {
        let error = item_id(&EventKey::Remote {
            event_id: "not-an-event-id".to_owned(),
        })
        .unwrap_err();
        assert!(matches!(error, ChatError::InvalidInput { .. }));
    }
}
