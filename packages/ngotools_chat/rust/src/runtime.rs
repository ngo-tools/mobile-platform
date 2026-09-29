//! The facade's own tokio runtime. reqwest and the SDK require a tokio
//! context; flutter_rust_bridge's async executor does not provide one.

use std::{ops::Deref, sync::OnceLock};

use tokio::runtime::Runtime;

use crate::api::error::ChatError;

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

/// Runs a future on the facade runtime and converts its error at the API
/// boundary.
pub(crate) async fn on_runtime<F, T>(future: F) -> Result<T, ChatError>
where
    F: std::future::Future<Output = anyhow::Result<T>> + Send + 'static,
    T: Send + 'static,
{
    match runtime().spawn(future).await {
        Ok(result) => result.map_err(ChatError::from),
        Err(error) => Err(ChatError::Internal {
            message: format!("task failed: {error}"),
        }),
    }
}

/// Runs an async store operation from a synchronous SDK callback.
pub(crate) fn block_on_runtime<F: std::future::Future>(future: F) -> F::Output {
    tokio::task::block_in_place(|| tokio::runtime::Handle::current().block_on(future))
}

/// Drops its value inside the facade runtime. Dart releases opaque objects
/// on its own threads, but the SDK's SQLite stores return pooled connections
/// via `tokio::task::spawn_blocking`, which panics without a tokio context.
pub(crate) struct DropInRuntime<T>(Option<T>);

impl<T> DropInRuntime<T> {
    pub(crate) fn new(value: T) -> Self {
        Self(Some(value))
    }
}

impl<T> Deref for DropInRuntime<T> {
    type Target = T;

    fn deref(&self) -> &T {
        self.0.as_ref().expect("only taken on drop")
    }
}

impl<T> Drop for DropInRuntime<T> {
    fn drop(&mut self) {
        let _context = runtime().enter();
        drop(self.0.take());
    }
}

#[cfg(test)]
mod tests {
    use super::DropInRuntime;

    struct ReturnsToPool;

    impl Drop for ReturnsToPool {
        fn drop(&mut self) {
            drop(tokio::task::spawn_blocking(|| {}));
        }
    }

    #[test]
    fn drops_outside_of_a_runtime_without_panicking() {
        drop(DropInRuntime::new(ReturnsToPool));
    }
}
