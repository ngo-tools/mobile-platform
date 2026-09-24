import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ngotools_api/ngotools_api.dart';

void main() {
  test('searches contacts with typed pagination and sorting', () async {
    final adapter = _StubHttpClientAdapter((options) {
      return _jsonResponse({
        'data': [
          {
            'id': 41,
            'type': 'person',
            'first_name': 'Erika',
            'last_name': 'Beispiel',
            'email': 'erika@example.invalid',
            'updated_at': '2026-09-23T10:30:00Z',
          },
          {'id': 42, 'type': 'future_contact_type', 'name': 'Kontakt 42'},
        ],
        'meta': {
          'current_page': 2,
          'last_page': 3,
          'per_page': 20,
          'total': 42,
        },
      });
    });
    final api = _api(adapter);

    final page = await api.searchContacts(
      query: '  Erika  ',
      page: 2,
      perPage: 20,
      sort: const [
        MobileContactSort(
          field: MobileContactSortField.updatedAt,
          direction: MobileContactSortDirection.descending,
        ),
        MobileContactSort(field: MobileContactSortField.id),
      ],
    );

    expect(page.page, 2);
    expect(page.perPage, 20);
    expect(page.total, 42);
    expect(page.lastPage, 3);
    expect(page.hasNextPage, isTrue);
    expect(page.items.first.kind, MobileContactKind.person);
    expect(page.items.first.email, 'erika@example.invalid');
    expect(page.items.first.updatedAt, DateTime.utc(2026, 9, 23, 10, 30));
    expect(page.items.last.kind, MobileContactKind.unknown);
    expect(() => page.items.clear(), throwsUnsupportedError);
    final request = adapter.requests.single;
    expect(request.path, '/api/v2/contacts/search');
    expect(request.method, 'POST');
    expect(request.queryParameters, {'page': 2, 'limit': 20});
    expect(jsonDecode(request.data as String), {
      'search': {'value': 'Erika', 'case_sensitive': false},
      'sort': [
        {'field': 'updated_at', 'direction': 'desc'},
        {'field': 'id', 'direction': 'asc'},
      ],
    });

    await api.close();
  });

  test('loads a contact with immutable addresses', () async {
    final adapter = _StubHttpClientAdapter((options) {
      return _jsonResponse({
        'data': {
          'id': 73,
          'type': 'organization',
          'name': 'Beispielverein',
          'active_address_id': 8,
          'addresses': [
            {
              'id': 8,
              'type': 'work',
              'line1': 'Musterweg 1',
              'postal_code': '10115',
              'city': 'Berlin',
              'country': 'DE',
            },
          ],
        },
      });
    });
    final api = _api(adapter);

    final contact = await api.fetchContact(73);

    expect(contact.kind, MobileContactKind.organization);
    expect(contact.name, 'Beispielverein');
    expect(contact.activeAddressId, 8);
    expect(contact.addresses.single.city, 'Berlin');
    expect(() => contact.addresses.clear(), throwsUnsupportedError);
    final request = adapter.requests.single;
    expect(request.path, '/api/v2/contacts/73');
    expect(request.method, 'GET');
    expect(request.queryParameters, {'include': 'addresses'});

    await api.close();
  });

  test('rejects invalid search arguments before issuing a request', () async {
    final adapter = _StubHttpClientAdapter(
      (_) => throw StateError('The request must not be sent.'),
    );
    final api = _api(adapter);

    await expectLater(api.searchContacts(page: 0), throwsArgumentError);
    await expectLater(api.searchContacts(perPage: 101), throwsArgumentError);
    await expectLater(
      api.searchContacts(
        sort: const [
          MobileContactSort(field: MobileContactSortField.name),
          MobileContactSort(field: MobileContactSortField.updatedAt),
          MobileContactSort(field: MobileContactSortField.id),
        ],
      ),
      throwsArgumentError,
    );
    await expectLater(api.fetchContact(0), throwsArgumentError);
    expect(adapter.requests, isEmpty);

    await api.close();
  });

  test(
    'normalizes a denied contact request without exposing details',
    () async {
      final adapter = _StubHttpClientAdapter(
        (_) => _jsonResponse({
          'code': 'feature_disabled',
          'title': 'Contacts unavailable',
          'detail': 'Internal tenant feature context',
        }, 403),
      );
      final api = _api(adapter);

      await expectLater(
        api.searchContacts(),
        throwsA(
          isA<MobileApiException>()
              .having((error) => error.problem.code, 'code', 'feature_disabled')
              .having((error) => error.problem.status, 'status', 403)
              .having(
                (error) => error.toString(),
                'text',
                isNot(contains('tenant')),
              ),
        ),
      );

      await api.close();
    },
  );

  test('rejects invalid pagination metadata at the stable boundary', () async {
    final adapter = _StubHttpClientAdapter(
      (_) => _jsonResponse({
        'data': <Object?>[],
        'meta': {'current_page': 1, 'last_page': 1, 'per_page': 0, 'total': 0},
      }),
    );
    final api = _api(adapter);

    await expectLater(
      api.searchContacts(),
      throwsA(
        isA<MobileApiException>().having(
          (error) => error.problem.code,
          'code',
          'invalid_response',
        ),
      ),
    );

    await api.close();
  });
}

NgoToolsMobileApi _api(_StubHttpClientAdapter adapter) {
  final dio = Dio(BaseOptions(baseUrl: 'https://api.example.invalid'))
    ..httpClientAdapter = adapter;

  return NgoToolsMobileApi.testing(
    dio: dio,
    requestId: () => 'request-contacts-synthetic',
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
