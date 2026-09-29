//! The facade's own tokio runtime. reqwest and the SDK require a tokio
//! context; flutter_rust_bridge's async executor does not provide one.

use std::sync::OnceLock;

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
