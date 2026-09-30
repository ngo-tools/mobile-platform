//! Key backup / recovery key and device verification state.

use matrix_sdk::encryption::{recovery::RecoveryState, VerificationState};

use crate::api::{client::ChatClient, error::ChatError};

pub enum RecoveryStatus {
    Unknown,
    Enabled,
    Disabled,
    Incomplete,
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
    pub async fn enable_recovery(&self) -> Result<String, ChatError> {
        let client = self.client.clone();
        self.lifecycle
            .run(async move {
                client
                    .encryption()
                    .wait_for_e2ee_initialization_tasks()
                    .await;
                Ok(client.encryption().recovery().enable().await?)
            })
            .await
    }

    /// Restores cross-signing and the key backup on a new device.
    pub async fn recover(&self, recovery_key: String) -> Result<(), ChatError> {
        let client = self.client.clone();
        self.lifecycle
            .run(async move {
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
