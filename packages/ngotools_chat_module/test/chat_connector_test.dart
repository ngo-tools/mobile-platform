import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ngotools_api/ngotools_api.dart';
import 'package:ngotools_chat/ngotools_chat.dart';
import 'package:ngotools_chat_module/ngotools_chat_module.dart';

void main() {
  late _FakeChatApi api;
  late _FakeClientFactory clients;
  late _MemoryDeviceStore devices;
  late _FakeTimers timers;
  late DateTime now;

  ChatConnector connector() => ChatConnector(
    api: api,
    clients: clients,
    devices: devices,
    deviceName: 'iPhone 16',
    now: () => now,
    timer: timers.schedule,
  );

  setUp(() {
    now = DateTime.utc(2026, 10, 1, 12);
    api = _FakeChatApi(expiresAt: now.add(const Duration(days: 7)));
    clients = _FakeClientFactory();
    devices = _MemoryDeviceStore();
    timers = _FakeTimers();
  });

  test('signs a new installation in with an issued session', () async {
    final chat = connector();

    await chat.connect();

    final client = clients.opened.single;
    expect(chat.state, isA<ChatConnected>());
    expect((chat.state as ChatConnected).matrixUserId, _userId);
    expect(api.calls, ['account', 'create:iPhone 16']);
    expect(client.signIns, ['$_userId|NGOAPP1|token-1']);
    expect(client.homeserverUrl, _homeserver);
    expect(client.syncing, isTrue);
    expect(devices.record?.deviceId, 'NGOAPP1');
    expect(devices.record?.expiresAt, now.add(const Duration(days: 7)));
    expect(timers.pending.single.delay, const Duration(days: 6));

    await chat.close();
  });

  test('restores the stored session without signing in again', () async {
    devices.record = _record(expiresAt: now.add(const Duration(days: 3)));
    clients.restoredUserId = _userId;
    final chat = connector();

    await chat.connect();

    expect(chat.state, isA<ChatConnected>());
    expect(api.calls, ['account']);
    expect(clients.opened.single.signIns, isEmpty);
    expect(clients.opened.single.syncing, isTrue);
    expect(clients.purges, 0);

    await chat.close();
  });

  test('renews a restored token that expires within a day', () async {
    devices.record = _record(expiresAt: now.add(const Duration(hours: 5)));
    clients.restoredUserId = _userId;
    final chat = connector();

    await chat.connect();

    expect(api.calls, ['account', 'renew']);
    expect(clients.opened.single.tokens, ['token-1']);
    expect(devices.record?.expiresAt, now.add(const Duration(days: 7)));
    expect(chat.state, isA<ChatConnected>());

    await chat.close();
  });

  test('remembers the recovery offer until a new device signs in', () async {
    final chat = connector();
    await chat.connect();

    expect(chat.recoveryPromptSeen, isFalse);

    await chat.markRecoveryPromptSeen();
    now = now.add(const Duration(days: 6, minutes: 1));
    api.expiresAt = now.add(const Duration(days: 7));
    timers.fireAll();
    await chat.refresh();

    expect(chat.recoveryPromptSeen, isTrue);
    expect(devices.record?.recoveryPromptSeen, isTrue);

    await chat.disconnect();
    await chat.connect();

    expect(chat.recoveryPromptSeen, isFalse);

    await chat.close();
  });

  test('renews when the scheduled renewal is due', () async {
    final chat = connector();
    await chat.connect();

    now = now.add(const Duration(days: 6, minutes: 1));
    api.expiresAt = now.add(const Duration(days: 7));
    timers.fireAll();
    await chat.refresh();

    expect(api.calls, ['account', 'create:iPhone 16', 'renew']);
    expect(clients.opened.single.tokens, ['token-2']);
    expect(timers.pending.single.delay, const Duration(days: 6));
    expect(chat.state, isA<ChatConnected>());

    await chat.close();
  });

  test('renews when the chat client reports an expired token', () async {
    final chat = connector();
    await chat.connect();

    clients.opened.single.state.value = ChatSessionState.expired;
    await chat.refresh();

    expect(api.calls.last, 'renew');
    expect(clients.opened.single.tokens, ['token-2']);

    await chat.close();
  });

  test(
    'starts over with a clean store when the stored session is gone',
    () async {
      devices.record = _record(expiresAt: now.add(const Duration(days: 3)));
      clients.restoredUserId = null;
      final chat = connector();

      await chat.connect();

      expect(clients.purges, 1);
      expect(clients.opened.first.disposed, isTrue);
      expect(clients.opened.last.signIns, hasLength(1));
      expect(api.calls, ['account', 'create:iPhone 16']);
      expect(chat.state, isA<ChatConnected>());

      await chat.close();
    },
  );

  test('forgets the chat data of another account', () async {
    devices.record = ChatDeviceRecord(
      matrixUserId: '@someone.else:example.org',
      deviceId: 'NGOAPPOLD',
      homeserverUrl: _homeserver,
    );
    final chat = connector();

    await chat.connect();

    expect(clients.purges, greaterThanOrEqualTo(1));
    expect(devices.record?.matrixUserId, _userId);
    expect(clients.opened.single.signIns, hasLength(1));

    await chat.close();
  });

  test('signs in again when NGO.Tools no longer knows the session', () async {
    final chat = connector();
    await chat.connect();
    api.renewError = _refusal('no_chat_session', 404);

    clients.opened.single.state.value = ChatSessionState.expired;
    await chat.refresh();

    expect(api.calls, [
      'account',
      'create:iPhone 16',
      'renew',
      'account',
      'create:iPhone 16',
    ]);
    expect(clients.opened.first.disposed, isTrue);
    expect(clients.opened.last.signIns, hasLength(1));
    expect(chat.state, isA<ChatConnected>());

    await chat.close();
  });

  test('deletes the chat data when access was withdrawn on renewal', () async {
    final chat = connector();
    await chat.connect();
    api.renewError = _refusal('no_chat_access', 403);

    clients.opened.single.state.value = ChatSessionState.expired;
    await chat.refresh();

    expect(chat.state, _unavailable(ChatUnavailableReason.accessWithdrawn));
    expect(clients.opened.single.disposed, isTrue);
    expect(devices.record, isNull);
    expect(devices.storeKey, isNull);
    expect(timers.pending, isEmpty);

    await chat.close();
  });

  test(
    'checks the account again when the chat client reports a lock',
    () async {
      final chat = connector();
      await chat.connect();
      api.account = _account(MobileChatAccountStatus.locked);

      clients.opened.single.state.value = ChatSessionState.locked;
      await chat.refresh();

      expect(chat.state, _unavailable(ChatUnavailableReason.accessWithdrawn));
      expect(devices.record, isNull);

      await chat.close();
    },
  );

  test(
    'reports accounts that cannot use the chat and removes their data',
    () async {
      for (final (status, reason) in [
        (MobileChatAccountStatus.locked, ChatUnavailableReason.accessWithdrawn),
        (
          MobileChatAccountStatus.deactivated,
          ChatUnavailableReason.accountClosed,
        ),
        (MobileChatAccountStatus.none, ChatUnavailableReason.noAccount),
      ]) {
        devices.record = _record();
        api.account = _account(status);
        final chat = connector();

        await chat.connect();

        expect(chat.state, _unavailable(reason));
        expect(devices.record, isNull);
        expect(api.calls, isNot(contains(startsWith('create'))));

        await chat.close();
      }
    },
  );

  test('keeps the chat data while the homeserver is paused', () async {
    devices.record = _record();
    api.account = const MobileChatAccount(
      status: MobileChatAccountStatus.active,
      available: false,
    );
    final chat = connector();

    await chat.connect();

    expect(
      chat.state,
      _unavailable(ChatUnavailableReason.homeserverUnavailable),
    );
    expect(devices.record, isNotNull);
    expect(clients.purges, 0);

    await chat.close();
  });

  test('reports a refused sign-in', () async {
    api.createError = _refusal('chat_unavailable', 403);
    final chat = connector();

    await chat.connect();

    expect(
      chat.state,
      _unavailable(ChatUnavailableReason.homeserverUnavailable),
    );

    await chat.close();
  });

  test('fails without network and connects on the next attempt', () async {
    api.accountError = const SocketExceptionLike();
    final chat = connector();

    await chat.connect();
    expect(chat.state, isA<ChatConnectionFailed>());

    api.accountError = null;
    await chat.connect();
    expect(chat.state, isA<ChatConnected>());

    await chat.close();
  });

  test(
    'keeps running and retries when a renewal fails without network',
    () async {
      final chat = connector();
      await chat.connect();
      now = now.add(const Duration(days: 6, hours: 1));
      api.renewError = const SocketExceptionLike();

      await chat.refresh();

      expect(chat.state, isA<ChatConnected>());
      expect(timers.pending.last.delay, const Duration(minutes: 1));

      await chat.close();
    },
  );

  testWidgets('pauses in the background and renews on return', (tester) async {
    final chat = connector();
    await chat.connect();
    final lifecycle = ChatAppLifecycle(chat)..attach();
    addTearDown(lifecycle.detach);
    now = now.add(const Duration(days: 6, hours: 1));
    api.expiresAt = now.add(const Duration(days: 7));

    lifecycle.didChangeAppLifecycleState(AppLifecycleState.paused);
    lifecycle.didChangeAppLifecycleState(AppLifecycleState.inactive);
    lifecycle.didChangeAppLifecycleState(AppLifecycleState.resumed);
    await lifecycle.settled;

    expect(clients.opened.single.lifecycle, ['pause', 'resume']);
    expect(api.calls.last, 'renew');
  });

  test('ends the session and deletes all chat data on disconnect', () async {
    final chat = connector();
    await chat.connect();

    await chat.disconnect();

    expect(api.calls.last, 'delete');
    expect(chat.state, isA<ChatDisconnected>());
    expect(clients.opened.single.disposed, isTrue);
    expect(clients.purges, greaterThanOrEqualTo(1));
    expect(devices.record, isNull);
    expect(devices.storeKey, isNull);

    await chat.close();
  });

  test('deletes the chat data even when NGO.Tools cannot be reached', () async {
    final chat = connector();
    await chat.connect();
    api.deleteError = const SocketExceptionLike();

    await chat.disconnect();

    expect(chat.state, isA<ChatDisconnected>());
    expect(devices.record, isNull);

    await chat.close();
  });
}

