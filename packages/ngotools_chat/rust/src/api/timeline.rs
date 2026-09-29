//! Room timeline: live items, back pagination, sending and media.

use std::{path::PathBuf, sync::Arc};

use eyeball_im::VectorDiff;
use futures_util::{pin_mut, StreamExt};
use imbl::Vector;
use matrix_sdk::{
    media::{MediaFormat, MediaRequestParameters},
    ruma::{
        events::room::{message::MessageType, MediaSource},
        RoomId,
    },
};
use matrix_sdk_ui::timeline::{
    AttachmentConfig, AttachmentSource, MsgLikeKind, RoomExt, Timeline, TimelineItem,
    TimelineItemContent, TimelineItemKind, VirtualTimelineItem,
};

use crate::{
    api::{
        client::{ActiveTimeline, ChatClient},
        error::ChatError,
    },
    frb_generated::StreamSink,
    runtime::{on_runtime, runtime},
};

pub enum MessageKind {
    Text {
        body: String,
    },
    Image {
        body: String,
        source_json: String,
        width: Option<u32>,
        height: Option<u32>,
    },
    UnableToDecrypt,
    Redacted,
    Other {
        description: String,
    },
}

pub enum TimelineEntry {
    Message {
        unique_id: String,
        event_id: Option<String>,
        sender_id: String,
        sender_name: Option<String>,
        timestamp_ms: i64,
        is_own: bool,
        is_sending: bool,
        is_failed: bool,
        kind: MessageKind,
    },
    State {
        unique_id: String,
        description: String,
    },
    DayDivider {
        unique_id: String,
        timestamp_ms: i64,
    },
    ReadMarker {
        unique_id: String,
    },
    TimelineStart {
        unique_id: String,
    },
}

impl ChatClient {
    /// Opens the timeline of a room; subsequent timeline calls act on it.
    pub async fn open_timeline(&self, room_id: String) -> Result<(), ChatError> {
        let service = self.sync_service().await?;
        let room_id =
            RoomId::parse(&room_id).map_err(|error| ChatError::invalid(error.to_string()))?;
        let timeline = on_runtime(async move {
            let room = service.room_list_service().room(&room_id)?;
            Ok(Arc::new(room.timeline().await?))
        })
        .await?;

        let mut active = self.timeline.lock().await;
        if let Some(ActiveTimeline {
            task: Some(previous),
            ..
        }) = active.take()
        {
            previous.abort();
        }
        *active = Some(ActiveTimeline {
            timeline,
            task: None,
        });
        Ok(())
    }

    /// Streams snapshots of the open timeline.
    pub async fn watch_timeline(
        &self,
        sink: StreamSink<Vec<TimelineEntry>>,
    ) -> Result<(), ChatError> {
        let mut active = self.timeline.lock().await;
        let active = active
            .as_mut()
            .ok_or_else(|| ChatError::invalid("no open timeline"))?;
        let timeline = active.timeline.clone();
        let task = runtime().spawn(async move {
            let (initial, stream) = timeline.subscribe().await;
            let mut items: Vector<Arc<TimelineItem>> = initial;
            if sink
                .add(items.iter().map(|item| map_timeline_item(item)).collect())
                .is_err()
            {
                return;
            }
            pin_mut!(stream);
            while let Some(diffs) = stream.next().await {
                for diff in diffs {
                    apply_diff(&mut items, diff);
                }
                if sink
                    .add(items.iter().map(|item| map_timeline_item(item)).collect())
                    .is_err()
                {
                    break;
                }
            }
        });
        if let Some(previous) = active.task.replace(task) {
            previous.abort();
        }
        Ok(())
    }

    /// Loads older events; returns true when the start of the room was reached.
    pub async fn paginate_back(&self, count: u16) -> Result<bool, ChatError> {
        let timeline = self.active_timeline().await?;
        on_runtime(async move { Ok(timeline.paginate_backwards(count).await?) }).await
    }

    pub async fn send_text(&self, body: String) -> Result<(), ChatError> {
        let timeline = self.active_timeline().await?;
        on_runtime(async move {
            let content =
                matrix_sdk::ruma::events::room::message::RoomMessageEventContent::text_plain(body);
            timeline.send(content.into()).await?;
            Ok(())
        })
        .await
    }

    pub async fn send_image(&self, file_path: String, mime_type: String) -> Result<(), ChatError> {
        let timeline = self.active_timeline().await?;
        on_runtime(async move {
            let mime: mime::Mime = mime_type.parse()?;
            let source = AttachmentSource::File(PathBuf::from(file_path));
            timeline
                .send_attachment(source, mime, AttachmentConfig::default())
                .await?;
            Ok(())
        })
        .await
    }

