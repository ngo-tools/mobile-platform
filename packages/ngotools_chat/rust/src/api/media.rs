//! Authenticated media (and E2EE decryption) for timeline items and avatars.

use matrix_sdk::{
    media::{MediaFormat, MediaRequestParameters},
    ruma::events::room::MediaSource,
};

use crate::{
    api::{client::ChatClient, error::ChatError},
    runtime::on_runtime,
};

impl ChatClient {
    /// Downloads (and decrypts) media referenced by a timeline item
    /// (`EventContent::*::media`). Uses the SDK media cache.
    pub async fn fetch_media(&self, media: String) -> Result<Vec<u8>, ChatError> {
        let source: MediaSource =
            serde_json::from_str(&media).map_err(|error| ChatError::invalid(error.to_string()))?;
        let client = self.client.clone();
        on_runtime(async move {
            let request = MediaRequestParameters {
                source,
                format: MediaFormat::File,
            };
            Ok(client.media().get_media_content(&request, true).await?)
        })
        .await
    }
}
