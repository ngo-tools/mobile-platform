---
name: create-ngo-tools-app
description: Create a new tenant-bound NGO.Tools Flutter app through the public registration handshake and Mobile Platform generator. Use when someone asks to start, scaffold, or build an individual mobile app for one NGO.Tools organization. Do not use for the generic multi-tenant Staff App.
---

# Create an NGO.Tools organization app

Create a private Flutter app repository that is bound to exactly one
NGO.Tools tenant and pinned to a reviewed commit of the public Mobile Platform.
The user should not need to know local manifest paths, output paths, or Git
commit SHAs.

## Ask only for human decisions

Determine the tenant from the user's explicit organization slug or HTTPS
tenant URL. If neither is available, ask one short question for it. Never guess
a production tenant from unrelated files or accounts.

Collect only decisions that cannot safely be discovered:

- app purpose and working name;
- iOS, Android, or both;
- organization-owned or NGO.Tools-managed repository and distribution;
- support and privacy URLs;
- public platform identifiers that the registration still requires, such as
  Apple Team ID or Android signing-certificate fingerprints;
- optional branding assets.

Do not ask the user for `REGISTRATION`, `OUTPUT`, or `PLATFORM_SHA`. Resolve
those values during the workflow.

## Workflow

1. Use an existing clean `ngo-tools/mobile-platform` checkout when one is in
   scope. Otherwise clone `https://github.com/ngo-tools/mobile-platform.git`
   into the task workspace. Do not overwrite another project.
2. Use the full lowercase commit SHA of the checked-out, reviewed default
   branch as the platform ref. Do not use a moving branch name in generated
   dependencies.
3. Look only inside the current task workspace for an approved
   `ngo-tools.mobile.yaml` belonging to the requested tenant. Validate it
   against `schemas/ngo-tools.mobile.schema.json` before use.
4. If no approved manifest exists, read
   [the registration handshake](references/registration-handshake.md), start
   it against the explicit tenant, present the returned authorization URL, and
   wait for an organization admin to approve it. Keep polling credentials in a
   temporary file or memory only.
5. Derive a readable sibling output directory from the approved app slug. The
   target must not exist. If it does exist, verify whether it is the same
   generated app and ask before choosing a different location.
6. From the Mobile Platform root run:

   ```bash
   dart pub get
   dart run tool/setup_app.dart \
     --registration="$APP_REGISTRATION" \
     --output="$APP_OUTPUT" \
     --platform-ref="$PLATFORM_REF"
   ```

   Use task-specific shell variables; do not repurpose `HOME` or
   `CODEX_HOME`.
7. In the generated repository, read `AGENTS.md`, `APP_BRIEF.md`, and
   `docs/MODULES.md`. Replace the synthetic brief with the user's actual
   purpose, users, and intended screens. Do not invent missing business scope.
8. Reuse only modules marked `available` and approved in the registration.
   App and screen code must use repositories from the platform packages, not
   direct HTTP calls. Server capabilities, permissions, and token abilities
   remain authoritative.
9. Run `flutter pub get`, `flutter analyze`, focused tests for changed code,
   and a debug build using `lib/main_staging.dart`. Leave the complete test
   suite to CI unless the user explicitly requests it.
10. Report the tenant, selected modules, platform commit, generated location,
    and verification. Do not commit, push, deploy, sign, or submit to a store
    unless the user explicitly asks.

## Hard boundaries

- One generated app belongs to one tenant; never add runtime tenant selection.
- Development is synthetic, staging uses only the provisioned staging tenant,
  and production stays isolated.
- Registration manifests contain public configuration only. Never place raw
  tokens, signing keys, store credentials, or production data in the repo,
  prompts, logs, fixtures, or generated files.
- The browser approval is a human action. Do not approve a registration on the
  user's behalf.
- Do not add hosts, scopes, native permissions, dependencies, or modules that
  are absent from the approved registration.
- Signing and store material belongs only in protected CI environments.
