import 'dart:async';
import 'dart:io';

import 'package:flutter/widgets.dart';
import 'package:ngotools_api/ngotools_api.dart';
import 'package:ngotools_chat_module/ngotools_chat_module.dart';
import 'package:ngotools_mobile_core/ngotools_mobile_core.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';

/// The chat of the app: connection without a second login, lifecycle and
/// the chat destination. The app generator removes this file together with
/// the chat packages when the `chat` module is not selected.
final class GoldenChat {
  GoldenChat._(this.api, this.connector, this._lifecycle);

  /// Prepares the chat for [environment]; nothing connects before
  /// [connect].
  static Future<GoldenChat> create({
    required NgoToolsMobileApi api,
    required MobileAppConfiguration app,
    required MobileEnvironmentConfiguration environment,
    String? deviceName,
  }) async {
    final support = await getApplicationSupportDirectory();
    final cache = await getApplicationCacheDirectory();
    final connector = ChatConnector(
      api: api,
      clients: NgoToolsChatClientFactory(
        dataDirectory: path.join(support.path, 'chat', environment.id),
        cacheDirectory: path.join(cache.path, 'chat', environment.id),
        logFile: path.join(support.path, 'chat', 'chat.log'),
        clientName: 'NGO.Tools App',
        clientUri: 'https://ngo.tools/',
        redirectUri: environment.oidc.redirectUri.toString(),
      ),
      devices: SecureChatDeviceStore(),
      deviceName: deviceName ?? Platform.operatingSystem,
    );

    return GoldenChat._(api, connector, ChatAppLifecycle(connector)..attach());
  }

  /// NGO.Tools address book and chat sessions.
  final MobileChatApi api;

  /// Connection to the chat.
  final ChatConnector connector;

  /// Opens rooms from deep links and notifications.
  final controller = ChatHomeController();

  final ChatAppLifecycle _lifecycle;

  /// Chat destination.
  Widget build(BuildContext context, {required bool isGerman}) => ChatHome(
    connector: connector,
    api: api,
    labels: isGerman ? ChatLabels.german : ChatLabels.english,
    controller: controller,
  );

  /// Opens a `/chat` or `/chat/rooms/{id}` link.
  void openDeepLink(Uri uri) {
    final roomId = ChatDeepLink.roomId(uri);

    if (roomId != null) {
      controller.openRoom(roomId);
    }
  }

  /// Signs into the chat after the NGO.Tools sign-in.
  Future<void> connect() => connector.connect();

  /// Ends the chat session and deletes the chat data; call before signing
  /// out of NGO.Tools.
  Future<void> disconnect() => connector.disconnect();

  /// Stops everything, keeping the chat data.
  Future<void> dispose() async {
    _lifecycle.detach();
    controller.dispose();
    await connector.close();
  }
}
