//! Small, stable facade over matrix-rust-sdk for the NGO.Tools Flutter apps.
//!
//! Dart never sees access or refresh tokens: the session is persisted inside
//! the encrypted SQLite state store (key supplied by the app from the
//! Keychain/Keystore) and refreshed tokens are written back from Rust.

use std::{
    path::PathBuf,
    sync::{
        atomic::{AtomicU32, Ordering},
        Arc, OnceLock,
    },
    time::Instant,
};

use anyhow::{anyhow, Context, Result};
use eyeball_im::VectorDiff;
use flutter_rust_bridge::frb;
use futures_util::{pin_mut, StreamExt};
use imbl::Vector;
use matrix_sdk::{
    authentication::oauth::{
        registration::{ApplicationType, ClientMetadata, Localized, OAuthGrantType},
        ClientId, ClientRegistrationData, OAuthSession, UserSession,
    },
    cross_process_lock::CrossProcessLockConfig,
    encryption::{
        recovery::RecoveryState, BackupDownloadStrategy, EncryptionSettings, VerificationState,
    },
    media::{MediaFormat, MediaRequestParameters},
    reqwest::Certificate,
    ruma::{
        api::client::push::{Pusher, PusherIds, PusherInit, PusherKind},
        events::{
            room::{message::MessageType, MediaSource},
            AnySyncMessageLikeEvent, AnySyncTimelineEvent, SyncMessageLikeEvent,
        },
        push::{HttpPusherData, PushFormat},
        serde::Raw,
        EventId, RoomId, UserId,
    },
    store::RoomLoadSettings,
    AuthSession, Client, SessionChange, SqliteStoreConfig,
};
use matrix_sdk_ui::{
    notification_client::{
        NotificationClient, NotificationEvent, NotificationProcessSetup, NotificationStatus,
    },
    room_list_service::{filters::new_filter_non_left, RoomListItem},
    sync_service::{State as SyncState, SyncService},
    timeline::{
        AttachmentConfig, AttachmentSource, MsgLikeKind, RoomExt, Timeline, TimelineItem,
        TimelineItemContent, TimelineItemKind, VirtualTimelineItem,
    },
};
use serde::{Deserialize, Serialize};
use tokio::{runtime::Runtime, sync::Mutex, task::JoinHandle};
use url::Url;

use crate::frb_generated::StreamSink;

const SESSION_KEY: &[u8] = b"ngotools.session.v1";

pub(crate) fn runtime() -> &'static Runtime {
    static RUNTIME: OnceLock<Runtime> = OnceLock::new();
    RUNTIME.get_or_init(|| {
        tokio::runtime::Builder::new_multi_thread()
            .worker_threads(2)
            .enable_all()
            .thread_name("ngotools-matrix")
            .build()
            .expect("tokio runtime")
    })
}

/// Runs a future on the facade's own tokio runtime (reqwest and the SDK
/// require a tokio context; FRB's async executor does not provide one).
async fn on_runtime<F, T>(future: F) -> Result<T>
where
    F: std::future::Future<Output = Result<T>> + Send + 'static,
    T: Send + 'static,
{
    runtime()
        .spawn(future)
        .await
        .map_err(|error| anyhow!("task failed: {error}"))?
}

#[frb(init)]
pub fn init_app() {
    flutter_rust_bridge::setup_default_user_utils();
}

/// Writes SDK logs to a file (stdout is not visible on iOS/Android).
pub fn init_logging(log_file: String) -> Result<()> {
    let file = std::fs::OpenOptions::new()
        .create(true)
        .append(true)
        .open(log_file)?;
    // FRB already installs a `log` logger; only set the tracing dispatcher.
    let subscriber = tracing_subscriber::fmt()
        .with_env_filter(tracing_subscriber::EnvFilter::try_new(
            "warn,matrix_sdk=info,matrix_sdk_ui=info,matrix_sdk::sliding_sync=warn,ngotools_matrix_core=debug",
        )?)
        .with_ansi(false)
        .with_writer(std::sync::Mutex::new(file))
        .finish();
    tracing::subscriber::set_global_default(subscriber).map_err(|error| anyhow!("{error}"))
}

