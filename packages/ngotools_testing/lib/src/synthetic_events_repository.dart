import 'package:ngotools_api/ngotools_api.dart';
import 'package:ngotools_events/ngotools_events.dart';

/// Deterministic, secret-free events used by examples and widget tests.
///
/// Answers are kept in memory. With [readOnly] every answer is rejected like
/// a token without `events:write`.
final class SyntheticEventsRepository implements EventsRepository {
  /// Creates events relative to [today].
  SyntheticEventsRepository({required DateTime today, this.readOnly = false})
    : _today = DateTime(today.year, today.month, today.day) {
    for (final request in [
      _request(_schulung, _technik, MobileAvailabilityStatus.notSet),
      _request(_gottesdienst3, _technik, MobileAvailabilityStatus.available),
      _request(_gottesdienst4, _technik, MobileAvailabilityStatus.notSet),
    ]) {
      _requests[_key(request.event.id, request.service.id)] = request;
    }
  }

  /// Whether answers are rejected.
  final bool readOnly;

  final DateTime _today;
  final Map<String, MobileEventAvailability> _requests = {};

  static const _technik = MobileEventService(id: 1, name: 'Technik');
  static const _moderation = MobileEventService(id: 2, name: 'Moderation');
  static const _band = MobileEventService(id: 3, name: 'Band');
  static const _gottesdienstType = MobileEventType(id: 1, name: 'Gottesdienst');

  static const _gottesdienst1 = 201;
  static const _jugendabend = 202;
  static const _schulung = 203;
  static const _gottesdienst3 = 204;
  static const _gottesdienst4 = 205;

  DateTime _at(int days, int hour, [int minute = 0]) =>
      DateTime(_today.year, _today.month, _today.day + days, hour, minute);

  List<MobileEventSummary> get _events => [
    MobileEventSummary(
      id: _gottesdienst1,
      name: 'Gottesdienst',
      type: _gottesdienstType,
      start: _at(3, 10),
      end: _at(3, 11, 30),
      allDay: false,
      planningCompleted: true,
      myServices: const [_technik],
      availabilityOpen: false,
    ),
    MobileEventSummary(
      id: _jugendabend,
      name: 'Jugendabend',
      start: _at(5, 18),
      end: _at(5, 21),
      allDay: false,
      planningCompleted: false,
      myServices: const [],
      availabilityOpen: false,
    ),
    MobileEventSummary(
      id: _schulung,
      name: 'Mitarbeiterschulung Technik',
      start: _at(9, 9, 30),
      end: _at(9, 16),
      allDay: false,
      planningCompleted: false,
      myServices: const [],
      availabilityOpen: _isOpen(_schulung),
    ),
    MobileEventSummary(
      id: _gottesdienst3,
      name: 'Gottesdienst',
      type: _gottesdienstType,
      start: _at(17, 10),
      end: _at(17, 11, 30),
      allDay: false,
      planningCompleted: false,
      myServices: const [],
      availabilityOpen: _isOpen(_gottesdienst3),
    ),
    MobileEventSummary(
      id: _gottesdienst4,
      name: 'Gottesdienst',
      type: _gottesdienstType,
      start: _at(80, 10),
      end: _at(80, 11, 30),
      allDay: false,
      planningCompleted: false,
      myServices: const [],
      availabilityOpen: _isOpen(_gottesdienst4),
    ),
  ];

  bool _isOpen(int eventId) => _requests.values.any(
    (request) =>
        request.event.id == eventId &&
        request.status == MobileAvailabilityStatus.notSet,
  );

  MobileEventAvailability _request(
    int eventId,
    MobileEventService service,
    MobileAvailabilityStatus status,
  ) => MobileEventAvailability(
    event: _events.firstWhere((event) => event.id == eventId).reference,
    service: service,
    status: status,
  );

  static String _key(int eventId, int serviceId) => '$eventId-$serviceId';

  @override
  Future<List<MobileEventSummary>> listEvents({
    required DateTime from,
    required DateTime to,
  }) async {
    final end = DateTime(to.year, to.month, to.day + 1);

    return _events
        .where(
          (event) => !event.start.isBefore(from) && event.start.isBefore(end),
        )
        .toList(growable: false);
  }

