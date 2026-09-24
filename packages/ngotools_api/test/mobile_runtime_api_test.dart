import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ngotools_api/ngotools_api.dart';
import 'package:ngotools_api/src/internal/mobile_api_interceptors.dart';

void main() {
  test('maps generated responses to immutable capabilities', () async {
    final adapter = StubHttpClientAdapter(_successfulResponse);
    final dio = Dio(BaseOptions(baseUrl: 'https://api.example.invalid'))
      ..httpClientAdapter = adapter;
    final api = NgoToolsMobileApi.testing(
      dio: dio,
      requestId: () => 'request-synthetic',
    );

    final capabilities = await api.fetchCapabilities();

    expect(capabilities.schemaVersion, 1);
    expect(capabilities.hasFeature('contacts'), isTrue);
    expect(capabilities.hasPermission('imports:write'), isTrue);
    expect(capabilities.canImport('contacts'), isTrue);
    expect(capabilities.importTypes['contacts']?.maxBatchSize, 250);
    expect(
      () => capabilities.features.add('accounting'),
      throwsUnsupportedError,
    );
    expect(
      adapter.requests.every(
        (request) => request.headers['X-Request-ID'] == 'request-synthetic',
      ),
      isTrue,
    );
    expect(
      adapter.requests.every(
        (request) =>
            request.headers[Headers.acceptHeader] ==
            'application/json, application/problem+json',
      ),
      isTrue,
    );

    await api.close();
  });

  test('retries a transient read exactly once', () async {
    var capabilityAttempts = 0;
    final adapter = StubHttpClientAdapter((options) {
      if (options.path == '/api/v2/capabilities' && capabilityAttempts++ == 0) {
        throw DioException(
          requestOptions: options,
          type: DioExceptionType.connectionError,
        );
      }

      return _successfulResponse(options);
    });
    final dio = Dio(BaseOptions(baseUrl: 'https://api.example.invalid'))
      ..httpClientAdapter = adapter;
    final api = NgoToolsMobileApi.testing(dio: dio);

    final capabilities = await api.fetchCapabilities();

    expect(capabilities.canImport('contacts'), isTrue);
    expect(capabilityAttempts, 2);

    await api.close();
  });

  test('never retries a write request', () async {
    var attempts = 0;
    final adapter = StubHttpClientAdapter((options) {
      attempts += 1;
      throw DioException(
        requestOptions: options,
        type: DioExceptionType.connectionError,
      );
    });
    final dio = Dio(BaseOptions(baseUrl: 'https://api.example.invalid'))
      ..httpClientAdapter = adapter;
    dio.interceptors.add(MobileReadRetryInterceptor(dio));

    await expectLater(
      dio.post<void>('/api/write'),
      throwsA(isA<DioException>()),
    );
    expect(attempts, 1);

    dio.close(force: true);
  });

  test('normalizes validation failures without retaining a raw response', () {
    final options = RequestOptions(
      path: '/api/example',
      headers: {'X-Request-ID': 'request-fallback'},
    );
    final error = DioException.badResponse(
      statusCode: 422,
      requestOptions: options,
      response: Response<Object?>(
        requestOptions: options,
        statusCode: 422,
        headers: Headers.fromMap({
          'x-request-id': ['request-response'],
        }),
        data: {
          'message': 'The given data was invalid.',
          'error_code': 'invalid_import',
          'errors': {
            'email': ['The email must be valid.'],
          },
        },
      ),
    );

    final problem = MobileApiProblemParser.fromDio(error);

    expect(problem.code, 'invalid_import');
    expect(problem.status, 422);
    expect(problem.requestId, 'request-response');
    expect(problem.validationErrors['email'], ['The email must be valid.']);
    expect(problem.toString(), isNot(contains('must be valid')));
  });

  test('redacts server error details', () {
    final options = RequestOptions(path: '/api/example');
    final error = DioException.badResponse(
      statusCode: 500,
      requestOptions: options,
      response: Response<Object?>(
        requestOptions: options,
        statusCode: 500,
        data: {
          'code': 'database_connection_failed',
          'title': 'Database connection failed',
          'detail': 'Secret internal exception and stack trace',
          'errors': {
            'query': ['select secret from internal_table'],
          },
        },
      ),
    );

    final problem = MobileApiProblemParser.fromDio(error);

    expect(problem.code, 'server_error');
    expect(problem.title, 'Server error');
    expect(problem.type, isNull);
    expect(problem.detail, isNull);
    expect(problem.instance, isNull);
    expect(problem.validationErrors, isEmpty);
    expect(problem.retriable, isFalse);
  });

  test('emits capability invalidation for an unrelated 403', () async {
    final invalidations = StreamController<void>.broadcast();
    final dio = Dio(BaseOptions(baseUrl: 'https://api.example.invalid'))
      ..httpClientAdapter = StubHttpClientAdapter(
        (options) => _jsonResponse({'code': 'feature_disabled'}, 403),
      );
    dio.interceptors.add(MobileProblemInterceptor(invalidations));
    final invalidation = expectLater(invalidations.stream, emits(null));

    await expectLater(
      dio.get<void>('/api/domain-resource'),
      throwsA(
        isA<DioException>().having(
          (error) => error.error,
          'normalized error',
          isA<MobileApiException>(),
        ),
      ),
    );
    await invalidation;

    dio.close(force: true);
    await invalidations.close();
  });

  test('refreshes the capability store after invalidation', () async {
    final invalidations = StreamController<void>.broadcast();
    var capabilityLoads = 0;
    final adapter = StubHttpClientAdapter((options) {
      if (options.path == '/api/v2/capabilities') {
        capabilityLoads += 1;
      }

      return _successfulResponse(options);
    });
    final dio = Dio(BaseOptions(baseUrl: 'https://api.example.invalid'))
      ..httpClientAdapter = adapter;
    final api = NgoToolsMobileApi.testing(
      dio: dio,
      capabilityInvalidations: invalidations,
    );
    final cubit = MobileCapabilitiesCubit(api);

    await cubit.load();
    invalidations.add(null);
    await _waitFor(() => capabilityLoads == 2);

    expect(cubit.state.status, MobileCapabilitiesStatus.ready);
    expect(cubit.state.capabilities?.canImport('contacts'), isTrue);

    await cubit.close();
    await api.close();
    await invalidations.close();
  });
}

