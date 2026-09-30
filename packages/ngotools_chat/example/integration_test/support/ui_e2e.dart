import 'dart:async';

import 'package:flutter_test/flutter_test.dart';

import '../chat_flow_e2e.dart' as flow;

/// Pumps while real time passes (SDK streams run outside the test clock).
Future<void> settle(WidgetTester tester, Duration duration) async {
  final end = DateTime.now().add(duration);

  while (DateTime.now().isBefore(end)) {
    await tester.runAsync(
      () => Future<void>.delayed(const Duration(milliseconds: 100)),
    );
    await tester.pump();
  }
}

/// Pumps until [finder] shows (and [absent] does not).
Future<void> waitFor(
  WidgetTester tester,
  Finder finder, {
  Finder? absent,
  Duration timeout = const Duration(seconds: 60),
}) async {
  final end = DateTime.now().add(timeout);

  while (DateTime.now().isBefore(end)) {
    await settle(tester, const Duration(milliseconds: 200));

    if (finder.evaluate().isNotEmpty &&
        (absent == null || absent.evaluate().isEmpty)) {
      return;
    }
  }

  throw TimeoutException('Not shown: $finder');
}

/// Screens that failed an accessibility guideline; the test fails at the end.
final accessibilityFailures = <String>[];

/// Checks tap targets, labels and text contrast of what is shown.
Future<void> checkAccessibility(WidgetTester tester, String screen) async {
  final semantics = tester.ensureSemantics();
  final guidelines = {
    'tap_targets': androidTapTargetGuideline,
    'labeled_tap_targets': labeledTapTargetGuideline,
    'text_contrast': textContrastGuideline,
  };

  for (final MapEntry(key: name, value: guideline) in guidelines.entries) {
    final result = await guideline.evaluate(tester);

    if (!result.passed) {
      accessibilityFailures.add('$screen/$name');
    }

    flow.metric(
      'a11y_${screen}_$name',
      result.passed ? 'ok' : (result.reason ?? 'failed').replaceAll('\n', ' '),
    );
  }

  semantics.dispose();
}
