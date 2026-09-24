/// Auth and capability-aware navigation contracts for NGO.Tools apps.
library;

import 'package:ngotools_auth/ngotools_auth.dart';

/// The result of evaluating access to an application route.
enum MobileRouteAccess { allowed, signInRequired, capabilityMissing }

/// Authentication and capability requirements for one route.
class MobileRouteRequirement {
  /// Creates an immutable route requirement.
  MobileRouteRequirement({
    this.requiresAuthentication = true,
    Iterable<String> capabilities = const [],
  }) : capabilities = Set.unmodifiable(capabilities);

  /// Whether a signed-in identity is required.
  final bool requiresAuthentication;

  /// Effective capabilities required by the route.
  final Set<String> capabilities;

  /// Evaluates this requirement without granting server permissions.
  MobileRouteAccess evaluate({
    required MobileAuthStatus authStatus,
    required Set<String> effectiveCapabilities,
  }) {
    if (requiresAuthentication &&
        authStatus != MobileAuthStatus.authenticated) {
      return MobileRouteAccess.signInRequired;
    }

    if (!effectiveCapabilities.containsAll(capabilities)) {
      return MobileRouteAccess.capabilityMissing;
    }

    return MobileRouteAccess.allowed;
  }
}
