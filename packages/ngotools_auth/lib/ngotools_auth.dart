/// Token-safe authentication contracts for NGO.Tools mobile apps.
library;

/// The observable authentication state of an app session.
enum MobileAuthStatus { signedOut, authorizing, authenticated, expired }

/// A sanitized identity that contains no OAuth or API tokens.
class MobileIdentity {
  /// Creates a sanitized identity.
  MobileIdentity({
    required this.id,
    required this.displayName,
    required Iterable<String> capabilities,
  }) : capabilities = Set.unmodifiable(capabilities);

  /// The tenant-scoped user identifier.
  final String id;

  /// The display name safe to show in the user interface.
  final String displayName;

  /// Effective server-provided capabilities.
  final Set<String> capabilities;
}

/// Authentication boundary consumed by application code.
abstract interface class MobileAuthentication {
  /// Emits sanitized authentication states.
  Stream<MobileAuthStatus> get status;

  /// Returns the current sanitized identity, if authenticated.
  MobileIdentity? get identity;

  /// Starts Authorization Code with PKCE in the external system browser.
  Future<void> signIn();

  /// Revokes the session and clears protected local state.
  Future<void> signOut();
}
