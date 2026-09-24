import 'package:flutter_test/flutter_test.dart';
import 'package:ngotools_auth/ngotools_auth.dart';
import 'package:ngotools_mobile_core/ngotools_mobile_core.dart';

void main() {
  test('keeps the sanitized capability set immutable', () {
    final capabilities = <String>{'contacts.read'};
    final identity = MobileIdentity(
      id: 'synthetic-user',
      displayName: 'Synthetic User',
      capabilities: capabilities,
    );

    capabilities.add('contacts.write');

    expect(identity.capabilities, {'contacts.read'});
    expect(
      () => identity.capabilities.add('contacts.write'),
      throwsUnsupportedError,
    );
  });

  test('derives auth routes from the API origin instead of its v2 path', () {
    final configuration = _configuration();

    expect(
      configuration.authEndpoint('exchange').toString(),
      'https://api.example.invalid/api/auth/exchange',
    );
  });

  test('rejects web redirects and incomplete OIDC scopes', () {
    expect(
      () => _configuration(
        redirectUri: Uri.https('mobile.example.invalid', '/oauth/callback'),
      ),
      throwsFormatException,
    );
    expect(
      () => _configuration(scopes: const ['openid', 'profile']),
      throwsFormatException,
    );
  });

  test('selects one tenant environment from the public app config', () {
    final oidc = MobileOidcConfiguration(
      issuer: Uri.https('identity.example.invalid', '/realms/synthetic'),
      clientId: 'mobile-synthetic',
      redirectUri: Uri.parse('ngotools-synthetic://oauth/callback'),
      scopes: const ['openid', 'profile', 'email', 'offline_access'],
    );
    final app = MobileAppConfiguration(
      appId: 'mob_01J00000000000000000000000',
      tenant: 'synthetic-demo',
      defaultLocale: 'de',
      locales: const ['de', 'en'],
      environments: {
        MobileEnvironment.staging: MobileEnvironmentConfiguration(
          environment: MobileEnvironment.staging,
          id: 'env_01J00000000000000000000001',
          apiBaseUrl: Uri.https('staging.example.invalid', '/api/v2'),
          configRevision: 'cfg_01J00000000000000000000001',
          attestationMode: MobileAttestationMode.test,
          oidc: oidc,
        ),
      },
    );

    final configuration = MobileAuthConfiguration.fromApp(
      app: app,
      environment: MobileEnvironment.staging,
      platform: MobilePlatform.android,
      deviceName: 'Synthetic Pixel',
      buildNumber: '42',
    );

    expect(configuration.tenant, 'synthetic-demo');
    expect(configuration.environmentId, 'env_01J00000000000000000000001');
    expect(configuration.clientId, 'mobile-synthetic');
  });
}

MobileAuthConfiguration _configuration({
  Uri? redirectUri,
  List<String> scopes = const ['openid', 'profile', 'email', 'offline_access'],
}) => MobileAuthConfiguration(
  appId: 'mob_01J00000000000000000000000',
  environmentId: 'env_01J00000000000000000000000',
  tenant: 'synthetic-demo',
  apiBaseUrl: Uri.https('api.example.invalid', '/api/v2'),
  issuer: Uri.https('identity.example.invalid', '/realms/synthetic'),
  clientId: 'mobile-synthetic',
  redirectUri: redirectUri ?? Uri.parse('ngotools-synthetic://oauth/callback'),
  scopes: scopes,
  platform: MobilePlatform.ios,
  deviceName: 'Synthetic iPhone',
  buildNumber: '42',
  attestationMode: MobileAttestationMode.disabled,
);
