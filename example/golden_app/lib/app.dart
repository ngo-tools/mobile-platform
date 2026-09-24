import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:ngotools_design_system/ngotools_design_system.dart';
import 'package:ngotools_mobile_core/ngotools_mobile_core.dart';

/// Secret-free reference application for the NGO.Tools Golden Path.
class GoldenApp extends StatelessWidget {
  /// Creates the reference app for [environment].
  const GoldenApp({required this.environment, super.key});

  /// The environment selected at build time.
  final MobileEnvironment environment;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      localizationsDelegates: GlobalMaterialLocalizations.delegates,
      supportedLocales: const [Locale('de'), Locale('en')],
      theme: NgoToolsTheme.community(),
      darkTheme: NgoToolsTheme.community(brightness: Brightness.dark),
      home: GoldenHome(environment: environment),
    );
  }
}

/// Displays the selected environment and synthetic-data boundary.
class GoldenHome extends StatelessWidget {
  /// Creates the Golden Path home screen.
  const GoldenHome({required this.environment, super.key});

  /// The environment selected at build time.
  final MobileEnvironment environment;

  @override
  Widget build(BuildContext context) {
    final languageCode = Localizations.localeOf(context).languageCode;
    final isGerman = languageCode == 'de';

    return Scaffold(
      appBar: AppBar(title: const Text('NGO.Tools')),
      body: Center(
        child: Semantics(
          liveRegion: true,
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  isGerman ? 'Synthetische Golden App' : 'Synthetic Golden App',
                  style: Theme.of(context).textTheme.headlineSmall,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 12),
                Text(
                  isGerman
                      ? 'Umgebung: ${environment.name}'
                      : 'Environment: ${environment.name}',
                ),
                const SizedBox(height: 8),
                Text(
                  isGerman
                      ? 'Diese Referenz enthält keine Produktionsdaten oder Zugangsdaten.'
                      : 'This reference contains no production data or credentials.',
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
