//! The chat client: configuration, OAuth login via MAS, session and sync.

use std::sync::{
    atomic::{AtomicU32, Ordering},
    Arc,
};

use anyhow::Context;
use flutter_rust_bridge::frb;
use futures_util::{pin_mut, StreamExt};
use matrix_sdk::{
    authentication::oauth::{
        registration::{ApplicationType, ClientMetadata, Localized, OAuthGrantType},
        ClientRegistrationData,
    },
    notification_settings::NotificationSettings,
    ruma::{serde::Raw, RoomId, UserId},
    store::RoomLoadSettings,
    Client, SessionChange,
};
use matrix_sdk_ui::sync_service::{State as SyncState, SyncService};
use tokio::{
    sync::{mpsc, Mutex, OnceCell},
    task::JoinHandle,
};
use url::Url;

use crate::{
    api::{error::ChatError, rooms::RoomListCommand},
    frb_generated::StreamSink,
    runtime::{on_runtime, runtime, DropInRuntime},
    session::{
        build_client, forget_session, persist_session, restore_stored_session, ClientParams,
    },
};

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
    /// supported on Android; install a user CA there).
    pub dev_root_certificate_pem: Option<String>,
    /// Holder name for the cross-process store/refresh lock. Required on iOS
    /// when a Notification Service Extension shares the store (e.g. `main`).
    pub cross_process_holder: Option<String>,
}

pub struct SessionInfo {
    pub user_id: String,
    pub device_id: String,
}

#[frb(opaque)]
pub struct ChatClient {
    pub(crate) client: DropInRuntime<Client>,
    config: Arc<ChatConfigInner>,
    pub(crate) sync_service: DropInRuntime<Mutex<Option<Arc<SyncService>>>>,
    pub(crate) room_task: Mutex<Option<JoinHandle<()>>>,
    pub(crate) room_commands: Mutex<Option<mpsc::UnboundedSender<RoomListCommand>>>,
    session_task: Mutex<Option<JoinHandle<()>>>,
    pending_login_state: Mutex<Option<String>>,
    refreshes: Arc<AtomicU32>,
    /// One instance per client: it applies own changes immediately and
    /// follows push rule updates from sync (a fresh instance would read the
    /// store, which only changes with the next sync).
    pub(crate) notification_settings: DropInRuntime<Arc<OnceCell<NotificationSettings>>>,
}

struct ChatConfigInner {
    client_name: String,
    client_uri: String,
    redirect_uri: String,
}

impl ChatClient {
    /// Builds the client with encrypted SQLite stores. No network access.
    pub async fn create(config: ChatConfig) -> Result<ChatClient, ChatError> {
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
                client: DropInRuntime::new(client),
                config: Arc::new(ChatConfigInner {
                    client_name: config.client_name,
                    client_uri: config.client_uri,
                    redirect_uri: config.redirect_uri,
                }),
                sync_service: DropInRuntime::new(Mutex::new(None)),
                room_task: Mutex::new(None),
                room_commands: Mutex::new(None),
                session_task: Mutex::new(None),
                pending_login_state: Mutex::new(None),
                refreshes,
                notification_settings: DropInRuntime::new(Arc::new(OnceCell::new())),
            })
        })
        .await
    }

    /// Restores a previously persisted session from the encrypted store.
    pub async fn restore_session(&self) -> Result<Option<SessionInfo>, ChatError> {
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
    pub async fn login_url(&self) -> Result<String, ChatError> {
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
    pub async fn finish_login(&self, callback_url: String) -> Result<SessionInfo, ChatError> {
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

    pub async fn logout(&self) -> Result<(), ChatError> {
        self.stop_sync().await?;
        let client = self.client.clone();
        on_runtime(async move {
            client.oauth().logout().await?;
            forget_session(&client).await
        })
        .await
    }

    /// Starts the sync service (Simplified Sliding Sync + encryption sync).
    pub async fn start_sync(&self) -> Result<(), ChatError> {
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

    pub async fn stop_sync(&self) -> Result<(), ChatError> {
        if let Some(task) = self.room_task.lock().await.take() {
            task.abort();
        }
        self.room_commands.lock().await.take();
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
    pub async fn watch_sync_state(&self, sink: StreamSink<String>) -> Result<(), ChatError> {
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

    /// Creates (or reuses) an encrypted DM with the given user.
    pub async fn create_dm(&self, user_id: String) -> Result<String, ChatError> {
        let user_id =
            UserId::parse(&user_id).map_err(|error| ChatError::invalid(error.to_string()))?;
        let client = self.client.clone();
        on_runtime(async move {
            if let Some(room) = client.get_dm_room(&user_id) {
                return Ok(room.room_id().to_string());
            }
            let room = client.create_dm(&user_id).await?;
            Ok(room.room_id().to_string())
        })
        .await
    }

    pub async fn join_room(&self, room_id: String) -> Result<(), ChatError> {
        let room_id =
            RoomId::parse(&room_id).map_err(|error| ChatError::invalid(error.to_string()))?;
        let client = self.client.clone();
        on_runtime(async move {
            let room = client.get_room(&room_id).ok_or(ChatError::NotFound)?;
            room.join().await?;
            Ok(())
        })
        .await
    }

    pub async fn user_id(&self) -> Option<String> {
        self.client.user_id().map(|user_id| user_id.to_string())
    }

    /// Authenticated round trip (`/whoami`); refreshes an expired access token.
    pub async fn whoami(&self) -> Result<String, ChatError> {
        let client = self.client.clone();
        on_runtime(async move { Ok(client.whoami().await?.user_id.to_string()) }).await
    }

    /// Number of token refreshes persisted by this client instance.
    pub fn persisted_refreshes(&self) -> u32 {
        self.refreshes.load(Ordering::SeqCst)
    }

    /// Stops all background work so that another client may open the store.
    pub async fn shutdown(&self) -> Result<(), ChatError> {
        if let Some(task) = self.session_task.lock().await.take() {
            task.abort();
        }
        self.stop_room_list().await;
        self.stop_sync().await
    }

    pub(crate) async fn sync_service(&self) -> Result<Arc<SyncService>, ChatError> {
        self.sync_service
            .lock()
            .await
            .clone()
            .ok_or_else(|| ChatError::invalid("sync not started"))
    }

    /// Logs session changes; persisting refreshed tokens happens in the
    /// synchronous session callbacks (see `session::build_client`).
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
