# Local NGO.Tools app preview

Use this workflow before registration. Its only purpose is to let the user see
and refine the app locally with synthetic data.

## Build a disposable preview manifest

Start from `example/golden_app/ngo-tools.mobile.yaml` in the checked-out Mobile
Platform and write a separate temporary manifest. Keep every environment on
reserved `.invalid` hosts. Change only public preview values:

- set `owner.tenant` to the organization slug entered by the user;
- set `owner.repositoryModel` to `customer_owned`;
- derive `metadata.name` from the slug and keep version `0.1.0`;
- derive valid local iOS and Android identifiers from the slug, using distinct
  `.dev`, `.staging`, and base variants; these are disposable preview values;
- set support and privacy URLs to descriptive `.invalid` URLs;
- set `features.modules` to the selected available modules plus their declared
  dependencies;
- set API scopes and device permissions from the local module catalog;
- keep distribution on internal testing defaults and deep-link hosts on
  `.invalid`.

Do not contact the tenant and do not reuse a real support URL, privacy URL,
bundle ID, application ID, signing fingerprint, OIDC client, or backend URL.
Validate the preview manifest against `schemas/ngo-tools.mobile.schema.json` by
passing it through `tool/setup_app.dart`.

## Show the preview

In the generated preview repository:

1. Keep the visible synthetic-data notice.
2. Use the derived organization name in the app shell.
3. Enable only the selected starting modules and their dependencies.
4. Back screens exclusively with `ngotools_testing` fixtures or equivalent
   `.invalid` synthetic data. Do not add direct HTTP calls.
5. Run formatting, analysis, and focused tests for changed preview code.
6. Detect local devices with `flutter devices`, start an available iOS
   Simulator or Android emulator when necessary, and run:

   ```bash
   flutter run -t lib/main_development.dart
   ```

The preview is disposable. Iterate locally until the user explicitly asks to
bind the app to the tenant. Registration then creates a fresh final app from
approved public configuration; never promote preview identifiers or `.invalid`
values into staging or production.
