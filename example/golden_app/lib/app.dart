import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:ngotools_api/ngotools_api.dart';
import 'package:ngotools_auth/ngotools_auth.dart';
import 'package:ngotools_contacts/ngotools_contacts.dart';
import 'package:ngotools_design_system/ngotools_design_system.dart';
import 'package:ngotools_events/ngotools_events.dart';
import 'package:ngotools_mobile_core/ngotools_mobile_core.dart';
import 'package:ngotools_navigation/ngotools_navigation.dart';

import 'generated/mobile_app_config.dart';

/// Secret-free reference application for the NGO.Tools Golden Path.
class GoldenApp extends StatelessWidget {
  /// Creates the reference app for [environment].
  const GoldenApp({
    required this.environment,
    this.configuration,
    this.authStatus = MobileAuthStatus.signedOut,
    this.capabilities,
    this.contactsRepository,
    this.contactDraftManager,
    this.eventsRepository,
    this.onSignIn,
    this.onSignOut,
    super.key,
  });

  /// The environment selected at build time.
  final MobileEnvironment environment;

  /// Public tenant-bound registration for this app.
  final MobileAppConfiguration? configuration;

  /// Current token-free authentication status.
  final MobileAuthStatus authStatus;

  /// Optional capability override used by deterministic tests.
  final MobileRuntimeCapabilities? capabilities;

  /// Optional contact source supplied by the application composition root.
  final ContactsRepository? contactsRepository;

  /// Optional encrypted draft coordinator supplied by the composition root.
  final ContactDraftManager? contactDraftManager;

  /// Optional event source supplied by the application composition root.
  final EventsRepository? eventsRepository;

  /// Starts the external-browser sign-in, if the runtime supports it.
  final Future<void> Function()? onSignIn;

  /// Signs out and removes local private data.
  final Future<void> Function()? onSignOut;

  @override
  Widget build(BuildContext context) => MaterialApp(
    debugShowCheckedModeBanner: false,
    localizationsDelegates: GlobalMaterialLocalizations.delegates,
    supportedLocales: const [Locale('de'), Locale('en')],
    theme: NgoToolsTheme.community(),
    darkTheme: NgoToolsTheme.community(brightness: Brightness.dark),
    home: GoldenShell(
      environment: environment,
      configuration: configuration ?? mobileAppConfiguration,
      authStatus: authStatus,
      capabilities: capabilities,
      contactsRepository: contactsRepository,
      contactDraftManager: contactDraftManager,
      eventsRepository: eventsRepository,
      onSignIn: onSignIn,
      onSignOut: onSignOut,
    ),
  );
}

/// Demonstrates adaptive, server-capability-aware navigation.
class GoldenShell extends StatelessWidget {
  /// Creates the Golden Path shell.
  const GoldenShell({
    required this.environment,
    required this.configuration,
    required this.authStatus,
    this.capabilities,
    this.contactsRepository,
    this.contactDraftManager,
    this.eventsRepository,
    this.onSignIn,
    this.onSignOut,
    super.key,
  });

  final MobileEnvironment environment;
  final MobileAppConfiguration configuration;
  final MobileAuthStatus authStatus;
  final MobileRuntimeCapabilities? capabilities;
  final ContactsRepository? contactsRepository;
  final ContactDraftManager? contactDraftManager;
  final EventsRepository? eventsRepository;
  final Future<void> Function()? onSignIn;
  final Future<void> Function()? onSignOut;

