import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:ngotools_api/ngotools_api.dart';
import 'package:ngotools_auth/ngotools_auth.dart';
import 'package:ngotools_design_system/ngotools_design_system.dart';
import 'package:ngotools_mobile_core/ngotools_mobile_core.dart';
import 'package:ngotools_navigation/ngotools_navigation.dart';
import 'package:ngotools_testing/ngotools_testing.dart';

/// Secret-free reference application for the NGO.Tools Golden Path.
class GoldenApp extends StatelessWidget {
  /// Creates the reference app for [environment].
  const GoldenApp({required this.environment, this.capabilities, super.key});

  /// The environment selected at build time.
  final MobileEnvironment environment;

  /// Optional capability override used by deterministic tests.
  final MobileRuntimeCapabilities? capabilities;

  @override
  Widget build(BuildContext context) => MaterialApp(
    debugShowCheckedModeBanner: false,
    localizationsDelegates: GlobalMaterialLocalizations.delegates,
    supportedLocales: const [Locale('de'), Locale('en')],
    theme: NgoToolsTheme.community(),
    darkTheme: NgoToolsTheme.community(brightness: Brightness.dark),
    home: GoldenShell(
      environment: environment,
      capabilities: capabilities ?? SyntheticMobileFixture.capabilities,
    ),
  );
}

/// Demonstrates adaptive, server-capability-aware navigation.
class GoldenShell extends StatelessWidget {
  /// Creates the Golden Path shell.
  const GoldenShell({
    required this.environment,
    required this.capabilities,
    super.key,
  });

  final MobileEnvironment environment;
  final MobileRuntimeCapabilities capabilities;

  @override
  Widget build(BuildContext context) {
    final isGerman = Localizations.localeOf(context).languageCode == 'de';
    final environmentConfiguration = SyntheticMobileFixture.configuration
        .forEnvironment(environment);
    final diagnostics = MobileDiagnosticsSnapshot.fromRuntime(
      appId: SyntheticMobileFixture.configuration.appId,
      environment: environmentConfiguration,
      authStatus: MobileAuthStatus.authenticated,
      capabilities: capabilities,
    );
    final items = [
      MobileNavigationItem(
        id: 'home',
        label: isGerman ? 'Start' : 'Home',
        icon: Icons.home_outlined,
        selectedIcon: Icons.home,
        builder: (_) => GoldenHome(environment: environment),
        requirement: MobileRouteRequirement(requiresAuthentication: false),
      ),
      MobileNavigationItem(
        id: 'contacts',
        label: isGerman ? 'Kontakte' : 'Contacts',
        icon: Icons.people_outline,
        selectedIcon: Icons.people,
        builder: (_) => NgoToolsEmptyState(
          title: isGerman ? 'Noch keine Kontakte' : 'No contacts yet',
          message: isGerman
              ? 'Diese synthetische Ansicht enthält keine Personendaten.'
              : 'This synthetic view contains no personal data.',
        ),
        requirement: MobileRouteRequirement(
          features: const ['contacts'],
          permissions: const ['contacts:read'],
        ),
      ),
      MobileNavigationItem(
        id: 'diagnostics',
        label: isGerman ? 'Diagnose' : 'Diagnostics',
        icon: Icons.health_and_safety_outlined,
        selectedIcon: Icons.health_and_safety,
        builder: (_) => MobileDiagnosticsView(
          snapshot: diagnostics,
          labels: isGerman
              ? MobileDiagnosticsLabels.german
              : MobileDiagnosticsLabels.english,
        ),
      ),
    ];

    return MobileAdaptiveScaffold(
      title: const Text('NGO.Tools'),
      breakpoint: NgoToolsLayout.navigationRailBreakpoint,
      items: items,
      authStatus: MobileAuthStatus.authenticated,
      capabilities: capabilities,
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
    final isGerman = Localizations.localeOf(context).languageCode == 'de';

    return ListView(
      padding: const EdgeInsets.all(NgoToolsLayout.sectionSpacing),
      children: [
        NgoToolsSectionCard(
          title: isGerman ? 'Synthetische Golden App' : 'Synthetic Golden App',
          leading: const Icon(Icons.shield_outlined),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                isGerman
                    ? 'Umgebung: ${environment.name}'
                    : 'Environment: ${environment.name}',
              ),
              const SizedBox(height: NgoToolsLayout.compactSpacing),
              NgoToolsStatusBanner(
                status: NgoToolsStatus.success,
                message: isGerman
                    ? 'Diese Referenz enthält keine Produktionsdaten oder Zugangsdaten.'
                    : 'This reference contains no production data or credentials.',
              ),
            ],
          ),
        ),
      ],
    );
  }
}
