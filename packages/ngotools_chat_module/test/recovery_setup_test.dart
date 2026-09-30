import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ngotools_chat/ngotools_chat.dart';
import 'package:ngotools_chat_module/ngotools_chat_module.dart';
import 'package:ngotools_design_system/ngotools_design_system.dart';

import 'fakes.dart';

void main() {
  late FakeChatGateway gateway;
  final labels = ChatEncryptionLabels.german;

  Future<List<bool?>> pumpSetup(
    WidgetTester tester, {
    bool replaceKey = false,
  }) async {
    final results = <bool?>[];
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
                  await Navigator.of(context).push<bool>(
                    MaterialPageRoute(
                      builder: (_) => ChatRecoverySetupPage(
                        gateway: gateway,
                        labels: labels,
                        replaceKey: replaceKey,
                      ),
                    ),
                  ),
                ),
                child: const Text('start'),
              ),
            ),
          ),
        ),
      ),
    );
    await tester.tap(find.text('start'));
    await tester.pumpAndSettle();

    return results;
  }

  setUp(() {
    gateway = FakeChatGateway()
      ..encryption.value = const EncryptionStatus(
        recovery: RecoveryStatus.disabled,
        deviceVerified: true,
      );
  });

  testWidgets('shows the key, copies it and checks it was saved', (
    tester,
  ) async {
    String? clipboard;
    tester.binding.defaultBinaryMessenger.setMockMethodCallHandler(
      SystemChannels.platform,
      (call) async {
        if (call.method == 'Clipboard.setData') {
          clipboard = (call.arguments as Map)['text'] as String;
        }

        return null;
      },
    );
    final results = await pumpSetup(tester);

    expect(find.textContaining('Ende-zu-Ende-verschlüsselt'), findsOneWidget);

    await tester.tap(find.text('Einrichten'));
    await tester.pumpAndSettle();

    expect(gateway.calls, ['enableRecovery']);
    expect(find.text(gateway.recoveryKey), findsOneWidget);
    expect(find.byType(BackButton), findsNothing);

    await tester.tap(find.text('Schlüssel kopieren'));
    await tester.pumpAndSettle();

    expect(clipboard, gateway.recoveryKey);
    expect(find.text('Kopiert'), findsOneWidget);

    await tester.tap(find.text('Weiter'));
    await tester.pumpAndSettle();
    await tester.enterText(find.byType(TextField), 'abcd');
    await tester.tap(find.text('Fertig'));
    await tester.pumpAndSettle();

    expect(find.textContaining('Die Zeichen passen nicht'), findsOneWidget);
    expect(results, isEmpty);

    await tester.enterText(find.byType(TextField), ' xy z9 ');
    await tester.tap(find.text('Fertig'));
    await tester.pumpAndSettle();

    expect(results, [true]);
  });

  testWidgets('keeps the key screen until it is confirmed', (tester) async {
    final results = await pumpSetup(tester);
    await tester.tap(find.text('Einrichten'));
    await tester.pumpAndSettle();

    await tester.binding.handlePopRoute();
    await tester.pumpAndSettle();

    expect(find.text(gateway.recoveryKey), findsOneWidget);
    expect(results, isEmpty);
  });

  testWidgets('can be skipped', (tester) async {
    final results = await pumpSetup(tester);

    await tester.tap(find.text('Später'));
    await tester.pumpAndSettle();

    expect(results, [false]);
    expect(gateway.calls, isEmpty);
  });

  testWidgets('offers a retry when the setup fails', (tester) async {
    gateway.failRecovery = true;
    await pumpSetup(tester);

    await tester.tap(find.text('Einrichten'));
    await tester.pumpAndSettle();

    expect(find.textContaining('konnte nicht eingerichtet'), findsOneWidget);

    gateway.failRecovery = false;
    await tester.tap(find.text('Erneut versuchen'));
    await tester.pumpAndSettle();

    expect(find.text(gateway.recoveryKey), findsOneWidget);
  });

  testWidgets('shows the reminder only while recovery is not set up', (
    tester,
  ) async {
    var setUps = 0;
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: ChatRecoveryBanner(
            gateway: gateway,
            labels: labels,
            onSetUp: () => setUps++,
          ),
        ),
      ),
    );

    await tester.tap(find.text('Einrichten'));
    expect(setUps, 1);

    gateway.encryption.value = const EncryptionStatus(
      recovery: RecoveryStatus.enabled,
      deviceVerified: true,
    );
    await tester.pump();

    expect(find.text('Einrichten'), findsNothing);
  });

  testWidgets('creates a new key after confirmation', (tester) async {
    gateway.encryption.value = const EncryptionStatus(
      recovery: RecoveryStatus.enabled,
      deviceVerified: true,
    );
    await tester.pumpWidget(
      MaterialApp(
        theme: NgoToolsTheme.community(),
        home: ChatSecurityPage(gateway: gateway, labels: labels),
      ),
    );

    expect(find.text('Wiederherstellung eingerichtet'), findsOneWidget);
    expect(find.text('Dieses Gerät ist bestätigt.'), findsOneWidget);

    await tester.tap(find.text('Neuen Schlüssel erzeugen'));
    await tester.pumpAndSettle();

    expect(
      find.textContaining('funktioniert danach nicht mehr'),
      findsOneWidget,
    );

    await tester.tap(
      find.widgetWithText(FilledButton, 'Neuen Schlüssel erzeugen'),
    );
    await tester.pumpAndSettle();

    expect(gateway.calls, ['enableRecovery']);
    expect(find.text(gateway.recoveryKey), findsOneWidget);
  });

  testWidgets('names the state of this device', (tester) async {
    gateway.encryption.value = const EncryptionStatus(
      recovery: RecoveryStatus.incomplete,
      deviceVerified: false,
    );
    await tester.pumpWidget(
      MaterialApp(
        home: ChatSecurityPage(gateway: gateway, labels: labels),
      ),
    );

    expect(
      find.text('Auf diesem Gerät fehlt der Wiederherstellungsschlüssel'),
      findsOneWidget,
    );
    expect(find.text('Dieses Gerät ist noch nicht bestätigt.'), findsOneWidget);
    expect(find.text('Neuen Schlüssel erzeugen'), findsNothing);
  });

  test('compares the key ending without spaces and case', () {
    expect(chatRecoveryKeyEnding('EsTc 1a2b XyZ9'), 'xyz9');
    expect(chatRecoveryKeyEnding(' xy Z9 '), 'xyz9');
  });
}