pub struct ChatConfig {
    pub homeserver_url: String,
    /// Persistent directory for the SQLite stores.
    pub data_dir: String,
    /// Directory for caches (event cache, media).
    pub cache_dir: String,
    /// 32 random bytes from the Keychain/Keystore; encrypts all stores.
    pub store_key: Vec<u8>,
    pub client_name: String,
    pub client_uri: String,
    pub redirect_uri: String,
    /// Extra trusted root CA (PEM) for local development servers only (not
    /// supported on Android, use the network security config there).
    pub dev_root_certificate_pem: Option<String>,
    /// Holder name for the cross-process store/refresh lock. Required on iOS
    /// when a Notification Service Extension shares the store (e.g. `main`).
    pub cross_process_holder: Option<String>,
}

pub struct SessionInfo {
    pub user_id: String,
    pub device_id: String,
}

pub struct RoomSummary {
    pub room_id: String,
    pub display_name: String,
    pub is_encrypted: bool,
    pub is_direct: bool,
    pub is_invite: bool,
    pub unread_count: u64,
    pub latest_timestamp_ms: Option<i64>,
}

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

pub enum RecoveryStatus {
    Unknown,
    Enabled,
    Disabled,
    Incomplete,
}

pub struct NotificationContent {
    pub room_name: String,
    pub sender_name: Option<String>,
    pub body: String,
    pub is_direct: bool,
    pub is_encrypted: Option<bool>,
}

#[derive(Serialize, Deserialize)]
struct StoredSession {
    client_id: String,
    user_id: String,
    device_id: String,
    access_token: String,
    refresh_token: Option<String>,
}

struct ActiveTimeline {
    timeline: Arc<Timeline>,
    task: Option<JoinHandle<()>>,
}

#[frb(opaque)]
pub struct ChatClient {
    client: Client,
    config: Arc<ChatConfigInner>,
    sync_service: Mutex<Option<Arc<SyncService>>>,
    room_task: Mutex<Option<JoinHandle<()>>>,
    timeline: Mutex<Option<ActiveTimeline>>,
    session_task: Mutex<Option<JoinHandle<()>>>,
    pending_login_state: Mutex<Option<String>>,
    refreshes: Arc<AtomicU32>,
}

struct ChatConfigInner {
    client_name: String,
    client_uri: String,
    redirect_uri: String,
}

impl ChatClient {
    /// Builds the client with encrypted SQLite stores. No network access.
    pub async fn create(config: ChatConfig) -> Result<ChatClient> {
        on_runtime(async move {
            let (client, refreshes) = build_client(ClientParams {
                homeserver_url: config.homeserver_url,
                data_dir: config.data_dir,
                cache_dir: config.cache_dir,
                store_key: config.store_key,
                dev_root_certificate_pem: config.dev_root_certificate_pem,
                cross_process_holder: config.cross_process_holder,
                low_memory: false,
            })
            .await?;

            Ok(ChatClient {
                client,
                config: Arc::new(ChatConfigInner {
                    client_name: config.client_name,
                    client_uri: config.client_uri,
                    redirect_uri: config.redirect_uri,
                }),
                sync_service: Mutex::new(None),
                room_task: Mutex::new(None),
                timeline: Mutex::new(None),
                session_task: Mutex::new(None),
                pending_login_state: Mutex::new(None),
                refreshes,
            })
        })
        .await
    }

    /// Restores a previously persisted session from the encrypted store.
    pub async fn restore_session(&self) -> Result<Option<SessionInfo>> {
        let client = self.client.clone();
        let restored = on_runtime(async move {
            restore_stored_session(&client, RoomLoadSettings::default()).await
        })
        .await?;

        if restored.is_some() {
            self.watch_session_changes().await;
        }

        Ok(restored)
    }

    /// Starts an OAuth 2.0 authorization code flow with PKCE against MAS
    /// (dynamic client registration) and returns the URL for the system
    /// browser.
    pub async fn login_url(&self) -> Result<String> {
        let client = self.client.clone();
        let config = self.config.clone();
        let data = on_runtime(async move {
            let redirect_uri = Url::parse(&config.redirect_uri)?;
            let metadata = ClientMetadata {
                client_name: Some(Localized::new(config.client_name.clone(), [])),
                ..ClientMetadata::new(
                    ApplicationType::Native,
                    vec![OAuthGrantType::AuthorizationCode {
                        redirect_uris: vec![redirect_uri.clone()],
                    }],
                    Localized::new(Url::parse(&config.client_uri)?, []),
                )
            };
            let registration = ClientRegistrationData::new(Raw::new(&metadata)?);
            let data = client
                .oauth()
                .login(redirect_uri, None, Some(registration), None)
                .build()
                .await?;
            Ok(data)
        })
        .await?;

        *self.pending_login_state.lock().await = Some(data.state.secret().to_owned());

        Ok(data.url.to_string())
    }

