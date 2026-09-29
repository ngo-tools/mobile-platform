//! Typed errors of the facade. Dart receives them as `ChatError` exceptions
//! and can react to the kind (signed out, locked, offline, …) instead of
//! parsing messages.

use std::time::{Duration, SystemTime};

use matrix_sdk::{
    authentication::oauth::OAuthError,
    ruma::api::error::{ErrorKind, RetryAfter},
    HttpError, RefreshTokenError,
};
use oauth2::{basic::BasicErrorResponseType, RequestTokenError};

#[derive(Debug)]
pub enum ChatError {
    /// No connection to the homeserver or MAS (retry later).
    Network,
    /// The session is no longer valid; the user must sign in again.
    SessionExpired,
    /// The account was locked (e.g. chat access revoked in NGO.Tools).
    AccountLocked,
    Forbidden,
    NotFound,
    RateLimited {
        retry_after_ms: Option<u64>,
    },
    Crypto {
        message: String,
    },
    Storage {
        message: String,
    },
    InvalidInput {
        message: String,
    },
    Internal {
        message: String,
    },
}

impl std::fmt::Display for ChatError {
    fn fmt(&self, formatter: &mut std::fmt::Formatter<'_>) -> std::fmt::Result {
        match self {
            Self::Network => write!(formatter, "network unavailable"),
            Self::SessionExpired => write!(formatter, "session expired"),
            Self::AccountLocked => write!(formatter, "account locked"),
            Self::Forbidden => write!(formatter, "forbidden"),
            Self::NotFound => write!(formatter, "not found"),
            Self::RateLimited { retry_after_ms } => {
                write!(
                    formatter,
                    "rate limited (retry after {retry_after_ms:?} ms)"
                )
            }
            Self::Crypto { message } => write!(formatter, "crypto error: {message}"),
            Self::Storage { message } => write!(formatter, "storage error: {message}"),
            Self::InvalidInput { message } => write!(formatter, "invalid input: {message}"),
            Self::Internal { message } => write!(formatter, "internal error: {message}"),
        }
    }
}

impl std::error::Error for ChatError {}

impl ChatError {
    pub(crate) fn invalid(message: impl Into<String>) -> Self {
        Self::InvalidInput {
            message: message.into(),
        }
    }
}

/// Maps a Matrix error code to the facade error, if it is one we distinguish.
pub(crate) fn classify_kind(kind: &ErrorKind) -> Option<ChatError> {
    Some(match kind {
        ErrorKind::UnknownToken(_) => ChatError::SessionExpired,
        ErrorKind::UserLocked | ErrorKind::UserDeactivated | ErrorKind::UserSuspended => {
            ChatError::AccountLocked
        }
        ErrorKind::Forbidden => ChatError::Forbidden,
        ErrorKind::NotFound => ChatError::NotFound,
        ErrorKind::LimitExceeded(data) => ChatError::RateLimited {
            retry_after_ms: data.retry_after.as_ref().map(retry_after_ms),
        },
        _ => return None,
    })
}

fn retry_after_ms(retry_after: &RetryAfter) -> u64 {
    let delay = match retry_after {
        RetryAfter::Delay(delay) => *delay,
        RetryAfter::DateTime(at) => at
            .duration_since(SystemTime::now())
            .unwrap_or(Duration::ZERO),
    };
    u64::try_from(delay.as_millis()).unwrap_or(u64::MAX)
}

fn classify_http(error: &HttpError) -> Option<ChatError> {
    if let Some(kind) = error.client_api_error_kind() {
        if let Some(classified) = classify_kind(kind) {
            return Some(classified);
        }
    }

    match error {
        HttpError::Reqwest(reqwest) if reqwest.is_connect() || reqwest.is_timeout() => {
            Some(ChatError::Network)
        }
        HttpError::RefreshToken(refresh) => Some(classify_refresh(refresh)),
        HttpError::Cached(inner) => classify_http(inner),
        _ => None,
    }
}

/// A refresh that fails for lack of connectivity must not sign the user out.
fn classify_refresh(error: &RefreshTokenError) -> ChatError {
    match error {
        RefreshTokenError::RefreshTokenRequired => ChatError::SessionExpired,
        RefreshTokenError::MatrixAuth(http) => {
            classify_http(http).unwrap_or(ChatError::SessionExpired)
        }
        RefreshTokenError::OAuth(oauth) => classify_oauth(oauth),
    }
}

fn classify_oauth(error: &OAuthError) -> ChatError {
    match error {
        OAuthError::RefreshToken(RequestTokenError::ServerResponse(response)) => {
            match response.error() {
                BasicErrorResponseType::InvalidGrant
                | BasicErrorResponseType::InvalidClient
                | BasicErrorResponseType::UnauthorizedClient => ChatError::SessionExpired,
                _ => ChatError::Internal {
                    message: error.to_string(),
                },
            }
        }
        OAuthError::RefreshToken(RequestTokenError::Request(_)) => ChatError::Network,
        _ => ChatError::Internal {
            message: error.to_string(),
        },
    }
}

