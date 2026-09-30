# Changelog

## Unreleased

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
