import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:golden_app/app.dart';
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
}
