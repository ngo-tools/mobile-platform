# NGO.Tools Mobile Platform

Open-source Flutter packages and tooling for tenant-bound NGO.Tools
organization apps.

This repository contains the shared technical platform. Organization-specific
features and production credentials belong in separate private app
repositories and protected CI environments.

## Requirements

- Flutter 3.41.6
- Dart 3.11.4

## Local gate

```bash
dart pub get
dart run tool/check.dart
```

The gate validates the app manifest and native identifiers, scans for secrets,
checks package boundaries, formats and analyzes the workspace, and runs all
tests.

## Workspace

- `ngotools_mobile_core`: immutable environment and app configuration
- `ngotools_auth`: authentication state boundary without exposed raw tokens
- `ngotools_api`: API contract and problem-detail types
- `ngotools_design_system`: shared accessible visual foundation
- `ngotools_navigation`: auth- and capability-aware navigation contracts
- `ngotools_testing`: synthetic fixtures for application tests
- `example/golden_app`: secret-free reference shell

The repository is licensed under the MIT License.
