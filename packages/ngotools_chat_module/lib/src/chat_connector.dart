import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:ngotools_api/ngotools_api.dart';
import 'package:ngotools_chat/ngotools_chat.dart';

import 'chat_client.dart';
import 'chat_connection_state.dart';
import 'chat_device_store.dart';

/// Schedules [callback] after [delay]; replaceable in tests.
typedef ChatTimerFactory =
    Timer Function(Duration delay, void Function() callback);

/// Connects the organization app to the chat without a second login.
///
/// NGO.Tools issues a chat session for the signed-in team member, bound to the
/// app's API token. The connector signs in with it, renews the token before
/// it expires, reacts to withdrawn access and removes everything on
/// [disconnect]. Call [disconnect] before the app signs out of NGO.Tools, and
/// [refresh] when the app returns to the foreground.
final class ChatConnector extends Cubit<ChatConnectionState> {
  /// Creates a connector; [deviceName] appears in the account's sessions.
  ChatConnector({
    required MobileChatApi api,
    required ChatClientFactory clients,
    required ChatDeviceStore devices,
    String? deviceName,
    Duration renewBefore = const Duration(hours: 24),
    Duration retryAfter = const Duration(minutes: 1),
    DateTime Function()? now,
    ChatTimerFactory? timer,
  }) : _api = api,
       _clients = clients,
       _devices = devices,
       _deviceName = deviceName,
       _renewBefore = renewBefore,
       _retryAfter = retryAfter,
       _now = now ?? DateTime.now,
       _timer = timer ?? Timer.new,
       super(const ChatDisconnected());

  final MobileChatApi _api;
  final ChatClientFactory _clients;
  final ChatDeviceStore _devices;
  final String? _deviceName;
  final Duration _renewBefore;
  final Duration _retryAfter;
  final DateTime Function() _now;
  final ChatTimerFactory _timer;

  ChatClient? _client;
  ChatDeviceRecord? _record;
  bool _syncing = false;
  Timer? _renewal;
  void Function()? _unwatch;
  Future<void> _queue = Future.value();

  /// Signs in or restores the chat session and starts syncing.
  Future<void> connect() => _serial(_connect);

  /// Renews the access token when it expires soon or expired.
  Future<void> refresh() => _serial(_refresh);

  /// Ends the chat session and deletes the chat data of this installation.
  Future<void> disconnect() => _serial(_disconnect);

  @override
  Future<void> close() async {
    await _queue;
    await _closeClient();
    await super.close();
  }

  Future<void> _serial(Future<void> Function() operation) {
    final next = _queue.then((_) => isClosed ? null : operation());
    _queue = next.then((_) {}, onError: (Object _) {});

    return next;
  }

  Future<void> _connect() async {
    _emit(const ChatConnecting());

    try {
      final account = await _api.fetchChatAccount();

      if (!account.available) {
        await _closeClient();
        _emit(
          const ChatUnavailable(ChatUnavailableReason.homeserverUnavailable),
        );

        return;
      }

      final matrixUserId = account.matrixUserId;
      final homeserverUrl = account.homeserverUrl;

      if (account.status != MobileChatAccountStatus.active ||
          matrixUserId == null ||
          homeserverUrl == null) {
        await _purge();
        _emit(ChatUnavailable(_reasonFor(account.status)));

        return;
      }

      var record = _record ?? await _devices.read();

      if (record != null &&
          (record.matrixUserId != matrixUserId ||
              record.homeserverUrl != homeserverUrl)) {
        await _purge();
        record = null;
      }

      if (record != null && _client == null) {
        final client = await _open(homeserverUrl);

        if (await client.restore() != record.matrixUserId) {
          record = null;
        }
      }

      if (record == null) {
        record = await _signIn();
      } else {
        _record = record;

        if (_isDue(record) ||
            _client!.state.value == ChatSessionState.expired) {
          await _renew();
        }
      }

      await _run(record);
    } on MobileApiException catch (error) {
      await _handleRefusal(error);
    } on Object catch (error) {
      _emit(ChatConnectionFailed(error));
    }
  }

  Future<void> _refresh() async {
    final client = _client;
    final record = _record;

    if (client == null || record == null) {
      return;
    }

    if (!_isDue(record) && client.state.value != ChatSessionState.expired) {
      return;
    }

    try {
      await _renew();

      if (state is! ChatConnected) {
        _emit(ChatConnected(client: client, matrixUserId: record.matrixUserId));
      }
    } on MobileApiException catch (error) {
      await _handleRefusal(error);
    } on Object catch (error) {
      _renewal?.cancel();
      _renewal = _timer(_retryAfter, () => unawaited(refresh()));

      if (client.state.value == ChatSessionState.expired) {
        _emit(ChatConnectionFailed(error));
      }
    }
  }

