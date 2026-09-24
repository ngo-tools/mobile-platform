import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ngotools_api/ngotools_api.dart';
import 'package:ngotools_auth/ngotools_auth.dart';
import 'package:ngotools_mobile_core/ngotools_mobile_core.dart';
import 'package:ngotools_navigation/ngotools_navigation.dart';

void main() {
  group('MobileRouteRequirement', () {
    final requirement = MobileRouteRequirement(
      features: const ['contacts'],
      permissions: const ['contacts:read'],
      importTypes: const ['contacts'],
    );

    test('requires authentication before checking capabilities', () {
      expect(
        requirement.evaluate(
          authStatus: MobileAuthStatus.signedOut,
          capabilities: null,
        ),
        MobileRouteAccess.signInRequired,
      );
    });

    test('keeps unloaded capabilities distinct from denied access', () {
      expect(
        requirement.evaluate(
          authStatus: MobileAuthStatus.authenticated,
          capabilities: null,
        ),
        MobileRouteAccess.capabilitiesLoading,
      );
    });

    test('distinguishes features, permissions, and import availability', () {
      expect(
        requirement.evaluate(
          authStatus: MobileAuthStatus.authenticated,
          capabilities: _capabilities(features: const []),
        ),
        MobileRouteAccess.featureMissing,
      );
      expect(
        requirement.evaluate(
          authStatus: MobileAuthStatus.authenticated,
          capabilities: _capabilities(permissions: const []),
        ),
        MobileRouteAccess.permissionMissing,
      );
      expect(
        requirement.evaluate(
          authStatus: MobileAuthStatus.authenticated,
          capabilities: _capabilities(importAvailable: false),
        ),
        MobileRouteAccess.importUnavailable,
      );
    });

    test('allows a route only when every server requirement is met', () {
      expect(
        requirement.evaluate(
          authStatus: MobileAuthStatus.authenticated,
          capabilities: _capabilities(),
        ),
        MobileRouteAccess.allowed,
      );
    });
  });

  test('uses the same policy for visible items and direct access', () {
    final contacts = _item(
      id: 'contacts',
      requirement: MobileRouteRequirement(features: const ['contacts']),
    );
    final diagnostics = _item(id: 'diagnostics');
    final capabilities = _capabilities(features: const []);

    final visible = MobileNavigationResolver.visibleItems(
      items: [contacts, diagnostics],
      authStatus: MobileAuthStatus.authenticated,
      capabilities: capabilities,
    );

    expect(visible.map((item) => item.id), ['diagnostics']);
    expect(
      MobileNavigationResolver.accessFor(
        item: contacts,
        authStatus: MobileAuthStatus.authenticated,
        capabilities: capabilities,
      ),
      MobileRouteAccess.featureMissing,
    );
  });

  testWidgets('uses bottom navigation on compact layouts', (tester) async {
    await tester.binding.setSurfaceSize(const Size(600, 800));
    addTearDown(() => tester.binding.setSurfaceSize(null));

    await tester.pumpWidget(_shell(capabilities: _capabilities()));

    expect(find.byType(NavigationBar), findsOneWidget);
    expect(find.byType(NavigationRail), findsNothing);
  });

  testWidgets('uses a navigation rail on large layouts', (tester) async {
    await tester.binding.setSurfaceSize(const Size(1000, 800));
    addTearDown(() => tester.binding.setSurfaceSize(null));

    await tester.pumpWidget(_shell(capabilities: _capabilities()));

    expect(find.byType(NavigationRail), findsOneWidget);
    expect(find.byType(NavigationBar), findsNothing);
  });

  testWidgets('falls back when refreshed capabilities remove a destination', (
    tester,
  ) async {
    const shellKey = ValueKey('shell');
    await tester.binding.setSurfaceSize(const Size(600, 800));
    addTearDown(() => tester.binding.setSurfaceSize(null));

    await tester.pumpWidget(
      _shell(key: shellKey, capabilities: _capabilities()),
    );
    await tester.tap(find.text('Contacts'));
    await tester.pump();
    expect(find.text('contacts-content'), findsOneWidget);

    await tester.pumpWidget(
      _shell(
        key: shellKey,
        capabilities: _capabilities(features: const []),
      ),
    );
    await tester.pump();

    expect(find.text('home-content'), findsOneWidget);
    expect(find.text('Contacts'), findsNothing);
  });

  test('diagnostics include only the approved support fields', () {
    final environment = MobileEnvironmentConfiguration(
      environment: MobileEnvironment.staging,
      id: 'env_synthetic',
      apiBaseUrl: Uri.parse(
        'https://staging.example.invalid/api/v2/internal-path',
      ),
      configRevision: 'cfg_synthetic',
      attestationMode: MobileAttestationMode.test,
      oidc: MobileOidcConfiguration(
        issuer: Uri.parse('https://identity.example.invalid/realms/synthetic'),
        clientId: 'mobile-synthetic',
        redirectUri: Uri.parse('ngotools-synthetic://oauth/callback'),
        scopes: const ['openid'],
      ),
    );

    final snapshot = MobileDiagnosticsSnapshot.fromRuntime(
      appId: 'mob_synthetic',
      environment: environment,
      authStatus: MobileAuthStatus.authenticated,
      capabilities: _capabilities(),
    );
    final supportText = snapshot.toSupportText();

    expect(snapshot.features, ['contacts']);
    expect(supportText, contains('api_host=staging.example.invalid'));
    expect(supportText, isNot(contains('/api/v2')));
    expect(supportText, isNot(contains('Authorization')));
    expect(supportText, isNot(contains('email')));
    expect(supportText, contains('permission_count=1'));
  });
}

Widget _shell({Key? key, required MobileRuntimeCapabilities capabilities}) =>
    MaterialApp(
      home: MobileAdaptiveScaffold(
        key: key,
        breakpoint: 840,
        authStatus: MobileAuthStatus.authenticated,
        capabilities: capabilities,
        items: [
          _item(id: 'home'),
          _item(
            id: 'contacts',
            requirement: MobileRouteRequirement(features: const ['contacts']),
          ),
        ],
      ),
    );

MobileNavigationItem _item({
  required String id,
  MobileRouteRequirement? requirement,
}) => MobileNavigationItem(
  id: id,
  label: id == 'home' ? 'Home' : 'Contacts',
  icon: id == 'home' ? Icons.home_outlined : Icons.people_outline,
  builder: (_) => Center(child: Text('$id-content')),
  requirement: requirement,
);

MobileRuntimeCapabilities _capabilities({
  Iterable<String> features = const ['contacts'],
  Iterable<String> permissions = const ['contacts:read'],
  bool importAvailable = true,
}) => MobileRuntimeCapabilities(
  schemaVersion: 1,
  features: features,
  permissions: permissions,
  importsEnabled: true,
  importTypes: {
    'contacts': MobileImportCapability(
      key: 'contacts',
      supported: true,
      requiredFeature: 'contacts',
      featureEnabled: true,
      permissionGranted: true,
      available: importAvailable,
      requires: const ['contacts'],
      batchImportSupported: true,
      blockers: const [],
    ),
  },
);