    pub async fn mark_as_read(&self) -> Result<(), ChatError> {
        let timeline = self.active_timeline().await?;
        on_runtime(async move {
            timeline
                .mark_as_read(
                    matrix_sdk::ruma::api::client::receipt::create_receipt::v3::ReceiptType::Read,
                )
                .await?;
            Ok(())
        })
        .await
    }

    /// Downloads (and decrypts) authenticated media referenced by a timeline item.
    pub async fn fetch_media(&self, source_json: String) -> Result<Vec<u8>, ChatError> {
        let client = self.client.clone();
        on_runtime(async move {
            let source: MediaSource = serde_json::from_str(&source_json)?;
            let request = MediaRequestParameters {
                source,
                format: MediaFormat::File,
            };
            Ok(client.media().get_media_content(&request, true).await?)
        })
        .await
    }

    async fn active_timeline(&self) -> Result<Arc<Timeline>, ChatError> {
        Ok(self
            .timeline
            .lock()
            .await
            .as_ref()
            .ok_or_else(|| ChatError::invalid("no open timeline"))?
            .timeline
            .clone())
    }
}

fn apply_diff(items: &mut Vector<Arc<TimelineItem>>, diff: VectorDiff<Arc<TimelineItem>>) {
    diff.apply(items);
}

fn map_timeline_item(item: &TimelineItem) -> TimelineEntry {
    let unique_id = item.unique_id().0.clone();
    match item.kind() {
        TimelineItemKind::Virtual(VirtualTimelineItem::DateDivider(ts)) => {
            TimelineEntry::DayDivider {
                unique_id,
                timestamp_ms: i64::from(ts.0),
            }
        }
        TimelineItemKind::Virtual(VirtualTimelineItem::ReadMarker) => {
            TimelineEntry::ReadMarker { unique_id }
        }
        TimelineItemKind::Virtual(VirtualTimelineItem::TimelineStart) => {
            TimelineEntry::TimelineStart { unique_id }
        }
        TimelineItemKind::Event(event) => {
            let kind = match event.content() {
                TimelineItemContent::MsgLike(msg_like) => match &msg_like.kind {
                    MsgLikeKind::Message(message) => match message.msgtype() {
                        MessageType::Image(image) => MessageKind::Image {
                            body: image.body.clone(),
                            source_json: serde_json::to_string(&image.source).unwrap_or_default(),
                            width: image
                                .info
                                .as_ref()
                                .and_then(|info| info.width)
                                .map(|w| u32::try_from(w).unwrap_or(0)),
                            height: image
                                .info
                                .as_ref()
                                .and_then(|info| info.height)
                                .map(|h| u32::try_from(h).unwrap_or(0)),
                        },
                        _ => MessageKind::Text {
                            body: message.body().to_owned(),
                        },
                    },
                    MsgLikeKind::UnableToDecrypt(_) => MessageKind::UnableToDecrypt,
                    MsgLikeKind::Redacted => MessageKind::Redacted,
                    _ => MessageKind::Other {
                        description: "Nicht unterstützter Inhalt".to_owned(),
                    },
                },
                other => {
                    return TimelineEntry::State {
                        unique_id,
                        description: describe_state(other),
                    };
                }
            };
            let send_state = event.send_state();
            TimelineEntry::Message {
                unique_id,
                event_id: event.event_id().map(ToString::to_string),
                sender_id: event.sender().to_string(),
                sender_name: match event.sender_profile() {
                    matrix_sdk_ui::timeline::TimelineDetails::Ready(profile) => {
                        profile.display_name.clone()
                    }
                    _ => None,
                },
                timestamp_ms: i64::from(event.timestamp().0),
                is_own: event.is_own(),
                is_sending: matches!(
                    send_state,
                    Some(matrix_sdk_ui::timeline::EventSendState::NotSentYet { .. })
                ),
                is_failed: matches!(
                    send_state,
                    Some(matrix_sdk_ui::timeline::EventSendState::SendingFailed { .. })
                ),
                kind,
            }
        }
    }
}

fn describe_state(content: &TimelineItemContent) -> String {
    match content {
        TimelineItemContent::MembershipChange(change) => {
            format!("{} – Mitgliedschaft geändert", change.user_id())
        }
        TimelineItemContent::ProfileChange(change) => {
            format!("{} – Profil geändert", change.user_id())
        }
        TimelineItemContent::OtherState(state) => {
            format!("Raumänderung ({})", state.content().event_type())
        }
        _ => "Ereignis".to_owned(),
    }
}
