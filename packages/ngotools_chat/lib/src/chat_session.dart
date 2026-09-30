import 'dart:async';

import 'package:flutter/foundation.dart';

import 'chat_models.dart';
import 'mapping.dart' as map;
import 'room_list_controller.dart';
import 'rust/api/client.dart' as rust;
import 'rust/api/logging.dart' as rust;
import 'rust/frb_generated.dart';
import 'thread_list_controller.dart';
import 'timeline_controller.dart';

/// Configuration of a [ChatSession].
class ChatSessionConfig {
  const ChatSessionConfig({
    required this.homeserverUrl,
    required this.dataDirectory,
    required this.cacheDirectory,
    required this.storeKey,
    required this.clientName,
    required this.clientUri,
    required this.redirectUri,
    this.devRootCertificatePem,
    this.crossProcessHolder,
  });

  final String homeserverUrl;

  /// Persistent directory for the encrypted stores (the App Group directory
  /// on iOS when a notification extension shares them).
  final String dataDirectory;
  final String cacheDirectory;

  /// 32 random bytes from the Keychain/Keystore; encrypts all stores.
  final Uint8List storeKey;
  final String clientName;
  final String clientUri;

  /// Redirect URI of the OAuth login (custom scheme of the app).
  final String redirectUri;

  /// Extra trusted root CA (PEM) for local development servers (iOS only).
  final String? devRootCertificatePem;

  /// Holder name for the store lock shared with the iOS notification
  /// extension (e.g. `main`).
  final String? crossProcessHolder;
}

/// A Matrix chat account on this device: sign-in, sync and access to rooms,
/// timelines, media, encryption and push.
///
/// Call [initialize] once per process, then [open]. Dispose the session
/// before opening another one on the same stores.
class ChatSession {
  ChatSession._(this._client) {
    _subscriptions.add(
      _client.watchSessionState().listen(
        (state) => _state.value = map.sessionState(state),
      ),
    );
  }

  static bool _rustReady = false;

  /// Loads the native library and configures logging. Later calls (e.g.
  /// after a hot restart) only change the log level.
  static Future<void> initialize({
    required String logFile,
    ChatLogLevel level = ChatLogLevel.info,
  }) async {
    if (!_rustReady) {
      await RustLib.init();
      _rustReady = true;
    }
    await map.guard(
      () => rust.initLogging(logFile: logFile, level: map.logLevel(level)),
    );
  }

  /// Opens the encrypted stores; no network access.
  static Future<ChatSession> open(ChatSessionConfig config) async {
    final client = await map.guard(
      () => rust.ChatClient.create(
        config: rust.ChatConfig(
          homeserverUrl: config.homeserverUrl,
          dataDir: config.dataDirectory,
          cacheDir: config.cacheDirectory,
          storeKey: config.storeKey,
          clientName: config.clientName,
          clientUri: config.clientUri,
          redirectUri: config.redirectUri,
          devRootCertificatePem: config.devRootCertificatePem,
          crossProcessHolder: config.crossProcessHolder,
        ),
      ),
    );

    return ChatSession._(client);
  }

  final rust.ChatClient _client;
  final _state = ValueNotifier<ChatSessionState>(ChatSessionState.signedOut);
  final _syncStatus = ValueNotifier<ChatSyncStatus>(ChatSyncStatus.idle);
  final _subscriptions = <StreamSubscription<Object?>>[];
  ChatAccount? _account;

  ValueListenable<ChatSessionState> get state => _state;

  ValueListenable<ChatSyncStatus> get syncStatus => _syncStatus;

  /// The signed-in account, if any.
  ChatAccount? get account => _account;

  /// Restores the session stored on this device.
  Future<ChatAccount?> restore() async {
    final info = await map.guard(_client.restoreSession);

    return _account = info == null ? null : map.account(info);
  }

  /// Starts the OAuth login; open the returned URL in the system browser.
  Future<Uri> startLogin() async =>
      Uri.parse(await map.guard(_client.loginUrl));

  /// Completes the login with the redirect the app received.
  Future<ChatAccount> finishLogin(Uri callback) async {
    final info = await map.guard(
      () => _client.finishLogin(callbackUrl: callback.toString()),
    );

    return _account = map.account(info);
  }

  /// Signs in with a chat session that NGO.Tools issued for this device
  /// (the organization apps' background sign-in, no browser). The token is
  /// kept in the encrypted store only; keep [deviceId] for later sessions of
  /// the same account so keys and verification survive.
  Future<ChatAccount> signInWithToken({
    required String userId,
    required String deviceId,
    required String accessToken,
  }) async {
    final info = await map.guard(
      () => _client.signInWithToken(
        userId: userId,
        deviceId: deviceId,
        accessToken: accessToken,
      ),
    );

    return _account = map.account(info);
  }

  /// Takes over a renewed token of an issued session while the session keeps
  /// running (sync, timelines).
  Future<void> updateAccessToken(String accessToken) =>
      map.guard(() => _client.updateAccessToken(accessToken: accessToken));

