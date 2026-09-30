//! Session state, sync status and the app lifecycle (pause/resume).
//!
//! The sync service runs in offline mode: network loss is handled by the SDK
//! (it polls `/versions` and resumes). Other errors restart it with a
//! backoff, except when the session is gone: then the state switches to
//! `Expired`/`Locked` and the app has to sign in again.

use std::{
    sync::{
        atomic::{AtomicBool, Ordering},
        Arc,
    },
    time::Duration,
};

use futures_util::{pin_mut, StreamExt};
use matrix_sdk_ui::sync_service::{State as SyncState, SyncService};
use tokio::sync::watch;

use crate::{
    api::{
        client::ChatClient,
        error::{classify_error, ChatError},
    },
    frb_generated::StreamSink,
    runtime::{on_runtime, runtime},
};

#[derive(Clone, Copy, Debug, PartialEq)]
pub enum SessionState {
    SignedOut,
    Active,
    /// Tokens were revoked or rejected; sign in again.
    Expired,
    /// The account was locked or deactivated.
    Locked,
}

#[derive(Clone, Copy, Debug, PartialEq)]
pub enum SyncStatus {
    Idle,
    Running,
    /// No connection; the SDK resumes on its own.
    Offline,
    /// Failed; restarted with a backoff unless the session is gone.
    Error,
    Stopped,
}

pub(crate) struct Lifecycle {
    session: watch::Sender<SessionState>,
    paused: AtomicBool,
}

impl Lifecycle {
    pub(crate) fn new() -> Arc<Self> {
        Arc::new(Self {
            session: watch::Sender::new(SessionState::SignedOut),
            paused: AtomicBool::new(false),
        })
    }

    pub(crate) fn set_session(&self, state: SessionState) {
        self.session.send_if_modified(|current| {
            let changed = *current != state;
            *current = state;
            changed
        });
    }

    fn session(&self) -> SessionState {
        *self.session.borrow()
    }

    /// Ends an active session when a call shows that it is gone. The SDK
    /// does not always report this itself (e.g. MAS keeps refreshing tokens
    /// of locked accounts that the homeserver then rejects).
    pub(crate) fn report(&self, error: &ChatError) {
        let next = match error {
            ChatError::SessionExpired => SessionState::Expired,
            ChatError::AccountLocked => SessionState::Locked,
            _ => return,
        };
        self.session.send_if_modified(|current| {
            if *current != SessionState::Active {
                return false;
            }
            *current = next;
            true
        });
    }

    /// Runs a facade call on the runtime and reports session errors.
    pub(crate) async fn run<F, T>(&self, future: F) -> Result<T, ChatError>
    where
        F: std::future::Future<Output = anyhow::Result<T>> + Send + 'static,
        T: Send + 'static,
    {
        let result = on_runtime(future).await;
        if let Err(error) = &result {
            self.report(error);
        }
        result
    }
}

impl ChatClient {
    /// Streams the session state; starts with the current one.
    pub async fn watch_session_state(
        &self,
        sink: StreamSink<SessionState>,
    ) -> Result<(), ChatError> {
        let mut states = self.lifecycle.session.subscribe();
        let task = runtime().spawn(async move {
            loop {
                let state = *states.borrow_and_update();
                if sink.add(state).is_err() || states.changed().await.is_err() {
                    break;
                }
            }
        });
        if let Some(previous) = self.session_state_task.lock().await.replace(task) {
            previous.abort();
        }
        Ok(())
    }

    /// Streams the sync status; starts with the current one.
    pub async fn watch_sync_status(&self, sink: StreamSink<SyncStatus>) -> Result<(), ChatError> {
        let service = self.sync_service().await?;
        let task = runtime().spawn(async move {
            let states = service.state();
            let initial = states.get();
            let states = futures_util::stream::once(async move { initial }).chain(states);
            pin_mut!(states);
            while let Some(state) = states.next().await {
                if sink.add(sync_status(&state)).is_err() {
                    break;
                }
            }
        });
        if let Some(previous) = self.sync_status_task.lock().await.replace(task) {
            previous.abort();
        }
        Ok(())
    }

    /// Stops syncing while the app is in the background (room list and
    /// timelines stay; on iOS this frees the store for the notification
    /// extension).
    pub async fn pause(&self) -> Result<(), ChatError> {
        self.lifecycle.paused.store(true, Ordering::SeqCst);
        let Some(service) = self.sync_service.lock().await.clone() else {
            return Ok(());
        };
        self.lifecycle
            .run(async move {
                service.stop().await;
                Ok(())
            })
            .await
    }

