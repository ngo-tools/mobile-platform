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
}
