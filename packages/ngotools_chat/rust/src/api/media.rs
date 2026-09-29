//! Authenticated media (and E2EE decryption) for timeline items and avatars.

use matrix_sdk::{
    media::{MediaFormat, MediaRequestParameters, MediaThumbnailSettings},
    ruma::{events::room::MediaSource, UInt},
};

use crate::{
    api::{client::ChatClient, error::ChatError},
    runtime::on_runtime,
};

impl ChatClient {
    /// Downloads (and decrypts) media referenced by a timeline item
    /// (`EventContent::*::media`). Uses the SDK media cache.
    pub async fn fetch_media(&self, media: String) -> Result<Vec<u8>, ChatError> {
        let source = parse_media(&media)?;
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

    /// Downloads a scaled preview (`width` x `height`, aspect kept). The
    /// server scales plain media; encrypted media cannot be scaled, so this
    /// returns the whole (decrypted) file. Prefer `EventContent::Image::
    /// thumbnail` with `fetch_media` when it is set.
    pub async fn fetch_thumbnail(
        &self,
        media: String,
        width: u32,
        height: u32,
    ) -> Result<Vec<u8>, ChatError> {
        let source = parse_media(&media)?;
        let client = self.client.clone();
        on_runtime(async move {
            let settings = MediaThumbnailSettings::new(UInt::from(width), UInt::from(height));
            let request = MediaRequestParameters {
                source,
                format: MediaFormat::Thumbnail(settings),
            };
            Ok(client.media().get_media_content(&request, true).await?)
        })
        .await
    }
}

fn parse_media(media: &str) -> Result<MediaSource, ChatError> {
    serde_json::from_str(media).map_err(|error| ChatError::invalid(error.to_string()))
}
