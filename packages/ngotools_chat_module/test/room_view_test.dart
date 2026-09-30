import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ngotools_chat/ngotools_chat.dart';
import 'package:ngotools_chat_module/ngotools_chat_module.dart';
import 'package:ngotools_design_system/ngotools_design_system.dart';

import 'fakes.dart';

void main() {
  final now = DateTime(2026, 10, 1, 15);
  late FakeChatGateway gateway;

  Future<void> pumpRoom(WidgetTester tester, {bool isGroup = true}) async {
    tester.view.physicalSize = const Size(1080, 2340);
    tester.view.devicePixelRatio = 3;
    addTearDown(tester.view.reset);
    await tester.pumpWidget(
      MaterialApp(
        theme: NgoToolsTheme.community(),
        home: ChatRoomPage(
          gateway: gateway,
          labels: ChatLabels.german,
          roomId: '!room',
          title: 'Vorstand',
          isGroup: isGroup,
          now: () => now,
        ),
      ),
    );
    await tester.pumpAndSettle();
  }

  setUp(() => gateway = FakeChatGateway());

  testWidgets('opens the timeline, loads history and marks it read', (
    tester,
  ) async {
    gateway.timeline.items.value = [
      TimelineItem.dateDivider(id: 'day', date: DateTime(2026, 10, 1)),
      eventItem(chatEvent(r'$1', 'Hallo zusammen')),
      eventItem(chatEvent(r'$2', 'Wer kommt morgen?')),
      eventItem(
        chatEvent(
          r'$3',
          'Ich',
          sender: '@tina:example.org',
          senderName: 'Tina',
        ),
      ),
    ];
    await pumpRoom(tester);

    expect(gateway.calls, containsAll(['open:!room', 'paginate', 'read']));
    expect(find.text('Heute'), findsOneWidget);
    expect(find.text('Maria'), findsOneWidget);
    expect(find.text('Tina'), findsOneWidget);
    expect(
      tester.getTopLeft(find.text('Hallo zusammen')).dy,
      lessThan(tester.getTopLeft(find.text('Ich')).dy),
    );
  });

  testWidgets('hides sender names in direct chats', (tester) async {
    gateway.timeline.items.value = [eventItem(chatEvent(r'$1', 'Hallo'))];
    await pumpRoom(tester, isGroup: false);

    expect(find.text('Maria'), findsNothing);
  });

  testWidgets('sends a message and clears the composer', (tester) async {
    await pumpRoom(tester);

    expect(
      tester
          .widget<IconButton>(find.widgetWithIcon(IconButton, Icons.send))
          .onPressed,
      isNull,
    );

    await tester.enterText(find.byType(TextField), ' Guten Morgen ');
    await tester.pump();
    await tester.tap(find.byIcon(Icons.send));
    await tester.pumpAndSettle();

    expect(gateway.calls, contains('send:Guten Morgen'));
    expect(gateway.calls, contains('typing:true'));
    expect(gateway.calls.last, 'send:Guten Morgen');
    expect(find.text(' Guten Morgen '), findsNothing);
  });

  testWidgets('reports a failed send', (tester) async {
    gateway.timeline.failSend = true;
    await pumpRoom(tester);

    await tester.enterText(find.byType(TextField), 'Hallo');
    await tester.pump();
    await tester.tap(find.byIcon(Icons.send));
    await tester.pumpAndSettle();

    expect(
      find.text('Das hat nicht geklappt. Bitte versuche es erneut.'),
      findsOneWidget,
    );
  });

  testWidgets('replies to a message from its actions', (tester) async {
    gateway.timeline.items.value = [
      eventItem(chatEvent(r'$1', 'Wer bringt Kuchen?')),
    ];
    await pumpRoom(tester);

    await tester.longPress(find.text('Wer bringt Kuchen?'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Antworten'));
    await tester.pumpAndSettle();

    expect(find.text('Antwort an Maria'), findsOneWidget);

    await tester.enterText(find.byType(TextField), 'Ich');
    await tester.pump();
    await tester.tap(find.byIcon(Icons.send));
    await tester.pumpAndSettle();

    expect(gateway.calls, contains(r'reply:$1:Ich'));
    expect(find.text('Antwort an Maria'), findsNothing);
  });

  testWidgets('edits and deletes own messages', (tester) async {
    gateway.timeline.items.value = [
      eventItem(chatEvent(r'$1', 'Tippfeler', isOwn: true)),
    ];
    await pumpRoom(tester);

    await tester.longPress(find.text('Tippfeler'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Bearbeiten'));
    await tester.pumpAndSettle();

    expect(find.text('Nachricht bearbeiten'), findsOneWidget);

    await tester.enterText(find.byType(TextField), 'Tippfehler');
    await tester.pump();
    await tester.tap(find.byIcon(Icons.send));
    await tester.pumpAndSettle();

    expect(gateway.calls, contains(r'edit:$1:Tippfehler'));

    await tester.longPress(find.text('Tippfeler'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Löschen'));
    await tester.pumpAndSettle();
    expect(find.text('Nachricht löschen?'), findsOneWidget);
    await tester.tap(find.widgetWithText(FilledButton, 'Löschen'));
    await tester.pumpAndSettle();

    expect(gateway.calls, contains(r'redact:$1'));
  });

  testWidgets('does not offer editing or deleting messages of others', (
    tester,
  ) async {
    gateway.timeline.items.value = [eventItem(chatEvent(r'$1', 'Hallo'))];
    await pumpRoom(tester);

    await tester.longPress(find.text('Hallo'));
    await tester.pumpAndSettle();

    expect(find.text('Bearbeiten'), findsNothing);
    expect(find.text('Löschen'), findsNothing);
    expect(find.text('Text kopieren'), findsOneWidget);
  });

  testWidgets('reacts from the actions and toggles existing reactions', (
    tester,
  ) async {
    gateway.timeline.items.value = [
      eventItem(
        chatEvent(
          r'$1',
          'Geschafft!',
          reactions: const [Reaction(key: '🎉', count: 2, byMe: false)],
        ),
      ),
    ];
    await pumpRoom(tester);

    await tester.tap(find.text('🎉 2'));
    await tester.pumpAndSettle();
    await tester.longPress(find.text('Geschafft!'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('👍'));
    await tester.pumpAndSettle();

    expect(gateway.calls, containsAll([r'react:$1:🎉', r'react:$1:👍']));
  });

  testWidgets('fits the message actions on small phones with large text', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(960, 1920);
    tester.view.devicePixelRatio = 3;
    tester.platformDispatcher.textScaleFactorTestValue = 1.5;
    addTearDown(tester.view.reset);
    addTearDown(tester.platformDispatcher.clearTextScaleFactorTestValue);
    gateway.timeline.items.value = [
      eventItem(chatEvent(r'$1', 'Hallo', isOwn: true)),
    ];
    await tester.pumpWidget(
      MaterialApp(
        theme: NgoToolsTheme.community(),
        home: ChatRoomPage(
          gateway: gateway,
          labels: ChatLabels.german,
          roomId: '!room',
          title: 'Vorstand',
          isGroup: true,
        ),
      ),
    );
    await tester.pumpAndSettle();

    await tester.longPress(find.text('Hallo'));
    await tester.pumpAndSettle();

    expect(tester.takeException(), isNull);
    expect(find.text('👍'), findsOneWidget);
  });

  testWidgets('offers retry and discard for failed messages', (tester) async {
    gateway.timeline.items.value = [
      eventItem(
        chatEvent(
          r'$1',
          'Offline geschrieben',
          isOwn: true,
          sendState: const SendState.failed(recoverable: true),
        ),
      ),
    ];
    await pumpRoom(tester);

    expect(find.byIcon(Icons.error_outline), findsOneWidget);

    await tester.longPress(find.text('Offline geschrieben'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Erneut senden'));
    await tester.pumpAndSettle();

    expect(gateway.calls, contains('retry'));
  });

  testWidgets('shows who is typing', (tester) async {
    await pumpRoom(tester);

    gateway.timeline.typing.value = const [
      ChatUser(id: '@maria:example.org', displayName: 'Maria'),
    ];
    await tester.pump();

    expect(find.text('Maria schreibt …'), findsOneWidget);
  });

  testWidgets('loads a replied-to message once and shows notices', (
    tester,
  ) async {
    gateway.timeline.items.value = [
      eventItem(
        chatEvent(
          r'$m',
          '',
          content: const EventContent.membership(
            userId: '@paul.peters:example.org',
            change: MembershipChange.joined,
          ),
        ),
      ),
      eventItem(
        chatEvent(r'$2', 'Genau', replyTo: const ReplyPreview(eventId: r'$1')),
      ),
      eventItem(
        chatEvent(r'$3', '', content: const EventContent.unableToDecrypt()),
      ),
    ];
    await pumpRoom(tester);
    await tester.pump();

    expect(
      gateway.calls.where((call) => call == r'replyDetails:$1'),
      hasLength(1),
    );
    expect(find.text('Nachricht wird geladen …'), findsOneWidget);
    expect(find.text('paul.peters ist beigetreten'), findsOneWidget);
    expect(
      find.text('Diese Nachricht kann noch nicht entschlüsselt werden.'),
      findsOneWidget,
    );
  });

  testWidgets('opens a thread from its summary', (tester) async {
    gateway.timeline.items.value = [
      eventItem(
        chatEvent(
          r'$root',
          'Planung Sommerfest',
          thread: const ThreadSummary(replyCount: 3),
        ),
      ),
    ];
    await pumpRoom(tester);

    await tester.tap(find.text('3 Antworten'));
    await tester.pumpAndSettle();

    expect(gateway.calls, contains(r'openThread:$root'));
    expect(find.text('Thread'), findsOneWidget);
  });

  testWidgets('lists the threads of a room', (tester) async {
    await pumpRoom(tester);

    await tester.tap(find.byTooltip('Threads'));
    await tester.pumpAndSettle();
    expect(
      find.text('In diesem Chat gibt es noch keine Threads.'),
      findsOneWidget,
    );

    gateway.threads.threads.value = [
      ThreadInfo(
        root: ThreadEvent(
          eventId: r'$root',
          sender: const ChatUser(
            id: '@maria:example.org',
            displayName: 'Maria',
          ),
          timestamp: DateTime(2026, 10, 1, 9),
          isOwn: false,
          preview: const MessagePreview.text('Planung Sommerfest'),
        ),
        replyCount: 2,
      ),
    ];
    await tester.pumpAndSettle();

    expect(find.text('Planung Sommerfest'), findsOneWidget);
    expect(find.text('Maria · 2 Antworten'), findsOneWidget);

    await tester.tap(find.text('Planung Sommerfest'));
    await tester.pumpAndSettle();
    expect(gateway.calls, contains(r'openThread:$root'));
  });

  testWidgets('stops the timeline when leaving the room', (tester) async {
    await pumpRoom(tester);

    await tester.pumpWidget(const SizedBox());

    expect(gateway.timeline.disposed, isTrue);
  });

  test('labels dates of dividers', () {
    final labels = ChatLabels.german;

    expect(labels.dayLabel(DateTime(2026, 9, 30), now), 'Gestern');
    expect(
      labels.dayLabel(DateTime(2026, 9, 28), now),
      'Montag, 28. September',
    );
    expect(
      ChatLabels.english.dayLabel(DateTime(2025, 12, 24), now),
      'Wednesday, 24 December 2025',
    );
  });
}
