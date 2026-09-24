import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ngotools_design_system/ngotools_design_system.dart';

void main() {
  test('creates light and dark Community themes', () {
    expect(NgoToolsTheme.community().brightness, Brightness.light);
    expect(
      NgoToolsTheme.community(brightness: Brightness.dark).brightness,
      Brightness.dark,
    );
  });

  testWidgets('components remain readable with enlarged text', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        theme: NgoToolsTheme.community(),
        home: const MediaQuery(
          data: MediaQueryData(textScaler: TextScaler.linear(2)),
          child: Scaffold(
            body: SingleChildScrollView(
              child: Column(
                children: [
                  NgoToolsSectionCard(title: 'Section', child: Text('Content')),
                  NgoToolsStatusBanner(message: 'Safe status'),
                  NgoToolsEmptyState(title: 'Empty', message: 'No records'),
                ],
              ),
            ),
          ),
        ),
      ),
    );

    expect(find.text('Section'), findsOneWidget);
    expect(find.text('Safe status'), findsOneWidget);
    expect(find.text('Empty'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });
}
