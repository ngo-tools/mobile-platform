enum ChatErrorKind {
  /// No connection to the homeserver; retry later.
  network,

  /// The session ended; sign in again.
  sessionExpired,

  /// The account was locked or deactivated.
  accountLocked,
  forbidden,
  notFound,

  /// Too many requests; see [ChatException.retryAfter].
  rateLimited,
  crypto,
  storage,
  invalidInput,
  internal,
}

/// Error of a chat call. [message] is diagnostic text for logs, not for
/// users; show a text based on [kind].
class ChatException implements Exception {
  const ChatException(this.kind, {this.message, this.retryAfter});

  final ChatErrorKind kind;
  final String? message;
  final Duration? retryAfter;

  @override
  String toString() =>
      'ChatException(${kind.name}${message == null ? '' : ': $message'})';
}
