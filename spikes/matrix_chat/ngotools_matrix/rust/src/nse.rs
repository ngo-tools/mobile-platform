//! Minimal C ABI for the iOS Notification Service Extension.
//!
//! The extension runs in its own process with a ~24 MB memory limit. It opens
//! the app's encrypted store (App Group container) with its own cross-process
//! lock holder, restores only the pushed room and resolves + decrypts the
//! event referenced by an `event_id_only` push.

use std::{
    ffi::{c_char, CStr, CString},
    time::Instant,
};

use anyhow::{Context, Result};
use matrix_sdk::{
    ruma::{
        events::{AnySyncMessageLikeEvent, AnySyncTimelineEvent, SyncMessageLikeEvent},
        EventId, RoomId,
    },
    store::RoomLoadSettings,
};
use matrix_sdk_ui::notification_client::{
    NotificationClient, NotificationEvent, NotificationProcessSetup, NotificationStatus,
};
use serde::{Deserialize, Serialize};

use crate::api::chat::{build_client, restore_stored_session, runtime, ClientParams};

#[derive(Deserialize)]
struct NseConfig {
    homeserver_url: String,
    data_dir: String,
    cache_dir: String,
    /// Spike only; production reads the key from a shared Keychain group.
    store_key_hex: String,
}

#[derive(Serialize)]
struct NseResult {
    ok: bool,
    room_name: Option<String>,
    sender_name: Option<String>,
    body: Option<String>,
    is_encrypted: Option<bool>,
    duration_ms: u128,
    error: Option<String>,
}

/// Resolves a pushed event. Returns a JSON string that must be released with
/// `ngotools_nse_string_free`.
///
/// # Safety
/// All arguments must be valid, NUL-terminated UTF-8 C strings.
#[unsafe(no_mangle)]
pub unsafe extern "C" fn ngotools_nse_get_notification(
    config_json: *const c_char,
    room_id: *const c_char,
    event_id: *const c_char,
) -> *mut c_char {
    let started = Instant::now();
    let arguments = unsafe { (read(config_json), read(room_id), read(event_id)) };

    let outcome = match arguments {
        (Ok(config), Ok(room_id), Ok(event_id)) => {
            runtime().block_on(resolve(config, room_id, event_id))
        }
        _ => Err(anyhow::anyhow!("invalid arguments")),
    };

    let result = match outcome {
        Ok(Some((room_name, sender_name, body, is_encrypted))) => NseResult {
            ok: true,
            room_name: Some(room_name),
            sender_name,
            body: Some(body),
            is_encrypted,
            duration_ms: started.elapsed().as_millis(),
            error: None,
        },
        Ok(None) => NseResult {
            ok: false,
            room_name: None,
            sender_name: None,
            body: None,
            is_encrypted: None,
            duration_ms: started.elapsed().as_millis(),
            error: Some("event not found or filtered".to_owned()),
        },
        Err(error) => NseResult {
            ok: false,
            room_name: None,
            sender_name: None,
            body: None,
            is_encrypted: None,
            duration_ms: started.elapsed().as_millis(),
            error: Some(format!("{error:#}")),
        },
    };

    let json = serde_json::to_string(&result).unwrap_or_else(|_| "{\"ok\":false}".to_owned());
    CString::new(json).map(CString::into_raw).unwrap_or(std::ptr::null_mut())
}

/// Frees a string returned by `ngotools_nse_get_notification`.
///
/// # Safety
/// `value` must come from `ngotools_nse_get_notification` and be freed once.
#[unsafe(no_mangle)]
pub unsafe extern "C" fn ngotools_nse_string_free(value: *mut c_char) {
    if !value.is_null() {
        drop(unsafe { CString::from_raw(value) });
    }
}

unsafe fn read(value: *const c_char) -> Result<String> {
    if value.is_null() {
        anyhow::bail!("null pointer");
    }
    Ok(unsafe { CStr::from_ptr(value) }.to_str()?.to_owned())
}

type Resolved = (String, Option<String>, String, Option<bool>);

async fn resolve(config_json: String, room_id: String, event_id: String) -> Result<Option<Resolved>> {
    let config: NseConfig = serde_json::from_str(&config_json)?;
    let room_id = RoomId::parse(&room_id)?;
    let event_id = EventId::parse(&event_id)?;
    let store_key = (0..config.store_key_hex.len())
        .step_by(2)
        .map(|index| u8::from_str_radix(&config.store_key_hex[index..index + 2], 16))
        .collect::<Result<Vec<u8>, _>>()?;

    let (client, _) = build_client(ClientParams {
        homeserver_url: config.homeserver_url,
        data_dir: config.data_dir,
        cache_dir: config.cache_dir,
        store_key,
        dev_root_certificate_pem: None,
        cross_process_holder: Some("nse".to_owned()),
        low_memory: std::env::var("NGOTOOLS_NSE_DEFAULT_MEMORY").is_err(),
    })
    .await?;

    restore_stored_session(&client, RoomLoadSettings::One(room_id.clone()))
        .await?
        .context("no session in the shared store")?;

    let notifications = NotificationClient::new(client, NotificationProcessSetup::MultipleProcesses).await?;
    let NotificationStatus::Event(item) = notifications.get_notification(&room_id, &event_id).await? else {
        return Ok(None);
    };

    let body = match &item.event {
        NotificationEvent::Timeline(event) => match event.as_ref() {
            AnySyncTimelineEvent::MessageLike(AnySyncMessageLikeEvent::RoomMessage(
                SyncMessageLikeEvent::Original(message),
            )) => message.content.body().to_owned(),
            AnySyncTimelineEvent::MessageLike(AnySyncMessageLikeEvent::RoomEncrypted(_)) => {
                "Verschlüsselte Nachricht".to_owned()
            }
            _ => "Neue Nachricht".to_owned(),
        },
        NotificationEvent::Invite(_) => "Einladung".to_owned(),
    };

    Ok(Some((item.room_computed_display_name.clone(), item.sender_display_name.clone(), body, item.is_room_encrypted)))
}
