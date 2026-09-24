import 'package:ngotools_mobile_core/ngotools_mobile_core.dart';

/// Mobile operating systems supported by the authentication broker.
enum MobilePlatform { ios, android }

/// Public, secret-free authentication configuration for one environment.
class MobileAuthConfiguration {
  /// Creates and validates a tenant-bound authentication configuration.
  MobileAuthConfiguration({
    required this.appId,
    required this.environmentId,
    required this.tenant,
    required this.apiBaseUrl,
    required this.issuer,
    required this.clientId,
    required this.redirectUri,
    required Iterable<String> scopes,
    required this.platform,
    required this.deviceName,
    required this.buildNumber,
    required this.attestationMode,
  }) : scopes = List.unmodifiable(scopes) {
    _validate();
  }

  /// Builds auth settings from the signed-off public app configuration.
  factory MobileAuthConfiguration.fromApp({
    required MobileAppConfiguration app,
    required MobileEnvironment environment,
    required MobilePlatform platform,
    required String deviceName,
    required String buildNumber,
  }) {
    final selected = app.forEnvironment(environment);

    return MobileAuthConfiguration(
      appId: app.appId,
      environmentId: selected.id,
      tenant: app.tenant,
      apiBaseUrl: selected.apiBaseUrl,
      issuer: selected.oidc.issuer,
      clientId: selected.oidc.clientId,
      redirectUri: selected.oidc.redirectUri,
      scopes: selected.oidc.scopes,
      platform: platform,
      deviceName: deviceName,
      buildNumber: buildNumber,
      attestationMode: selected.attestationMode,
    );
  }

  final String appId;
  final String environmentId;
  final String tenant;
  final Uri apiBaseUrl;
  final Uri issuer;
  final String clientId;
  final Uri redirectUri;
  final List<String> scopes;
  final MobilePlatform platform;
  final String deviceName;
  final String buildNumber;
  final MobileAttestationMode attestationMode;

  /// Returns a fixed authentication endpoint on the configured API origin.
  Uri authEndpoint(String action) => apiBaseUrl.replace(
    path: '/api/auth/$action',
    query: null,
    fragment: null,
  );

  /// A non-secret namespace that prevents sessions crossing app environments.
  String get storageNamespace => '${appId}_$environmentId';

  void _validate() {
    if (appId.isEmpty || environmentId.isEmpty || clientId.isEmpty) {
      throw const FormatException(
        'App, environment, and OIDC client identifiers are required.',
      );
    }

    if (!RegExp(r'^[a-z0-9]+(?:-[a-z0-9]+)*$').hasMatch(tenant)) {
      throw const FormatException('The tenant slug is invalid.');
    }

    if (apiBaseUrl.scheme != 'https' || issuer.scheme != 'https') {
      throw const FormatException('API and issuer URLs must use HTTPS.');
    }

    if (redirectUri.scheme.isEmpty ||
        redirectUri.scheme == 'http' ||
        redirectUri.scheme == 'https' ||
        redirectUri.host != 'oauth' ||
        redirectUri.path != '/callback') {
      throw const FormatException(
        'The redirect URI must use a private scheme and /oauth/callback.',
      );
    }

    const requiredScopes = {'openid', 'profile', 'offline_access'};

    if (!scopes.toSet().containsAll(requiredScopes)) {
      throw const FormatException(
        'OIDC scopes must include openid, profile, and offline_access.',
      );
    }

    if (deviceName.trim().isEmpty || buildNumber.trim().isEmpty) {
      throw const FormatException('Device name and build number are required.');
    }
  }
}
