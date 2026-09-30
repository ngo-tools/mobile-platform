import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ngotools_api/ngotools_api.dart';
import 'package:ngotools_chat/ngotools_chat.dart';
import 'package:ngotools_chat_module/ngotools_chat_module.dart';
import 'package:ngotools_design_system/ngotools_design_system.dart';

import 'fakes.dart';

void main() {
  late FakeChatGateway gateway;
  late _ConnectApi api;
  late ChatConnector connector;
  late ChatHomeController controller;

  Future<void> pumpHome(
    WidgetTester tester, {
    Size size = const Size(360, 780),
  }) async {
    connector = ChatConnector(
      api: api,
      clients: _Clients(),
      devices: _Devices(),
      timer: (_, _) => _NoTimer(),
    );
    tester.view.physicalSize = size * 3;
    tester.view.devicePixelRatio = 3;
    addTearDown(tester.view.reset);
    await tester.pumpWidget(
      MaterialApp(
        theme: NgoToolsTheme.community(),
        home: Scaffold(
          body: ChatHome(
            connector: connector,
            api: api,
            labels: ChatLabels.german,
            controller: controller,
            gatewayFor: (_) => gateway,
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
  }

  setUp(() {
    gateway = FakeChatGateway();
    api = _ConnectApi();
    controller = ChatHomeController();
    gateway.list.rooms.value = [
      RoomSummary(
        id: '!group',
        name: 'Vorstand',
        kind: RoomKind.group,
        membership: Membership.joined,
        isEncrypted: false,
        unreadMessages: 0,
        unreadMentions: 0,
      ),
    ];
  });

  testWidgets('connects and shows the room list', (tester) async {
    await pumpHome(tester);

    expect(api.calls, ['account', 'create']);
    expect(find.text('Vorstand'), findsOneWidget);
  });

  testWidgets('explains withdrawn access', (tester) async {
    api.status = MobileChatAccountStatus.locked;
    await pumpHome(tester);

    expect(find.text('Chat nicht verfügbar'), findsOneWidget);
    expect(find.textContaining('Chat-Zugang beendet'), findsOneWidget);
  });

  testWidgets('opens a room with details on phones', (tester) async {
    await pumpHome(tester);

    await tester.tap(find.text('Vorstand'));
    await tester.pumpAndSettle();

    expect(gateway.calls, contains('open:!group'));
    expect(find.byTooltip('Details'), findsOneWidget);

    await tester.tap(find.byTooltip('Details'));
    await tester.pumpAndSettle();
    expect(find.textContaining('nicht Ende-zu-Ende'), findsOneWidget);
  });

  testWidgets('shows list and room side by side on tablets', (tester) async {
    await pumpHome(tester, size: const Size(1200, 800));

    await tester.tap(find.text('Vorstand'));
    await tester.pumpAndSettle();

    expect(find.byType(ChatRoomListView), findsOneWidget);
    expect(find.byType(ChatRoomView), findsOneWidget);
  });

  testWidgets('opens a room requested from outside', (tester) async {
    await pumpHome(tester);

    controller.openRoom('!group');
    await tester.pumpAndSettle();

    expect(gateway.calls, contains('open:!group'));
    expect(controller.pendingRoomId, isNull);
  });

  testWidgets('starts a direct chat and opens it', (tester) async {
    await pumpHome(tester);

    await tester.tap(find.byTooltip('Neuer Chat'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Maria Muster'));
    await tester.pumpAndSettle();

    expect(gateway.calls, contains('dm:@maria.muster:example.org'));
    expect(gateway.calls, contains('open:!dm-@maria.muster:example.org'));
    expect(find.text('Maria Muster'), findsOneWidget);
  });

  test('parses chat deep links', () {
    expect(
      ChatDeepLink.roomId(Uri.parse('app:/chat/rooms/!abc:example.org')),
      '!abc:example.org',
    );
    expect(ChatDeepLink.roomId(Uri.parse('app:/chat')), isNull);
    expect(ChatDeepLink.matches(Uri.parse('app:/chat')), isTrue);
    expect(ChatDeepLink.matches(Uri.parse('app:/events/1')), isFalse);
  });
}

final class _ConnectApi extends FakePeopleApi {
  final calls = <String>[];
  MobileChatAccountStatus status = MobileChatAccountStatus.active;

  @override
  Future<MobileChatAccount> fetchChatAccount() async {
    calls.add('account');

    return MobileChatAccount(
      status: status,
      available: true,
      matrixUserId: status == MobileChatAccountStatus.active
          ? '@anna:example.org'
          : null,
      serverName: 'example.org',
      homeserverUrl: Uri.parse('https://matrix.example.org'),
    );
  }

  @override
  Future<MobileChatSession> createChatSession({String? deviceName}) async {
    calls.add('create');

    return MobileChatSession(
      matrixUserId: '@anna:example.org',
      deviceId: 'NGOAPPTEST',
      accessToken: 'token',
      homeserverUrl: Uri.parse('https://matrix.example.org'),
      serverName: 'example.org',
    );
  }

  @override
  Future<void> deleteChatSession() async {}
}

final class _Client implements ChatClient {
  @override
  final ValueNotifier<ChatSessionState> state = ValueNotifier(
    ChatSessionState.signedOut,
  );

  @override
  ChatSession get session => throw UnimplementedError();

  @override
  Future<String?> restore() async => null;

  @override
  Future<void> signInWithToken({
    required String userId,
    required String deviceId,
    required String accessToken,
  }) async => state.value = ChatSessionState.active;

  @override
  Future<void> updateAccessToken(String accessToken) async {}

  @override
  Future<void> pause() async {}

  @override
  Future<void> resume() async {}

  @override
  Future<void> startSync() async {}

  @override
  Future<void> dispose() async {}
}

final class _Clients implements ChatClientFactory {
  @override
  Future<ChatClient> open({
    required Uri homeserverUrl,
    required Uint8List storeKey,
  }) async => _Client();

  @override
  Future<void> purge() async {}
}

final class _Devices implements ChatDeviceStore {
  ChatDeviceRecord? record;

  @override
  Future<ChatDeviceRecord?> read() async => record;

  @override
  Future<void> write(ChatDeviceRecord record) async => this.record = record;

  @override
  Future<Uint8List> readOrCreateStoreKey() async => Uint8List(32);

  @override
  Future<void> clear() async => record = null;
}

final class _NoTimer implements Timer {
  @override
  void cancel() {}

  @override
  bool get isActive => false;

  @override
  int get tick => 0;
}
