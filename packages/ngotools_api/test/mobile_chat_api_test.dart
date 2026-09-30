import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ngotools_api/ngotools_api.dart';

void main() {
  test('loads the chat account with its homeserver', () async {
    final adapter = _StubHttpClientAdapter(
      (_) => _jsonResponse({
        'data': {
          'status': 'active',
          'available': true,
          'matrix_user_id': '@anna.admin:example.org',
          'server_name': 'example.org',
          'homeserver_url': 'https://matrix-example.chat.ngo.tools',
        },
      }),
    );
    final api = _api(adapter);

    final account = await api.fetchChatAccount();

    expect(adapter.requests.single.path, '/api/v3/chat/account');
    expect(account.status, MobileChatAccountStatus.active);
    expect(account.matrixUserId, '@anna.admin:example.org');
    expect(
      account.homeserverUrl,
      Uri.parse('https://matrix-example.chat.ngo.tools'),
    );
    expect(account.isUsable, isTrue);

    await api.close();
  });

  test('reports withdrawn access without a homeserver', () async {
    final adapter = _StubHttpClientAdapter(
      (_) => _jsonResponse({
        'data': {
          'status': 'locked',
          'available': true,
          'matrix_user_id': null,
          'server_name': 'example.org',
          'homeserver_url': 'https://matrix-example.chat.ngo.tools',
        },
      }),
    );
    final api = _api(adapter);

    final account = await api.fetchChatAccount();

    expect(account.status, MobileChatAccountStatus.locked);
    expect(account.isUsable, isFalse);

    await api.close();
  });

  test('rejects a homeserver without https', () async {
    final adapter = _StubHttpClientAdapter(
      (_) => _jsonResponse({
        'data': {
          'status': 'active',
          'available': true,
          'matrix_user_id': '@anna.admin:example.org',
          'server_name': 'example.org',
          'homeserver_url': 'http://matrix-example.chat.ngo.tools',
        },
      }),
    );
    final api = _api(adapter);

    await expectLater(api.fetchChatAccount(), throwsA(_invalidResponse));

    await api.close();
  });

  test('pages through the address book', () async {
    final adapter = _StubHttpClientAdapter(
      (_) => _jsonResponse({
        'data': [
          {
            'matrix_user_id': '@maria.muster:example.org',
            'display_name': 'Maria Muster',
            'kind': 'contact',
          },
          {
            'matrix_user_id': '@tina.team:example.org',
            'display_name': 'Tina Team',
            'kind': 'team_member',
          },
        ],
        'meta': {'current_page': 1, 'last_page': 2, 'per_page': 2, 'total': 3},
      }),
    );
    final api = _api(adapter);

    final page = await api.listChatPeople(search: ' mar ', perPage: 2);

    expect(adapter.requests.single.path, '/api/v3/chat/people');
    expect(adapter.requests.single.queryParameters, {
      'search': 'mar',
      'page': 1,
      'per_page': 2,
    });
    expect(page.people.map((person) => person.kind), [
      MobileChatPersonKind.contact,
      MobileChatPersonKind.teamMember,
    ]);
    expect(page.hasMore, isTrue);
    expect(page.total, 3);

    await api.close();
  });

  test('signs in, renews and ends the chat session', () async {
    final adapter = _StubHttpClientAdapter(
      (options) => options.method == 'DELETE'
          ? ResponseBody.fromString('', 204)
          : _jsonResponse({
              'data': {
                'matrix_user_id': '@anna.admin:example.org',
                'device_id': 'NGOAPPABCDEFGHIJKLMNOPQRST',
                'access_token': 'mpt_synthetic',
                'expires_at': '2026-10-07T12:00:00+00:00',
                'homeserver_url': 'https://matrix-example.chat.ngo.tools',
                'server_name': 'example.org',
              },
            }, options.path.endsWith('/renew') ? 200 : 201),
    );
    final api = _api(adapter);

    final session = await api.createChatSession(deviceName: 'iPhone 16');
    final renewed = await api.renewChatSession();
    await api.deleteChatSession();

    expect(adapter.requests.map((request) => request.path), [
      '/api/v3/chat/sessions',
      '/api/v3/chat/sessions/current/renew',
      '/api/v3/chat/sessions/current',
    ]);
    expect(jsonDecode(adapter.requests.first.data as String), {
      'device_name': 'iPhone 16',
    });
    expect(session.deviceId, 'NGOAPPABCDEFGHIJKLMNOPQRST');
    expect(session.expiresAt, DateTime.utc(2026, 10, 7, 12));
    expect(renewed.accessToken, 'mpt_synthetic');
    expect(session.toString(), isNot(contains('mpt_synthetic')));

    await api.close();
  });

  test('surfaces the reason a chat session is refused', () async {
    final adapter = _StubHttpClientAdapter(
      (_) => _jsonResponse({
        'message': 'The API token has no chat session.',
        'code': 'no_chat_session',
      }, 404),
    );
    final api = _api(adapter);

    await expectLater(
      api.renewChatSession(),
      throwsA(
        isA<MobileApiException>()
            .having((error) => error.problem.status, 'status', 404)
            .having((error) => error.problem.code, 'code', 'no_chat_session'),
      ),
    );

    await api.close();
  });
}

final _invalidResponse = isA<MobileApiException>().having(
  (error) => error.problem.code,
  'code',
  'invalid_response',
);

NgoToolsMobileApi _api(_StubHttpClientAdapter adapter) {
  final dio = Dio(BaseOptions(baseUrl: 'https://api.example.invalid'))
    ..httpClientAdapter = adapter;

  return NgoToolsMobileApi.testing(
    dio: dio,
    requestId: () => 'request-chat-synthetic',
  );
}

ResponseBody _jsonResponse(Object body, [int statusCode = 200]) =>
    ResponseBody.fromString(
      jsonEncode(body),
      statusCode,
      headers: {
        Headers.contentTypeHeader: [Headers.jsonContentType],
      },
    );

final class _StubHttpClientAdapter implements HttpClientAdapter {
  _StubHttpClientAdapter(this._handler);

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
