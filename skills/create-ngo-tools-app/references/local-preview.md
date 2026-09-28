# Live NGO.Tools app preview

Use this workflow before registration. It lets the user see the app in a local
simulator with the organization's real data: an organization admin approves a
short-lived, read-only preview in the browser, and the user signs in with the
normal NGO.Tools account. Nothing is registered and no final store identifier
is reserved.

## Build a disposable preview manifest

Start from `example/golden_app/ngo-tools.mobile.yaml` in the checked-out Mobile
Platform and write a separate temporary manifest. Keep every environment on
reserved `.invalid` hosts; the live preview replaces only the development
configuration after approval. Change only public preview values:

- set `owner.tenant` to the organization slug entered by the user;
- set `owner.repositoryModel` to `customer_owned`;
- derive `metadata.name` from the slug and keep version `0.1.0`;
- derive valid local iOS and Android identifiers from the slug, using distinct
  `.dev`, `.staging`, and base variants; these are disposable preview values;
- derive the development redirect as `ngotools-<slug>-preview://oauth/callback`;
- set support and privacy URLs to descriptive `.invalid` URLs;
- set `features.modules` to the selected available modules plus their declared
  dependencies;
- set API scopes and device permissions from the local module catalog;
- keep distribution on internal testing defaults and deep-link hosts on
  `.invalid`.

Do not reuse a real support URL, privacy URL, bundle ID, application ID,
signing fingerprint, OIDC client, or backend URL. Validate the preview manifest
against `schemas/ngo-tools.mobile.schema.json` by passing it through
`tool/setup_app.dart`.

## Connect the preview to the organization

From the Mobile Platform root request the live preview for the generated app:

```bash
dart run tool/live_preview.dart \
  --app="$PREVIEW_OUTPUT" \
  --tenant="$ORGANIZATION_SLUG" \
  --platform=ios
```

Use `--platform=android` when the local device is an Android emulator. The tool
takes the redirect, locales and modules from the preview manifest; pass
`--modules=events,profile` only to narrow the request.

1. Show the printed approval link and code to the user. An organization admin
   opens the link, compares the code and approves. Tell the user to approve
   only a preview they started themselves; it reads real data for 8 hours.
2. Wait for the tool. It never stores the poll token. After approval it writes
   `lib/generated/mobile_app_config.dart` (development only, `prv_…` app ID)
   and a non-secret `.ngotools/live-preview.json`.
3. If the tool reports that live previews are not enabled for the
   organization, or the admin declines, keep the preview on synthetic data:
   back screens exclusively with `ngotools_testing` fixtures and say so.
   Do not retry against another tenant or environment.

The preview token can read only the approved modules (`profile:read`,
`contacts:read`, `events:read`). Writing actions, such as answering event
availability, are rejected and the app shows a read-only notice. Admins can
revoke a preview at any time under Settings → Mobile Apps.

## Show the preview

In the generated preview repository:

1. Use the derived organization name in the app shell.
2. Enable only the selected starting modules and their dependencies. Do not add
   direct HTTP calls; modules access NGO.Tools through their repositories.
3. Run formatting, analysis, and focused tests for changed preview code.
4. Detect local devices with `flutter devices`, start an available iOS
   Simulator or Android emulator when necessary, and run:

   ```bash
   flutter run -t lib/main_development.dart
   ```

5. Ask the user to tap "Mit NGO.Tools anmelden" and sign in in the system
   browser. The start screen marks the app as a live preview.

The preview is disposable. Iterate locally until the user explicitly asks to
bind the app to the tenant. Registration then creates a fresh final app from
approved public configuration; never promote preview identifiers, the `prv_…`
configuration or `.invalid` values into staging or production.
