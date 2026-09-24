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

## Create an organization app

Use a public registration exported by NGO.Tools and pin the generated app to a
reviewed Mobile Platform commit:

```bash
dart run tool/setup_app.dart \
  --registration=/absolute/path/ngo-tools.mobile.yaml \
  --output=/absolute/path/my-organization-app \
  --platform-ref=0123456789abcdef0123456789abcdef01234567
```

The destination must not exist. The command validates the registration before
writing, configures Android and iOS identifiers, redirects, app links, and
declared device permissions, and records only public generation provenance. It
does not fetch credentials, run a build, configure signing, or create a remote
repository. A single dependency override block pins the complete internal
package graph to the requested commit until the packages are published.

The generated repository also contains a manual release workflow. It requires
protected GitHub environments with human reviewers, builds only an immutable
default-branch commit, and waits for NGO.Tools approval of the signed artifact
before uploading it to Google Play or TestFlight. No signing or store material
is stored in this public platform repository.

## Discover modules

The versioned descriptors under `modules/` are the source of truth for reusable
app modules. Inspect them through the local catalog command:

```bash
dart run tool/modules.dart list
dart run tool/modules.dart search contacts
dart run tool/modules.dart explain contacts
```

Generated organization apps receive a complete local catalog snapshot and a
local `docs/MODULES.md`, so supported additions remain discoverable. The `add`
command updates module and API-scope manifest declarations only for modules
marked `available`; it never grants server access.

## Workspace

- `ngotools_mobile_core`: immutable environment and app configuration
- `ngotools_auth`: authentication state boundary without exposed raw tokens
- `ngotools_api`: generated runtime transport and sanitized public contracts
- `ngotools_contacts`: remote read-only contact search and details
- `ngotools_design_system`: shared accessible visual foundation
- `ngotools_navigation`: adaptive auth- and capability-aware navigation
- `ngotools_testing`: synthetic fixtures for application tests
- `example/golden_app`: secret-free reference shell

The repository is licensed under the MIT License.
