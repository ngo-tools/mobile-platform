/// Core environment and application contracts for NGO.Tools mobile apps.
library;

/// A deployment environment available to an organization app.
enum MobileEnvironment { development, staging, production }

/// The level of platform attestation enforced by the backend.
enum MobileAttestationMode { disabled, test, enforced }

/// Public, secret-free configuration for one deployment environment.
class MobileEnvironmentConfiguration {
  /// Creates an immutable environment configuration.
  const MobileEnvironmentConfiguration({
    required this.environment,
    required this.id,
    required this.apiBaseUrl,
    required this.configRevision,
    required this.attestationMode,
  });

  /// The deployment environment represented by this configuration.
  final MobileEnvironment environment;

  /// The stable environment identifier returned by NGO.Tools.
  final String id;

  /// The fixed NGO.Tools API base URL for this environment.
  final Uri apiBaseUrl;

  /// The revision used to invalidate stale public configuration.
  final String configRevision;

  /// The attestation policy enforced for this environment.
  final MobileAttestationMode attestationMode;
}

/// Public, tenant-bound configuration embedded in an organization app.
class MobileAppConfiguration {
  /// Creates an immutable organization app configuration.
  MobileAppConfiguration({
    required this.appId,
    required this.tenant,
    required this.defaultLocale,
    required Iterable<String> locales,
    required Map<MobileEnvironment, MobileEnvironmentConfiguration>
    environments,
  }) : locales = List.unmodifiable(locales),
       environments = Map.unmodifiable(environments);

  /// The stable app identifier issued by NGO.Tools.
  final String appId;

  /// The single tenant slug this app is allowed to use.
  final String tenant;

  /// The locale used when no supported device locale matches.
  final String defaultLocale;

  /// The locales shipped with the app.
  final List<String> locales;

  /// Public environment configuration keyed by deployment environment.
  final Map<MobileEnvironment, MobileEnvironmentConfiguration> environments;

  /// Returns the configuration for [environment].
  MobileEnvironmentConfiguration forEnvironment(
    MobileEnvironment environment,
  ) =>
      environments[environment] ??
      (throw StateError('Missing ${environment.name} configuration.'));
}
