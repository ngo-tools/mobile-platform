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

Start every app-creation workflow by asking one free-form question:

> Wie lautet der Organisations-Slug?

Require the user to enter the slug. Do not infer it from a URL, conversation,
file, account, or checkout. Do not offer choices, example tenants, URLs,
demo tenants, staging tenants, or fallback environments. Use exactly the slug
the user supplies.

After loading the platform catalog, ask which currently available modules
should be included initially. Present them as a multiple-choice or multi-select
question and say explicitly that further available modules can be added later.
Ask only which modules should be included, not for an app purpose or name in
the same question. If the interface has no multi-select control, offer complete
combinations for a small catalog or accept a comma-separated list.

Use the tenant's public display name for the app name when available; otherwise
derive a readable working name from the supplied slug. Do not ask for a name or
purpose merely to generate the initial app shell.

Use `customer_owned` for the repository model and the customer's own store
accounts without asking. Use `managed_by_ngotools` only when the user already
requested that model explicitly before this workflow.

Collect only remaining decisions that cannot safely be discovered:

- iOS, Android, or both;
- support and privacy URLs when tenant metadata does not provide them;
- public platform identifiers that the registration still requires, such as
  Apple Team ID or Android signing-certificate fingerprints;
- optional branding assets when the user wants custom branding immediately.

Do not ask the user for `REGISTRATION`, `OUTPUT`, or `PLATFORM_SHA`. Resolve
those values during the workflow.

## Workflow

1. After the user has supplied the organization slug, use an existing clean
   `ngo-tools/mobile-platform` checkout when one is in
   scope. Otherwise clone `https://github.com/ngo-tools/mobile-platform.git`
   into the task workspace. Do not overwrite another project.
2. Read the local module catalog and ask which available modules should be
   included initially. Phrase the question as: "Welche Module sollen direkt
   mitgegeben werden? Weitere Module können später ergänzt werden." Allow more
   than one module and do not describe the current catalog as the final limit
   of the app.
3. Use the full lowercase commit SHA of the checked-out, reviewed default
   branch as the platform ref. Do not use a moving branch name in generated
   dependencies.
4. Look only inside the current task workspace for an approved
   `ngo-tools.mobile.yaml` belonging to the requested tenant. Validate it
   against `schemas/ngo-tools.mobile.schema.json` before use.
5. If no approved manifest exists, read
   [the registration handshake](references/registration-handshake.md), start
   it against the explicit tenant, present the returned authorization URL, and
   wait for an organization admin to approve it. Keep polling credentials in a
   temporary file or memory only.
6. Derive a readable sibling output directory from the approved app slug. The
   target must not exist. If it does exist, verify whether it is the same
   generated app and ask before choosing a different location.
7. From the Mobile Platform root run:

   ```bash
   dart pub get
   dart run tool/setup_app.dart \
     --registration="$APP_REGISTRATION" \
     --output="$APP_OUTPUT" \
     --platform-ref="$PLATFORM_REF"
   ```

   Use task-specific shell variables; do not repurpose `HOME` or
   `CODEX_HOME`.
8. In the generated repository, read `AGENTS.md`, `APP_BRIEF.md`, and
   `docs/MODULES.md`. Record the selected starting modules and known user
   requirements. Leave unknown future product scope open instead of inventing
   it.
9. Reuse only modules marked `available` and approved in the registration.
   App and screen code must use repositories from the platform packages, not
   direct HTTP calls. Server capabilities, permissions, and token abilities
   remain authoritative.
10. Run `flutter pub get`, `flutter analyze`, focused tests for changed code,
   and a debug build using `lib/main_staging.dart`. Leave the complete test
   suite to CI unless the user explicitly requests it.
11. Report the tenant, selected modules, platform commit, generated location,
    and verification. Do not commit, push, deploy, sign, or submit to a store
    unless the user explicitly asks.

## Hard boundaries

- One generated app belongs to one tenant; never add runtime tenant selection.
- The organization slug is mandatory user input. Never replace it with a
  guessed, demo, or staging tenant.
- Initial module selection is not a permanent product limit. Further available
  modules may be added later through the platform workflow.
- Self-service apps default to `customer_owned`; do not ask who owns the
  repository or store accounts.
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
