import 'dart:convert';
import 'dart:typed_data';

import 'package:crypto/crypto.dart';
import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ngotools_auth/ngotools_auth.dart';
import 'package:ngotools_auth/src/internal/auth_session.dart';
import 'package:ngotools_auth/src/internal/token_exchange_client.dart';
import 'package:ngotools_mobile_core/ngotools_mobile_core.dart';

void main() {
  test('binds attestation to the challenge and OIDC token hash', () async {
    final adapter = _BrokerAdapter();
    final dio = Dio()..httpClientAdapter = adapter;
    final attestation = _CapturingAttestationProvider();
    final client = NgoToolsTokenExchangeClient(
      attestationProvider: attestation,
      dio: dio,
    );
    final configuration = _configuration();
    const tokens = OidcTokenSet(
      accessToken: 'synthetic-oidc-access',
      refreshToken: 'synthetic-oidc-refresh',
      idToken: 'synthetic-id-token',
    );

    final session = await client.exchange(
      configuration: configuration,
      tokens: tokens,
    );
    final request = attestation.request!;
    final canonical = jsonEncode({
      'version': 1,
      'challenge_id': 'synthetic-challenge-id',
      'challenge': 'synthetic-challenge',
      'app_id': configuration.appId,
      'environment_id': configuration.environmentId,
      'platform': 'android',
      'keycloak_token_sha256': sha256
          .convert(utf8.encode(tokens.accessToken))
          .toString(),
      'device_name': configuration.deviceName,
      'build_number': configuration.buildNumber,
    });
    final expectedHash = sha256.convert(utf8.encode(canonical)).bytes;

    expect(request.clientDataHash, expectedHash);
    expect(
      request.requestHash,
      base64UrlEncode(expectedHash).replaceAll('=', ''),
    );
    expect(session.apiToken, 'synthetic-api-token');
    expect(session.identity.email, 'user@example.invalid');
    expect(adapter.paths, [
      '/api/auth/attestation-challenges',
      '/api/auth/exchange',
    ]);
    expect(adapter.exchangeData?['kc_access_token'], tokens.accessToken);
    expect(adapter.exchangeData?['attestation'], {
      'integrity_token': 'synthetic-integrity-proof',
    });
  });
}

final class _CapturingAttestationProvider implements MobileAttestationProvider {
  MobileAttestationRequest? request;

  @override
  Future<MobileAttestationProof> createProof(
    MobileAttestationRequest request,
  ) async {
    this.request = request;

    return const MobileAttestationProof(
      integrityToken: 'synthetic-integrity-proof',
    );
  }
}

final class _BrokerAdapter implements HttpClientAdapter {
  final paths = <String>[];
  Map<String, Object?>? exchangeData;

  @override
  void close({bool force = false}) {}

  @override
  Future<ResponseBody> fetch(
    RequestOptions options,
    Stream<Uint8List>? requestStream,
    Future<void>? cancelFuture,
  ) async {
    paths.add(options.uri.path);

    if (options.uri.path.endsWith('/attestation-challenges')) {
      return _jsonResponse({
        'challenge_id': 'synthetic-challenge-id',
        'challenge': 'synthetic-challenge',
        'expires_in': 120,
      });
    }

    exchangeData = (options.data! as Map<Object?, Object?>).map(
      (key, value) => MapEntry(key.toString(), value),
    );

    return _jsonResponse({
      'token': 'synthetic-api-token',
      'user': {
        'id': 'synthetic-user',
        'name': 'Synthetic User',
        'email': 'user@example.invalid',
      },
      'tenant': {'slug': 'synthetic-demo', 'name': 'Synthetic Demo'},
    });
  }

  ResponseBody _jsonResponse(Map<String, Object?> value) =>
      ResponseBody.fromString(
        jsonEncode(value),
        200,
        headers: {
          Headers.contentTypeHeader: [Headers.jsonContentType],
        },
      );
}

MobileAuthConfiguration _configuration() => MobileAuthConfiguration(
  appId: 'mob_01J00000000000000000000000',
  environmentId: 'env_01J00000000000000000000000',
  tenant: 'synthetic-demo',
  apiBaseUrl: Uri.https('api.example.invalid', '/api/v2'),
  issuer: Uri.https('identity.example.invalid', '/realms/synthetic'),
  clientId: 'mobile-synthetic',
  redirectUri: Uri.parse('ngotools-synthetic://oauth/callback'),
  scopes: const ['openid', 'profile', 'email', 'offline_access'],
  platform: MobilePlatform.android,
  deviceName: 'Synthetic Pixel',
  buildNumber: '42',
  attestationMode: MobileAttestationMode.test,
);
