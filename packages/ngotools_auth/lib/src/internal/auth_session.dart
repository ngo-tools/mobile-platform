import '../mobile_auth_state.dart';

final class AuthSession {
  const AuthSession({
    required this.apiToken,
    required this.oidcRefreshToken,
    required this.identity,
    this.oidcIdToken,
  });

  final String apiToken;
  final String oidcRefreshToken;
  final String? oidcIdToken;
  final MobileIdentity identity;
}

final class OidcTokenSet {
  const OidcTokenSet({
    required this.accessToken,
    required this.refreshToken,
    this.idToken,
  });

  final String accessToken;
  final String refreshToken;
  final String? idToken;
}
