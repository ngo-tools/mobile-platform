//! Key backup / recovery key and device verification state.

use futures_util::StreamExt;
use matrix_sdk::encryption::{
    recovery::{RecoveryError, RecoveryState},
    secret_storage::SecretStorageError,
    VerificationState,
};

use crate::{
    api::{client::ChatClient, error::ChatError},
    frb_generated::StreamSink,
    runtime::runtime,
};

#[derive(Clone, Copy, Debug, PartialEq, Eq)]
pub enum RecoveryStatus {
    Unknown,
    Enabled,
    Disabled,
    /// Recovery is set up for the account, but this device does not have the
    /// secrets yet: enter the recovery key.
    Incomplete,
}

/// What the app shows about encryption: whether recovery is set up and
/// whether this device is verified.
#[derive(Clone, Copy, Debug, PartialEq, Eq)]
pub struct EncryptionStatus {
    pub recovery: RecoveryStatus,
    pub device_verified: bool,
}

fn recovery_status(state: RecoveryState) -> RecoveryStatus {
    match state {
        RecoveryState::Unknown => RecoveryStatus::Unknown,
        RecoveryState::Enabled => RecoveryStatus::Enabled,
        RecoveryState::Disabled => RecoveryStatus::Disabled,
        RecoveryState::Incomplete => RecoveryStatus::Incomplete,
    }
}

impl ChatClient {
    pub async fn recovery_status(&self) -> Result<RecoveryStatus, ChatError> {
        let client = self.client.clone();
        self.lifecycle
            .run(async move {
                client
                    .encryption()
                    .wait_for_e2ee_initialization_tasks()
                    .await;
                Ok(recovery_status(client.encryption().recovery().state()))
            })
            .await
    }

    /// Streams recovery and verification state; starts with the current one
    /// and emits only changes.
    pub async fn watch_encryption(
        &self,
        sink: StreamSink<EncryptionStatus>,
    ) -> Result<(), ChatError> {
        let client = self.client.clone();
        let task = runtime().spawn(async move {
            let encryption = client.encryption();
            encryption.wait_for_e2ee_initialization_tasks().await;
            let mut recovery = encryption.recovery().state_stream().fuse();
            let mut verification = encryption.verification_state();
            let mut status = EncryptionStatus {
                recovery: recovery_status(encryption.recovery().state()),
                device_verified: verification.get() == VerificationState::Verified,
            };
            if sink.add(status).is_err() {
                return;
            }
            loop {
                let next = tokio::select! {
                    Some(state) = recovery.next() => EncryptionStatus {
                        recovery: recovery_status(state),
                        ..status
                    },
                    Some(state) = verification.next() => EncryptionStatus {
                        device_verified: state == VerificationState::Verified,
                        ..status
                    },
                    else => break,
                };
                if next == status {
                    continue;
                }
                status = next;
                if sink.add(status).is_err() {
                    break;
                }
            }
        });
        if let Some(previous) = self.encryption_task.lock().await.replace(task) {
            previous.abort();
        }
        Ok(())
    }

    /// Enables key backup + secret storage and returns the recovery key
    /// that the user has to write down. Replaces an existing recovery key.
    pub async fn enable_recovery(&self) -> Result<String, ChatError> {
        let client = self.client.clone();
        self.lifecycle
            .run(async move {
                client
                    .encryption()
                    .wait_for_e2ee_initialization_tasks()
                    .await;
                let recovery = client.encryption().recovery();
                // A new key for an account that already has recovery.
                if recovery.state() == RecoveryState::Enabled {
                    return Ok(recovery.reset_key().await?);
                }
                Ok(recovery.enable().await?)
            })
            .await
    }

    /// Restores cross-signing and the key backup on a new device. A key that
    /// does not open the account's secret storage fails with `InvalidInput`.
    pub async fn recover(&self, recovery_key: String) -> Result<(), ChatError> {
        let client = self.client.clone();
        self.lifecycle
            .run(async move {
                client
                    .encryption()
                    .wait_for_e2ee_initialization_tasks()
                    .await;
                match client.encryption().recovery().recover(&recovery_key).await {
                    // Mistyped or not this account's key: the user can fix it.
                    Err(RecoveryError::SecretStorage(SecretStorageError::SecretStorageKey(_))) => {
                        Err(ChatError::invalid("wrong recovery key").into())
                    }
                    result => Ok(result?),
                }
            })
            .await
    }

    /// Whether this is the account's only device: signing out without
    /// recovery loses access to encrypted history.
    pub async fn is_last_device(&self) -> Result<bool, ChatError> {
        let client = self.client.clone();
        self.lifecycle
            .run(async move {
                client
                    .encryption()
                    .wait_for_e2ee_initialization_tasks()
                    .await;
                Ok(client.encryption().recovery().is_last_device().await?)
            })
            .await
    }

    /// `verified` once this device is cross-signed (e.g. after recovery).
    pub async fn verification_state(&self) -> Result<String, ChatError> {
        let client = self.client.clone();
        self.lifecycle
            .run(async move {
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
}
