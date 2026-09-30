import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:ngotools_chat/ngotools_chat.dart';

/// The part of a [ChatSession] the connector drives.
abstract interface class ChatClient {
  /// Session state reported by the chat client.
  ValueListenable<ChatSessionState> get state;

  /// The chat session for the chat screens.
  ChatSession get session;

  /// Restores the session stored on this device; returns its Matrix user id.
  Future<String?> restore();

  /// Signs in with a session NGO.Tools issued for this installation.
  Future<void> signInWithToken({
    required String userId,
    required String deviceId,
    required String accessToken,
  });

  /// Takes over a renewed access token of the running session.
  Future<void> updateAccessToken(String accessToken);

  /// Starts syncing.
  Future<void> startSync();

  /// Stops syncing while the app is in the background.
  Future<void> pause();

  /// Resumes syncing after [pause].
  Future<void> resume();

  /// Stops all background work; the stores stay on the device.
  Future<void> dispose();
}

/// Opens chat clients and removes their stores.
abstract interface class ChatClientFactory {
  /// Opens the encrypted stores of this installation for [homeserverUrl].
  Future<ChatClient> open({
    required Uri homeserverUrl,
    required Uint8List storeKey,
  });

  /// Deletes all stores of this installation; no client may be open.
  Future<void> purge();
}

/// Opens [ChatSession]s in fixed app directories.
final class NgoToolsChatClientFactory implements ChatClientFactory {
  /// Creates a factory for the app's chat directories.
  ///
  /// [dataDirectory] and [cacheDirectory] belong to the chat alone; [purge]
  /// deletes them. [redirectUri] is only used by browser logins, which the
  /// organization apps do not offer.
  NgoToolsChatClientFactory({
    required this.dataDirectory,
    required this.cacheDirectory,
    required this.logFile,
    required this.clientName,
    required this.clientUri,
    required this.redirectUri,
    this.logLevel = ChatLogLevel.info,
  });

  /// Persistent directory of the encrypted chat stores.
  final String dataDirectory;

  /// Cache directory of the chat client.
  final String cacheDirectory;

  /// Log file of the native chat client.
  final String logFile;

  /// Client name shown in the account's session list.
  final String clientName;

  /// Website of the app.
  final String clientUri;

  /// Custom-scheme redirect of the app.
  final String redirectUri;

  /// Log level of the native chat client.
  final ChatLogLevel logLevel;

  @override
  Future<ChatClient> open({
    required Uri homeserverUrl,
    required Uint8List storeKey,
  }) async {
    await ChatSession.initialize(logFile: logFile, level: logLevel);

    return _SessionChatClient(
      await ChatSession.open(
        ChatSessionConfig(
          homeserverUrl: homeserverUrl.toString(),
          dataDirectory: dataDirectory,
          cacheDirectory: cacheDirectory,
          storeKey: storeKey,
          clientName: clientName,
          clientUri: clientUri,
          redirectUri: redirectUri,
          crossProcessHolder: 'main',
        ),
      ),
    );
  }

  @override
  Future<void> purge() async {
    for (final path in [dataDirectory, cacheDirectory]) {
      final directory = Directory(path);

      if (await directory.exists()) {
        await directory.delete(recursive: true);
      }
    }
  }
}

final class _SessionChatClient implements ChatClient {
  _SessionChatClient(this.session);

  @override
  final ChatSession session;

  @override
  ValueListenable<ChatSessionState> get state => session.state;

  @override
  Future<String?> restore() async => (await session.restore())?.userId;

  @override
  Future<void> signInWithToken({
    required String userId,
    required String deviceId,
    required String accessToken,
  }) => session.signInWithToken(
    userId: userId,
    deviceId: deviceId,
    accessToken: accessToken,
  );

  @override
  Future<void> updateAccessToken(String accessToken) =>
      session.updateAccessToken(accessToken);

  @override
  Future<void> startSync() => session.startSync();

  @override
  Future<void> pause() => session.pause();

  @override
  Future<void> resume() => session.resume();

  @override
  Future<void> dispose() => session.dispose();
}
