import 'dart:async';
import 'dart:io';

import 'package:flutter/widgets.dart';
import 'package:ngotools_api/ngotools_api.dart';
import 'package:ngotools_chat_module/ngotools_chat_module.dart';
import 'package:ngotools_mobile_core/ngotools_mobile_core.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';

import 'app_chat.dart';

/// The chat of the app: connection without a second login, lifecycle and
/// the chat destination. The app generator removes this file together with
/// the chat packages when the `chat` module is not selected.
final class GoldenChat implements AppChat {
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

  @override
  Widget build(BuildContext context, {required bool isGerman}) => ChatHome(
    connector: connector,
    api: api,
    labels: isGerman ? ChatLabels.german : ChatLabels.english,
    controller: controller,
  );

  @override
  void openDeepLink(Uri uri) {
    final roomId = ChatDeepLink.roomId(uri);

    if (roomId != null) {
      controller.openRoom(roomId);
    }
  }

  @override
  Future<void> connect() => connector.connect();

  @override
  Future<bool> confirmSignOut(
    BuildContext context, {
    required bool isGerman,
  }) async {
    final state = connector.state;

    if (state is! ChatConnected) {
      return true;
    }

    return confirmChatSignOut(
      context,
      gateway: SessionChatGateway(state.client.session),
      labels: (isGerman ? ChatLabels.german : ChatLabels.english).encryption,
    );
  }

  @override
  Future<void> disconnect() => connector.disconnect();

  @override
  Future<void> dispose() async {
    _lifecycle.detach();
    controller.dispose();
    await connector.close();
  }
}