  Future<void> _disconnect() async {
    if (_record != null || await _devices.read() != null) {
      try {
        await _api.deleteChatSession();
      } on Object {
        // NGO.Tools also ends the session when the app's API token goes away.
      }
    }

    await _purge();
    _emit(const ChatDisconnected());
  }

  /// A fresh device: nothing of an earlier session may remain in the stores.
  Future<ChatDeviceRecord> _signIn() async {
    await _purge();

    final session = await _api.createChatSession(deviceName: _deviceName);
    final client = await _open(session.homeserverUrl);
    await client.signInWithToken(
      userId: session.matrixUserId,
      deviceId: session.deviceId,
      accessToken: session.accessToken,
    );

    final record = ChatDeviceRecord(
      matrixUserId: session.matrixUserId,
      deviceId: session.deviceId,
      homeserverUrl: session.homeserverUrl,
      expiresAt: session.expiresAt,
    );
    await _devices.write(record);

    return _record = record;
  }

  Future<void> _renew() async {
    final session = await _api.renewChatSession();
    await _client!.updateAccessToken(session.accessToken);

    final record = _record!.renewedUntil(session.expiresAt);
    await _devices.write(record);
    _record = record;
    _scheduleRenewal();
  }

  Future<void> _run(ChatDeviceRecord record) async {
    final client = _client!;

    if (!_syncing) {
      await client.startSync();
      _syncing = true;
    }

    _watch(client);
    _scheduleRenewal();
    _emit(ChatConnected(client: client, matrixUserId: record.matrixUserId));
  }

  Future<void> _handleRefusal(MobileApiException error) async {
    switch (error.problem.code) {
      case 'no_chat_session':
        await _purge();
        await _connect();
      case 'no_chat_access':
        await _purge();
        _emit(const ChatUnavailable(ChatUnavailableReason.accessWithdrawn));
      case 'chat_unavailable' || 'feature_not_active':
        await _closeClient();
        _emit(
          const ChatUnavailable(ChatUnavailableReason.homeserverUnavailable),
        );
      default:
        _emit(ChatConnectionFailed(error));
    }
  }

  Future<ChatClient> _open(Uri homeserverUrl) async {
    final client = await _clients.open(
      homeserverUrl: homeserverUrl,
      storeKey: await _devices.readOrCreateStoreKey(),
    );
    _client = client;

    return client;
  }

  void _watch(ChatClient client) {
    if (_unwatch != null) {
      return;
    }

    void onStateChanged() {
      switch (client.state.value) {
        case ChatSessionState.expired:
          unawaited(refresh());
        case ChatSessionState.locked:
          unawaited(connect());
        case ChatSessionState.active || ChatSessionState.signedOut:
          break;
      }
    }

    client.state.addListener(onStateChanged);
    _unwatch = () => client.state.removeListener(onStateChanged);
  }

  void _scheduleRenewal() {
    _renewal?.cancel();
    final expiresAt = _record?.expiresAt;

    if (expiresAt == null) {
      return;
    }

    final delay = expiresAt.subtract(_renewBefore).difference(_now());
    _renewal = _timer(
      delay.isNegative ? Duration.zero : delay,
      () => unawaited(refresh()),
    );
  }

  bool _isDue(ChatDeviceRecord record) {
    final expiresAt = record.expiresAt;

    return expiresAt != null &&
        !expiresAt.subtract(_renewBefore).isAfter(_now());
  }

  Future<void> _closeClient() async {
    _renewal?.cancel();
    _renewal = null;
    _unwatch?.call();
    _unwatch = null;

    final client = _client;
    _client = null;
    _syncing = false;
    await client?.dispose();
  }

  Future<void> _purge() async {
    await _closeClient();
    _record = null;
    await _clients.purge();
    await _devices.clear();
  }

  void _emit(ChatConnectionState next) {
    if (!isClosed) {
      emit(next);
    }
  }

  static ChatUnavailableReason _reasonFor(MobileChatAccountStatus status) =>
      switch (status) {
        MobileChatAccountStatus.locked => ChatUnavailableReason.accessWithdrawn,
        MobileChatAccountStatus.deactivated =>
          ChatUnavailableReason.accountClosed,
        MobileChatAccountStatus.none ||
        MobileChatAccountStatus.active => ChatUnavailableReason.noAccount,
      };
}
