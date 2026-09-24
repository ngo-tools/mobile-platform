import 'package:freezed_annotation/freezed_annotation.dart';

part 'mobile_auth_state.freezed.dart';

/// The observable authentication lifecycle of an app session.
enum MobileAuthStatus {
  signedOut,
  restoring,
  authorizing,
  renewing,
  authenticated,
  expired,
  failed,
}

/// Stable failure categories safe to expose to UI and telemetry.
enum MobileAuthFailureCode {
  cancelled,
  configuration,
  authorization,
  attestation,
  exchange,
  network,
  storage,
  expired,
  unknown,
}

/// A sanitized authentication failure with no provider response data.
@freezed
abstract class MobileAuthFailure with _$MobileAuthFailure {
  /// Creates a sanitized authentication failure.
  const factory MobileAuthFailure({
    required MobileAuthFailureCode code,
    @Default(false) bool retriable,
  }) = _MobileAuthFailure;
}

/// A sanitized identity that contains no OAuth or API tokens.
final class MobileIdentity {
  /// Creates a sanitized, deeply immutable identity.
  MobileIdentity({
    required this.id,
    required this.displayName,
    this.email,
    Iterable<String> capabilities = const [],
  }) : capabilities = Set.unmodifiable(Set.of(capabilities));

  /// The tenant-scoped user identifier.
  final String id;

  /// The display name safe to show in the user interface.
  final String displayName;

  /// The optional address safe to show for the current user.
  final String? email;

  /// Effective server-provided capabilities.
  final Set<String> capabilities;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is MobileIdentity &&
          id == other.id &&
          displayName == other.displayName &&
          email == other.email &&
          capabilities.length == other.capabilities.length &&
          capabilities.containsAll(other.capabilities);

  @override
  int get hashCode => Object.hash(
    id,
    displayName,
    email,
    Object.hashAllUnordered(capabilities),
  );
}

/// Immutable state emitted by the authentication Cubit.
@freezed
abstract class MobileAuthState with _$MobileAuthState {
  /// Creates a token-free authentication state.
  const factory MobileAuthState({
    @Default(MobileAuthStatus.signedOut) MobileAuthStatus status,
    MobileIdentity? identity,
    MobileAuthFailure? failure,
  }) = _MobileAuthState;
}
