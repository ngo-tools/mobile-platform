//! Logging to a file (stdout is not visible on iOS/Android).

use flutter_rust_bridge::frb;

use crate::api::error::ChatError;

#[frb(init)]
pub fn init_app() {
    flutter_rust_bridge::setup_default_user_utils();
}

/// Writes SDK logs to `log_file`. Callable once per process.
pub fn init_logging(log_file: String) -> Result<(), ChatError> {
    let file = std::fs::OpenOptions::new()
        .create(true)
        .append(true)
        .open(log_file)
        .map_err(|error| ChatError::Storage {
            message: error.to_string(),
        })?;
    let filter = tracing_subscriber::EnvFilter::try_new(
        "warn,matrix_sdk=info,matrix_sdk_ui=info,matrix_sdk::sliding_sync=warn,ngotools_matrix_core=debug",
    )
    .map_err(|error| ChatError::invalid(error.to_string()))?;
    // FRB already installs a `log` logger; only set the tracing dispatcher.
    let subscriber = tracing_subscriber::fmt()
        .with_env_filter(filter)
        .with_ansi(false)
        .with_writer(std::sync::Mutex::new(file))
        .finish();
    tracing::subscriber::set_global_default(subscriber)
        .map_err(|error| ChatError::invalid(error.to_string()))?;

    // Panics only reach stderr, which nobody sees on a device.
    let previous_hook = std::panic::take_hook();
    std::panic::set_hook(Box::new(move |info| {
        tracing::error!("panic: {info}");
        previous_hook(info);
    }));
    Ok(())
}