  @override
  Widget build(BuildContext context) {
    final isGerman = Localizations.localeOf(context).languageCode == 'de';
    final environmentConfiguration = configuration.forEnvironment(environment);
    final diagnostics = MobileDiagnosticsSnapshot.fromRuntime(
      appId: configuration.appId,
      environment: environmentConfiguration,
      authStatus: authStatus,
      capabilities: capabilities,
    );
    final items = [
      MobileNavigationItem(
        id: 'home',
        label: isGerman ? 'Start' : 'Home',
        icon: Icons.home_outlined,
        selectedIcon: Icons.home,
        builder: (_) => GoldenHome(
          environment: environment,
          isLivePreview: configuration.appId.startsWith('prv_'),
          authStatus: authStatus,
          onSignIn: onSignIn,
          onSignOut: onSignOut,
        ),
        requirement: MobileRouteRequirement(requiresAuthentication: false),
      ),
      MobileNavigationItem(
        id: 'contacts',
        label: isGerman ? 'Kontakte' : 'Contacts',
        icon: Icons.people_outline,
        selectedIcon: Icons.people,
        builder: (_) => contactsRepository == null
            ? NgoToolsEmptyState(
                title: isGerman
                    ? 'Kontakte nicht verbunden'
                    : 'Contacts not connected',
                message: isGerman
                    ? 'Die App benötigt eine authentifizierte API-Verbindung.'
                    : 'The app requires an authenticated API connection.',
              )
            : ContactsView(
                repository: contactsRepository!,
                labels: isGerman ? ContactLabels.german : ContactLabels.english,
                draftManager: contactDraftManager,
              ),
        requirement: MobileRouteRequirement(
          features: const ['contacts'],
          permissions: const ['contacts:read', 'contacts:write'],
        ),
      ),
      MobileNavigationItem(
        id: 'events',
        label: isGerman ? 'Termine' : 'Events',
        icon: Icons.event_outlined,
        selectedIcon: Icons.event,
        builder: (_) => eventsRepository == null
            ? _notConnected(isGerman)
            : EventsView(
                repository: eventsRepository!,
                labels: isGerman ? EventLabels.german : EventLabels.english,
              ),
        requirement: MobileRouteRequirement(features: const ['events']),
      ),
      MobileNavigationItem(
        id: 'duties',
        label: isGerman ? 'Dienste' : 'Duties',
        icon: Icons.volunteer_activism_outlined,
        selectedIcon: Icons.volunteer_activism,
        builder: (_) => eventsRepository == null
            ? _notConnected(isGerman)
            : DutiesView(
                repository: eventsRepository!,
                labels: isGerman ? EventLabels.german : EventLabels.english,
              ),
        requirement: MobileRouteRequirement(features: const ['events']),
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
      authStatus: authStatus,
      capabilities: capabilities,
    );
  }
}

Widget _notConnected(bool isGerman) => NgoToolsEmptyState(
  title: isGerman ? 'Termine nicht verbunden' : 'Events not connected',
  message: isGerman
      ? 'Die App benötigt eine authentifizierte API-Verbindung.'
      : 'The app requires an authenticated API connection.',
);

/// Displays the selected environment and synthetic-data boundary.
class GoldenHome extends StatelessWidget {
  /// Creates the Golden Path home screen.
  const GoldenHome({
    required this.environment,
    this.isLivePreview = false,
    this.authStatus = MobileAuthStatus.signedOut,
    this.onSignIn,
    this.onSignOut,
    super.key,
  });

  /// The environment selected at build time.
  final MobileEnvironment environment;

  /// Whether the app runs as a temporary live preview.
  final bool isLivePreview;

  /// Current token-free authentication status.
  final MobileAuthStatus authStatus;

  /// Starts the sign-in, if available.
  final Future<void> Function()? onSignIn;

  /// Signs out, if available.
  final Future<void> Function()? onSignOut;

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
        if (onSignIn != null) ...[
          const SizedBox(height: NgoToolsLayout.spacing),
          NgoToolsSectionCard(
            title: isGerman ? 'Anmeldung' : 'Sign-in',
            leading: const Icon(Icons.login),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                if (isLivePreview) ...[
                  NgoToolsStatusBanner(
                    status: NgoToolsStatus.warning,
                    message: isGerman
                        ? 'Live-Vorschau mit echten Daten: nur lesend, endet nach 8 Stunden.'
                        : 'Live preview with real data: read-only, ends after 8 hours.',
                  ),
                  const SizedBox(height: NgoToolsLayout.compactSpacing),
                ],
                if (authStatus == MobileAuthStatus.failed ||
                    authStatus == MobileAuthStatus.expired) ...[
                  NgoToolsStatusBanner(
                    status: NgoToolsStatus.error,
                    message: isGerman
                        ? 'Die Anmeldung ist fehlgeschlagen oder abgelaufen.'
                        : 'Sign-in failed or expired.',
                  ),
                  const SizedBox(height: NgoToolsLayout.compactSpacing),
                ],
                if (authStatus == MobileAuthStatus.authenticated)
                  OutlinedButton(
                    onPressed: onSignOut == null
                        ? null
                        : () => unawaited(onSignOut!()),
                    child: Text(isGerman ? 'Abmelden' : 'Sign out'),
                  )
                else
                  FilledButton(
                    onPressed:
                        authStatus == MobileAuthStatus.authorizing ||
                            authStatus == MobileAuthStatus.restoring
                        ? null
                        : () => unawaited(onSignIn!()),
                    child: Text(
                      isGerman
                          ? 'Mit NGO.Tools anmelden'
                          : 'Sign in with NGO.Tools',
                    ),
                  ),
              ],
            ),
          ),
        ],
      ],
    );
  }
}
