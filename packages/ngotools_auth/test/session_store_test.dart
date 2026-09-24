import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ngotools_auth/ngotools_auth.dart';
import 'package:ngotools_auth/src/internal/auth_session.dart';
import 'package:ngotools_auth/src/internal/session_store.dart';
import 'package:ngotools_mobile_core/ngotools_mobile_core.dart';

void main() {
  setUp(() => FlutterSecureStorage.setMockInitialValues({}));

  test('round-trips a versioned protected session envelope', () async {
    final store = SecureAuthSessionStore();
    final configuration = _configuration();
    final session = AuthSession(
      apiToken: 'synthetic-api-token',
      oidcRefreshToken: 'synthetic-refresh-token',
      identity: MobileIdentity(
        id: 'synthetic-user',
        displayName: 'Synthetic User',
        email: 'user@example.invalid',
        capabilities: {'contacts.read'},
      ),
    );

    await store.write(configuration, session);
    final restored = await store.read(configuration);

    expect(restored?.apiToken, session.apiToken);
    expect(restored?.oidcRefreshToken, session.oidcRefreshToken);
    expect(restored?.identity, session.identity);
  });

  test('does not restore a session in another environment', () async {
    final store = SecureAuthSessionStore();
    final configuration = _configuration();
    final session = AuthSession(
      apiToken: 'synthetic-api-token',
      oidcRefreshToken: 'synthetic-refresh-token',
      identity: MobileIdentity(
        id: 'synthetic-user',
        displayName: 'Synthetic User',
      ),
    );

    await store.write(configuration, session);

    expect(await store.read(_configuration(environment: 'other')), isNull);
  });
}

MobileAuthConfiguration _configuration({String environment = 'default'}) =>
    MobileAuthConfiguration(
      appId: 'mob_01J00000000000000000000000',
      environmentId: 'env-$environment',
      tenant: 'synthetic-demo',
      apiBaseUrl: Uri.https('$environment.example.invalid', '/api/v2'),
      issuer: Uri.https('identity.example.invalid', '/realms/synthetic'),
      clientId: 'mobile-synthetic',
      redirectUri: Uri.parse('ngotools-synthetic://oauth/callback'),
      scopes: const ['openid', 'profile', 'email', 'offline_access'],
      platform: MobilePlatform.ios,
      deviceName: 'Synthetic iPhone',
      buildNumber: '42',
      attestationMode: MobileAttestationMode.disabled,
    );
