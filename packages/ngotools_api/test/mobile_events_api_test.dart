import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ngotools_api/ngotools_api.dart';

void main() {
  test('lists events for calendar days with own services', () async {
    final adapter = _StubHttpClientAdapter(
      (options) => _jsonResponse({
        'data': [
          {
            'id': 7,
            'name': 'Gottesdienst',
            'type': {'id': 2, 'name': 'Gottesdienst'},
            'start': '2026-10-04T08:00:00+00:00',
            'end': '2026-10-04T09:30:00+00:00',
            'all_day': false,
            'planning_completed': true,
            'my_services': [
              {'id': 3, 'name': 'Technik'},
            ],
            'availability_open': false,
            'future_field': 'ignored',
          },
          {
            'id': 8,
            'name': 'Gemeindefest',
            'start': '2026-10-17T00:00:00+00:00',
            'end': '2026-10-17T21:59:00+00:00',
            'all_day': true,
            'planning_completed': false,
            'my_services': <Object>[],
            'availability_open': true,
          },
        ],
      }),
    );
    final api = _api(adapter);

    final events = await api.listEvents(
      from: DateTime(2026, 10, 1, 18, 30),
      to: DateTime(2026, 10, 31),
    );

    expect(adapter.requests.single.path, '/api/v2/events');
    expect(adapter.requests.single.queryParameters, {
      'from': '2026-10-01',
      'to': '2026-10-31',
    });
    expect(events, hasLength(2));
    expect(events.first.type?.name, 'Gottesdienst');
    expect(events.first.start, DateTime.utc(2026, 10, 4, 8));
    expect(events.first.myServices.single.name, 'Technik');
    expect(events.last.type, isNull);
    expect(events.last.allDay, isTrue);
    expect(events.last.availabilityOpen, isTrue);
    expect(() => events.first.myServices.clear(), throwsUnsupportedError);

    await api.close();
  });

  test('rejects an inverted date range before sending', () async {
    final adapter = _StubHttpClientAdapter(
      (_) => _jsonResponse({'data': <Object>[]}),
    );
    final api = _api(adapter);

    expect(
      () => api.listEvents(from: DateTime(2026, 10, 2), to: DateTime(2026, 10)),
      throwsArgumentError,
    );
    expect(adapter.requests, isEmpty);

    await api.close();
  });

  test('loads an event with agenda, nested songs and team', () async {
    final adapter = _StubHttpClientAdapter(
      (options) => _jsonResponse({
        'data': {
          'id': 7,
          'name': 'Gottesdienst',
          'start': '2026-10-04T08:00:00+00:00',
          'end': '2026-10-04T09:30:00+00:00',
          'all_day': false,
          'planning_completed': false,
          'my_services': <Object>[],
          'availability_open': true,
          'details': 'Mit Kinderbetreuung.',
          'agenda': {
            'completed': false,
            'items': [
              {
                'id': 1,
                'type': 'Custom',
                'name': 'Soundcheck',
                'items': <Object>[],
                'starts_at': '2026-10-04T07:30:00+00:00',
                'duration_minutes': null,
                'responsible': [
                  {'name': 'Mira Muster', 'is_me': true},
                ],
                'is_mine': true,
              },
              {
                'id': 2,
                'type': 'Music',
                'name': 'Lobpreis',
                'items': [
                  {
                    'id': 3,
                    'type': 'Song',
                    'name': 'Großer Gott, wir loben dich',
                    'key': 'G',
                    'language': 'de',
                    'items': <Object>[],
                  },
                  {
                    'id': 4,
                    'type': 'Medley',
                    'name': 'Anbetung',
                    'items': [
                      {
                        'id': 5,
                        'type': 'Song',
                        'name': '10.000 Gründe',
                        'key': 'D',
                        'items': <Object>[],
                      },
                    ],
                  },
                ],
                'starts_at': '2026-10-04T08:05:00+00:00',
                'duration_minutes': 15,
                'responsible_service': {'id': 9, 'name': 'Band'},
                'responsible': <Object>[],
                'is_mine': false,
              },
            ],
          },
          'team': [
            {
              'service': {'id': 3, 'name': 'Technik'},
              'required': 2,
              'open': 1,
              'members': [
                {'name': 'Technikteam', 'is_me': true},
              ],
            },
          ],
        },
      }),
    );
    final api = _api(adapter);

    final event = await api.fetchEvent(7);

    expect(adapter.requests.single.path, '/api/v2/events/7');
    expect(event.details, 'Mit Kinderbetreuung.');
    expect(event.summary.availabilityOpen, isTrue);
    final agenda = event.agenda!;
    expect(agenda.completed, isFalse);
    expect(agenda.entries.first.isBeforeStart, isTrue);
    expect(agenda.entries.first.isMine, isTrue);
    expect(agenda.entries.last.durationMinutes, 15);
    expect(agenda.entries.last.responsibleService?.name, 'Band');
    expect(agenda.entries.last.item.children.first.key, 'G');
    expect(
      agenda.entries.last.item.children.last.children.single.name,
      '10.000 Gründe',
    );
    expect(event.team.single.open, 1);
    expect(event.team.single.members.single.isMe, isTrue);

    await api.close();
  });

  test('treats an event without planning as having no agenda', () async {
    final adapter = _StubHttpClientAdapter(
      (options) => _jsonResponse({
        'data': {
          'id': 8,
          'name': 'Jugendabend',
          'start': '2026-10-02T16:00:00+00:00',
          'end': '2026-10-02T19:00:00+00:00',
          'all_day': false,
          'planning_completed': false,
          'my_services': <Object>[],
          'availability_open': false,
          'agenda': null,
          'team': <Object>[],
        },
      }),
    );
    final api = _api(adapter);

    final event = await api.fetchEvent(8);

    expect(event.agenda, isNull);
    expect(event.team, isEmpty);

    await api.close();
  });

  test('lists own assignments and availability requests', () async {
    final adapter = _StubHttpClientAdapter(
      (options) => _jsonResponse({
        'data': options.path == '/api/v2/event-assignments'
            ? [
                {
                  'id': 11,
                  'event': _eventReference,
                  'service': {'id': 3, 'name': 'Technik'},
                },
              ]
            : [
                {
                  'event': _eventReference,
                  'service': {'id': 3, 'name': 'Technik'},
                  'status': 'not-set',
                },
                {
                  'event': _eventReference,
                  'service': {'id': 4, 'name': 'Moderation'},
                  'status': 'if-needs-must',
                },
              ],
      }),
    );
    final api = _api(adapter);

    final assignments = await api.listEventAssignments();
    final availabilities = await api.listEventAvailabilities();

    expect(assignments.single.event.name, 'Gottesdienst');
    expect(assignments.single.service.name, 'Technik');
    expect(availabilities.first.status, MobileAvailabilityStatus.notSet);
    expect(availabilities.last.status, MobileAvailabilityStatus.ifNeedsMust);

    await api.close();
  });

  test('answers and withdraws availability', () async {
    final adapter = _StubHttpClientAdapter((options) {
      if (options.method == 'DELETE') {
        return ResponseBody.fromString('', 204);
      }

      return _jsonResponse({
        'data': {
          'event': _eventReference,
          'service': {'id': 3, 'name': 'Technik'},
          'status': 'available',
        },
      });
    });
    final api = _api(adapter);

    final answer = await api.answerEventAvailability(
      eventId: 7,
      serviceId: 3,
      status: MobileAvailabilityStatus.available,
    );
    await api.withdrawEventAvailability(eventId: 7, serviceId: 3);

    expect(answer.status, MobileAvailabilityStatus.available);
    expect(adapter.requests.first.method, 'PUT');
    expect(adapter.requests.first.path, '/api/v2/event-availabilities/7/3');
    expect(jsonDecode(adapter.requests.first.data as String), {
      'status': 'available',
    });
    expect(adapter.requests.last.method, 'DELETE');
    expect(adapter.requests.last.path, '/api/v2/event-availabilities/7/3');
    expect(
      () => api.answerEventAvailability(
        eventId: 7,
        serviceId: 3,
        status: MobileAvailabilityStatus.notSet,
      ),
      throwsArgumentError,
    );

    await api.close();
  });

  test('surfaces a forbidden answer as a sanitized problem', () async {
    final adapter = _StubHttpClientAdapter(
      (options) =>
          _jsonResponse({'message': 'This action is unauthorized.'}, 403),
    );
    final api = _api(adapter);

    await expectLater(
      api.answerEventAvailability(
        eventId: 7,
        serviceId: 3,
        status: MobileAvailabilityStatus.available,
      ),
      throwsA(
        isA<MobileApiException>().having(
          (error) => error.problem.status,
          'status',
          403,
        ),
      ),
    );

    await api.close();
  });

  test('rejects responses with invalid identifiers', () async {
    final adapter = _StubHttpClientAdapter(
      (options) => _jsonResponse({
        'data': [
          {
            'id': 0,
            'event': _eventReference,
            'service': {'id': 3, 'name': 'Technik'},
          },
        ],
      }),
    );
    final api = _api(adapter);

    await expectLater(
      api.listEventAssignments(),
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

const _eventReference = {
  'id': 7,
  'name': 'Gottesdienst',
  'start': '2026-10-04T08:00:00+00:00',
  'end': '2026-10-04T09:30:00+00:00',
  'all_day': false,
};

NgoToolsMobileApi _api(_StubHttpClientAdapter adapter) {
  final dio = Dio(BaseOptions(baseUrl: 'https://api.example.invalid'))
    ..httpClientAdapter = adapter;

  return NgoToolsMobileApi.testing(
    dio: dio,
    requestId: () => 'request-events-synthetic',
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
