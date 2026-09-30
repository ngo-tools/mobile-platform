import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ngotools_chat/ngotools_chat.dart';
import 'package:ngotools_chat_module/ngotools_chat_module.dart';
import 'package:ngotools_design_system/ngotools_design_system.dart';

import 'fakes.dart';

void main() {
  late FakeChatGateway gateway;
  final labels = ChatEncryptionLabels.german;

  Future<List<bool?>> pumpRecover(WidgetTester tester) async {
    final results = <bool?>[];
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
                      builder: (_) =>
                          ChatRecoverPage(gateway: gateway, labels: labels),
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
        recovery: RecoveryStatus.incomplete,
        deviceVerified: false,
      );
  });

  testWidgets('restores with the key and confirms it', (tester) async {
    final results = await pumpRecover(tester);

    expect(
      tester
          .widget<FilledButton>(
            find.widgetWithText(FilledButton, 'Wiederherstellen'),
          )
          .onPressed,
      isNull,
    );

    await tester.enterText(find.byType(TextField), '  EsTc 1a2b\n3c4d  ');
    await tester.pump();
    await tester.tap(find.text('Wiederherstellen'));
    await tester.pumpAndSettle();

    expect(gateway.calls, ['recover:EsTc 1a2b\n3c4d']);
    expect(results, [true]);
    expect(find.textContaining('Wiederhergestellt'), findsOneWidget);
  });

  testWidgets('explains a key that does not match', (tester) async {
    gateway.recoverError = ChatErrorKind.invalidInput;
    final results = await pumpRecover(tester);

    await tester.enterText(find.byType(TextField), 'EsTc falsch');
    await tester.pump();
    await tester.tap(find.text('Wiederherstellen'));
    await tester.pumpAndSettle();

    expect(find.textContaining('Dieser Schlüssel passt nicht'), findsOneWidget);
    expect(results, isEmpty);

    gateway.recoverError = ChatErrorKind.network;
    await tester.tap(find.text('Wiederherstellen'));
    await tester.pumpAndSettle();

    expect(find.textContaining('Das hat nicht geklappt'), findsOneWidget);
  });

  testWidgets('explains how to reset a lost key in the web chat', (
    tester,
  ) async {
    await pumpRecover(tester);

    await tester.tap(find.text('Schlüssel verloren?'));
    await tester.pumpAndSettle();

    expect(
      find.textContaining('Digitale Identität zurücksetzen'),
      findsOneWidget,
    );
    expect(find.textContaining('Web-Chat'), findsOneWidget);
  });

  testWidgets('reminds a device without the key', (tester) async {
    var recovers = 0;
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: ChatRecoveryBanner(
            gateway: gateway,
            labels: labels,
            onSetUp: () {},
            onRecover: () => recovers++,
          ),
        ),
      ),
    );

    expect(
      find.textContaining('fehlt Dein Wiederherstellungsschlüssel'),
      findsOneWidget,
    );

    await tester.tap(find.text('Wiederherstellungsschlüssel eingeben'));

    expect(recovers, 1);
  });

  testWidgets('enters the key from the security page', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        theme: NgoToolsTheme.community(),
        home: ChatSecurityPage(gateway: gateway, labels: labels),
      ),
    );

    await tester.tap(find.text('Wiederherstellungsschlüssel eingeben'));
    await tester.pumpAndSettle();

    expect(find.text('Nachrichten wiederherstellen'), findsOneWidget);
  });
}
