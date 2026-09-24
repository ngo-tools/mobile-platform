import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:ngotools_mobile_core/ngotools_mobile_core.dart';

import 'internal/auth_interceptor.dart';
import 'internal/auth_session.dart';
import 'internal/authorization_gateway.dart';
import 'internal/session_store.dart';
import 'internal/token_exchange_client.dart';
import 'mobile_attestation.dart';
import 'mobile_auth_configuration.dart';
import 'mobile_auth_state.dart';

/// Owns the authentication lifecycle without exposing raw tokens to app code.
final class MobileAuthCubit extends Cubit<MobileAuthState> {
  /// Creates the production authentication pipeline.
  factory MobileAuthCubit({
    required MobileAuthConfiguration configuration,
    required MobileAttestationProvider attestationProvider,
  }) {
    if (configuration.attestationMode != MobileAttestationMode.disabled &&
        attestationProvider is DisabledMobileAttestationProvider) {
      throw ArgumentError.value(
        attestationProvider,
        'attestationProvider',
        'A native attestation provider is required by this environment.',
      );
    }

    return MobileAuthCubit.testing(
      configuration: configuration,
      authorizationGateway: const AppAuthAuthorizationGateway(),
      tokenExchangeClient: NgoToolsTokenExchangeClient(
        attestationProvider: attestationProvider,
      ),
      sessionStore: SecureAuthSessionStore(),
    );
  }

  /// Creates an authentication pipeline with controlled test boundaries.
  @visibleForTesting
  MobileAuthCubit.testing({
    required MobileAuthConfiguration configuration,
    required AuthorizationGateway authorizationGateway,
    required TokenExchangeClient tokenExchangeClient,
    required AuthSessionStore sessionStore,
  }) : _configuration = configuration,
       _authorizationGateway = authorizationGateway,
       _tokenExchangeClient = tokenExchangeClient,
       _sessionStore = sessionStore,
       super(const MobileAuthState());

  final MobileAuthConfiguration _configuration;
  final AuthorizationGateway _authorizationGateway;
  final TokenExchangeClient _tokenExchangeClient;
  final AuthSessionStore _sessionStore;

  AuthSession? _session;
  int _operation = 0;

  /// Restores a protected session when the app starts.
  Future<void> restore() async {
    final operation = ++_operation;
    emit(const MobileAuthState(status: MobileAuthStatus.restoring));

    try {
      final session = await _sessionStore.read(_configuration);

      if (operation != _operation) {
        return;
      }

      _session = session;

      emit(
        session == null
            ? const MobileAuthState()
            : MobileAuthState(
                status: MobileAuthStatus.authenticated,
                identity: session.identity,
              ),
      );
    } on Object {
      if (operation != _operation) {
        return;
      }

      _session = null;
      emit(
        const MobileAuthState(
          status: MobileAuthStatus.failed,
          failure: MobileAuthFailure(code: MobileAuthFailureCode.storage),
        ),
      );
    }
  }

  /// Starts Authorization Code with PKCE in the external system browser.
  Future<void> signIn() async {
    if (_session != null || state.status == MobileAuthStatus.authorizing) {
      return;
    }

    final operation = ++_operation;
    emit(const MobileAuthState(status: MobileAuthStatus.authorizing));

    try {
      final tokens = await _authorizationGateway.authorize(_configuration);

      if (operation != _operation) {
        return;
      }

      final session = await _tokenExchangeClient.exchange(
        configuration: _configuration,
        tokens: tokens,
      );

      if (operation != _operation) {
        return;
      }

      try {
        await _sessionStore.write(_configuration, session);
      } on Object {
        try {
          await _sessionStore.delete(_configuration);
        } on Object {
          // The storage failure state remains authoritative for the UI.
        }
        _emitFailure(MobileAuthFailureCode.storage);

        return;
      }

      if (operation != _operation) {
        await _sessionStore.delete(_configuration);

        return;
      }

      _session = session;
      emit(
        MobileAuthState(
          status: MobileAuthStatus.authenticated,
          identity: session.identity,
        ),
      );
    } on AuthorizationCancelled {
      if (operation != _operation) {
        return;
      }

      emit(
        const MobileAuthState(
          failure: MobileAuthFailure(code: MobileAuthFailureCode.cancelled),
        ),
      );
    } on DioException catch (error) {
      if (operation != _operation) {
        return;
      }

      _emitFailure(_dioFailure(error));
    } on AttestationFailure {
      if (operation != _operation) {
        return;
      }

      _emitFailure(MobileAuthFailureCode.attestation);
    } on FormatException {
      if (operation != _operation) {
        return;
      }

      _emitFailure(MobileAuthFailureCode.exchange);
    } on Object {
      if (operation != _operation) {
        return;
      }

      _emitFailure(MobileAuthFailureCode.authorization);
    }
  }

