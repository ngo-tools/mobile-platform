import 'dart:convert';
import 'dart:typed_data';

import 'package:crypto/crypto.dart';
import 'package:dio/dio.dart';

import '../mobile_attestation.dart';
import '../mobile_auth_configuration.dart';
import '../mobile_auth_state.dart';
import 'auth_session.dart';

abstract interface class TokenExchangeClient {
  Future<AuthSession> exchange({
    required MobileAuthConfiguration configuration,
    required OidcTokenSet tokens,
  });

  Future<void> revoke(MobileAuthConfiguration configuration, String apiToken);
}

final class AttestationFailure implements Exception {
  const AttestationFailure();
}

final class NgoToolsTokenExchangeClient implements TokenExchangeClient {
  NgoToolsTokenExchangeClient({
    required MobileAttestationProvider attestationProvider,
    Dio? dio,
  }) : _attestationProvider = attestationProvider,
       _dio = dio ?? Dio();

  final MobileAttestationProvider _attestationProvider;
  final Dio _dio;

  @override
  Future<AuthSession> exchange({
    required MobileAuthConfiguration configuration,
    required OidcTokenSet tokens,
  }) async {
    final challengeResponse = await _dio.post<Map<String, Object?>>(
      configuration.authEndpoint('attestation-challenges').toString(),
      data: {
        'app_id': configuration.appId,
        'environment_id': configuration.environmentId,
        'platform': configuration.platform.name,
        'build_number': configuration.buildNumber,
      },
    );
    final challengeData = challengeResponse.data;
    final challengeId = challengeData?['challenge_id'];
    final challenge = challengeData?['challenge'];

    if (challengeId is! String || challenge is! String) {
      throw const FormatException('Invalid attestation challenge response.');
    }

    final binding = _createBinding(
      configuration: configuration,
      challengeId: challengeId,
      challenge: challenge,
      oidcAccessToken: tokens.accessToken,
    );
    final MobileAttestationProof proof;

    try {
      proof = await _attestationProvider.createProof(binding.request);
    } on Object {
      throw const AttestationFailure();
    }
    final exchangeResponse = await _dio.post<Map<String, Object?>>(
      configuration.authEndpoint('exchange').toString(),
      data: {
        'kc_access_token': tokens.accessToken,
        'device_name': configuration.deviceName,
        'app_id': configuration.appId,
        'environment_id': configuration.environmentId,
        'platform': configuration.platform.name,
        'challenge_id': challengeId,
        'challenge': challenge,
        'build_number': configuration.buildNumber,
        'attestation': proof.toJson(),
      },
    );

    return _parseSession(exchangeResponse.data, tokens);
  }

  @override
  Future<void> revoke(
    MobileAuthConfiguration configuration,
    String apiToken,
  ) async {
    await _dio.post<void>(
      configuration.authEndpoint('logout').toString(),
      options: Options(headers: {'Authorization': 'Bearer $apiToken'}),
    );
  }

  _AttestationBinding _createBinding({
    required MobileAuthConfiguration configuration,
    required String challengeId,
    required String challenge,
    required String oidcAccessToken,
  }) {
    final canonical = jsonEncode({
      'version': 1,
      'challenge_id': challengeId,
      'challenge': challenge,
      'app_id': configuration.appId,
      'environment_id': configuration.environmentId,
      'platform': configuration.platform.name,
      'keycloak_token_sha256': sha256
          .convert(utf8.encode(oidcAccessToken))
          .toString(),
      'device_name': configuration.deviceName,
      'build_number': configuration.buildNumber,
    });
    final digest = sha256.convert(utf8.encode(canonical));
    final clientDataHash = Uint8List.fromList(digest.bytes);
    final requestHash = base64UrlEncode(clientDataHash).replaceAll('=', '');

    return _AttestationBinding(
      request: MobileAttestationRequest(
        challengeId: challengeId,
        challenge: challenge,
        appId: configuration.appId,
        environmentId: configuration.environmentId,
        platform: configuration.platform.name,
        deviceName: configuration.deviceName,
        buildNumber: configuration.buildNumber,
        clientDataHash: clientDataHash,
        requestHash: requestHash,
      ),
    );
  }

  AuthSession _parseSession(Map<String, Object?>? data, OidcTokenSet tokens) {
    final apiToken = data?['token'];
    final user = data?['user'];

    if (apiToken is! String ||
        user is! Map<String, Object?> ||
        user['id'] == null ||
        user['name'] is! String) {
      throw const FormatException('Invalid token exchange response.');
    }

    return AuthSession(
      apiToken: apiToken,
      oidcRefreshToken: tokens.refreshToken,
      oidcIdToken: tokens.idToken,
      identity: MobileIdentity(
        id: user['id'].toString(),
        displayName: user['name']! as String,
        email: user['email'] as String?,
      ),
    );
  }
}

final class _AttestationBinding {
  const _AttestationBinding({required this.request});

  final MobileAttestationRequest request;
}
