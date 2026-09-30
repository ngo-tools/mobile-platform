import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ngotools_chat/ngotools_chat.dart';
import 'package:ngotools_chat_module/ngotools_chat_module.dart';
import 'package:ngotools_design_system/ngotools_design_system.dart';

import 'fakes.dart';

void main() {
  late FakeChatGateway gateway;
  late FakePeopleApi api;
  late Object? popped;

  Future<void> pumpPushed(WidgetTester tester, Widget page) async {
    tester.view.physicalSize = const Size(1080, 2340);
    tester.view.devicePixelRatio = 3;
    addTearDown(tester.view.reset);
    popped = null;
    await tester.pumpWidget(
      MaterialApp(
        theme: NgoToolsTheme.community(),
        home: Builder(
          builder: (context) => Scaffold(
            body: FilledButton(
              onPressed: () async => popped = await Navigator.of(
                context,
              ).push(MaterialPageRoute<Object>(builder: (_) => page)),
              child: const Text('open'),
            ),
          ),
        ),
      ),
    );
    await tester.tap(find.text('open'));
    await tester.pumpAndSettle();
  }

  setUp(() {
    gateway = FakeChatGateway();
    api = FakePeopleApi();
  });

  group('new chat', () {
    Widget page() => ChatNewChatPage(
      api: api,
      gateway: gateway,
      labels: ChatLabels.german,
      searchDelay: Duration.zero,
    );

    testWidgets('lists people with their kind and searches', (tester) async {
      await pumpPushed(tester, page());

      expect(find.text('Maria Muster'), findsOneWidget);
      expect(find.text('Kontakt'), findsOneWidget);
      expect(find.text('Team'), findsOneWidget);

      await tester.enterText(find.byType(TextField), 'tina');
      await tester.pumpAndSettle();

      expect(api.searches.last, 'tina');
      expect(find.text('Maria Muster'), findsNothing);
      expect(find.text('Tina Team'), findsOneWidget);
    });

    testWidgets('opens the direct chat and returns its room', (tester) async {
      await pumpPushed(tester, page());

      await tester.tap(find.text('Maria Muster'));
      await tester.pumpAndSettle();

      expect(gateway.calls, contains('dm:@maria.muster:example.org'));
      expect(popped, '!dm-@maria.muster:example.org');
    });

    testWidgets('stays open when the chat cannot be started', (tester) async {
      gateway.failDirectChat = true;
      await pumpPushed(tester, page());

      await tester.tap(find.text('Maria Muster'));
      await tester.pumpAndSettle();

      expect(find.text('Neuer Chat'), findsOneWidget);
      expect(
        find.text('Das hat nicht geklappt. Bitte versuche es erneut.'),
        findsOneWidget,
      );
    });

    testWidgets('offers a retry when the address book fails', (tester) async {
      api.fail = true;
      await pumpPushed(tester, page());

      expect(
        find.text('Das Adressbuch konnte nicht geladen werden.'),
        findsOneWidget,
      );

      api.fail = false;
      await tester.tap(find.text('Erneut versuchen'));
      await tester.pumpAndSettle();
      expect(find.text('Maria Muster'), findsOneWidget);
    });
  });

  group('room details', () {
    RoomSummary room({RoomKind kind = RoomKind.direct}) => RoomSummary(
      id: '!room',
      name: kind == RoomKind.direct ? 'Maria Muster' : 'Vorstand',
      kind: kind,
      membership: Membership.joined,
      isEncrypted: kind == RoomKind.direct,
      unreadMessages: 0,
      unreadMentions: 0,
    );

    Widget page(RoomSummary room) => ChatRoomDetailsPage(
      gateway: gateway,
      labels: ChatLabels.german,
      room: room,
    );

    testWidgets('lists members by role and marks invites and self', (
      tester,
    ) async {
      gateway.roomMembers = const [
        ChatMember(
          user: ChatUser(id: '@zora:example.org', displayName: 'Zora'),
          state: MemberState.invited,
          role: MemberRole.user,
          isOwn: false,
        ),
        ChatMember(
          user: ChatUser(id: '@anna:example.org', displayName: 'Anna'),
          state: MemberState.joined,
          role: MemberRole.user,
          isOwn: true,
        ),
        ChatMember(
          user: ChatUser(id: '@ngo-bot:example.org', displayName: 'NGO.Tools'),
          state: MemberState.joined,
          role: MemberRole.admin,
          isOwn: false,
        ),
      ];
      await pumpPushed(tester, page(room(kind: RoomKind.group)));

      expect(find.text('3 Mitglieder'), findsOneWidget);
      expect(find.text('Anna (Du)'), findsOneWidget);
      expect(find.text('eingeladen'), findsOneWidget);
      expect(find.text('Admin'), findsOneWidget);
      expect(
        tester.getTopLeft(find.text('NGO.Tools')).dy,
        lessThan(tester.getTopLeft(find.text('Anna (Du)')).dy),
      );
      expect(find.textContaining('nicht Ende-zu-Ende'), findsOneWidget);
      await tester.scrollUntilVisible(find.text('Admin'), 200);
      await tester.drag(find.byType(ListView), const Offset(0, -2000));
      await tester.pumpAndSettle();
      expect(find.text('Chat verlassen'), findsNothing);
    });

    testWidgets('changes the notification mode', (tester) async {
      await pumpPushed(tester, page(room()));

      await tester.tap(find.text('Stumm'));
      await tester.pumpAndSettle();
      expect(gateway.calls, contains('notify:mute'));

      await tester.tap(find.text('Standard'));
      await tester.pumpAndSettle();
      expect(gateway.calls, contains('notify:default'));
    });

    testWidgets('leaves a direct chat after confirmation', (tester) async {
      await pumpPushed(tester, page(room()));

      expect(find.textContaining('Ende-zu-Ende-verschlüsselt'), findsOneWidget);

      await tester.scrollUntilVisible(find.text('Chat verlassen'), 200);
      await tester.tap(find.text('Chat verlassen'));
      await tester.pumpAndSettle();
      await tester.tap(find.widgetWithText(FilledButton, 'Chat verlassen'));
      await tester.pumpAndSettle();

      expect(gateway.calls, contains('leave:!room'));
      expect(popped, ChatRoomDetailsResult.left);
    });
  });
}
