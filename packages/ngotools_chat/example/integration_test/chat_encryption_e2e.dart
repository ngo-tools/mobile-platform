import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:ngotools_chat/ngotools_chat.dart';
import 'package:ngotools_chat_module/ngotools_chat_module.dart';
import 'package:ngotools_design_system/ngotools_design_system.dart';

import 'chat_flow_e2e.dart' as flow;
import 'support/ui_e2e.dart';

/// Acceptance of the encryption screens (M6) against the local e2e server:
/// set up recovery, the sign-out warning, an unreadable message on a new
/// device, a wrong and the right recovery key.
void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  setUpAll(() async {
    const hostLogFile = String.fromEnvironment('RUST_LOG_FILE');
    await ChatSession.initialize(
      logFile: hostLogFile.isNotEmpty
          ? hostLogFile
          : '${Directory.systemTemp.path}/chat-encryption-rust.log',
      level: ChatLogLevel.debug,
    );
  });

  testWidgets(
    'encryption screens with the real SDK',
    (tester) async {
      final run = DateTime.now().millisecondsSinceEpoch;
      final labels = ChatLabels.german.encryption;
      final alice = await flow.loginUser(
        'alice',
        flow.aliceName,
        'enc-$run-alice',
        await flow.storeKey('enc-alice-$run'),
      );
      final bob = await flow.loginUser(
        'bob',
        flow.bobName,
        'enc-$run-bob',
        await flow.storeKey('enc-bob-$run'),
      );
      final aliceGateway = SessionChatGateway(alice.session);

      Future<void> show(Widget home) => tester.pumpWidget(
        MaterialApp(theme: NgoToolsTheme.community(), home: home),
      );

      // Set up recovery on Alice's first device.
      await show(ChatSecurityPage(gateway: aliceGateway, labels: labels));
      await waitFor(tester, find.text('Wiederherstellung nicht eingerichtet'));
      await tester.tap(find.widgetWithText(FilledButton, 'Einrichten'));
      await waitFor(tester, find.text('Nachrichten sichern'));
      await checkAccessibility(tester, 'recovery_intro');
      // The security page stays below the setup.
      await tester.tap(find.widgetWithText(FilledButton, 'Einrichten').last);
      await waitFor(tester, find.byKey(const Key('recovery-key')));
      final recoveryKey = tester
          .widget<SelectableText>(find.byKey(const Key('recovery-key')))
          .data!;
      await checkAccessibility(tester, 'recovery_key');
      debugPrint('E2E_SCREENSHOT enc-recovery-key');
      await settle(tester, const Duration(seconds: 2));
      await tester.tap(find.text('Weiter'));
      await settle(tester, const Duration(milliseconds: 500));
      await tester.enterText(
        find.byType(TextField),
        chatRecoveryKeyEnding(recoveryKey),
      );
      await tester.tap(find.text('Fertig'));
      await waitFor(tester, find.text('Wiederherstellung eingerichtet'));
      flow.metric('ui_recovery_set_up', 'ok');

      // Bob writes in an encrypted direct chat; Alice reads it on this device,
      // so its keys go into her backup.
      final roomId = await bob.session.createDirectChat(
        '@${flow.aliceName}:${flow.serverName}',
      );
      await alice.waitForRooms(
        (rooms) => rooms.any((room) => room.id == roomId),
      );
      await alice.session.joinRoom(roomId);
      await bob.openTimeline(roomId);
      final secret = 'Vertraulich $run';
      await bob.timeline.sendText(secret);
      await alice.openTimeline(roomId);
      await alice.waitForTimeline((items) => flow.hasText(items, secret));
      await settle(tester, const Duration(seconds: 3));

      // Bob has no recovery and only this device: signing out warns.
      final bobGateway = SessionChatGateway(bob.session);
      final signOut = <bool>[];
      await show(
        Scaffold(
          body: Builder(
            builder: (context) => Center(
              child: TextButton(
                onPressed: () async => signOut.add(
                  await confirmChatSignOut(
                    context,
                    gateway: bobGateway,
                    labels: labels,
                  ),
                ),
                child: const Text('Abmelden'),
              ),
            ),
          ),
        ),
      );
      await settle(tester, const Duration(seconds: 1));
      await tester.tap(find.text('Abmelden'));
      await waitFor(
        tester,
        find.text('Verschlüsselte Nachrichten gehen verloren'),
      );
      await checkAccessibility(tester, 'sign_out_warning');
      await tester.tap(find.text('Abbrechen'));
      await settle(tester, const Duration(milliseconds: 500));
      expect(signOut, [false]);
      flow.metric('ui_sign_out_warning', 'ok');

      // Alice on a new device: the message is unreadable until she enters her
      // recovery key.
      final second = await flow.loginUser(
        'alice2',
        flow.aliceName,
        'enc-$run-alice2',
        await flow.storeKey('enc-alice2-$run'),
      );
      await second.waitForRooms(
        (rooms) => rooms.any((room) => room.id == roomId),
      );
      final secondGateway = SessionChatGateway(second.session);
      await waitForEncryption(
        tester,
        second.session,
        RecoveryStatus.incomplete,
      );
      await show(
        Builder(
          builder: (context) => ChatRoomPage(
            gateway: secondGateway,
            labels: ChatLabels.german,
            roomId: roomId,
            title: flow.bobName,
            isGroup: false,
            onEnterRecoveryKey: () => Navigator.of(context).push(
              MaterialPageRoute<bool>(
                builder: (_) =>
                    ChatRecoverPage(gateway: secondGateway, labels: labels),
              ),
            ),
          ),
        ),
      );
      await waitFor(
        tester,
        find.text('Zum Lesen ist Dein Wiederherstellungsschlüssel nötig.'),
      );
      flow.metric('ui_undecryptable_reason', 'ok');
      await checkAccessibility(tester, 'room_undecryptable');
      debugPrint('E2E_SCREENSHOT enc-undecryptable');
      await settle(tester, const Duration(seconds: 2));

      await tester.tap(
        find.text('Zum Lesen ist Dein Wiederherstellungsschlüssel nötig.'),
      );
      await waitFor(
        tester,
        find.text('Warum ist diese Nachricht nicht lesbar?'),
      );
      await tester.tap(find.text('Wiederherstellungsschlüssel eingeben'));
      await waitFor(tester, find.text('Nachrichten wiederherstellen'));
      await checkAccessibility(tester, 'recover');

      await tester.enterText(
        find.byType(TextField).last,
        'EsTc aaaa bbbb cccc dddd eeee ffff gggg hhhh iiii jjjj kkkk',
      );
      await tester.pump();
      await tester.tap(find.text('Wiederherstellen'));
      await waitFor(
        tester,
        find.textContaining('Dieser Schlüssel passt nicht'),
      );
      flow.metric('ui_wrong_key', 'ok');

      await tester.enterText(find.byType(TextField).last, recoveryKey);
      await tester.pump();
      await tester.tap(find.text('Wiederherstellen'));
      await waitFor(
        tester,
        find.text(secret),
        absent: find.text('Nachrichten wiederherstellen'),
      );
      flow.metric('ui_history_restored', 'ok');
      debugPrint('E2E_SCREENSHOT enc-restored');
      await settle(tester, const Duration(seconds: 2));

      await tester.pumpWidget(const SizedBox());
      await settle(tester, const Duration(seconds: 1));
      await second.session.dispose();
      await alice.session.dispose();
      await bob.session.dispose();
      expect(accessibilityFailures, isEmpty);
    },
    timeout: const Timeout(Duration(minutes: 6)),
  );
}

Future<void> waitForEncryption(
  WidgetTester tester,
  ChatSession session,
  RecoveryStatus recovery,
) async {
  final end = DateTime.now().add(const Duration(seconds: 60));

  while (session.encryption.value?.recovery != recovery) {
    if (DateTime.now().isAfter(end)) {
      throw StateError('encryption stays ${session.encryption.value}');
    }

    await settle(tester, const Duration(milliseconds: 200));
  }
}