const _userId = '@anna.admin:example.org';
final _homeserver = Uri.parse('https://matrix-example.chat.ngo.tools');

ChatDeviceRecord _record({DateTime? expiresAt}) => ChatDeviceRecord(
  matrixUserId: _userId,
  deviceId: 'NGOAPPSTORED',
  homeserverUrl: _homeserver,
  expiresAt: expiresAt,
);

MobileChatAccount _account(MobileChatAccountStatus status) => MobileChatAccount(
  status: status,
  available: true,
  matrixUserId: status == MobileChatAccountStatus.active ? _userId : null,
  serverName: 'example.org',
  homeserverUrl: _homeserver,
);

MobileApiException _refusal(String code, int status) => MobileApiException(
  MobileApiProblem(code: code, title: code, status: status),
);

Matcher _unavailable(ChatUnavailableReason reason) =>
    isA<ChatUnavailable>().having((state) => state.reason, 'reason', reason);

final class SocketExceptionLike implements Exception {
  const SocketExceptionLike();
}

final class _FakeChatApi implements MobileChatApi {
  _FakeChatApi({required this.expiresAt});

  DateTime expiresAt;
  MobileChatAccount account = _account(MobileChatAccountStatus.active);
  Object? accountError;
  Object? createError;
  Object? renewError;
  Object? deleteError;
  final calls = <String>[];
  int _devices = 0;
  int _tokens = 0;

