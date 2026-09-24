import 'dart:typed_data';

/// Hash-bound public data passed to a platform attestation implementation.
class MobileAttestationRequest {
  /// Creates an attestation request without exposing an OIDC token.
  MobileAttestationRequest({
    required this.challengeId,
    required this.challenge,
    required this.appId,
    required this.environmentId,
    required this.platform,
    required this.deviceName,
    required this.buildNumber,
    required Uint8List clientDataHash,
    required this.requestHash,
  }) : _clientDataHash = Uint8List.fromList(clientDataHash);

  final String challengeId;
  final String challenge;
  final String appId;
  final String environmentId;
  final String platform;
  final String deviceName;
  final String buildNumber;

  /// The SHA-256 binding used by Apple App Attest.
  Uint8List get clientDataHash => Uint8List.fromList(_clientDataHash);

  final Uint8List _clientDataHash;

  /// The base64url SHA-256 binding used by Google Play Integrity.
  final String requestHash;
}

/// Platform-specific proof returned to the NGO.Tools token broker.
class MobileAttestationProof {
  /// Creates an attestation proof.
  const MobileAttestationProof({
    this.keyId,
    this.attestationObject,
    this.assertion,
    this.integrityToken,
  });

  /// Creates an empty proof for an explicitly disabled policy.
  const MobileAttestationProof.disabled()
    : keyId = null,
      attestationObject = null,
      assertion = null,
      integrityToken = null;

  final String? keyId;
  final String? attestationObject;
  final String? assertion;
  final String? integrityToken;

  /// Serializes only proof fields accepted by the broker.
  Map<String, String> toJson() => {
    'key_id': ?keyId,
    'attestation_object': ?attestationObject,
    'assertion': ?assertion,
    'integrity_token': ?integrityToken,
  };
}

/// Produces native proof for an already hash-bound broker challenge.
abstract interface class MobileAttestationProvider {
  /// Creates a platform proof without receiving any raw authentication token.
  Future<MobileAttestationProof> createProof(MobileAttestationRequest request);
}

/// Attestation provider for development environments where policy is disabled.
final class DisabledMobileAttestationProvider
    implements MobileAttestationProvider {
  /// Creates a disabled attestation provider.
  const DisabledMobileAttestationProvider();

  @override
  Future<MobileAttestationProof> createProof(
    MobileAttestationRequest request,
  ) async => const MobileAttestationProof.disabled();
}