  /// Discards a login whose browser flow was cancelled.
  Future<void> abortLogin() => map.guard(_client.abortLogin);

  /// Signs out on the server and forgets the stored session.
  Future<void> logout() async {
    await map.guard(_client.logout);
    _account = null;
  }

  /// Authenticated round trip (refreshes an expired access token); returns
  /// the user id.
  Future<String> verifySession() => map.guard(_client.whoami);

  Future<void> startSync() async {
    await map.guard(_client.startSync);
    _subscriptions.add(
      _client.watchSyncStatus().listen(
        (status) => _syncStatus.value = map.syncStatus(status),
      ),
    );
  }

  /// Stops syncing while the app is in the background; see
  /// `ChatLifecycleObserver`.
  Future<void> pause() => map.guard(_client.pause);

  /// Resumes syncing; fails with `sessionExpired`/`accountLocked` when the
  /// session ended.
  Future<void> resume() => map.guard(_client.resume);

  /// The room list; one per session, after [startSync].
  RoomListController rooms() => roomListController(_client);

  /// Creates an encrypted direct chat or returns the existing one.
  Future<String> createDirectChat(String userId) =>
      map.guard(() => _client.createDm(userId: userId));

  Future<void> joinRoom(String roomId) =>
      map.guard(() => _client.joinRoom(roomId: roomId));

  /// Leaves a joined room or declines an invite.
  Future<void> leaveRoom(String roomId) =>
      map.guard(() => _client.leaveRoom(roomId: roomId));

  /// Joined and invited members.
  Future<List<ChatMember>> members(String roomId) async => [
    for (final entry in await map.guard(
      () => _client.roomMembers(roomId: roomId),
    ))
      map.member(entry),
  ];

  Future<RoomNotificationSettings> notificationSettings(String roomId) async =>
      map.notificationSettings(
        await map.guard(() => _client.roomNotificationSettings(roomId: roomId)),
      );

  /// Sets the room's mode; `null` restores the account default.
  Future<void> setNotificationMode(String roomId, NotificationMode? mode) =>
      map.guard(
        () => _client.setRoomNotificationMode(
          roomId: roomId,
          mode: mode == null ? null : map.rustNotificationMode(mode),
        ),
      );

  Future<TimelineController> openTimeline(String roomId) async =>
      timelineController(
        await map.guard(() => _client.timeline(roomId: roomId)),
      );

  /// Timeline of the thread started by [rootEventId]; everything sent
  /// through it goes into the thread.
  Future<TimelineController> openThread(
    String roomId,
    String rootEventId,
  ) async => timelineController(
    await map.guard(
      () => _client.threadTimeline(roomId: roomId, rootEventId: rootEventId),
    ),
  );

  /// Thread overview of a room with the first page loaded.
  Future<ThreadListController> openThreads(String roomId) async =>
      threadListController(
        await map.guard(() => _client.threadList(roomId: roomId)),
      );

  /// Downloads (and decrypts) media; cached by the SDK.
  Future<Uint8List> fetchMedia(ChatMedia media) =>
      map.guard(() => _client.fetchMedia(media: media.reference));

  /// Scaled preview; the server scales plain media, encrypted media is
  /// returned in full (prefer `ImageContent.thumbnail`).
  Future<Uint8List> fetchThumbnail(ChatMedia media, int width, int height) =>
      map.guard(
        () => _client.fetchThumbnail(
          media: media.reference,
          width: width,
          height: height,
        ),
      );

  Future<RecoveryStatus> recoveryStatus() async =>
      map.recoveryStatus(await map.guard(_client.recoveryStatus));

  /// Enables key backup and returns the recovery key to show the user.
  Future<String> enableRecovery() => map.guard(_client.enableRecovery);

  /// Restores keys and verifies this device with the recovery key.
  Future<void> recover(String recoveryKey) =>
      map.guard(() => _client.recover(recoveryKey: recoveryKey));

  Future<VerificationState> verificationState() async =>
      map.verificationState(await map.guard(_client.verificationState));

  /// Registers an HTTP pusher (Sygnal) with `event_id_only` payloads.
  Future<void> registerPusher({
    required String pushKey,
    required String appId,
    required String gatewayUrl,
    required String deviceName,
  }) => map.guard(
    () => _client.registerPusher(
      pushKey: pushKey,
      appId: appId,
      gatewayUrl: gatewayUrl,
      deviceName: deviceName,
    ),
  );

  /// Resolves and decrypts a pushed event (`event_id_only` payload).
  Future<ChatNotification?> notification(String roomId, String eventId) async {
    final content = await map.guard(
      () => _client.getNotification(roomId: roomId, eventId: eventId),
    );

    return content == null ? null : map.notification(content);
  }

  /// Number of token refreshes persisted by this session.
  @visibleForTesting
  Future<int> persistedRefreshes() => _client.persistedRefreshes();

  /// Stops all background work so another session may open the stores.
  Future<void> dispose() async {
    await map.guard(_client.shutdown);
    for (final subscription in _subscriptions) {
      await subscription.cancel();
    }
    _state.dispose();
    _syncStatus.dispose();
  }
}