Future<ResponseBody> _successfulResponse(RequestOptions options) async {
  if (options.path == '/api/me') {
    return _jsonResponse({
      'user': {
        'id': 42,
        'name': 'Synthetic Tester',
        'email': 'tester@example.invalid',
      },
      'permissions': ['contacts:read', 'imports:write'],
      'features': ['contacts'],
    });
  }

  if (options.path == '/api/v2/capabilities') {
    return _jsonResponse({
      'data': {
        'schema_version': 1,
        'features': ['contacts'],
        'imports': {
          'enabled': true,
          'types': {
            'contacts': {
              'label': 'Contacts',
              'supported': true,
              'required_feature': 'contacts',
              'feature_enabled': true,
              'permission_granted': true,
              'available': true,
              'requires': ['contacts'],
              'batch_import_supported': true,
              'blockers': <Object?>[],
              'limits': {'max_batch_size': 250},
            },
          },
        },
      },
    });
  }

  return _jsonResponse({'code': 'not_found'}, 404);
}

ResponseBody _jsonResponse(Object body, [int statusCode = 200]) =>
    ResponseBody.fromString(
      jsonEncode(body),
      statusCode,
      headers: {
        Headers.contentTypeHeader: [Headers.jsonContentType],
      },
    );

Future<void> _waitFor(bool Function() condition) async {
  for (var attempt = 0; attempt < 50; attempt += 1) {
    if (condition()) {
      return;
    }

    await Future<void>.delayed(const Duration(milliseconds: 10));
  }

  fail('Condition was not met in time.');
}

final class StubHttpClientAdapter implements HttpClientAdapter {
  StubHttpClientAdapter(this._handler);

  final FutureOr<ResponseBody> Function(RequestOptions options) _handler;
  final List<RequestOptions> requests = [];

  @override
  void close({bool force = false}) {}

  @override
  Future<ResponseBody> fetch(
    RequestOptions options,
    Stream<Uint8List>? requestStream,
    Future<void>? cancelFuture,
  ) async {
    requests.add(options);

    return _handler(options);
  }
}
