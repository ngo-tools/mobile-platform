import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ngotools_auth/ngotools_auth.dart';
import 'package:ngotools_auth/src/internal/auth_session.dart';
import 'package:ngotools_auth/src/internal/authorization_gateway.dart';
import 'package:ngotools_auth/src/internal/session_store.dart';
import 'package:ngotools_auth/src/internal/token_exchange_client.dart';
import 'package:ngotools_mobile_core/ngotools_mobile_core.dart';

void main() {
  late _AuthorizationGateway gateway;
  late _TokenExchangeClient exchange;
  late _SessionStore store;
  late MobileAuthCubit cubit;

  setUp(() {
    gateway = _AuthorizationGateway();
    exchange = _TokenExchangeClient();
    store = _SessionStore();
    cubit = MobileAuthCubit.testing(
      configuration: _configuration(),
      authorizationGateway: gateway,
      tokenExchangeClient: exchange,
      sessionStore: store,
    );
  });

  tearDown(() => cubit.close());

  test('signs in and exposes only sanitized authenticated state', () async {
    await cubit.signIn();

    expect(cubit.state.status, MobileAuthStatus.authenticated);
    expect(cubit.state.identity?.displayName, 'Synthetic User');
    expect(cubit.state.toString(), isNot(contains('synthetic-api-token')));
    expect(store.session?.apiToken, 'synthetic-api-token');
  });

  test('restores and rotates a protected session', () async {
    store.session = _session(apiToken: 'synthetic-old-api-token');
    await cubit.restore();
    await cubit.renew();

    expect(gateway.renewedRefreshToken, 'synthetic-refresh-token');
    expect(store.session?.apiToken, 'synthetic-api-token');
    expect(cubit.state.status, MobileAuthStatus.authenticated);
  });

  test('clears local state when remote logout fails', () async {
    store.session = _session();
    await cubit.restore();
    exchange.revokeFails = true;

    await cubit.signOut();

    expect(store.session, isNull);
    expect(cubit.state.status, MobileAuthStatus.signedOut);
  });

  test('maps browser cancellation without leaving a session', () async {
    gateway.cancelAuthorization = true;

    await cubit.signIn();

    expect(cubit.state.status, MobileAuthStatus.signedOut);
    expect(cubit.state.failure?.code, MobileAuthFailureCode.cancelled);
    expect(store.session, isNull);
  });

  test('reports attestation failures without provider details', () async {
    exchange.attestationFails = true;

    await cubit.signIn();

    expect(cubit.state.status, MobileAuthStatus.failed);
    expect(cubit.state.failure?.code, MobileAuthFailureCode.attestation);
    expect(cubit.state.toString(), isNot(contains('native failure detail')));
  });

  test('does not authenticate when protected storage fails', () async {
    store.writeFails = true;

    await cubit.signIn();

    expect(cubit.state.status, MobileAuthStatus.failed);
    expect(cubit.state.failure?.code, MobileAuthFailureCode.storage);
    expect(store.session, isNull);
  });

  test('authorizes only requests to the configured API origin', () async {
    store.session = _session();
    await cubit.restore();
    final adapter = _ApiAdapter();
    final dio = Dio()..httpClientAdapter = adapter;
    cubit.attachTo(dio);

    await dio.get<void>('https://api.example.invalid/api/v2/profile');

    expect(adapter.authorization, 'Bearer synthetic-api-token');
    await expectLater(
      dio.get<void>('https://other.example.invalid/api/v2/profile'),
      throwsA(isA<DioException>()),
    );
    expect(adapter.requests, 1);
  });

  test('expires and removes a session rejected by the API', () async {
    store.session = _session();
    await cubit.restore();
    final adapter = _ApiAdapter()..statusCode = 401;
    final dio = Dio()..httpClientAdapter = adapter;
    cubit.attachTo(dio);

    await expectLater(
      dio.get<void>('https://api.example.invalid/api/v2/profile'),
      throwsA(isA<DioException>()),
    );
    await Future<void>.delayed(Duration.zero);

    expect(cubit.state.status, MobileAuthStatus.expired);
    expect(cubit.state.failure?.code, MobileAuthFailureCode.expired);
    expect(store.session, isNull);
  });

  test('discards a browser result after the user signs out', () async {
    final authorization = Completer<OidcTokenSet>();
    gateway.authorization = authorization;

    final signIn = cubit.signIn();
    await Future<void>.delayed(Duration.zero);
    await cubit.signOut();
    authorization.complete(
      const OidcTokenSet(
        accessToken: 'synthetic-late-token',
        refreshToken: 'synthetic-late-refresh',
      ),
    );
    await signIn;

    expect(cubit.state.status, MobileAuthStatus.signedOut);
    expect(store.session, isNull);
    expect(exchange.exchanges, 0);
  });
}

