# Changelog

## Unreleased

- Follow recovery and verification state (`ChatSession.encryption`),
  check whether this is the account's last device (`isLastDevice`) and
  create a new recovery key when recovery is already enabled
  (`enableRecovery`).
- Messages that cannot be decrypted carry the reason
  (`UnableToDecryptContent.reason`, `DecryptionFailure`).
- Leave rooms and decline invites (`leaveRoom`).
- Several room lists may run at once; a closed list no longer stops the
  others. Rooms this account left disappear from the list.
- Sign in with a chat session issued by NGO.Tools (`signInWithToken`) and
  swap renewed tokens into the running session (`updateAccessToken`).
- **Breaking:** handwritten public API. `ChatSession` replaces the generated
  `ChatClient`; models, controllers and `ChatException` are plain Dart types
  and the generated bindings are no longer exported. The platform gate
  keeps it that way.
- Add the session state stream (`active`, `expired`, `locked`,
  `signedOut`), `pause`/`resume` with `ChatLifecycleObserver`, a typed sync
  status and `abortLogin`. Expired sessions stop the sync instead of
  retrying; other failures restart it with a backoff.
- `initLogging` takes a level and may be called again; SDK logs never use
  `trace`.
- Send images with pixel size and an on-device preview
  (`prepareImageAttachment`), report upload progress on the local echo and
  fetch scaled previews (`fetchThumbnail`).
- Add room members, typing (send and watch) and per-room notification modes,
  including the mode in the room list.
- Add typed `ChatError`s; offline token refreshes no longer look like an
  expired session.
- Stream the room list as diffs with filters, paging, unread counts and a
  typed preview of the latest message (`RoomListController`).
- Open one `ChatTimeline` per room, streamed as diffs (`TimelineController`)
  with typed content, replies, reactions, edits and thread summaries, and
  actions to reply, edit, redact, react, retry and cancel.
- Add threads: summaries on thread roots, thread timelines for reading and
  replying, and a paginated thread overview per room
  (`ThreadListController`).
- Fix controllers hanging in `dispose` on an idle stream: they now stop the
  Rust stream first (`ChatClient.stopRoomList` for the room list).
- Fix a crash when Dart released a client, timeline or thread list: SDK
  objects are now dropped inside the facade runtime. Rust panics are
  written to the log file.

## 0.1.0-dev.1

- Add the Rust facade on matrix-rust-sdk 0.19.1 with OAuth login via MAS,
  encrypted session storage, room list, timeline, E2EE, recovery, media,
  pushers and notification resolution.
- Add the shared `ngotools_matrix_core` pod and the C ABI for the iOS
  Notification Service Extension.
- Add signed precompiled binaries, the license gate and end-to-end tests.