fn classify_sdk(error: &matrix_sdk::Error) -> Option<ChatError> {
    use matrix_sdk::Error;

    if let Some(kind) = error.client_api_error_kind() {
        if let Some(classified) = classify_kind(kind) {
            return Some(classified);
        }
    }

    Some(match error {
        Error::Http(http) => return classify_http(http),
        Error::AuthenticationRequired => ChatError::SessionExpired,
        Error::CryptoStoreError(inner) => ChatError::Storage {
            message: inner.to_string(),
        },
        Error::StateStore(inner) => ChatError::Storage {
            message: inner.to_string(),
        },
        Error::OlmError(inner) => ChatError::Crypto {
            message: inner.to_string(),
        },
        Error::MegolmError(inner) => ChatError::Crypto {
            message: inner.to_string(),
        },
        _ => return None,
    })
}

impl From<anyhow::Error> for ChatError {
    fn from(error: anyhow::Error) -> Self {
        for cause in error.chain() {
            if let Some(chat) = cause.downcast_ref::<ChatError>() {
                return chat.clone_kind();
            }
            if let Some(sdk) = cause.downcast_ref::<matrix_sdk::Error>() {
                if let Some(classified) = classify_sdk(sdk) {
                    return classified;
                }
            }
            if let Some(http) = cause.downcast_ref::<HttpError>() {
                if let Some(classified) = classify_http(http) {
                    return classified;
                }
            }
            if let Some(refresh) = cause.downcast_ref::<RefreshTokenError>() {
                return classify_refresh(refresh);
            }
            if let Some(oauth) = cause.downcast_ref::<OAuthError>() {
                return classify_oauth(oauth);
            }
            if let Some(reqwest) = cause.downcast_ref::<matrix_sdk::reqwest::Error>() {
                if reqwest.is_connect() || reqwest.is_timeout() {
                    return ChatError::Network;
                }
            }
        }

        ChatError::Internal {
            message: format!("{error:#}"),
        }
    }
}

impl ChatError {
    fn clone_kind(&self) -> Self {
        match self {
            Self::Network => Self::Network,
            Self::SessionExpired => Self::SessionExpired,
            Self::AccountLocked => Self::AccountLocked,
            Self::Forbidden => Self::Forbidden,
            Self::NotFound => Self::NotFound,
            Self::RateLimited { retry_after_ms } => Self::RateLimited {
                retry_after_ms: *retry_after_ms,
            },
            Self::Crypto { message } => Self::Crypto {
                message: message.clone(),
            },
            Self::Storage { message } => Self::Storage {
                message: message.clone(),
            },
            Self::InvalidInput { message } => Self::InvalidInput {
                message: message.clone(),
            },
            Self::Internal { message } => Self::Internal {
                message: message.clone(),
            },
        }
    }
}

#[cfg(test)]
mod tests {
    use std::time::Duration;

    use matrix_sdk::ruma::api::error::{
        ErrorKind, LimitExceededErrorData, RetryAfter, UnknownTokenErrorData,
    };

    use super::{classify_kind, ChatError};

    #[test]
    fn maps_expired_and_locked_sessions() {
        assert!(matches!(
            classify_kind(&ErrorKind::UnknownToken(UnknownTokenErrorData::new())),
            Some(ChatError::SessionExpired)
        ));
        assert!(matches!(
            classify_kind(&ErrorKind::UserLocked),
            Some(ChatError::AccountLocked)
        ));
        assert!(matches!(
            classify_kind(&ErrorKind::UserDeactivated),
            Some(ChatError::AccountLocked)
        ));
    }

    #[test]
    fn keeps_the_rate_limit_delay() {
        let mut data = LimitExceededErrorData::new();
        data.retry_after = Some(RetryAfter::Delay(Duration::from_millis(1500)));

        assert!(matches!(
            classify_kind(&ErrorKind::LimitExceeded(data)),
            Some(ChatError::RateLimited {
                retry_after_ms: Some(1500)
            })
        ));
    }

    #[test]
    fn signs_out_only_when_the_refresh_token_is_rejected() {
        use matrix_sdk::authentication::oauth::OAuthError;
        use oauth2::{
            basic::BasicErrorResponseType, HttpClientError, RequestTokenError,
            StandardErrorResponse,
        };

        use super::classify_oauth;

        let rejected = OAuthError::RefreshToken(RequestTokenError::ServerResponse(
            StandardErrorResponse::new(BasicErrorResponseType::InvalidGrant, None, None),
        ));
        assert!(matches!(
            classify_oauth(&rejected),
            ChatError::SessionExpired
        ));

        let offline = OAuthError::RefreshToken(RequestTokenError::Request(HttpClientError::Other(
            "connection refused".to_owned(),
        )));
        assert!(matches!(classify_oauth(&offline), ChatError::Network));
    }

    #[test]
    fn leaves_unknown_codes_unclassified() {
        assert!(classify_kind(&ErrorKind::TooLarge).is_none());
    }

    #[test]
    fn wraps_unknown_errors_as_internal_and_keeps_chat_errors() {
        let internal = ChatError::from(anyhow::anyhow!("boom"));
        assert!(matches!(internal, ChatError::Internal { message } if message == "boom"));

        let wrapped = ChatError::from(anyhow::Error::new(ChatError::NotFound).context("room"));
        assert!(matches!(wrapped, ChatError::NotFound));
    }
}
