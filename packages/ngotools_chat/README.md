# ngotools_chat

Matrix chat for NGO.Tools organization apps, built on
[matrix-rust-sdk](https://github.com/matrix-org/matrix-rust-sdk) (Apache-2.0).
A small Rust facade (`rust/`, crate `ngotools_matrix_core`) wraps the SDK and
is bound to Dart with flutter_rust_bridge. The facade is the only place that
absorbs SDK changes; its API stays small and stable.

The package is under construction (milestone M1: foundation). It is not part
of the module catalog yet and must not be added to organization apps.

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

## Room list

`RoomListController` applies the facade's diff stream (`RoomListDiff`, 1:1 to
the SDK's `VectorDiff`) to an unmodifiable list and exposes it as a
`ValueListenable`. Filters (`all`, `people`, `groups`, `invites`, `unread`)
and paging are forwarded to the list task in Rust. Each `RoomSummary`
carries kind, membership, unread counts and a typed `MessagePreview` of the
latest event, which the app localizes.

## Timeline

`ChatClient.timeline(roomId)` returns a `ChatTimeline` per room;
`TimelineController` applies its diff stream (`TimelineDiff`) and guards back
pagination. Each `EventItem` carries a stable `EventKey` (local transaction
id or event id), sender, send state, typed content (text, image, video,
audio, file, membership and state changes, redacted, undecryptable), reply
preview, reactions (with `byMe`), edit marker and thread information.
Actions on `ChatTimeline`: `sendText` (optionally as reply), `sendImage`,
`edit`, `redact`, `toggleReaction`, `retry`/`cancel` for failed local
echoes, `markRead` and `loadReplyDetails`. `watchTyping` streams the other
members typing, `setTyping` sends the own typing state.

Event ids are not unique across items: the SDK can show the local echo next
to its remote echo for a while (matrix-rust-sdk#4758). Key widgets by
`TimelineItem.id`.

## Media

`prepareImageAttachment(filePath, mimeType, caption)` reads the pixel size
and renders a PNG preview (longest side 480 px) for `sendImage`. Encrypted
rooms need it: the server cannot scale encrypted media. Upload progress
appears on the local echo (`SendState.sending(progress)`).

For display, fetch `EventContent.image.thumbnail` with `fetchMedia` when it
is set; otherwise `fetchThumbnail(media, width, height)` lets the server
scale plain media (encrypted media is returned in full). Media is
decrypted and cached by the SDK.

## Room details

`roomMembers(roomId)` lists joined and invited members with role.
`roomNotificationSettings` and `setRoomNotificationMode` read and change the
per-room mode (all messages, mentions only, mute; `null` restores the
default). The room list carries the user-defined mode as
`RoomSummary.notificationMode` and updates when it changes.

## Threads

Threading support is enabled: the room timeline hides thread replies and
shows a `thread` summary (reply count, latest reply) on the root event.
`ChatClient.threadTimeline(roomId, rootEventId)` opens a thread; everything
sent through it (including replies) goes into the thread.
`ThreadListController` streams the thread overview of a room
(`ChatClient.threadList`) and loads further pages.

## Errors

Every facade call throws a typed `ChatError` (`network`, `sessionExpired`,
`accountLocked`, `forbidden`, `notFound`, `rateLimited`, `crypto`, `storage`,
`invalidInput`, `internal`). A token refresh that fails for lack of
connectivity is reported as `network`, never as `sessionExpired`.

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