  /// Rotates the OIDC grant and obtains a fresh NGO.Tools API token.
  Future<void> renew() async {
    if (state.status == MobileAuthStatus.renewing) {
      return;
    }

    final previous = _session;

    if (previous == null) {
      await expire();

      return;
    }

    final operation = ++_operation;
    emit(
      MobileAuthState(
        status: MobileAuthStatus.renewing,
        identity: previous.identity,
      ),
    );

    try {
      final tokens = await _authorizationGateway.renew(
        _configuration,
        previous.oidcRefreshToken,
      );

      if (operation != _operation) {
        return;
      }

      final session = await _tokenExchangeClient.exchange(
        configuration: _configuration,
        tokens: tokens,
      );

      if (operation != _operation) {
        return;
      }

      await _sessionStore.write(_configuration, session);

      if (operation != _operation) {
        await _sessionStore.delete(_configuration);

        return;
      }

      _session = session;
      emit(
        MobileAuthState(
          status: MobileAuthStatus.authenticated,
          identity: session.identity,
        ),
      );
    } on Object {
      if (operation != _operation) {
        return;
      }

      await expire();
    }
  }

  /// Revokes the current API token and always clears protected local state.
  Future<void> signOut() async {
    _operation += 1;
    final session = _session;

    try {
      if (session != null) {
        await _tokenExchangeClient.revoke(_configuration, session.apiToken);
      }
    } on Object {
      // Remote revocation is best effort; local credentials must still go.
    } finally {
      _session = null;
      try {
        await _sessionStore.delete(_configuration);
        emit(const MobileAuthState());
      } on Object {
        emit(
          const MobileAuthState(
            status: MobileAuthStatus.failed,
            failure: MobileAuthFailure(code: MobileAuthFailureCode.storage),
          ),
        );
      }
    }
  }

  /// Clears a rejected session and emits a stable expiry state.
  Future<void> expire() async {
    _operation += 1;
    _session = null;
    try {
      await _sessionStore.delete(_configuration);
      emit(
        const MobileAuthState(
          status: MobileAuthStatus.expired,
          failure: MobileAuthFailure(code: MobileAuthFailureCode.expired),
        ),
      );
    } on Object {
      emit(
        const MobileAuthState(
          status: MobileAuthStatus.failed,
          failure: MobileAuthFailure(code: MobileAuthFailureCode.storage),
        ),
      );
    }
  }

  /// Adds a same-origin authorization interceptor to an API client.
  void attachTo(Dio apiClient) {
    final alreadyAttached = apiClient.interceptors.any(
      (interceptor) => interceptor is AuthSessionInterceptor,
    );

    if (alreadyAttached) {
      return;
    }

    apiClient.interceptors.add(
      AuthSessionInterceptor(
        apiBaseUrl: _configuration.apiBaseUrl,
        session: () => _session,
        onUnauthorized: expire,
      ),
    );
  }

  void _emitFailure(MobileAuthFailureCode code) {
    _session = null;
    emit(
      MobileAuthState(
        status: MobileAuthStatus.failed,
        failure: MobileAuthFailure(
          code: code,
          retriable:
              code == MobileAuthFailureCode.network ||
              code == MobileAuthFailureCode.exchange,
        ),
      ),
    );
  }

  MobileAuthFailureCode _dioFailure(DioException error) =>
      error.type == DioExceptionType.connectionError ||
          error.type == DioExceptionType.connectionTimeout ||
          error.type == DioExceptionType.receiveTimeout ||
          error.type == DioExceptionType.sendTimeout
      ? MobileAuthFailureCode.network
      : MobileAuthFailureCode.exchange;
}
