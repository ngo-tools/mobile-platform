import 'package:ngotools_api/ngotools_api.dart';
import 'package:ngotools_auth/ngotools_auth.dart';

/// The result of evaluating access to an application route.
enum MobileRouteAccess {
  allowed,
  signInRequired,
  capabilitiesLoading,
  featureMissing,
  permissionMissing,
  importUnavailable,
}

/// Authentication and server capability requirements for one route.
final class MobileRouteRequirement {
  /// Creates a deeply immutable route requirement.
  MobileRouteRequirement({
    this.requiresAuthentication = true,
    Iterable<String> features = const [],
    Iterable<String> permissions = const [],
    Iterable<String> importTypes = const [],
  }) : features = Set.unmodifiable(features),
       permissions = Set.unmodifiable(permissions),
       importTypes = Set.unmodifiable(importTypes);

  /// Whether a signed-in identity is required.
  final bool requiresAuthentication;

  /// Marketplace features required by the route.
  final Set<String> features;

  /// User permissions required by the route.
  final Set<String> permissions;

  /// Server-enabled import types required by the route.
  final Set<String> importTypes;

  /// Evaluates this requirement without granting local permissions.
  MobileRouteAccess evaluate({
    required MobileAuthStatus authStatus,
    required MobileRuntimeCapabilities? capabilities,
  }) {
    if (requiresAuthentication &&
        authStatus != MobileAuthStatus.authenticated) {
      return MobileRouteAccess.signInRequired;
    }

    final needsCapabilities =
        features.isNotEmpty || permissions.isNotEmpty || importTypes.isNotEmpty;

    if (needsCapabilities && capabilities == null) {
      return MobileRouteAccess.capabilitiesLoading;
    }

    if (capabilities == null) {
      return MobileRouteAccess.allowed;
    }

    if (!capabilities.features.containsAll(features)) {
      return MobileRouteAccess.featureMissing;
    }

    if (!capabilities.permissions.containsAll(permissions)) {
      return MobileRouteAccess.permissionMissing;
    }

    if (importTypes.any((type) => !capabilities.canImport(type))) {
      return MobileRouteAccess.importUnavailable;
    }

    return MobileRouteAccess.allowed;
  }
}
