# Golden App

Secret-free reference application for the NGO.Tools mobile platform. Its
manifest, native identifiers, environments, and synthetic fixtures exercise
the same gate that organization-specific applications use.

Run it locally with an explicit environment entry point:

```bash
flutter run -t lib/main_development.dart
flutter run -t lib/main_staging.dart
flutter run -t lib/main_production.dart
```

All hosts use the reserved `.invalid` domain. The app contains no production
data, signing configuration, or store credentials.
