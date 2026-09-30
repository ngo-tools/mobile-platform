import 'package:flutter/widgets.dart';

/// The chat as the app shell sees it. Keeps the shell free of chat packages,
/// so the app generator can leave the chat out.
abstract interface class AppChat {
  /// Chat destination.
  Widget build(BuildContext context, {required bool isGerman});

  /// Opens a `/chat` or `/chat/rooms/{id}` link.
  void openDeepLink(Uri uri);

  /// Signs into the chat after the NGO.Tools sign-in.
  Future<void> connect();

  /// Asks before signing out when encrypted messages would be lost; `false`
  /// keeps the user signed in.
  Future<bool> confirmSignOut(BuildContext context, {required bool isGerman});

  /// Ends the chat session and deletes the chat data; call before signing
  /// out of NGO.Tools.
  Future<void> disconnect();

  /// Stops everything, keeping the chat data.
  Future<void> dispose();
}
