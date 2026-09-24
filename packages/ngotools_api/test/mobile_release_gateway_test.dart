import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ngotools_api/ngotools_api.dart';

void main() {
  final artifact = MobileReleaseArtifact(
    appId: 'mob_01J00000000000000000000000',
    platform: MobileReleasePlatform.android,
    channel: MobileReleaseChannel.beta,
    version: '1.2.3',
    buildNumber: '42',
    sourceRevision: 'a' * 40,
    artifactSha256: 'b' * 64,
    sdkVersion: '0.1.0-dev.1',
    contractVersion: '2.0.0',
  );

  test('keeps polling credentials private and validates no-store', () async {
    final adapter = StubHttpClientAdapter((options) {
      expect(options.path, '/api/v2/mobile-app-releases');
      expect(jsonDecode(options.data as String), {
        'app_id': artifact.appId,
        'platform': 'android',
        'channel': 'beta',
        'version': artifact.version,
        'build_number': artifact.buildNumber,
        'source_revision': artifact.sourceRevision,
        'artifact_sha256': artifact.artifactSha256,
        'sdk_version': artifact.sdkVersion,
        'contract_version': artifact.contractVersion,
      });

      return _jsonResponse(
        {
          'data': {
            'release_request_id': 'rrq_synthetic',
            'poll_token': 'p' * 64,
            'user_code': 'SYNTHETIC',
            'authorization_url':
                'https://admin.example.invalid/mobile-app-releases/SYNTHETIC',
            'expires_in': 600,
            'poll_interval': 2,
          },
        },
        headers: {
          'cache-control': ['no-store'],
        },
      );
    });
    final dio = Dio(BaseOptions(baseUrl: 'https://api.example.invalid'))
      ..httpClientAdapter = adapter;
    final gateway = MobileReleaseGateway.testing(dio: dio);

    final approval = await gateway.start(artifact);

    expect(approval.authorizationUri.host, 'admin.example.invalid');
    expect(approval.toString(), isNot(contains('p' * 64)));
    expect(approval.toString(), isNot(contains('rrq_synthetic')));

    gateway.close();
  });

  test('respects retry-after and returns only matching approvals', () async {
    var request = 0;
    var now = DateTime.utc(2026, 9, 24, 12);
    final waits = <Duration>[];
    final adapter = StubHttpClientAdapter((options) {
      request += 1;

      if (request == 1) {
        return _startResponse();
      }

      expect(options.path, '/api/v2/mobile-app-releases/rrq_synthetic/poll');
      expect(jsonDecode(options.data as String), {'poll_token': 'p' * 64});

      if (request == 2) {
        return _jsonResponse(
          {'status': 'pending', 'code': 'authorization_pending'},
          statusCode: 202,
          headers: {
            'cache-control': ['no-store'],
            'retry-after': ['7'],
          },
        );
      }

      return _jsonResponse(
        {
          'status': 'approved',
          'release': {
            'id': 'rel_synthetic',
            'app_id': artifact.appId,
            'platform': 'android',
            'channel': 'beta',
            'version': artifact.version,
            'build_number': artifact.buildNumber,
            'status': 'approved',
            'management_url':
                'https://admin.example.invalid/mobile-apps/${artifact.appId}',
          },
        },
        headers: {
          'cache-control': ['no-store'],
        },
      );
    });
    final dio = Dio(BaseOptions(baseUrl: 'https://api.example.invalid'))
      ..httpClientAdapter = adapter;
    final gateway = MobileReleaseGateway.testing(
      dio: dio,
      now: () => now,
      wait: (duration) async {
        waits.add(duration);
        now = now.add(duration);
      },
    );

    final approval = await gateway.start(artifact);
    final release = await gateway.waitForApproval(approval);

    expect(waits, [const Duration(seconds: 2), const Duration(seconds: 7)]);
    expect(release.id, 'rel_synthetic');
    expect(release.managementUri.host, 'admin.example.invalid');

    gateway.close();
  });

  test('normalizes denied approval without retaining server detail', () async {
    var request = 0;
    var now = DateTime.utc(2026, 9, 24, 12);
    final adapter = StubHttpClientAdapter((options) {
      request += 1;

      if (request == 1) {
        return _startResponse();
      }

      return _jsonResponse(
        {
          'code': 'access_denied',
          'detail': 'Internal reviewer identity must never escape.',
        },
        statusCode: 403,
        headers: {
          'cache-control': ['no-store'],
        },
      );
    });
    final dio = Dio(BaseOptions(baseUrl: 'https://api.example.invalid'))
      ..httpClientAdapter = adapter;
    final gateway = MobileReleaseGateway.testing(
      dio: dio,
      now: () => now,
      wait: (duration) async => now = now.add(duration),
    );
    final approval = await gateway.start(artifact);

    await expectLater(
      gateway.waitForApproval(approval),
      throwsA(
        isA<MobileApiException>()
            .having((error) => error.problem.code, 'code', 'access_denied')
            .having(
              (error) => error.toString(),
              'sanitized output',
              isNot(contains('reviewer identity')),
            )
            .having((error) => error.problem.detail, 'detail', isNull),
      ),
    );

    gateway.close();
  });

  test('rejects approval metadata that does not match the artifact', () async {
    var request = 0;
    var now = DateTime.utc(2026, 9, 24, 12);
    final adapter = StubHttpClientAdapter((options) {
      request += 1;

      if (request == 1) {
        return _startResponse();
      }

      return _jsonResponse(
        {
          'status': 'approved',
          'release': {
            'id': 'rel_synthetic',
            'app_id': artifact.appId,
            'platform': 'ios',
            'channel': 'beta',
            'version': artifact.version,
            'build_number': artifact.buildNumber,
            'status': 'approved',
            'management_url':
                'https://admin.example.invalid/mobile-apps/${artifact.appId}',
          },
        },
        headers: {
          'cache-control': ['no-store'],
        },
      );
    });
    final dio = Dio(BaseOptions(baseUrl: 'https://api.example.invalid'))
      ..httpClientAdapter = adapter;
    final gateway = MobileReleaseGateway.testing(
      dio: dio,
      now: () => now,
      wait: (duration) async => now = now.add(duration),
    );
    final approval = await gateway.start(artifact);

    await expectLater(
      gateway.waitForApproval(approval),
      throwsA(
        isA<MobileApiException>().having(
          (error) => error.problem.code,
          'code',
          'invalid_response',
        ),
      ),
    );

    gateway.close();
  });

  test('stops locally at expiry without sending another poll token', () async {
    var requests = 0;
    var now = DateTime.utc(2026, 9, 24, 12);
    final adapter = StubHttpClientAdapter((options) {
      requests += 1;

      return _jsonResponse(
        {
          'data': {
            'release_request_id': 'rrq_synthetic',
            'poll_token': 'p' * 64,
            'user_code': 'SYNTHETIC',
            'authorization_url':
                'https://admin.example.invalid/mobile-app-releases/SYNTHETIC',
            'expires_in': 1,
            'poll_interval': 2,
          },
        },
        headers: {
          'cache-control': ['no-store'],
        },
      );
    });
    final dio = Dio(BaseOptions(baseUrl: 'https://api.example.invalid'))
      ..httpClientAdapter = adapter;
    final gateway = MobileReleaseGateway.testing(
      dio: dio,
      now: () => now,
      wait: (duration) async => now = now.add(duration),
    );
    final approval = await gateway.start(artifact);

    await expectLater(
      gateway.waitForApproval(approval),
      throwsA(
        isA<MobileApiException>().having(
          (error) => error.problem.code,
          'code',
          'expired_release_request',
        ),
      ),
    );
    expect(requests, 1);

    gateway.close();
  });

  test('rejects error responses that could be cached', () async {
    var request = 0;
    var now = DateTime.utc(2026, 9, 24, 12);
    final adapter = StubHttpClientAdapter((options) {
      request += 1;

      if (request == 1) {
        return _startResponse();
      }

      return _jsonResponse({'code': 'access_denied'}, statusCode: 403);
    });
    final dio = Dio(BaseOptions(baseUrl: 'https://api.example.invalid'))
      ..httpClientAdapter = adapter;
    final gateway = MobileReleaseGateway.testing(
      dio: dio,
      now: () => now,
      wait: (duration) async => now = now.add(duration),
    );
    final approval = await gateway.start(artifact);

    await expectLater(
      gateway.waitForApproval(approval),
      throwsA(
        isA<MobileApiException>().having(
          (error) => error.problem.code,
          'code',
          'invalid_response',
        ),
      ),
    );

    gateway.close();
  });
}

ResponseBody _startResponse() => _jsonResponse(
  {
    'data': {
      'release_request_id': 'rrq_synthetic',
      'poll_token': 'p' * 64,
      'user_code': 'SYNTHETIC',
      'authorization_url':
          'https://admin.example.invalid/mobile-app-releases/SYNTHETIC',
      'expires_in': 600,
      'poll_interval': 2,
    },
  },
  headers: {
    'cache-control': ['no-store'],
  },
);

ResponseBody _jsonResponse(
  Object body, {
  int statusCode = 200,
  Map<String, List<String>> headers = const {},
}) => ResponseBody.fromString(
  jsonEncode(body),
  statusCode,
  headers: {
    Headers.contentTypeHeader: [Headers.jsonContentType],
    ...headers,
  },
);

final class StubHttpClientAdapter implements HttpClientAdapter {
  StubHttpClientAdapter(this._handler);

  final FutureOr<ResponseBody> Function(RequestOptions options) _handler;

  @override
  void close({bool force = false}) {}

  @override
  Future<ResponseBody> fetch(
    RequestOptions options,
    Stream<Uint8List>? requestStream,
    Future<void>? cancelFuture,
  ) async => _handler(options);
}
