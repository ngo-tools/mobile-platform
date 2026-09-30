# ngotools_chat

Matrix chat for NGO.Tools organization apps, built on
[matrix-rust-sdk](https://github.com/matrix-org/matrix-rust-sdk) (Apache-2.0).
A small Rust facade (`rust/`, crate `ngotools_matrix_core`) wraps the SDK and
is bound to Dart with flutter_rust_bridge. The facade is the only place that
absorbs SDK changes; its API stays small and stable.

The package is under construction (milestone M2: facade API done). It is not
part of the module catalog yet and must not be added to organization apps.

## Architecture

- **Sessions and tokens stay in Rust.** The OAuth session (MAS, Authorization
  Code + PKCE) and its refresh token are persisted in the encrypted SQLite
  state store. Dart only passes the 32-byte store key from the
  Keychain/Keystore.
- **One binary for app and Notification Service Extension.** On iOS the Rust
  code is the pod `ngotools_matrix_core` (no Flutter dependency), linked by
  the app and by the extension (`ios/Core/ngotools_matrix_core.h`, C ABI in
  `rust/src/nse.rs`). Both processes coordinate through the SDK's
  cross-process store and refresh locks.
- **Android TLS** uses `rustls-platform-verifier`, initialized over JNI by
  `NgotoolsChatPlugin`. It trusts the system and user CA store only; extra
  root certificates and the network security config are not supported.

## Usage

The public API is `package:ngotools_chat/ngotools_chat.dart`; the generated
bindings stay internal (enforced by the platform gate).

```dart
await ChatSession.initialize(logFile: logPath, level: ChatLogLevel.info);
final session = await ChatSession.open(ChatSessionConfig(/* stores, OAuth */));

final account = await session.restore() ??
    await session.finishLogin(await browserLogin(await session.startLogin()));
await session.startSync();
ChatLifecycleObserver(session).attach();

final rooms = session.rooms();                 // RoomListController
final timeline = await session.openTimeline(roomId);
await timeline.sendText('Hallo');
```

Calls throw `ChatException` with a `ChatErrorKind` (`network`,
`sessionExpired`, `accountLocked`, `forbidden`, `notFound`, `rateLimited`,
`crypto`, `storage`, `invalidInput`, `internal`); `message` is diagnostic
only. A token refresh that fails for lack of connectivity is `network`, never
`sessionExpired`.

## Session and lifecycle

`ChatSession.state` is `signedOut`, `active`, `expired` (tokens revoked or
rejected) or `locked`. On `expired`/`locked` the sync stops and `resume()`
fails; the app signs in again. With MAS a locked account shows as `expired`
(MAS rejects its tokens); `locked` appears when the homeserver reports
`M_USER_LOCKED`. `abortLogin()` discards a login whose browser flow was
cancelled.

The sync runs in the SDK's offline mode: network loss shows as
`ChatSyncStatus.offline` and recovers on its own. Other failures restart the
sync with a backoff (1–30 s). `ChatLifecycleObserver(session).attach()`
pauses the sync in the background and resumes it in the foreground (not on
`inactive`); on iOS pausing also frees the store for the notification
extension.

`ChatSession.initialize(logFile, level)` loads the native library once and
writes logs to a file (`error`, `warn`, `info`, `debug`); calling it again
only changes the level. SDK crates never log at `trace`, so logs contain
identifiers but no message bodies or tokens. Rust panics are logged too.

## Room list

`session.rooms()` returns a `RoomListController` (one per session, after
`startSync`). It applies the facade's diff stream to an unmodifiable list of
`RoomSummary` and exposes it as a `ValueListenable`. Filters (`all`,
`people`, `groups`, `invites`, `unread`) and paging run in Rust. A summary
carries kind, membership, unread counts, the user-defined notification mode
and a typed `MessagePreview` of the latest message, which the app localizes.

## Timeline

`session.openTimeline(roomId)` returns a `TimelineController`: items as a
`ValueListenable<List<TimelineItem>>` (`EventTimelineItem`,
`DateDividerItem`, `ReadMarkerItem`, `TimelineStartItem`), back pagination
and the message actions `sendText` (optionally as reply), `sendImage`,
`edit`, `redact`, `toggleReaction`, `retry`/`cancel` for failed local
echoes, `markRead` and `loadReplyDetails`. `typing` lists the other members
typing, `setTyping` sends the own state.

An `EventItem` carries its `EventKey`, sender (`ChatUser`), `SendState`
(`Sending` with upload progress, `Sent`, `SendFailed`), typed `EventContent`,
reply preview, reactions (with `byMe`), edit marker and thread information.
Event ids are not unique across items: the SDK can show the local echo next
to its remote echo for a while (matrix-rust-sdk#4758). Key widgets by
`TimelineItem.id`.

## Threads

The room timeline hides thread replies and shows a `thread` summary (reply
count, latest reply) on the root. `session.openThread(roomId, rootEventId)`
opens a thread as `TimelineController`; everything sent through it goes into
the thread. `session.openThreads(roomId)` returns a `ThreadListController`
with the thread overview (first page loaded, `loadMore` for the rest).

## Media

`prepareImageAttachment(filePath, mimeType, caption)` reads the pixel size
and renders a PNG preview (longest side 480 px) for `sendImage`. Encrypted
rooms need it: the server cannot scale encrypted media. Media references
are opaque `ChatMedia` values (also for avatars): show
`ImageContent.thumbnail` via `session.fetchMedia` when set; otherwise
`session.fetchThumbnail(media, width, height)` lets the server scale plain
media (encrypted media is returned in full). The SDK decrypts and caches
media.

## Room details, encryption, push

`members(roomId)` lists joined and invited members with role;
`notificationSettings` and `setNotificationMode` read and change the
per-room mode (all messages, mentions only, mute; `null` restores the
default). `recoveryStatus`, `enableRecovery`, `recover` and
`verificationState` cover key backup and device verification.
`registerPusher` registers a Sygnal pusher (`event_id_only`) and
`notification(roomId, eventId)` resolves and decrypts a pushed event.

## Binaries

Release builds of the facade are precompiled, signed (Ed25519) and published
by `.github/workflows/chat-native-binaries.yml`. Builds on machines without
`rustup` download them by crate hash and verify the signature against
`rust/cargokit.yaml`. With `rustup` installed, cargokit builds from source
with the pinned toolchain (`rust/rust-toolchain.toml`). To use the
published binaries anyway, put `use_precompiled_binaries: true` into a
`cargokit_options.yaml` in the app directory (not committed).

Published targets: `aarch64-apple-ios`, `aarch64-apple-ios-sim`,
`aarch64-linux-android`, `armv7-linux-androideabi`, `x86_64-linux-android`
and `i686-linux-android` (Android debug builds request x86). The vendored
cargokit is patched to accept pinned toolchain versions and to build only
the targets without a precompiled binary.

## Development

```bash
# Regenerate the Dart bindings after changing rust/src/api/**
flutter_rust_bridge_codegen generate
(cd rust && cargo fmt)

# Rust gate (also runs in CI)
cd rust
cargo fmt --check
cargo deny check licenses sources advisories
cargo clippy --all-targets --locked -- -D warnings
cargo test --locked
```

`deny.toml` forbids GPL, LGPL and AGPL code in the app binary. MPL-2.0
crates are allowed unmodified and must appear in the third-party notices.

## End-to-end tests

`e2e/` contains a local Synapse + MAS server (Docker) and a runner for
`example/integration_test/chat_flow_e2e.dart` on a simulator or emulator:

```bash
e2e/server/setup.sh up && e2e/server/setup.sh ca
python3 e2e/server/push_gateway.py 28451 &
e2e/run.sh ios <simulator-udid>
e2e/run.sh android <emulator-serial>   # rootable emulator started with -read-only
```
