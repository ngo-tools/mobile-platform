/// Accessible design foundations for NGO.Tools mobile apps.
library;

import 'package:flutter/material.dart';

/// Builds approved NGO.Tools application themes.
abstract final class NgoToolsTheme {
  /// Creates the Community template theme.
  static ThemeData community({Brightness brightness = Brightness.light}) {
    final colorScheme = ColorScheme.fromSeed(
      seedColor: const Color(0xFF146C5B),
      brightness: brightness,
    );

    return ThemeData(
      colorScheme: colorScheme,
      useMaterial3: true,
      visualDensity: VisualDensity.standard,
    );
  }
}