    /// Resumes syncing after `pause`.
    pub async fn resume(&self) -> Result<(), ChatError> {
        self.lifecycle.paused.store(false, Ordering::SeqCst);
        match self.lifecycle.session() {
            SessionState::Active => {}
            SessionState::Locked => return Err(ChatError::AccountLocked),
            SessionState::Expired | SessionState::SignedOut => {
                return Err(ChatError::SessionExpired)
            }
        }
        let service = self.sync_service().await?;
        self.lifecycle
            .run(async move {
                service.start().await;
                Ok(())
            })
            .await
    }

    pub(crate) fn supervise(&self, service: Arc<SyncService>) -> tokio::task::JoinHandle<()> {
        let lifecycle = self.lifecycle.clone();
        runtime().spawn(async move {
            let states = service.state();
            pin_mut!(states);
            let mut session = lifecycle.session.subscribe();
            let mut failures = 0;
            loop {
                tokio::select! {
                    state = states.next() => {
                        let Some(state) = state else { break };
                        match state {
                            SyncState::Running => failures = 0,
                            SyncState::Error(error) => {
                                restart_after_error(&service, &lifecycle, &error, failures).await;
                                failures += 1;
                            }
                            _ => {}
                        }
                    }
                    changed = session.changed() => {
                        if changed.is_err() {
                            break;
                        }
                        let state = *session.borrow_and_update();
                        if matches!(state, SessionState::Expired | SessionState::Locked) {
                            // Offline mode would otherwise keep retrying with
                            // the rejected token.
                            tracing::warn!("session {state:?}, stopping sync");
                            service.stop().await;
                        }
                    }
                }
            }
        })
    }
}

async fn restart_after_error(
    service: &SyncService,
    lifecycle: &Lifecycle,
    error: &matrix_sdk_ui::sync_service::Error,
    failures: u32,
) {
    let classified = classify_error(error);
    if matches!(
        classified,
        ChatError::SessionExpired | ChatError::AccountLocked
    ) {
        lifecycle.report(&classified);
        return;
    }
    let delay = restart_delay(failures);
    tracing::warn!("sync failed, restarting in {delay:?}: {error}");
    tokio::time::sleep(delay).await;
    if lifecycle.paused.load(Ordering::SeqCst) || lifecycle.session() != SessionState::Active {
        return;
    }
    service.start().await;
}

pub(crate) fn sync_status(state: &SyncState) -> SyncStatus {
    match state {
        SyncState::Idle => SyncStatus::Idle,
        SyncState::Running => SyncStatus::Running,
        SyncState::Terminated => SyncStatus::Stopped,
        SyncState::Error(_) => SyncStatus::Error,
        SyncState::Offline => SyncStatus::Offline,
    }
}

/// 1 s, 2 s, 4 s, … capped at 30 s.
fn restart_delay(failures: u32) -> Duration {
    Duration::from_secs(2u64.saturating_pow(failures).min(30))
}

#[cfg(test)]
mod tests {
    use std::time::Duration;

    use super::{restart_delay, Lifecycle, SessionState};

    #[test]
    fn backs_off_exponentially_up_to_thirty_seconds() {
        let delays: Vec<_> = (0..7).map(restart_delay).collect();
        assert_eq!(
            delays,
            [1, 2, 4, 8, 16, 30, 30].map(Duration::from_secs).to_vec()
        );
        assert_eq!(restart_delay(u32::MAX), Duration::from_secs(30));
    }

    #[test]
    fn ends_only_active_sessions_on_session_errors() {
        use crate::api::error::ChatError;

        let lifecycle = Lifecycle::new();
        lifecycle.report(&ChatError::SessionExpired);
        assert_eq!(lifecycle.session(), SessionState::SignedOut);

        lifecycle.set_session(SessionState::Active);
        lifecycle.report(&ChatError::Network);
        assert_eq!(lifecycle.session(), SessionState::Active);

        lifecycle.report(&ChatError::AccountLocked);
        assert_eq!(lifecycle.session(), SessionState::Locked);

        lifecycle.report(&ChatError::SessionExpired);
        assert_eq!(lifecycle.session(), SessionState::Locked);
    }

    #[test]
    fn notifies_only_real_session_changes() {
        let lifecycle = Lifecycle::new();
        let mut states = lifecycle.session.subscribe();

        lifecycle.set_session(SessionState::SignedOut);
        assert!(!states.has_changed().unwrap());

        lifecycle.set_session(SessionState::Active);
        assert!(states.has_changed().unwrap());
        assert_eq!(*states.borrow_and_update(), SessionState::Active);
    }
}
