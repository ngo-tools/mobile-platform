//! Pushers (Sygnal, `event_id_only`) and resolving pushed events.

use matrix_sdk::ruma::{
    api::client::push::{Pusher, PusherIds, PusherInit, PusherKind},
    events::{AnySyncMessageLikeEvent, AnySyncTimelineEvent, SyncMessageLikeEvent},
    push::{HttpPusherData, PushFormat},
    EventId, RoomId,
};
use matrix_sdk_ui::notification_client::{
    NotificationClient, NotificationEvent, NotificationProcessSetup, NotificationStatus,
};

use crate::api::{client::ChatClient, error::ChatError};

pub struct NotificationContent {
    pub room_name: String,
    pub sender_name: Option<String>,
    pub body: String,
    pub is_direct: bool,
    pub is_encrypted: Option<bool>,
}

impl ChatClient {
    /// Registers an HTTP pusher (Sygnal) with `event_id_only` payloads.
    pub async fn register_pusher(
        &self,
        push_key: String,
        app_id: String,
        gateway_url: String,
        device_name: String,
    ) -> Result<(), ChatError> {
        let client = self.client.clone();
        self.lifecycle
            .run(async move {
                let mut data = HttpPusherData::new(gateway_url);
                data.format = Some(PushFormat::EventIdOnly);
                let pusher: Pusher = PusherInit {
                    ids: PusherIds::new(push_key, app_id),
                    kind: PusherKind::Http(data),
                    app_display_name: "NGO.Tools".to_owned(),
                    device_display_name: device_name,
                    profile_tag: None,
                    lang: "de".to_owned(),
                }
                .into();
                client.pusher().set(pusher, false).await?;
                Ok(())
            })
            .await
    }

    /// Resolves and decrypts a pushed event (`event_id_only` payload) the way
    /// the Android FCM handler / iOS Notification Service Extension would.
    pub async fn get_notification(
        &self,
        room_id: String,
        event_id: String,
    ) -> Result<Option<NotificationContent>, ChatError> {
        let client = self.client.clone();
        let sync_service = self.sync_service.lock().await.clone();
        self.lifecycle
            .run(async move {
                let setup = match sync_service {
                    Some(sync_service) => NotificationProcessSetup::SingleProcess { sync_service },
                    None => NotificationProcessSetup::MultipleProcesses,
                };
                let notifications = NotificationClient::new(client, setup).await?;
                let room_id = RoomId::parse(&room_id)
                    .map_err(|error| ChatError::invalid(error.to_string()))?;
                let event_id = EventId::parse(&event_id)
                    .map_err(|error| ChatError::invalid(error.to_string()))?;
                let status = notifications.get_notification(&room_id, &event_id).await?;
                let NotificationStatus::Event(item) = status else {
                    return Ok(None);
                };
                let body = match &item.event {
                    NotificationEvent::Timeline(event) => describe_notification_event(event),
                    NotificationEvent::Invite(_) => "Einladung".to_owned(),
                };
                Ok(Some(NotificationContent {
                    room_name: item.room_computed_display_name.clone(),
                    sender_name: item.sender_display_name.clone(),
                    body,
                    is_direct: item.is_direct_message_room,
                    is_encrypted: item.is_room_encrypted,
                }))
            })
            .await
    }
}

fn describe_notification_event(event: &AnySyncTimelineEvent) -> String {
    match event {
        AnySyncTimelineEvent::MessageLike(AnySyncMessageLikeEvent::RoomMessage(
            SyncMessageLikeEvent::Original(message),
        )) => message.content.body().to_owned(),
        AnySyncTimelineEvent::MessageLike(AnySyncMessageLikeEvent::RoomEncrypted(_)) => {
            "Verschlüsselte Nachricht".to_owned()
        }
        _ => "Neue Nachricht".to_owned(),
    }
}
