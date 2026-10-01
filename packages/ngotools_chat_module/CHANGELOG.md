# Changelog

## 0.1.0-dev.1

- Restore on a new device: `ChatHome` asks once for the recovery key when
  the account has recovery but this device lacks the key
  (`ChatRecoverPage`), the banner and the security page keep offering
  it, and unreadable messages link to it while the key is missing. A
  lost key is explained with the reset in the web chat.
  `ChatGateway` gains `recover`.
- Set up recovery: `ChatHome` offers it once per device when the chat
  opens without it (`ChatRecoverySetupPage`: explanation, recovery key to
  copy, check of the last four characters), then reminds above the room
  list (`ChatRecoveryBanner`). `ChatSecurityPage` shows the state and
  creates a new key. `ChatGateway` gains `encryption` and
  `enableRecovery`.
- Unreadable messages name the reason and explain it on tap; where the
  recovery key helps, the explanation offers to enter it
  (`ChatUndecryptableMessage`, `onEnterRecoveryKey`). Encryption texts
  moved to `ChatLabels.encryption` (`ChatEncryptionLabels`).
- Add the chat screens: room list with invites, rooms with replies,
  edits, reactions, threads and images, new direct chats from the
  address book, room details, and `ChatHome` as the app destination.
- Add `ChatAppLifecycle`: pause in the background, renew on return.
- Add the chat connector: background sign-in with sessions issued by
  NGO.Tools, renewal before expiry, withdrawn access and sign-out cleanup.