  @override
  Future<MobileEventDetail> getEvent(int eventId) async {
    final summary = _events.firstWhere(
      (event) => event.id == eventId,
      orElse: () => throw MobileApiException(
        MobileApiProblem(code: 'not_found', title: 'Not found', status: 404),
      ),
    );

    if (eventId != _gottesdienst1 && eventId != _schulung) {
      return MobileEventDetail(summary: summary, team: const []);
    }

    final start = summary.start;

    return MobileEventDetail(
      summary: summary,
      details: 'Synthetische Veranstaltung ohne echte Daten.',
      agenda: MobileEventAgenda(
        completed: summary.planningCompleted,
        entries: [
          MobileEventAgendaEntry(
            item: MobileEventAgendaItem(
              id: 1,
              type: 'Custom',
              name: 'Soundcheck',
              children: const [],
            ),
            startsAt: start.subtract(const Duration(minutes: 30)),
            responsible: const [
              MobileEventPerson(name: 'Mira Muster', isMe: true),
            ],
            isMine: true,
          ),
          MobileEventAgendaEntry(
            item: MobileEventAgendaItem(
              id: 2,
              type: 'Custom',
              name: 'Begrüßung',
              children: const [],
            ),
            startsAt: start,
            durationMinutes: 5,
            responsible: const [
              MobileEventPerson(name: 'Lena Probe', isMe: false),
            ],
            isMine: false,
          ),
          MobileEventAgendaEntry(
            item: MobileEventAgendaItem(
              id: 3,
              type: 'Music',
              name: 'Lobpreis',
              children: [
                MobileEventAgendaItem(
                  id: 4,
                  type: 'Song',
                  name: 'Großer Gott, wir loben dich',
                  key: 'G',
                  language: 'de',
                  children: const [],
                ),
                MobileEventAgendaItem(
                  id: 5,
                  type: 'Medley',
                  name: 'Anbetung',
                  children: [
                    MobileEventAgendaItem(
                      id: 6,
                      type: 'Song',
                      name: '10.000 Gründe',
                      key: 'D',
                      children: const [],
                    ),
                  ],
                ),
              ],
            ),
            startsAt: start.add(const Duration(minutes: 5)),
            durationMinutes: 15,
            responsibleService: _band,
            responsible: const [
              MobileEventPerson(name: 'Paul Demo', isMe: false),
            ],
            isMine: false,
          ),
          MobileEventAgendaEntry(
            item: MobileEventAgendaItem(
              id: 7,
              type: 'Custom',
              name: 'Video-Einspieler',
              children: const [],
            ),
            startsAt: start.add(const Duration(minutes: 20)),
            durationMinutes: 5,
            responsibleService: _technik,
            responsible: const [
              MobileEventPerson(name: 'Mira Muster', isMe: true),
            ],
            isMine: true,
          ),
        ],
      ),
      team: [
        MobileEventTeamSlot(
          service: _technik,
          required: 2,
          open: 0,
          members: const [
            MobileEventPerson(name: 'Mira Muster', isMe: true),
            MobileEventPerson(name: 'Jonas Beispiel', isMe: false),
          ],
        ),
        MobileEventTeamSlot(
          service: _moderation,
          required: 1,
          open: 1,
          members: const [],
        ),
      ],
    );
  }

  @override
  Future<List<MobileEventAssignment>> listAssignments() async => [
    MobileEventAssignment(
      id: 301,
      event: _events.first.reference,
      service: _technik,
    ),
  ];

  @override
  Future<List<MobileEventAvailability>> listAvailabilities() async =>
      _requests.values.toList(growable: false)
        ..sort((left, right) => left.event.start.compareTo(right.event.start));

  @override
  Future<MobileEventAvailability> answer(
    MobileEventAvailability request,
    MobileAvailabilityStatus status,
  ) async {
    _rejectIfReadOnly();

    final updated = request.withStatus(status);
    _requests[_key(request.event.id, request.service.id)] = updated;

    return updated;
  }

  @override
  Future<void> withdraw(MobileEventAvailability request) async {
    _rejectIfReadOnly();

    _requests[_key(request.event.id, request.service.id)] = request.withStatus(
      MobileAvailabilityStatus.notSet,
    );
  }

  void _rejectIfReadOnly() {
    if (readOnly) {
      throw MobileApiException(
        MobileApiProblem(code: 'forbidden', title: 'Forbidden', status: 403),
      );
    }
  }
}
