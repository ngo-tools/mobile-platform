import 'dart:async';

import 'package:dio/dio.dart';

import '../mobile_api_problem.dart';

const capabilityRefreshExtra = 'ngotools.capability_refresh';
const retryCountExtra = 'ngotools.retry_count';

final class MobileRequestMetadataInterceptor extends Interceptor {
  MobileRequestMetadataInterceptor(this._nextRequestId);

  final String Function() _nextRequestId;

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    options.headers.putIfAbsent('X-Request-ID', _nextRequestId);
    options.headers.putIfAbsent(
      Headers.acceptHeader,
      () => 'application/json, application/problem+json',
    );
    handler.next(options);
  }
}

final class MobileReadRetryInterceptor extends Interceptor {
  MobileReadRetryInterceptor(this._dio);

  final Dio _dio;

  @override
  Future<void> onError(
    DioException err,
    ErrorInterceptorHandler handler,
  ) async {
    final options = err.requestOptions;
    final retryCount = options.extra[retryCountExtra] as int? ?? 0;

    if (!_isSafeMethod(options.method) ||
        retryCount > 0 ||
        !_isTransient(err.type)) {
      handler.next(err);

      return;
    }

    options.extra[retryCountExtra] = retryCount + 1;

    try {
      handler.resolve(await _dio.fetch<Object?>(options));
    } on DioException catch (retryError) {
      handler.next(retryError);
    }
  }

  bool _isSafeMethod(String method) =>
      const {'GET', 'HEAD', 'OPTIONS'}.contains(method.toUpperCase());

  bool _isTransient(DioExceptionType type) => const {
    DioExceptionType.connectionError,
    DioExceptionType.connectionTimeout,
    DioExceptionType.sendTimeout,
    DioExceptionType.receiveTimeout,
  }.contains(type);
}

final class MobileProblemInterceptor extends Interceptor {
  MobileProblemInterceptor(this._capabilityInvalidations);

  final StreamController<void> _capabilityInvalidations;

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    if (err.response?.statusCode == 403 &&
        err.requestOptions.extra[capabilityRefreshExtra] != true) {
      _capabilityInvalidations.add(null);
    }

    handler.next(
      err.copyWith(
        error: MobileApiException(MobileApiProblemParser.fromDio(err)),
      ),
    );
  }
}

abstract final class MobileApiProblemParser {
  static MobileApiProblem fromDio(DioException error) {
    final status = error.response?.statusCode ?? 0;
    final body = _body(error.response?.data);
    final requestId =
        _string(body['request_id']) ??
        error.response?.headers.value('x-request-id') ??
        _string(error.requestOptions.headers['X-Request-ID']);
    final isServerError = status >= 500;

    return MobileApiProblem(
      code: isServerError ? 'server_error' : _code(body, status, error.type),
      title: isServerError
          ? 'Server error'
          : _string(body['title']) ??
                _string(body['message']) ??
                _fallbackTitle(status),
      status: status,
      type: isServerError ? null : _uri(body['type']),
      detail: isServerError ? null : _string(body['detail']),
      instance: isServerError ? null : _uri(body['instance']),
      requestId: requestId,
      retryAfter: _retryAfter(error.response?.headers.value('retry-after')),
      retriable: _isRetriable(status, error.type),
      validationErrors: isServerError
          ? const {}
          : _validationErrors(body['errors']),
    );
  }

  static Map<String, Object?> _body(Object? value) {
    if (value is! Map) {
      return const {};
    }

    return value.map((key, value) => MapEntry(key.toString(), value));
  }

  static String _code(
    Map<String, Object?> body,
    int status,
    DioExceptionType type,
  ) {
    final explicit = _string(body['code']) ?? _string(body['error_code']);

    if (explicit != null) {
      return explicit;
    }

    if (type != DioExceptionType.badResponse) {
      return 'network_error';
    }

    return switch (status) {
      401 => 'unauthorized',
      403 => 'forbidden',
      422 => 'validation_failed',
      429 => 'rate_limited',
      >= 500 => 'server_error',
      _ => 'request_failed',
    };
  }

  static String _fallbackTitle(int status) => switch (status) {
    0 => 'Network error',
    401 => 'Authentication required',
    403 => 'Access denied',
    422 => 'Validation failed',
    429 => 'Too many requests',
    >= 500 => 'Server error',
    _ => 'Request failed',
  };

  static bool _isRetriable(int status, DioExceptionType type) =>
      type == DioExceptionType.connectionError ||
      type == DioExceptionType.connectionTimeout ||
      type == DioExceptionType.sendTimeout ||
      type == DioExceptionType.receiveTimeout ||
      const {408, 429, 502, 503, 504}.contains(status);

  static Map<String, List<String>> _validationErrors(Object? value) {
    if (value is! Map) {
      return const {};
    }

    final errors = <String, List<String>>{};

    for (final entry in value.entries) {
      final messages = entry.value is Iterable
          ? (entry.value as Iterable)
                .whereType<String>()
                .where((message) => message.isNotEmpty)
                .toList(growable: false)
          : <String>[];

      if (messages.isNotEmpty) {
        errors[entry.key.toString()] = messages;
      }
    }

    return errors;
  }

  static String? _string(Object? value) =>
      value is String && value.isNotEmpty ? value : null;

  static Uri? _uri(Object? value) {
    final string = _string(value);

    return string == null ? null : Uri.tryParse(string);
  }

  static Duration? _retryAfter(String? value) {
    final seconds = int.tryParse(value ?? '');

    return seconds == null || seconds < 0 ? null : Duration(seconds: seconds);
  }
}
