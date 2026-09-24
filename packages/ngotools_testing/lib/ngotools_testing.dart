/// Synthetic fixtures for NGO.Tools mobile app tests.
library;

import 'package:ngotools_api/ngotools_api.dart';
import 'package:ngotools_auth/ngotools_auth.dart';
import 'package:ngotools_mobile_core/ngotools_mobile_core.dart';

export 'src/synthetic_contacts_repository.dart';

/// Provides secret-free data for examples and tests.
abstract final class SyntheticMobileFixture {
  /// A tenant-bound configuration containing only `.invalid` hosts.
  static final configuration = MobileAppConfiguration(
    appId: 'mob_01J00000000000000000000000',
    tenant: 'synthetic-demo',
    defaultLocale: 'de',
    locales: const ['de', 'en'],
    environments: {
      for (final environment in MobileEnvironment.values)
        environment: MobileEnvironmentConfiguration(
          environment: environment,
          id: 'env_01J0000000000000000000000${environment.index}',
          apiBaseUrl: Uri.https(
            '${environment.name}.example.invalid',
            '/api/v2',
          ),
          configRevision: 'cfg_01J0000000000000000000000${environment.index}',
          attestationMode: switch (environment) {
            MobileEnvironment.development => MobileAttestationMode.disabled,
            MobileEnvironment.staging => MobileAttestationMode.test,
            MobileEnvironment.production => MobileAttestationMode.enforced,
          },
          oidc: MobileOidcConfiguration(
            issuer: Uri.https(
              'identity.${environment.name}.example.invalid',
              '/realms/synthetic',
            ),
            clientId: 'mobile-synthetic-${environment.name}',
            redirectUri: Uri.parse(
              'ngotools-synthetic-${environment.name}://oauth/callback',
            ),
            scopes: const ['openid', 'profile', 'email', 'offline_access'],
          ),
        ),
    },
  );

  /// A sanitized identity that does not represent a real person.
  static final identity = MobileIdentity(
    id: 'synthetic-user',
    displayName: 'Synthetic User',
    capabilities: const ['contacts.read'],
  );

  /// Effective capabilities containing no organization or user data.
  static final capabilities = MobileRuntimeCapabilities(
    schemaVersion: 1,
    features: const ['contacts', 'profile'],
    permissions: const ['contacts:read', 'contacts:write', 'profile:read'],
    importsEnabled: true,
    importTypes: {
      'contacts': MobileImportCapability(
        key: 'contacts',
        label: 'Contacts',
        supported: true,
        requiredFeature: 'contacts',
        featureEnabled: true,
        permissionGranted: true,
        available: true,
        requires: const ['contacts'],
        batchImportSupported: true,
        blockers: const [],
        maxBatchSize: 250,
      ),
    },
  );
}
