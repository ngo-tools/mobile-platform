import 'package:flutter_appauth/flutter_appauth.dart';

import '../mobile_auth_configuration.dart';
import 'auth_session.dart';

abstract interface class AuthorizationGateway {
  Future<OidcTokenSet> authorize(MobileAuthConfiguration configuration);

  Future<OidcTokenSet> renew(
    MobileAuthConfiguration configuration,
    String refreshToken,
  );
}

final class AuthorizationCancelled implements Exception {
  const AuthorizationCancelled();
}

final class AppAuthAuthorizationGateway implements AuthorizationGateway {
  const AppAuthAuthorizationGateway({
    FlutterAppAuth appAuth = const FlutterAppAuth(),
  }) : _appAuth = appAuth;

  final FlutterAppAuth _appAuth;

  @override
  Future<OidcTokenSet> authorize(MobileAuthConfiguration configuration) async {
    try {
      final response = await _appAuth.authorizeAndExchangeCode(
        AuthorizationTokenRequest(
          configuration.clientId,
          configuration.redirectUri.toString(),
          issuer: configuration.issuer.toString(),
          scopes: configuration.scopes,
        ),
      );

      return _validatedTokenSet(response);
    } on FlutterAppAuthUserCancelledException {
      throw const AuthorizationCancelled();
    }
  }

  @override
  Future<OidcTokenSet> renew(
    MobileAuthConfiguration configuration,
    String refreshToken,
  ) async {
    final response = await _appAuth.token(
      TokenRequest(
        configuration.clientId,
        configuration.redirectUri.toString(),
        issuer: configuration.issuer.toString(),
        refreshToken: refreshToken,
        scopes: configuration.scopes,
      ),
    );

    return _validatedTokenSet(response, fallbackRefreshToken: refreshToken);
  }

  OidcTokenSet _validatedTokenSet(
    TokenResponse response, {
    String? fallbackRefreshToken,
  }) {
    final accessToken = response.accessToken;
    final refreshToken = response.refreshToken ?? fallbackRefreshToken;

    if (accessToken == null ||
        accessToken.isEmpty ||
        refreshToken == null ||
        refreshToken.isEmpty) {
      throw const FormatException(
        'The authorization server returned an incomplete token set.',
      );
    }

    return OidcTokenSet(
      accessToken: accessToken,
      refreshToken: refreshToken,
      idToken: response.idToken,
    );
  }
}
