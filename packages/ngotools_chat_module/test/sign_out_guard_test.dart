import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ngotools_chat/ngotools_chat.dart';
import 'package:ngotools_chat_module/ngotools_chat_module.dart';
import 'package:ngotools_design_system/ngotools_design_system.dart';

import 'fakes.dart';

void main() {
  late FakeChatGateway gateway;

  Future<List<bool>> pumpSignOut(WidgetTester tester) async {
    final results = <bool>[];
    tester.view.physicalSize = const Size(1080, 2340);
    tester.view.devicePixelRatio = 3;
    addTearDown(tester.view.reset);
    await tester.pumpWidget(
      MaterialApp(
        theme: NgoToolsTheme.community(),
        home: Builder(
          builder: (context) => Scaffold(
            body: Center(
              child: TextButton(
                onPressed: () async => results.add(
                  await confirmChatSignOut(
                    context,
                    gateway: gateway,
                    labels: ChatEncryptionLabels.german,
                  ),
                ),
                child: const Text('Abmelden'),
              ),
            ),
          ),
        ),
      ),
    );
    await tester.tap(find.text('Abmelden'));
    await tester.pumpAndSettle();

    return results;
  }

  void recovery(RecoveryStatus status) => gateway.encryption.value =
      EncryptionStatus(recovery: status, deviceVerified: true);

  setUp(() => gateway = FakeChatGateway());

  testWidgets('signs out right away when recovery is set up', (tester) async {
    final results = await pumpSignOut(tester);

    expect(results, [true]);
    expect(gateway.calls, isEmpty);
  });

  testWidgets('signs out right away when another device keeps the keys', (
    tester,
  ) async {
    recovery(RecoveryStatus.disabled);
    gateway.lastDevice = false;

    final results = await pumpSignOut(tester);

    expect(results, [true]);
    expect(gateway.calls, ['isLastDevice']);
  });

  testWidgets('warns on the last device and can be cancelled', (tester) async {
    recovery(RecoveryStatus.disabled);
    final results = await pumpSignOut(tester);

    expect(
      find.text('Verschlüsselte Nachrichten gehen verloren'),
      findsOneWidget,
    );
    expect(find.textContaining('nicht mehr lesen'), findsOneWidget);

    await tester.tap(find.text('Abbrechen'));
    await tester.pumpAndSettle();

    expect(results, [false]);
  });

  testWidgets('signs out anyway on request', (tester) async {
    recovery(RecoveryStatus.disabled);
    final results = await pumpSignOut(tester);

    await tester.tap(find.text('Trotzdem abmelden'));
    await tester.pumpAndSettle();

    expect(results, [true]);
  });

  testWidgets('sets up recovery first and then signs out', (tester) async {
    recovery(RecoveryStatus.disabled);
    final results = await pumpSignOut(tester);

    await tester.tap(find.widgetWithText(FilledButton, 'Einrichten'));
    await tester.pumpAndSettle();
    await tester.tap(find.widgetWithText(FilledButton, 'Einrichten'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Weiter'));
    await tester.pumpAndSettle();
    await tester.enterText(find.byType(TextField), 'XyZ9');
    await tester.tap(find.text('Fertig'));
    await tester.pumpAndSettle();

    expect(gateway.calls, contains('enableRecovery'));
    expect(results, [true]);
  });

  testWidgets('asks for the key when this last device lacks it', (
    tester,
  ) async {
    recovery(RecoveryStatus.incomplete);
    final results = await pumpSignOut(tester);

    expect(find.textContaining('nicht gesichert'), findsOneWidget);

    await tester.tap(
      find.widgetWithText(FilledButton, 'Wiederherstellungsschlüssel eingeben'),
    );
    await tester.pumpAndSettle();
    await tester.enterText(find.byType(TextField), 'EsTc 1a2b');
    await tester.pump();
    await tester.tap(find.text('Wiederherstellen'));
    await tester.pumpAndSettle();

    expect(gateway.calls, contains('recover:EsTc 1a2b'));
    expect(results, [true]);
  });

  testWidgets('keeps the user signed in when securing is abandoned', (
    tester,
  ) async {
    recovery(RecoveryStatus.disabled);
    final results = await pumpSignOut(tester);

    await tester.tap(find.widgetWithText(FilledButton, 'Einrichten'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Später'));
    await tester.pumpAndSettle();

    expect(results, [false]);
  });

  testWidgets('warns when the devices cannot be checked', (tester) async {
    recovery(RecoveryStatus.disabled);
    gateway.lastDevice = null;

    await pumpSignOut(tester);

    expect(
      find.text('Verschlüsselte Nachrichten gehen verloren'),
      findsOneWidget,
    );
  });
}
