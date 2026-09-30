//! Logging to a file (stdout is not visible on iOS/Android).
//!
//! No personal content: the SDK logs identifiers (user, room and event ids)
//! but neither message bodies nor tokens up to `debug`. `trace` is never
//! enabled for SDK crates, since it may dump request and event payloads.

use std::sync::OnceLock;

use flutter_rust_bridge::frb;
use tracing_subscriber::{fmt, layer::SubscriberExt, reload, EnvFilter, Registry};

use crate::api::error::ChatError;

#[derive(Clone, Copy, Debug, PartialEq)]
pub enum LogLevel {
    Error,
    Warn,
    Info,
    Debug,
}

static FILTER: OnceLock<reload::Handle<EnvFilter, Registry>> = OnceLock::new();

#[frb(init)]
pub fn init_app() {
    flutter_rust_bridge::setup_default_user_utils();
}

/// Writes logs to `log_file`. Later calls (e.g. after a hot restart) only
/// change the level; the file stays.
pub fn init_logging(log_file: String, level: LogLevel) -> Result<(), ChatError> {
    let filter = filter(level)?;
    if let Some(handle) = FILTER.get() {
        return handle
            .reload(filter)
            .map_err(|error| ChatError::invalid(error.to_string()));
    }

    let file = std::fs::OpenOptions::new()
        .create(true)
        .append(true)
        .open(log_file)
        .map_err(|error| ChatError::Storage {
            message: error.to_string(),
        })?;
    let (filter, handle) = reload::Layer::new(filter);
    // FRB already installs a `log` logger; only set the tracing dispatcher.
    let subscriber = Registry::default().with(filter).with(
        fmt::layer()
            .with_ansi(false)
            .with_writer(std::sync::Mutex::new(file)),
    );
    tracing::subscriber::set_global_default(subscriber)
        .map_err(|error| ChatError::invalid(error.to_string()))?;
    let _ = FILTER.set(handle);

    // Panics only reach stderr, which nobody sees on a device.
    let previous_hook = std::panic::take_hook();
    std::panic::set_hook(Box::new(move |info| {
        tracing::error!("panic: {info}");
        previous_hook(info);
    }));
    Ok(())
}

fn filter(level: LogLevel) -> Result<EnvFilter, ChatError> {
    EnvFilter::try_new(directives(level)).map_err(|error| ChatError::invalid(error.to_string()))
}

fn directives(level: LogLevel) -> &'static str {
    match level {
        LogLevel::Error => "error",
        LogLevel::Warn => "warn",
        LogLevel::Info => {
            "warn,matrix_sdk=info,matrix_sdk_ui=info,matrix_sdk_crypto=info,\
             matrix_sdk::sliding_sync=warn,ngotools_matrix_core=info"
        }
        LogLevel::Debug => {
            "info,matrix_sdk=debug,matrix_sdk_ui=debug,matrix_sdk_base=debug,\
             matrix_sdk_crypto=debug,ngotools_matrix_core=debug"
        }
    }
}

#[cfg(test)]
mod tests {
    use super::{directives, filter, LogLevel};

    const LEVELS: [LogLevel; 4] = [
        LogLevel::Error,
        LogLevel::Warn,
        LogLevel::Info,
        LogLevel::Debug,
    ];

    #[test]
    fn every_level_is_a_valid_filter() {
        for level in LEVELS {
            assert!(filter(level).is_ok(), "{level:?}");
        }
    }

    #[test]
    fn never_enables_trace() {
        for level in LEVELS {
            assert!(!directives(level).contains("trace"), "{level:?}");
        }
    }
}
