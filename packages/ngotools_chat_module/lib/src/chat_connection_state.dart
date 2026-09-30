import 'chat_client.dart';

/// Why the chat cannot be used right now.
enum ChatUnavailableReason {
  /// The organization's homeserver does not run (not booked or paused).
  homeserverUnavailable,

  /// The user has no chat account.
  noAccount,

  /// The organization withdrew the user's chat access.
  accessWithdrawn,

  /// The chat account was closed for good.
  accountClosed,
}

/// Connection of the app to the chat.
sealed class ChatConnectionState {
  const ChatConnectionState();
}

/// Not connected; call `ChatConnector.connect`.
final class ChatDisconnected extends ChatConnectionState {
  /// Creates the disconnected state.
  const ChatDisconnected();
}

/// Signing in or restoring the chat session.
final class ChatConnecting extends ChatConnectionState {
  /// Creates the connecting state.
  const ChatConnecting();
}

/// The chat runs; [client] gives access to rooms and timelines.
final class ChatConnected extends ChatConnectionState {
  /// Creates the connected state.
  const ChatConnected({required this.client, required this.matrixUserId});

  /// The running chat client.
  final ChatClient client;

  /// Matrix user id of the account.
  final String matrixUserId;
}

/// The chat cannot be used; see [reason].
final class ChatUnavailable extends ChatConnectionState {
  /// Creates the unavailable state.
  const ChatUnavailable(this.reason);

  /// Why the chat cannot be used.
  final ChatUnavailableReason reason;
}

/// Connecting failed, for example without network; try again later.
final class ChatConnectionFailed extends ChatConnectionState {
  /// Creates the failed state.
  const ChatConnectionFailed(this.error);

  /// Diagnostic error for logs, not for users.
  final Object error;
}
