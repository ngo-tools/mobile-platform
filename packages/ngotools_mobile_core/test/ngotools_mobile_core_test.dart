import 'package:flutter_test/flutter_test.dart';
import 'package:ngotools_mobile_core/ngotools_mobile_core.dart';

void main() {
  test('returns the fixed configuration for an environment', () {
    final environment = MobileEnvironmentConfiguration(
      environment: MobileEnvironment.staging,
      id: 'env_01J00000000000000000000000',
      apiBaseUrl: Uri.https('staging.example.invalid', '/api/v2'),
      configRevision: 'cfg_01J00000000000000000000000',
      attestationMode: MobileAttestationMode.test,
    );
    final configuration = MobileAppConfiguration(
      appId: 'mob_01J00000000000000000000000',
      tenant: 'synthetic-demo',
      defaultLocale: 'de',
      locales: const ['de', 'en'],
      environments: {MobileEnvironment.staging: environment},
    );

    expect(
      configuration.forEnvironment(MobileEnvironment.staging),
      same(environment),
    );
  });

  test('does not expose mutable environment collections', () {
    final locales = <String>['de', 'en'];
    final environments = <MobileEnvironment, MobileEnvironmentConfiguration>{};
    final configuration = MobileAppConfiguration(
      appId: 'mob_01J00000000000000000000000',
      tenant: 'synthetic-demo',
      defaultLocale: 'de',
      locales: locales,
      environments: environments,
    );

    locales.add('fr');
    environments[MobileEnvironment.production] = MobileEnvironmentConfiguration(
      environment: MobileEnvironment.production,
      id: 'env_01J00000000000000000000000',
      apiBaseUrl: Uri.https('example.invalid', '/api/v2'),
      configRevision: 'cfg_01J00000000000000000000000',
      attestationMode: MobileAttestationMode.enforced,
    );

    expect(configuration.locales, ['de', 'en']);
    expect(configuration.environments, isEmpty);
  });
}