  @override
  Future<MobileChatAccount> fetchChatAccount() async {
    calls.add('account');
    _throwIf(accountError);

    return account;
  }

  @override
  Future<MobileChatSession> createChatSession({String? deviceName}) async {
    calls.add('create:$deviceName');
    _throwIf(createError);
    _devices++;

    return _session();
  }

  @override
  Future<MobileChatSession> renewChatSession() async {
    calls.add('renew');
    _throwIf(renewError);

    return _session();
  }

  @override
  Future<void> deleteChatSession() async {
    calls.add('delete');
    _throwIf(deleteError);
  }

  @override
  Future<MobileChatPeoplePage> listChatPeople({
    String? search,
    int page = 1,
    int perPage = 50,
  }) => throw UnimplementedError();

  MobileChatSession _session() => MobileChatSession(
    matrixUserId: _userId,
    deviceId: 'NGOAPP$_devices',
    accessToken: 'token-${++_tokens}',
    expiresAt: expiresAt,
    homeserverUrl: _homeserver,
    serverName: 'example.org',
  );

  static void _throwIf(Object? error) {
    if (error != null) {
      throw error;
    }
  }
}

final class _FakeClient implements ChatClient {
  _FakeClient(this.homeserverUrl, this.restoredUserId);

  final Uri homeserverUrl;
  final String? restoredUserId;

