//! Room list driven by `RoomListService` (Simplified Sliding Sync).

use futures_util::{pin_mut, StreamExt};
use imbl::Vector;
use matrix_sdk_ui::room_list_service::{filters::new_filter_non_left, RoomListItem};

use crate::{
    api::{client::ChatClient, error::ChatError},
    frb_generated::StreamSink,
    runtime::runtime,
};

pub struct RoomSummary {
    pub room_id: String,
    pub display_name: String,
    pub is_encrypted: bool,
    pub is_direct: bool,
    pub is_invite: bool,
    pub unread_count: u64,
    pub latest_timestamp_ms: Option<i64>,
}

impl ChatClient {
    /// Streams the complete room list (joined + invited) as snapshots,
    /// driven by `RoomListService` diffs.
    pub async fn watch_rooms(&self, sink: StreamSink<Vec<RoomSummary>>) -> Result<(), ChatError> {
        let service = self.sync_service().await?;
        let task = runtime().spawn(async move {
            let room_list_service = service.room_list_service();
            let Ok(all_rooms) = room_list_service.all_rooms().await else {
                return;
            };
            let (stream, controller) = all_rooms.entries_with_dynamic_adapters(200);
            controller.set_filter(Box::new(new_filter_non_left()));
            pin_mut!(stream);
            let mut rooms: Vector<RoomListItem> = Vector::new();
            while let Some(diffs) = stream.next().await {
                for diff in diffs {
                    diff.apply(&mut rooms);
                }
                let snapshot = rooms.iter().map(summarize_room).collect();
                if sink.add(snapshot).is_err() {
                    break;
                }
            }
        });
        if let Some(previous) = self.room_task.lock().await.replace(task) {
            previous.abort();
        }
        Ok(())
    }
}

/// Uses only cached room data: `Room::is_direct().await` blocks for invites.
fn summarize_room(room: &RoomListItem) -> RoomSummary {
    let display_name = match room.cached_display_name() {
        Some(name) => name.to_string(),
        None => room.room_id().to_string(),
    };
    RoomSummary {
        room_id: room.room_id().to_string(),
        display_name,
        is_encrypted: room.encryption_state().is_encrypted(),
        is_direct: room.direct_targets_length() > 0,
        is_invite: room.state() == matrix_sdk::RoomState::Invited,
        unread_count: room.num_unread_messages(),
        latest_timestamp_ms: room.latest_event_timestamp().map(|ts| i64::from(ts.0)),
    }
}