final class _AuthorizationGateway implements AuthorizationGateway {
  bool cancelAuthorization = false;
  Completer<OidcTokenSet>? authorization;
  String? renewedRefreshToken;

  @override
  Future<OidcTokenSet> authorize(MobileAuthConfiguration configuration) async {
    if (cancelAuthorization) {
      throw const AuthorizationCancelled();
    }

    if (authorization case final pending?) {
      return pending.future;
    }

    return const OidcTokenSet(
      accessToken: 'synthetic-oidc-token',
      refreshToken: 'synthetic-refresh-token',
    );
  }

  @override
  Future<OidcTokenSet> renew(
    MobileAuthConfiguration configuration,
    String refreshToken,
  ) async {
    renewedRefreshToken = refreshToken;

    return const OidcTokenSet(
      accessToken: 'synthetic-rotated-oidc-token',
      refreshToken: 'synthetic-rotated-refresh-token',
    );
  }
}

final class _TokenExchangeClient implements TokenExchangeClient {
  bool revokeFails = false;
  bool attestationFails = false;
  int exchanges = 0;

  @override
  Future<AuthSession> exchange({
    required MobileAuthConfiguration configuration,
    required OidcTokenSet tokens,
  }) async {
    exchanges += 1;

    if (attestationFails) {
      throw const AttestationFailure();
    }

    return _session(
      oidcRefreshToken: tokens.refreshToken,
      apiToken: 'synthetic-api-token',
    );
  }

  @override
  Future<void> revoke(
    MobileAuthConfiguration configuration,
    String apiToken,
  ) async {
    if (revokeFails) {
      throw StateError('Synthetic revocation failure.');
    }
  }
}

final class _SessionStore implements AuthSessionStore {
  AuthSession? session;
  bool writeFails = false;

  @override
  Future<void> delete(MobileAuthConfiguration configuration) async {
    session = null;
  }

  @override
  Future<AuthSession?> read(MobileAuthConfiguration configuration) async =>
      session;

  @override
  Future<void> write(
    MobileAuthConfiguration configuration,
    AuthSession session,
  ) async {
    if (writeFails) {
      throw StateError('Synthetic storage failure.');
    }

    this.session = session;
  }
}

final class _ApiAdapter implements HttpClientAdapter {
  int requests = 0;
  int statusCode = 200;
  String? authorization;

  @override
  void close({bool force = false}) {}

  @override
  Future<ResponseBody> fetch(
    RequestOptions options,
    Stream<Uint8List>? requestStream,
    Future<void>? cancelFuture,
  ) async {
    requests += 1;
    authorization = options.headers['Authorization'] as String?;

    return ResponseBody.fromString(
      jsonEncode({'ok': true}),
      statusCode,
      headers: {
        Headers.contentTypeHeader: [Headers.jsonContentType],
      },
    );
  }
}

AuthSession _session({
  String apiToken = 'synthetic-api-token',
  String oidcRefreshToken = 'synthetic-refresh-token',
}) => AuthSession(
  apiToken: apiToken,
  oidcRefreshToken: oidcRefreshToken,
  identity: MobileIdentity(id: 'synthetic-user', displayName: 'Synthetic User'),
);

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
  attestationMode: MobileAttestationMode.disabled,
);