    /// Completes the OAuth flow with the redirect URL received by the app.
    pub async fn finish_login(&self, callback_url: String) -> Result<SessionInfo> {
        let client = self.client.clone();
        let info = on_runtime(async move {
            let url = Url::parse(&callback_url)?;
            client.oauth().finish_login(url.into()).await?;
            persist_session(&client).await?;
            let user_id = client.user_id().context("no user id")?.to_string();
            let device_id = client.device_id().context("no device id")?.to_string();
            Ok(SessionInfo { user_id, device_id })
        })
        .await?;

        *self.pending_login_state.lock().await = None;
        self.watch_session_changes().await;

        Ok(info)
    }

    pub async fn logout(&self) -> Result<()> {
        self.stop_sync().await?;
        let client = self.client.clone();
        on_runtime(async move {
            client.oauth().logout().await?;
            client
                .state_store()
                .remove_custom_value(SESSION_KEY)
                .await?;
            Ok(())
        })
        .await
    }

    /// Starts the sync service (Simplified Sliding Sync + encryption sync).
    pub async fn start_sync(&self) -> Result<()> {
        let client = self.client.clone();
        let service = on_runtime(async move {
            let service = Arc::new(SyncService::builder(client).build().await?);
            service.start().await;

            // Like Element X: the sync service stops in `Error` (e.g. network
            // loss, expired token race); restart it with a small backoff.
            let supervised = service.clone();
            runtime().spawn(async move {
                let states = supervised.state();
                pin_mut!(states);
                while let Some(state) = states.next().await {
                    if matches!(state, SyncState::Error(_)) {
                        tracing::warn!("sync service error ({state:?}), restarting");
                        tokio::time::sleep(std::time::Duration::from_secs(1)).await;
                        supervised.start().await;
                    }
                }
            });

            Ok(service)
        })
        .await?;
        *self.sync_service.lock().await = Some(service);
        Ok(())
    }

    pub async fn stop_sync(&self) -> Result<()> {
        if let Some(task) = self.room_task.lock().await.take() {
            task.abort();
        }
        if let Some(service) = self.sync_service.lock().await.take() {
            on_runtime(async move {
                service.stop().await;
                Ok(())
            })
            .await?;
        }
        Ok(())
    }

    /// Streams the sync service state as text (`idle`, `running`, `terminated`, `error`, `offline`).
    pub async fn watch_sync_state(&self, sink: StreamSink<String>) -> Result<()> {
        let service = self.sync_service().await?;
        runtime().spawn(async move {
            let states = service.state();
            let initial = states.get();
            let states = futures_util::stream::once(async move { initial }).chain(states);
            pin_mut!(states);
            while let Some(state) = states.next().await {
                let label = match state {
                    SyncState::Idle => "idle",
                    SyncState::Running => "running",
                    SyncState::Terminated => "terminated",
                    SyncState::Error(_) => "error",
                    SyncState::Offline => "offline",
                };
                if sink.add(label.to_owned()).is_err() {
                    break;
                }
            }
        });
        Ok(())
    }

    /// Streams the complete room list (joined + invited) as snapshots,
    /// driven by `RoomListService` diffs.
    pub async fn watch_rooms(&self, sink: StreamSink<Vec<RoomSummary>>) -> Result<()> {
        let service = self.sync_service().await?;
        let task = runtime().spawn(async move {
            let room_list_service = service.room_list_service();
            let Ok(all_rooms) = room_list_service.all_rooms().await else {
                return;
            };
            tracing::debug!("room list: all_rooms ready");
            let (stream, controller) = all_rooms.entries_with_dynamic_adapters(200);
            controller.set_filter(Box::new(new_filter_non_left()));
            pin_mut!(stream);
            let mut rooms: Vector<RoomListItem> = Vector::new();
            while let Some(diffs) = stream.next().await {
                tracing::debug!(diffs = diffs.len(), "room list update");
                for diff in diffs {
                    diff.apply(&mut rooms);
                }
                let mut snapshot = Vec::with_capacity(rooms.len());
                for room in rooms.iter() {
                    snapshot.push(summarize_room(room).await);
                }
                tracing::debug!(rooms = snapshot.len(), "room list snapshot");
                if sink.add(snapshot).is_err() {
                    tracing::debug!("room list sink closed");
                    break;
                }
            }
        });
        if let Some(previous) = self.room_task.lock().await.replace(task) {
            previous.abort();
        }
        Ok(())
    }

