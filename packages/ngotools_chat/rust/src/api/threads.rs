//! Thread overview of a room (thread roots with reply count and latest
//! reply), streamed as diffs and paginated from the server.

use std::sync::Arc;

use flutter_rust_bridge::frb;
use futures_util::{pin_mut, StreamExt};
use matrix_sdk::ruma::RoomId;
use matrix_sdk_ui::timeline::thread_list_service::{
    ThreadListItem, ThreadListItemEvent, ThreadListPaginationState, ThreadListService,
};
use tokio::{sync::Mutex, task::JoinHandle};

use crate::{
    api::{
        client::ChatClient,
        error::ChatError,
        lifecycle::Lifecycle,
        timeline::{message_preview, sender, MessagePreview, Sender},
    },
    frb_generated::StreamSink,
    runtime::{runtime, DropInRuntime},
};

pub struct ThreadEvent {
    pub event_id: String,
    pub sender: Sender,
    pub timestamp_ms: i64,
    pub is_own: bool,
    /// `None` while the content is not known (e.g. not yet decrypted).
    pub preview: Option<MessagePreview>,
}

pub struct ThreadInfo {
    pub root: ThreadEvent,
    pub latest: Option<ThreadEvent>,
    pub reply_count: u32,
}

pub enum ThreadListDiff {
    Append { values: Vec<ThreadInfo> },
    Clear,
    PushFront { value: ThreadInfo },
    PushBack { value: ThreadInfo },
    PopFront,
    PopBack,
    Insert { index: u32, value: ThreadInfo },
    Set { index: u32, value: ThreadInfo },
    Remove { index: u32 },
    Truncate { length: u32 },
    Reset { values: Vec<ThreadInfo> },
}

#[frb(opaque)]
pub struct ChatThreadList {
    service: DropInRuntime<Arc<ThreadListService>>,
    lifecycle: Arc<Lifecycle>,
    watch_task: Mutex<Option<JoinHandle<()>>>,
}

impl ChatClient {
    /// Thread overview of a room. Call `paginate` to load threads.
    pub async fn thread_list(&self, room_id: String) -> Result<ChatThreadList, ChatError> {
        let room_id =
            RoomId::parse(&room_id).map_err(|error| ChatError::invalid(error.to_string()))?;
        let room = self.client.get_room(&room_id).ok_or(ChatError::NotFound)?;
        // The service spawns its event cache listener, which needs the runtime.
        let service = self
            .lifecycle
            .run(async move { Ok(Arc::new(ThreadListService::new(room))) })
            .await?;
        Ok(ChatThreadList {
            service: DropInRuntime::new(service),
            lifecycle: self.lifecycle.clone(),
            watch_task: Mutex::new(None),
        })
    }
}

impl ChatThreadList {
    /// Streams the thread list as diffs; the first batch resets the list.
    pub async fn watch(&self, sink: StreamSink<Vec<ThreadListDiff>>) -> Result<(), ChatError> {
        let service = self.service.clone();
        let task = runtime().spawn(async move {
            let (initial, stream) = service.subscribe_to_items_updates();
            tracing::debug!(count = initial.len(), "thread list: watching");
            let reset = ThreadListDiff::Reset {
                values: initial.iter().map(thread_info).collect(),
            };
            if sink.add(vec![reset]).is_err() {
                return;
            }
            pin_mut!(stream);
            while let Some(diffs) = stream.next().await {
                let mapped = diffs.into_iter().map(map_diff).collect();
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

    /// Loads the next page of threads; returns true when all are loaded.
    pub async fn paginate(&self) -> Result<bool, ChatError> {
        let service = self.service.clone();
        self.lifecycle
            .run(async move {
                tracing::debug!("thread list: paginate");
                service
                    .paginate()
                    .await
                    .map_err(|error| anyhow::anyhow!("{error}"))?;
                tracing::debug!(state = ?service.pagination_state(), "thread list: paginated");
                Ok(matches!(
                    service.pagination_state(),
                    ThreadListPaginationState::Idle { end_reached: true }
                ))
            })
            .await
    }

    /// Stops streaming.
    pub async fn close(&self) {
        if let Some(task) = self.watch_task.lock().await.take() {
            task.abort();
        }
    }
}

impl Drop for ChatThreadList {
    fn drop(&mut self) {
        if let Ok(mut task) = self.watch_task.try_lock() {
            if let Some(task) = task.take() {
                task.abort();
            }
        }
    }
}

fn thread_info(item: &ThreadListItem) -> ThreadInfo {
    ThreadInfo {
        root: thread_event(&item.root_event),
        latest: item.latest_event.as_ref().map(thread_event),
        reply_count: item.num_replies,
    }
}

fn thread_event(event: &ThreadListItemEvent) -> ThreadEvent {
    ThreadEvent {
        event_id: event.event_id.to_string(),
        sender: sender(&event.sender, &event.sender_profile),
        timestamp_ms: i64::from(event.timestamp.0),
        is_own: event.is_own,
        preview: event.content.as_ref().map(message_preview),
    }
}

fn map_diff(diff: eyeball_im::VectorDiff<ThreadListItem>) -> ThreadListDiff {
    use eyeball_im::VectorDiff;

    let index = |index: usize| u32::try_from(index).unwrap_or(u32::MAX);
    match diff {
        VectorDiff::Append { values } => ThreadListDiff::Append {
            values: values.iter().map(thread_info).collect(),
        },
        VectorDiff::Clear => ThreadListDiff::Clear,
        VectorDiff::PushFront { value } => ThreadListDiff::PushFront {
            value: thread_info(&value),
        },
        VectorDiff::PushBack { value } => ThreadListDiff::PushBack {
            value: thread_info(&value),
        },
        VectorDiff::PopFront => ThreadListDiff::PopFront,
        VectorDiff::PopBack => ThreadListDiff::PopBack,
        VectorDiff::Insert { index: at, value } => ThreadListDiff::Insert {
            index: index(at),
            value: thread_info(&value),
        },
        VectorDiff::Set { index: at, value } => ThreadListDiff::Set {
            index: index(at),
            value: thread_info(&value),
        },
        VectorDiff::Remove { index: at } => ThreadListDiff::Remove { index: index(at) },
        VectorDiff::Truncate { length } => ThreadListDiff::Truncate {
            length: index(length),
        },
        VectorDiff::Reset { values } => ThreadListDiff::Reset {
            values: values.iter().map(thread_info).collect(),
        },
    }
}
