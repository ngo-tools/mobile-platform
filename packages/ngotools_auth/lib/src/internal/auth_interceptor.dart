import 'dart:async';

import 'package:dio/dio.dart';

import 'auth_session.dart';

final class AuthSessionInterceptor extends Interceptor {
  AuthSessionInterceptor({
    required Uri apiBaseUrl,
    required AuthSession? Function() session,
    required FutureOr<void> Function() onUnauthorized,
  }) : _apiBaseUrl = apiBaseUrl,
       _session = session,
       _onUnauthorized = onUnauthorized;

  final Uri _apiBaseUrl;
  final AuthSession? Function() _session;
  final FutureOr<void> Function() _onUnauthorized;

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    if (!_hasConfiguredOrigin(options.uri)) {
      handler.reject(
        DioException(
          requestOptions: options,
          type: DioExceptionType.cancel,
          error: StateError(
            'Authentication is restricted to the configured API origin.',
          ),
        ),
      );

      return;
    }

    final session = _session();

    if (session == null) {
      handler.reject(
        DioException(
          requestOptions: options,
          type: DioExceptionType.cancel,
          error: StateError('No authenticated session is available.'),
        ),
      );

      return;
    }

    options.headers['Authorization'] = 'Bearer ${session.apiToken}';
    handler.next(options);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    if (err.response?.statusCode == 401 &&
        _hasConfiguredOrigin(err.requestOptions.uri)) {
      unawaited(Future<void>.sync(_onUnauthorized));
    }

    handler.next(err);
  }

  bool _hasConfiguredOrigin(Uri uri) =>
      uri.scheme == _apiBaseUrl.scheme &&
      uri.host == _apiBaseUrl.host &&
      uri.port == _apiBaseUrl.port;
}
