---
name: create-ngo-tools-app
description: Preview and create a tenant-bound NGO.Tools Flutter app with the Mobile Platform generator. Use when someone asks to start, scaffold, or build an individual mobile app for one NGO.Tools organization. Start with a synthetic local preview; register the app only after explicit confirmation. Do not use for the generic multi-tenant Staff App.
---

# Create an NGO.Tools organization app

First create a safe local Flutter preview for one NGO.Tools organization. Bind
it to the real tenant only after the user has seen the preview and explicitly
wants to continue. The user should not need to know manifest paths, output
paths, Git commit SHAs, temporary identifiers, or placeholder URLs.

## Ask only for human decisions

Start every app-creation workflow by asking one free-form question:

> Wie lautet der Organisations-Slug?

Require the user to enter the slug. Do not infer it from a URL, conversation,
file, account, or checkout. Do not offer choices, example tenants, URLs,
demo tenants, staging tenants, or fallback environments. Use exactly the slug
the user supplies.

After loading the platform catalog, ask which currently available modules
should be visible in the first preview. Present them as a multiple-choice or
multi-select question and say explicitly that further available modules can be
added later. Ask only about modules, not purpose, name, URLs, identifiers,
repository ownership, stores, or distribution. If the interface has no
multi-select control, offer complete combinations for a small catalog or
accept a comma-separated list.

Derive a readable preview name from the supplied slug. Do not ask for a name or
purpose merely to show the first app shell.

Do not ask for a target platform before the preview. Use the first suitable
local simulator or emulator that is already available or can be started.

Use `customer_owned` for the repository model and the customer's own store
accounts without asking. Use `managed_by_ngotools` only when the user already
requested that model explicitly before this workflow.

Do not ask the user for `REGISTRATION`, `OUTPUT`, or `PLATFORM_SHA`. Resolve
those values during the workflow.

## Phase 1: local preview

1. After the user has supplied the organization slug, use an existing clean
   `ngo-tools/mobile-platform` checkout when one is in
   scope. Otherwise clone `https://github.com/ngo-tools/mobile-platform.git`
   into the task workspace. Do not overwrite another project.
2. Read the local module catalog and ask which available modules should be
   shown in the first preview. Phrase the question as: "Welche Module möchtest
   Du zuerst im Simulator sehen? Weitere Module können später ergänzt werden."
   Allow more than one module and do not describe the current catalog as the
   final limit of the app.
3. Use the full lowercase commit SHA of the checked-out, reviewed default
   branch as the platform ref. Do not use a moving branch name in generated
   dependencies.
4. Read [the local preview workflow](references/local-preview.md). Create a
   disposable public manifest with `.invalid` hosts and automatically derived
   preview identifiers. Do not ask for support or privacy URLs, final bundle or
   application IDs, store metadata, signing information, or distribution.
5. Derive a readable sibling output directory ending in `-preview`. The target
   must not exist. If it exists, verify whether it is the same preview before
   reusing or replacing anything.
6. From the Mobile Platform root generate the preview app:

   ```bash
   dart pub get
   dart run tool/setup_app.dart \
     --registration="$PREVIEW_MANIFEST" \
     --output="$PREVIEW_OUTPUT" \
     --platform-ref="$PLATFORM_REF"
   ```

   Use task-specific shell variables; do not repurpose `HOME` or
   `CODEX_HOME`.
7. In the generated preview, read `AGENTS.md`, `APP_BRIEF.md`, and
   `docs/MODULES.md`. Record the selected starting modules and known user
   requirements. Use only synthetic fixtures and modules marked `available`.
   Leave unknown future product scope open instead of inventing it.
8. Run `flutter pub get`, `flutter analyze`, focused tests, and a development
   debug build. Start an available local simulator or emulator and run
   `flutter run -t lib/main_development.dart`. Do not ask the user to choose a
   platform for this preview. If no local device can be started, report that
   single limitation and preserve the ready preview.
9. Stop after the preview is visible. Invite feedback on screens, branding,
   and modules. Do not start registration merely because the preview build is
   successful.

## Phase 2: bind the approved preview

Continue only when the user explicitly asks to connect or register the app for
the tenant after seeing or declining the local preview.

1. Reuse an already approved `ngo-tools.mobile.yaml` for this exact tenant when
   one exists in the task workspace. Otherwise read
   [the registration handshake](references/registration-handshake.md).
2. Only now collect final values that cannot be discovered: target platforms,
   support and privacy URLs, required public platform identifiers, and
   optional production branding. Do not ask who owns the repository or store
   accounts; self-service remains `customer_owned`.
3. Start registration, show the authorization URL, and wait for an
   organization admin to approve the exact proposal in the browser.
4. Generate the final app into a new non-preview directory from the approved
   manifest. Port reviewed UI and brief changes from the preview, but never its
   synthetic manifest, hosts, or preview identifiers.
5. Run analysis, focused tests, and a staging debug build using
   `lib/main_staging.dart`. Leave the complete test suite to CI unless the user
   explicitly requests it.
6. Report the tenant, selected modules, platform commit, generated location,
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
- The first preview is local and synthetic. It must not contact the tenant,
  start registration, reserve final identifiers, or require legal URLs.
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
