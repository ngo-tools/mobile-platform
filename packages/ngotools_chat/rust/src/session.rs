//! Client construction and the OAuth session persisted in the encrypted
//! state store. Shared by the app and the iOS Notification Service Extension.
//!
//! Dart never sees access or refresh tokens: the session lives in the
//! encrypted SQLite store (key from the Keychain/Keystore) and refreshed
//! tokens are written back synchronously while the SDK holds its lock.

use std::{
    path::PathBuf,
    sync::{
        atomic::{AtomicU32, Ordering},
        Arc,
    },
    time::Instant,
};

use anyhow::{anyhow, Context, Result};
use matrix_sdk::{
    authentication::oauth::{ClientId, OAuthSession, UserSession},
    cross_process_lock::CrossProcessLockConfig,
    encryption::{BackupDownloadStrategy, EncryptionSettings},
    reqwest::Certificate,
    ruma::UserId,
    store::RoomLoadSettings,
    AuthSession, Client, SqliteStoreConfig, ThreadingSupport,
};
use serde::{Deserialize, Serialize};

use crate::{api::client::SessionInfo, runtime::block_on_runtime};

const SESSION_KEY: &[u8] = b"ngotools.session.v1";

#[derive(Serialize, Deserialize)]
pub(crate) struct StoredSession {
    client_id: String,
    user_id: String,
    device_id: String,
    access_token: String,
    refresh_token: Option<String>,
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
        // Thread replies leave the main timeline and appear as summaries on
        // the thread root; thread timelines show them.
        .with_threading_support(ThreadingSupport::Enabled {
            with_subscriptions: false,
        })
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
    // Media uploads report progress on their local echo.
    client.send_queue().enable_upload_progress(true);

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

pub(crate) async fn read_stored_session(client: &Client) -> Result<Option<StoredSession>> {
    let Some(bytes) = client.state_store().get_custom_value(SESSION_KEY).await? else {
        return Ok(None);
    };
    Ok(Some(serde_json::from_slice(&bytes)?))
}

pub(crate) async fn persist_session(client: &Client) -> Result<()> {
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

/// Removes the persisted session (after logout).
pub(crate) async fn forget_session(client: &Client) -> Result<()> {
    client
        .state_store()
        .remove_custom_value(SESSION_KEY)
        .await?;
    Ok(())
}
