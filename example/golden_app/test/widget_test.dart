import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:golden_app/app.dart';
import 'package:ngotools_api/ngotools_api.dart';
import 'package:ngotools_mobile_core/ngotools_mobile_core.dart';

void main() {
  testWidgets('shows the selected synthetic environment', (tester) async {
    await tester.pumpWidget(
      const GoldenApp(environment: MobileEnvironment.staging),
    );

    expect(find.text('Synthetic Golden App'), findsOneWidget);
    expect(find.text('Environment: staging'), findsOneWidget);
    expect(find.byType(Semantics), findsWidgets);
  });

  testWidgets('declares German and English locales', (tester) async {
    await tester.pumpWidget(
      const GoldenApp(environment: MobileEnvironment.development),
    );

    final app = tester.widget<MaterialApp>(find.byType(MaterialApp));

    expect(app.supportedLocales, const [Locale('de'), Locale('en')]);
  });

  testWidgets('shows only server-authorized destinations', (tester) async {
    final capabilities = MobileRuntimeCapabilities(
      schemaVersion: 1,
      features: const ['profile'],
      permissions: const ['profile:read'],
      importsEnabled: false,
      importTypes: const {},
    );

    await tester.pumpWidget(
      GoldenApp(
        environment: MobileEnvironment.development,
        capabilities: capabilities,
      ),
    );

    expect(find.text('Contacts'), findsNothing);
    expect(find.text('Diagnostics'), findsOneWidget);
  });

  testWidgets('shows sanitized diagnostics', (tester) async {
    await tester.pumpWidget(
      const GoldenApp(environment: MobileEnvironment.staging),
    );
    await tester.tap(find.text('Diagnostics'));
    await tester.pump();

    expect(find.text('staging.example.invalid'), findsOneWidget);
    expect(find.text('Synthetic User'), findsNothing);
    expect(find.textContaining('Bearer'), findsNothing);
  });
}