    /// Opens the timeline of a room and streams snapshots of its items.
    /// Opens the timeline of a room; subsequent timeline calls act on it.
    pub async fn open_timeline(&self, room_id: String) -> Result<()> {
        let service = self.sync_service().await?;
        let room_id = RoomId::parse(&room_id)?;
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
    pub async fn watch_timeline(&self, sink: StreamSink<Vec<TimelineEntry>>) -> Result<()> {
        let mut active = self.timeline.lock().await;
        let active = active.as_mut().context("no open timeline")?;
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
    pub async fn paginate_back(&self, count: u16) -> Result<bool> {
        let timeline = self.active_timeline().await?;
        on_runtime(async move { Ok(timeline.paginate_backwards(count).await?) }).await
    }

    pub async fn send_text(&self, body: String) -> Result<()> {
        let timeline = self.active_timeline().await?;
        on_runtime(async move {
            let content =
                matrix_sdk::ruma::events::room::message::RoomMessageEventContent::text_plain(body);
            timeline.send(content.into()).await?;
            Ok(())
        })
        .await
    }

    pub async fn send_image(&self, file_path: String, mime_type: String) -> Result<()> {
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

    pub async fn mark_as_read(&self) -> Result<()> {
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
    pub async fn fetch_media(&self, source_json: String) -> Result<Vec<u8>> {
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

    /// Creates (or reuses) an encrypted DM with the given user.
    pub async fn create_dm(&self, user_id: String) -> Result<String> {
        let client = self.client.clone();
        on_runtime(async move {
            let user_id = UserId::parse(&user_id)?;
            if let Some(room) = client.get_dm_room(&user_id) {
                return Ok(room.room_id().to_string());
            }
            let room = client.create_dm(&user_id).await?;
            Ok(room.room_id().to_string())
        })
        .await
    }

    pub async fn join_room(&self, room_id: String) -> Result<()> {
        let client = self.client.clone();
        on_runtime(async move {
            let room_id = RoomId::parse(&room_id)?;
            let room = client.get_room(&room_id).context("unknown room")?;
            room.join().await?;
            Ok(())
        })
        .await
    }

    pub async fn recovery_status(&self) -> Result<RecoveryStatus> {
        let client = self.client.clone();
        on_runtime(async move {
            client
                .encryption()
                .wait_for_e2ee_initialization_tasks()
                .await;
            Ok(match client.encryption().recovery().state() {
                RecoveryState::Unknown => RecoveryStatus::Unknown,
                RecoveryState::Enabled => RecoveryStatus::Enabled,
                RecoveryState::Disabled => RecoveryStatus::Disabled,
                RecoveryState::Incomplete => RecoveryStatus::Incomplete,
            })
        })
        .await
    }

    /// Enables key backup + secret storage and returns the recovery key
    /// that the user has to write down.
    pub async fn enable_recovery(&self) -> Result<String> {
        let client = self.client.clone();
        on_runtime(async move {
            client
                .encryption()
                .wait_for_e2ee_initialization_tasks()
                .await;
            Ok(client.encryption().recovery().enable().await?)
        })
        .await
    }

    /// Restores cross-signing and the key backup on a new device.
    pub async fn recover(&self, recovery_key: String) -> Result<()> {
        let client = self.client.clone();
        on_runtime(async move {
            client
                .encryption()
                .wait_for_e2ee_initialization_tasks()
                .await;
            client
                .encryption()
                .recovery()
                .recover(&recovery_key)
                .await?;
            Ok(())
        })
        .await
    }

    /// Registers an HTTP pusher (Sygnal) with `event_id_only` payloads.
    pub async fn register_pusher(
        &self,
        push_key: String,
        app_id: String,
        gateway_url: String,
        device_name: String,
    ) -> Result<()> {
        let client = self.client.clone();
        on_runtime(async move {
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
    ) -> Result<Option<NotificationContent>> {
        let client = self.client.clone();
        let sync_service = self.sync_service.lock().await.clone();
        on_runtime(async move {
            let setup = match sync_service {
                Some(sync_service) => NotificationProcessSetup::SingleProcess { sync_service },
                None => NotificationProcessSetup::MultipleProcesses,
            };
            let notifications = NotificationClient::new(client, setup).await?;
            let status = notifications
                .get_notification(&RoomId::parse(&room_id)?, &EventId::parse(&event_id)?)
                .await?;
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

    pub async fn user_id(&self) -> Option<String> {
        self.client.user_id().map(|user_id| user_id.to_string())
    }

    /// `verified` once this device is cross-signed (e.g. after recovery).
    pub async fn verification_state(&self) -> Result<String> {
        let client = self.client.clone();
        on_runtime(async move {
            client
                .encryption()
                .wait_for_e2ee_initialization_tasks()
                .await;
            Ok(match client.encryption().verification_state().get() {
                VerificationState::Verified => "verified",
                VerificationState::Unverified => "unverified",
                VerificationState::Unknown => "unknown",
            }
            .to_owned())
        })
        .await
    }

    /// Authenticated round trip (`/whoami`); refreshes an expired access token.
    pub async fn whoami(&self) -> Result<String> {
        let client = self.client.clone();
        on_runtime(async move { Ok(client.whoami().await?.user_id.to_string()) }).await
    }

    /// Number of token refreshes persisted by this client instance.
    pub fn persisted_refreshes(&self) -> u32 {
        self.refreshes.load(Ordering::SeqCst)
    }

    /// Stops all background work so that another client may open the store.
    pub async fn shutdown(&self) -> Result<()> {
        if let Some(task) = self.session_task.lock().await.take() {
            task.abort();
        }
        if let Some(ActiveTimeline {
            task: Some(task), ..
        }) = self.timeline.lock().await.take()
        {
            task.abort();
        }
        self.stop_sync().await
    }

    async fn sync_service(&self) -> Result<Arc<SyncService>> {
        self.sync_service
            .lock()
            .await
            .clone()
            .context("sync not started")
    }

    async fn active_timeline(&self) -> Result<Arc<Timeline>> {
        Ok(self
            .timeline
            .lock()
            .await
            .as_ref()
            .context("no open timeline")?
            .timeline
            .clone())
    }

    /// Persists rotated tokens whenever MAS refreshes them.
    async fn watch_session_changes(&self) {
        let client = self.client.clone();
        let task = runtime().spawn(async move {
            let mut changes = client.subscribe_to_session_changes();
            while let Ok(change) = changes.recv().await {
                match change {
                    SessionChange::TokensRefreshed => tracing::debug!("tokens refreshed"),
                    SessionChange::UnknownToken { .. } => {
                        tracing::warn!("session invalidated by the server");
                    }
                }
            }
        });
        if let Some(previous) = self.session_task.lock().await.replace(task) {
            previous.abort();
        }
    }
}

pub(crate) struct ClientParams {
    pub(crate) homeserver_url: String,
    pub(crate) data_dir: String,
    pub(crate) cache_dir: String,
    pub(crate) store_key: Vec<u8>,
    pub(crate) dev_root_certificate_pem: Option<String>,
    pub(crate) cross_process_holder: Option<String>,
    /// Smaller SQLite caches/pools, for the memory-limited iOS NSE.
    pub(crate) low_memory: bool,
}

/// Builds a client on the encrypted SQLite stores. Shared by the app and the
/// iOS Notification Service Extension (see `crate::nse`).
pub(crate) async fn build_client(params: ClientParams) -> Result<(Client, Arc<AtomicU32>)> {
    let started = Instant::now();
    let data_dir = PathBuf::from(&params.data_dir);
    let cache_dir = PathBuf::from(&params.cache_dir);
    std::fs::create_dir_all(&data_dir)?;
    std::fs::create_dir_all(&cache_dir)?;

    if params.store_key.len() != 32 {
        return Err(anyhow!("store key must be 32 bytes"));
    }

    let store_config = if params.low_memory {
        SqliteStoreConfig::with_low_memory_config(&data_dir)
    } else {
        SqliteStoreConfig::new(&data_dir)
    }
    .key(Some(&params.store_key));

    let mut builder = Client::builder()
        .homeserver_url(&params.homeserver_url)
        .sqlite_store_with_config_and_cache_path(store_config, Some(cache_dir))
        .sliding_sync_version_builder(matrix_sdk::sliding_sync::VersionBuilder::Native)
        .handle_refresh_tokens()
        .with_encryption_settings(EncryptionSettings {
            auto_enable_cross_signing: true,
            backup_download_strategy: BackupDownloadStrategy::AfterDecryptionFailure,
            auto_enable_backups: true,
        });

    if let Some(holder) = &params.cross_process_holder {
        builder = builder.cross_process_store_config(CrossProcessLockConfig::MultiProcess {
            holder_name: holder.clone(),
        });
    }

    if let Some(pem) = &params.dev_root_certificate_pem {
        builder = builder.add_root_certificates(vec![Certificate::from_pem(pem.as_bytes())?]);
    }

    let client = builder.build().await?;

    // Persist rotated tokens synchronously while the SDK holds its refresh
    // lock, and reload them (another process, e.g. the iOS NSE, may have
    // refreshed in the meantime).
    let refreshes = Arc::new(AtomicU32::new(0));
    let counter = refreshes.clone();
    client.set_session_callbacks(
        Box::new(|client| {
            let stored =
                block_on_runtime(read_stored_session(&client))?.context("no stored session")?;
            Ok(matrix_sdk::SessionTokens {
                access_token: stored.access_token,
                refresh_token: stored.refresh_token,
            })
        }),
        Box::new(move |client| {
            block_on_runtime(persist_session(&client))?;
            counter.fetch_add(1, Ordering::SeqCst);
            tracing::debug!("persisted refreshed session");
            Ok(())
        }),
    )?;

    if let Some(holder) = &params.cross_process_holder {
        client
            .oauth()
            .enable_cross_process_refresh_lock(holder.clone())
            .await?;
    }

    tracing::debug!("client built in {:?}", started.elapsed());

    Ok((client, refreshes))
}

/// Restores the OAuth session persisted in the encrypted state store.
pub(crate) async fn restore_stored_session(
    client: &Client,
    room_load_settings: RoomLoadSettings,
) -> Result<Option<SessionInfo>> {
    let Some(stored) = read_stored_session(client).await? else {
        return Ok(None);
    };
    let session = OAuthSession {
        client_id: ClientId::new(stored.client_id),
        user: UserSession {
            meta: matrix_sdk::SessionMeta {
                user_id: UserId::parse(&stored.user_id)?,
                device_id: stored.device_id.clone().into(),
            },
            tokens: matrix_sdk::SessionTokens {
                access_token: stored.access_token,
                refresh_token: stored.refresh_token,
            },
        },
    };
    client
        .restore_session_with(AuthSession::OAuth(session.into()), room_load_settings)
        .await?;
    Ok(Some(SessionInfo {
        user_id: stored.user_id,
        device_id: stored.device_id,
    }))
}

/// Runs an async store operation from a synchronous SDK callback.
fn block_on_runtime<F: std::future::Future>(future: F) -> F::Output {
    tokio::task::block_in_place(|| tokio::runtime::Handle::current().block_on(future))
}

async fn read_stored_session(client: &Client) -> Result<Option<StoredSession>> {
    let Some(bytes) = client.state_store().get_custom_value(SESSION_KEY).await? else {
        return Ok(None);
    };
    Ok(Some(serde_json::from_slice(&bytes)?))
}

async fn persist_session(client: &Client) -> Result<()> {
    let oauth = client.oauth();
    let session = oauth.user_session().context("no user session")?;
    let stored = StoredSession {
        client_id: oauth.client_id().context("no client id")?.to_string(),
        user_id: session.meta.user_id.to_string(),
        device_id: session.meta.device_id.to_string(),
        access_token: session.tokens.access_token,
        refresh_token: session.tokens.refresh_token,
    };
    client
        .state_store()
        .set_custom_value(SESSION_KEY, serde_json::to_vec(&stored)?)
        .await?;
    Ok(())
}

async fn summarize_room(room: &RoomListItem) -> RoomSummary {
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