  @override
  final ValueNotifier<ChatSessionState> state = ValueNotifier(
    ChatSessionState.signedOut,
  );

  final signIns = <String>[];
  final tokens = <String>[];
  bool syncing = false;
  bool disposed = false;

  @override
  ChatSession get session => throw UnimplementedError();

  @override
  Future<String?> restore() async {
    if (restoredUserId != null) {
      state.value = ChatSessionState.active;
    }

    return restoredUserId;
  }

  @override
  Future<void> signInWithToken({
    required String userId,
    required String deviceId,
    required String accessToken,
  }) async {
    signIns.add('$userId|$deviceId|$accessToken');
    state.value = ChatSessionState.active;
  }

  @override
  Future<void> updateAccessToken(String accessToken) async {
    tokens.add(accessToken);
    state.value = ChatSessionState.active;
  }

  final lifecycle = <String>[];

  @override
  Future<void> pause() async => lifecycle.add('pause');

  @override
  Future<void> resume() async => lifecycle.add('resume');

  @override
  Future<void> startSync() async => syncing = true;

  @override
  Future<void> dispose() async => disposed = true;
}

final class _FakeClientFactory implements ChatClientFactory {
  final opened = <_FakeClient>[];
  String? restoredUserId;
  int purges = 0;

  @override
  Future<ChatClient> open({
    required Uri homeserverUrl,
    required Uint8List storeKey,
  }) async {
    expect(storeKey, hasLength(32));
    final client = _FakeClient(homeserverUrl, restoredUserId);
    opened.add(client);

    return client;
  }

  @override
  Future<void> purge() async {
    expect(
      opened.every((client) => client.disposed),
      isTrue,
      reason: 'stores may only be deleted after the client stopped',
    );
    purges++;
  }
}

final class _MemoryDeviceStore implements ChatDeviceStore {
  ChatDeviceRecord? record;
  Uint8List? storeKey;

  @override
  Future<ChatDeviceRecord?> read() async => record;

  @override
  Future<void> write(ChatDeviceRecord record) async => this.record = record;

  @override
  Future<Uint8List> readOrCreateStoreKey() async => storeKey ??= Uint8List(32);

  @override
  Future<void> clear() async {
    record = null;
    storeKey = null;
  }
}

final class _FakeTimers {
  final pending = <_FakeTimer>[];

  Timer schedule(Duration delay, void Function() callback) {
    final timer = _FakeTimer(delay, callback, pending);
    pending.add(timer);

    return timer;
  }

  void fireAll() {
    for (final timer in [...pending]) {
      timer.fire();
    }
  }
}

final class _FakeTimer implements Timer {
  _FakeTimer(this.delay, this._callback, this._pending);

  final Duration delay;
  final void Function() _callback;
  final List<_FakeTimer> _pending;

  void fire() {
    _pending.remove(this);
    _callback();
  }

  @override
  void cancel() => _pending.remove(this);

  @override
  bool get isActive => _pending.contains(this);

  @override
  int get tick => 0;
}
