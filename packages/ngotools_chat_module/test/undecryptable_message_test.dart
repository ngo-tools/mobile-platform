import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ngotools_chat/ngotools_chat.dart';
import 'package:ngotools_chat_module/ngotools_chat_module.dart';
import 'package:ngotools_design_system/ngotools_design_system.dart';

import 'fakes.dart';

void main() {
  late FakeChatGateway gateway;

  Future<void> pumpRoom(
    WidgetTester tester,
    DecryptionFailure reason, {
    VoidCallback? onEnterRecoveryKey,
  }) async {
    tester.view.physicalSize = const Size(1080, 2340);
    tester.view.devicePixelRatio = 3;
    addTearDown(tester.view.reset);
    gateway.timeline.items.value = [
      eventItem(
        chatEvent(
          r'$1',
          '',
          content: EventContent.unableToDecrypt(reason: reason),
        ),
      ),
    ];
    await tester.pumpWidget(
      MaterialApp(
        theme: NgoToolsTheme.community(),
        home: ChatRoomPage(
          gateway: gateway,
          labels: ChatLabels.german,
          roomId: '!room',
          title: 'Maria',
          isGroup: false,
          onEnterRecoveryKey: onEnterRecoveryKey,
        ),
      ),
    );
    await tester.pumpAndSettle();
  }

  setUp(() => gateway = FakeChatGateway());

  testWidgets('names the reason instead of a generic placeholder', (
    tester,
  ) async {
    final expected = {
      DecryptionFailure.unknown:
          'Diese Nachricht kann noch nicht entschlüsselt werden.',
      DecryptionFailure.sentBeforeJoined:
          'Vor Deinem Beitritt gesendet – nicht lesbar.',
      DecryptionFailure.historicalNoBackup: 'Auf diesem Gerät nicht lesbar.',
      DecryptionFailure.historicalUnverifiedDevice:
          'Zum Lesen ist Dein Wiederherstellungsschlüssel nötig.',
      DecryptionFailure.withheld: 'Nicht für dieses Gerät freigegeben.',
      DecryptionFailure.untrustedSender:
          'Von einem nicht bestätigten Gerät gesendet.',
    };

    for (final MapEntry(key: reason, value: text) in expected.entries) {
      await pumpRoom(tester, reason);

      expect(find.text(text), findsOneWidget, reason: reason.name);
    }
  });

  testWidgets('explains the reason and offers the recovery key', (
    tester,
  ) async {
    var opened = 0;
    await pumpRoom(
      tester,
      DecryptionFailure.historicalUnverifiedDevice,
      onEnterRecoveryKey: () => opened++,
    );

    await tester.tap(
      find.text('Zum Lesen ist Dein Wiederherstellungsschlüssel nötig.'),
    );
    await tester.pumpAndSettle();

    expect(
      find.text('Warum ist diese Nachricht nicht lesbar?'),
      findsOneWidget,
    );
    expect(find.textContaining('aus der Sicherung'), findsOneWidget);

    await tester.tap(find.text('Wiederherstellungsschlüssel eingeben'));
    await tester.pumpAndSettle();

    expect(opened, 1);
    expect(find.text('Warum ist diese Nachricht nicht lesbar?'), findsNothing);
  });

  testWidgets('offers no recovery key when it cannot help', (tester) async {
    await pumpRoom(
      tester,
      DecryptionFailure.sentBeforeJoined,
      onEnterRecoveryKey: () {},
    );

    await tester.tap(find.text('Vor Deinem Beitritt gesendet – nicht lesbar.'));
    await tester.pumpAndSettle();

    expect(
      find.textContaining('bevor Du dem Chat beigetreten'),
      findsOneWidget,
    );
    expect(find.text('Wiederherstellungsschlüssel eingeben'), findsNothing);
  });

  testWidgets('offers no recovery key when this device has it', (tester) async {
    await pumpRoom(tester, DecryptionFailure.unknown);

    await tester.tap(
      find.text('Diese Nachricht kann noch nicht entschlüsselt werden.'),
    );
    await tester.pumpAndSettle();

    expect(find.text('Wiederherstellungsschlüssel eingeben'), findsNothing);
  });

  test('has English texts for every reason', () {
    for (final reason in DecryptionFailure.values) {
      expect(ChatEncryptionLabels.english.undecryptable(reason), isNotEmpty);
      expect(
        ChatEncryptionLabels.english.undecryptableExplanation(reason),
        isNotEmpty,
      );
    }
  });
}
