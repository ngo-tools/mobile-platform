import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ngotools_chat/ngotools_chat.dart';
import 'package:ngotools_chat_module/ngotools_chat_module.dart';
import 'package:ngotools_design_system/ngotools_design_system.dart';

void main() {
  final now = DateTime(2026, 10, 1, 15);
  late _FakeGateway gateway;
  late List<RoomSummary> opened;

  Future<void> pumpList(WidgetTester tester, {ChatLabels? labels}) async {
    await tester.pumpWidget(
      MaterialApp(
        theme: NgoToolsTheme.community(),
        home: Scaffold(
          body: ChatRoomListView(
            gateway: gateway,
            labels: labels ?? ChatLabels.german,
            onOpenRoom: opened.add,
            now: () => now,
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
  }

  setUp(() {
    gateway = _FakeGateway();
    opened = [];
  });

  testWidgets('shows invites first and answers them', (tester) async {
    gateway.list.rooms.value = [
      _room('!dm', 'Maria Muster', latest: _latest('Hallo')),
      _room('!invite', 'Jugendgruppe', membership: Membership.invited),
    ];
    await pumpList(tester);

    expect(find.text('Einladungen'), findsOneWidget);
    expect(
      tester.getTopLeft(find.text('Jugendgruppe')).dy,
      lessThan(tester.getTopLeft(find.text('Maria Muster')).dy),
    );

    await tester.tap(find.text('Annehmen'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Ablehnen'));
    await tester.pumpAndSettle();

    expect(gateway.calls, ['join:!invite', 'leave:!invite']);
  });

  testWidgets('reports a failed answer without losing the invite', (
    tester,
  ) async {
    gateway
      ..failJoin = true
      ..list.rooms.value = [
        _room('!invite', 'Jugendgruppe', membership: Membership.invited),
      ];
    await pumpList(tester);

    await tester.tap(find.text('Annehmen'));
    await tester.pumpAndSettle();

    expect(
      find.text('Das hat nicht geklappt. Bitte versuche es erneut.'),
      findsOneWidget,
    );
    expect(find.text('Jugendgruppe'), findsOneWidget);
  });

  testWidgets('describes the latest message per room kind', (tester) async {
    gateway.list.rooms.value = [
      _room('!own', 'Maria Muster', latest: _latest('Bis später', isOwn: true)),
      _room(
        '!group',
        'Vorstand',
        kind: RoomKind.group,
        latest: _latest(
          '',
          preview: const MessagePreview.image(),
          sender: const ChatUser(id: '@tina:example.org', displayName: 'Tina'),
          timestamp: DateTime(2026, 9, 30, 20),
        ),
      ),
      _room(
        '!dm',
        'Paul',
        latest: _latest(
          '',
          preview: const MessagePreview.unableToDecrypt(),
          timestamp: DateTime(2026, 9, 27, 9),
        ),
      ),
    ];
    await pumpList(tester);

    expect(find.text('Du: Bis später'), findsOneWidget);
    expect(find.text('Tina: Bild'), findsOneWidget);
    expect(find.text('Verschlüsselte Nachricht'), findsOneWidget);
    expect(find.text('14:00'), findsOneWidget);
    expect(find.text('Gestern'), findsOneWidget);
    expect(find.text('So'), findsOneWidget);
  });

  testWidgets('counts unread messages and mentions for screen readers', (
    tester,
  ) async {
    final semantics = tester.ensureSemantics();
    gateway.list.rooms.value = [
      _room(
        '!group',
        'Vorstand',
        kind: RoomKind.group,
        unreadMessages: 4,
        unreadMentions: 1,
        notificationMode: NotificationMode.mute,
        latest: _latest('Wer kommt?'),
      ),
    ];
    await pumpList(tester);

    expect(find.text('1'), findsOneWidget);
    expect(find.byIcon(Icons.notifications_off_outlined), findsOneWidget);
    expect(
      find.bySemanticsLabel(
        RegExp(
          'Vorstand.*1 Erwähnung.*4 ungelesene Nachrichten.*Stummgeschaltet',
        ),
      ),
      findsOneWidget,
    );
    semantics.dispose();
  });

  testWidgets('opens joined rooms', (tester) async {
    gateway.list.rooms.value = [_room('!dm', 'Maria Muster')];
    await pumpList(tester);

    await tester.tap(find.text('Maria Muster'));

    expect(opened.single.id, '!dm');
  });

  testWidgets('searches by name and filters through the list', (tester) async {
    gateway.list.rooms.value = [
      _room('!a', 'Maria Muster'),
      _room('!b', 'Vorstand', kind: RoomKind.group),
    ];
    await pumpList(tester);

    await tester.enterText(find.byType(TextField), 'vor');
    await tester.pumpAndSettle();
    expect(find.text('Maria Muster'), findsNothing);
    expect(find.text('Vorstand'), findsOneWidget);

    await tester.enterText(find.byType(TextField), 'xyz');
    await tester.pumpAndSettle();
    expect(find.text('Keine Chats gefunden.'), findsOneWidget);

    await tester.tap(find.text('Gruppen'));
    await tester.pumpAndSettle();
    expect(gateway.list.filter.value, RoomFilter.groups);
  });

  testWidgets('explains an empty chat list', (tester) async {
    await pumpList(tester, labels: ChatLabels.english);

    expect(find.text('No chats yet'), findsOneWidget);
  });

  testWidgets('loads more rooms near the end of the list', (tester) async {
    gateway.list.rooms.value = [
      for (var i = 0; i < 40; i++) _room('!room$i', 'Raum $i'),
    ];
    await pumpList(tester);

    await tester.drag(find.byType(ListView), const Offset(0, -3000));
    await tester.pumpAndSettle();

    expect(gateway.list.loadMoreCalls, greaterThan(0));
  });

  testWidgets('stops the room list when leaving the screen', (tester) async {
    await pumpList(tester);

    await tester.pumpWidget(const SizedBox());

    expect(gateway.list.disposed, isTrue);
  });

  group('ChatConnectionView', () {
    Future<void> pumpState(WidgetTester tester, ChatConnectionState state) =>
        tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: ChatConnectionView(
                state: state,
                labels: ChatLabels.german,
                onRetry: () {},
                builder: (context, connection) => Text(connection.matrixUserId),
              ),
            ),
          ),
        );

    testWidgets('explains withdrawn access without a retry', (tester) async {
      await pumpState(
        tester,
        const ChatUnavailable(ChatUnavailableReason.accessWithdrawn),
      );

      expect(find.textContaining('Chat-Zugang beendet'), findsOneWidget);
      expect(find.text('Erneut versuchen'), findsNothing);
    });

    testWidgets('offers a retry after a failed connection', (tester) async {
      await pumpState(tester, ChatConnectionFailed(Exception('offline')));

      expect(find.text('Keine Verbindung zum Chat.'), findsOneWidget);
      expect(find.text('Erneut versuchen'), findsOneWidget);
    });
  });

  test('formats activity times relative to today', () {
    final labels = ChatLabels.german;

    expect(labels.activityTime(DateTime(2026, 10, 1, 9, 5), now), '09:05');
    expect(labels.activityTime(DateTime(2026, 9, 30, 23), now), 'Gestern');
    expect(labels.activityTime(DateTime(2026, 9, 28), now), 'Mo');
    expect(labels.activityTime(DateTime(2026, 8, 3), now), '03.08.');
    expect(labels.activityTime(DateTime(2025, 12, 24), now), '24.12.25');
  });
}

RoomSummary _room(
  String id,
  String name, {
  RoomKind kind = RoomKind.direct,
  Membership membership = Membership.joined,
  int unreadMessages = 0,
  int unreadMentions = 0,
  NotificationMode? notificationMode,
  LatestEvent? latest,
}) => RoomSummary(
  id: id,
  name: name,
  kind: kind,
  membership: membership,
  isEncrypted: kind == RoomKind.direct,
  unreadMessages: unreadMessages,
  unreadMentions: unreadMentions,
  notificationMode: notificationMode,
  latest: latest,
);

LatestEvent _latest(
  String body, {
  bool isOwn = false,
  MessagePreview? preview,
  ChatUser sender = const ChatUser(id: '@maria:example.org'),
  DateTime? timestamp,
}) => LatestEvent(
  sender: sender,
  isOwn: isOwn,
  timestamp: timestamp ?? DateTime(2026, 10, 1, 14),
  preview: preview ?? MessagePreview.text(body),
  isUnsent: false,
);

final class _FakeRoomList implements ChatRoomListSource {
  @override
  final ValueNotifier<List<RoomSummary>> rooms = ValueNotifier(const []);

  @override
  final ValueNotifier<RoomFilter> filter = ValueNotifier(RoomFilter.all);

  int loadMoreCalls = 0;
  bool disposed = false;

  @override
  Future<void> setFilter(RoomFilter filter) async => this.filter.value = filter;

  @override
  Future<void> loadMore() async => loadMoreCalls++;

  @override
  Future<void> dispose() async => disposed = true;
}

final class _FakeGateway implements ChatGateway {
  final list = _FakeRoomList();
  final calls = <String>[];
  bool failJoin = false;

  @override
  Future<ChatRoomListSource> rooms() async => list;

  @override
  Future<void> joinRoom(String roomId) async {
    calls.add('join:$roomId');

    if (failJoin) {
      throw const ChatException(ChatErrorKind.network);
    }
  }

  @override
  Future<void> leaveRoom(String roomId) async => calls.add('leave:$roomId');

  @override
  Future<Uint8List> thumbnail(ChatMedia media, int size) async => Uint8List(0);
}
