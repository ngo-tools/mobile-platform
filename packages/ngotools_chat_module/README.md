# ngotools_chat_module

Chat module of the NGO.Tools organization apps. It connects the app to the
organization's encrypted chat without a second login: NGO.Tools issues a chat
session for the signed-in team member, bound to the app's API token
(`chat:login`), and `ChatConnector` signs in with it.

- **Sign-in:** the account status comes from `chat/account` (`chat:read`). A new
  installation gets its own chat device; the access token stays in the
  encrypted chat store, the device record and the store key in the keychain.
- **Renewal:** the connector renews the token a day before it expires, when the
  client reports it expired, and on `refresh()` (call it when the app returns to
  the foreground). Renewal keeps the device, so keys and verification stay.
- **Withdrawn access:** a locked or closed account, or a refused renewal,
  deletes the chat data of the installation and reports `ChatUnavailable`.
- **Sign-out:** call `disconnect()` before the app signs out of NGO.Tools. It
  ends the chat session and deletes the chat stores and their key.

The module needs the `chat` feature and the scopes `chat:read` and
`chat:login`. Chat screens follow in a later version.
