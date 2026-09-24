# Golden App

Secret-free reference application for the NGO.Tools mobile platform. Its
manifest, native identifiers, environments, and synthetic fixtures exercise
the same gate that organization-specific applications use.

Its public runtime configuration is generated from `ngo-tools.mobile.yaml`.
Effective features and permissions are never generated from the manifest; they
must come from the authenticated runtime API.

Run it locally with an explicit environment entry point:

```bash
flutter run -t lib/main_development.dart
flutter run -t lib/main_staging.dart
flutter run -t lib/main_production.dart
```

All hosts use the reserved `.invalid` domain. The app contains no production
data, signing configuration, or store credentials.

## Protected releases

Generated organization apps include `.github/workflows/release.yml`. It can be
started manually from the protected default branch and accepts only a full
commit SHA from that branch. Before enabling it, create both GitHub
environments below with required reviewers, prevent self-review, and limit
deployment to protected branches:

- `mobile-production-android`
- `mobile-production-ios`

Store the following values only as secrets of the matching environment:

- Android: `ANDROID_KEYSTORE_BASE64`, `ANDROID_KEY_ALIAS`,
  `ANDROID_KEY_PASSWORD`, `ANDROID_STORE_PASSWORD`, and
  `GOOGLE_PLAY_SERVICE_ACCOUNT_JSON`
- iOS: `IOS_CERTIFICATE_BASE64`, `IOS_CERTIFICATE_PASSWORD`,
  `IOS_PROVISIONING_PROFILE_BASE64`, `IOS_PROVISIONING_PROFILE_NAME`,
  `IOS_TEAM_ID`, `APP_STORE_CONNECT_API_KEY_ID`,
  `APP_STORE_CONNECT_ISSUER_ID`, and `APP_STORE_CONNECT_PRIVATE_KEY`

The workflow fails before secret access if those environment protections are
missing. After signing, it hashes the final AAB or IPA and pauses for a second
organization-admin approval in NGO.Tools. Only the approved bytes are sent to
Google Play or TestFlight. Signing files and polling credentials are never
archived; the retained CI artifact contains public release provenance only.
