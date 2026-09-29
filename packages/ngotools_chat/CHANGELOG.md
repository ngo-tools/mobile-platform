# Changelog

## Unreleased

- Add typed `ChatError`s; offline token refreshes no longer look like an
  expired session.
- Stream the room list as diffs with filters, paging, unread counts and a
  typed preview of the latest message (`RoomListController`).

## 0.1.0-dev.1

- Add the Rust facade on matrix-rust-sdk 0.19.1 with OAuth login via MAS,
  encrypted session storage, room list, timeline, E2EE, recovery, media,
  pushers and notification resolution.
- Add the shared `ngotools_matrix_core` pod and the C ABI for the iOS
  Notification Service Extension.
- Add signed precompiled binaries, the license gate and end-to-end tests.
