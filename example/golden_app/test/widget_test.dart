import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:golden_app/app.dart';
import 'package:ngotools_api/ngotools_api.dart';
import 'package:ngotools_auth/ngotools_auth.dart';
import 'package:ngotools_mobile_core/ngotools_mobile_core.dart';
import 'package:ngotools_testing/ngotools_testing.dart';

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
        authStatus: MobileAuthStatus.authenticated,
        capabilities: capabilities,
      ),
    );

    expect(find.text('Contacts'), findsNothing);
    expect(find.text('Diagnostics'), findsOneWidget);
  });

  testWidgets('fails closed when contacts write access is missing', (
    tester,
  ) async {
    final capabilities = MobileRuntimeCapabilities(
      schemaVersion: 1,
      features: const ['contacts', 'profile'],
      permissions: const ['contacts:read', 'profile:read'],
      importsEnabled: false,
      importTypes: const {},
    );

    await tester.pumpWidget(
      GoldenApp(
        environment: MobileEnvironment.development,
        authStatus: MobileAuthStatus.authenticated,
        capabilities: capabilities,
        contactsRepository: const SyntheticContactsRepository(),
      ),
    );

    expect(find.text('Contacts'), findsNothing);
    expect(find.text('Diagnostics'), findsOneWidget);
  });

  testWidgets('shows sanitized diagnostics', (tester) async {
    await tester.pumpWidget(
      GoldenApp(
        environment: MobileEnvironment.staging,
        authStatus: MobileAuthStatus.authenticated,
        capabilities: SyntheticMobileFixture.capabilities,
      ),
    );
    await tester.tap(find.text('Diagnostics'));
    await tester.pump();

    expect(find.text('staging.example.invalid'), findsOneWidget);
    expect(find.text('Synthetic User'), findsNothing);
    expect(find.textContaining('Bearer'), findsNothing);
  });

  testWidgets('previews contacts with synthetic data only', (tester) async {
    await tester.pumpWidget(
      GoldenApp(
        environment: MobileEnvironment.development,
        authStatus: MobileAuthStatus.authenticated,
        capabilities: SyntheticMobileFixture.capabilities,
        contactsRepository: const SyntheticContactsRepository(),
      ),
    );
    await tester.tap(find.text('Contacts'));
    await tester.pumpAndSettle();

    expect(find.text('Erika Beispiel'), findsOneWidget);
    expect(find.textContaining('erika@example.invalid'), findsOneWidget);
    expect(find.textContaining('@ngo.tools'), findsNothing);
  });

  testWidgets('previews events and duties with synthetic data only', (
    tester,
  ) async {
    final capabilities = MobileRuntimeCapabilities(
      schemaVersion: 1,
      features: const ['events', 'profile'],
      permissions: const ['profile:read'],
      importsEnabled: false,
      importTypes: const {},
    );

    await tester.pumpWidget(
      GoldenApp(
        environment: MobileEnvironment.development,
        authStatus: MobileAuthStatus.authenticated,
        capabilities: capabilities,
        eventsRepository: SyntheticEventsRepository(today: DateTime.now()),
      ),
    );
    await tester.tap(find.text('Events'));
    await tester.pumpAndSettle();

    expect(find.text('Mitarbeiterschulung Technik'), findsOneWidget);
    expect(find.text('You: Technik'), findsOneWidget);
    expect(find.text('Contacts'), findsNothing);

    await tester.tap(find.text('Duties'));
    await tester.pumpAndSettle();

    expect(find.text('PLEASE GIVE YOUR AVAILABILITY · 2'), findsOneWidget);
    expect(find.textContaining('@ngo.tools'), findsNothing);
  });

  testWidgets('offers sign-in and marks a live preview', (tester) async {
    var signIns = 0;
    final preview = MobileAppConfiguration(
      appId: 'prv_01J00000000000000000000000',
      tenant: 'synthetic-demo',
      defaultLocale: 'de',
      locales: const ['de', 'en'],
      environments: {
        MobileEnvironment.development: MobileEnvironmentConfiguration(
          environment: MobileEnvironment.development,
          id: 'env_01J00000000000000000000009',
          apiBaseUrl: Uri.https('synthetic-demo.example.invalid', '/api/v3'),
          configRevision: 'cfg_01J00000000000000000000009',
          attestationMode: MobileAttestationMode.disabled,
          oidc: MobileOidcConfiguration(
            issuer: Uri.https('identity.example.invalid', '/realms/synthetic'),
            clientId: 'mobile-preview-01j00000000000000000000000',
            redirectUri: Uri.parse(
              'ngotools-01j00000000000000000000000://oauth/callback',
            ),
            scopes: const ['openid', 'profile', 'email'],
          ),
        ),
      },
    );

    await tester.pumpWidget(
      GoldenApp(
        environment: MobileEnvironment.development,
        configuration: preview,
        onSignIn: () async => signIns += 1,
      ),
    );
    await tester.pumpAndSettle();

    expect(
      find.text('Live preview with real data: read-only, ends after 8 hours.'),
      findsOneWidget,
    );

    await tester.tap(find.text('Sign in with NGO.Tools'));
    await tester.pump();

    expect(signIns, 1);
  });

  testWidgets('shows the chat only with the booked chat feature', (
    tester,
  ) async {
    Future<void> pump(List<String> features) => tester.pumpWidget(
      GoldenApp(
        environment: MobileEnvironment.development,
        authStatus: MobileAuthStatus.authenticated,
        capabilities: MobileRuntimeCapabilities(
          schemaVersion: 1,
          features: features,
          permissions: const ['profile:read'],
          importsEnabled: false,
          importTypes: const {},
        ),
        chatBuilder: (context, {required isGerman}) =>
            const Text('synthetic chat'),
      ),
    );

    await pump(const ['profile']);
    expect(find.text('Chat'), findsNothing);

    await pump(const ['profile', 'chat']);
    await tester.tap(find.text('Chat'));
    await tester.pumpAndSettle();
    expect(find.text('synthetic chat'), findsOneWidget);
  });
}
