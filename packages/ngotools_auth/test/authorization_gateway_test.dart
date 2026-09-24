import 'package:flutter_appauth/flutter_appauth.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:ngotools_auth/ngotools_auth.dart';
import 'package:ngotools_auth/src/internal/authorization_gateway.dart';
import 'package:ngotools_mobile_core/ngotools_mobile_core.dart';

final class _MockFlutterAppAuth extends Mock implements FlutterAppAuth {}

void main() {
  late _MockFlutterAppAuth appAuth;
  late AppAuthAuthorizationGateway gateway;

  setUpAll(() {
    registerFallbackValue(
      AuthorizationTokenRequest(
        'fallback',
        'fallback://oauth/callback',
        issuer: 'https://identity.example.invalid',
      ),
    );
    registerFallbackValue(
      TokenRequest(
        'fallback',
        'fallback://oauth/callback',
        issuer: 'https://identity.example.invalid',
      ),
    );
  });

  setUp(() {
    appAuth = _MockFlutterAppAuth();
    gateway = AppAuthAuthorizationGateway(appAuth: appAuth);
  });

  test('uses a public-client authorization code request with PKCE', () async {
    when(() => appAuth.authorizeAndExchangeCode(any())).thenAnswer(
      (_) async => AuthorizationTokenResponse(
        'synthetic-oidc-access',
        'synthetic-oidc-refresh',
        DateTime.utc(2030),
        'synthetic-id-token',
        'Bearer',
        const ['openid', 'profile', 'email', 'offline_access'],
        null,
        null,
      ),
    );

    final tokens = await gateway.authorize(_configuration());
    final request =
        verify(
              () => appAuth.authorizeAndExchangeCode(captureAny()),
            ).captured.single
            as AuthorizationTokenRequest;

    expect(request.clientId, 'mobile-synthetic');
    expect(request.clientSecret, isNull);
    expect(request.redirectUrl, 'ngotools-synthetic://oauth/callback');
    expect(request.issuer, 'https://identity.example.invalid/realms/synthetic');
    expect(
      request.externalUserAgent,
      ExternalUserAgent.asWebAuthenticationSession,
    );
    expect(tokens.accessToken, 'synthetic-oidc-access');
  });

  test('keeps the previous refresh token when rotation omits one', () async {
    when(() => appAuth.token(any())).thenAnswer(
      (_) async => TokenResponse(
        'rotated-oidc-access',
        null,
        DateTime.utc(2030),
        null,
        'Bearer',
        const ['openid'],
        null,
      ),
    );

    final tokens = await gateway.renew(
      _configuration(),
      'synthetic-old-refresh',
    );

    expect(tokens.refreshToken, 'synthetic-old-refresh');
  });
}

MobileAuthConfiguration _configuration() => MobileAuthConfiguration(
  appId: 'mob_01J00000000000000000000000',
  environmentId: 'env_01J00000000000000000000000',
  tenant: 'synthetic-demo',
  apiBaseUrl: Uri.https('api.example.invalid', '/api/v2'),
  issuer: Uri.https('identity.example.invalid', '/realms/synthetic'),
  clientId: 'mobile-synthetic',
  redirectUri: Uri.parse('ngotools-synthetic://oauth/callback'),
  scopes: const ['openid', 'profile', 'email', 'offline_access'],
  platform: MobilePlatform.ios,
  deviceName: 'Synthetic iPhone',
  buildNumber: '42',
  attestationMode: MobileAttestationMode.disabled,
);
