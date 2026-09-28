import 'package:ngotools_api/ngotools_api.dart';
import 'package:ngotools_events/ngotools_events.dart';

const technik = MobileEventService(id: 1, name: 'Technik');

MobileEventSummary event(
  int id, {
  required DateTime start,
  String name = 'Gottesdienst',
  List<MobileEventService> myServices = const [],
  bool availabilityOpen = false,
  bool planningCompleted = false,
}) => MobileEventSummary(
  id: id,
  name: name,
  type: const MobileEventType(id: 1, name: 'Gottesdienst'),
  start: start,
  end: start.add(const Duration(minutes: 90)),
  allDay: false,
  planningCompleted: planningCompleted,
  myServices: myServices,
  availabilityOpen: availabilityOpen,
);

MobileEventAvailability request(
  MobileEventSummary event, [
  MobileAvailabilityStatus status = MobileAvailabilityStatus.notSet,
]) => MobileEventAvailability(
  event: event.reference,
  service: technik,
  status: status,
);

MobileApiException problem(int status, [String code = 'problem']) =>
    MobileApiException(
      MobileApiProblem(code: code, title: 'Problem', status: status),
    );

final class FakeEventsRepository implements EventsRepository {
  FakeEventsRepository({
    this.events = const [],
    this.assignments = const [],
    this.requests = const [],
    this.details = const {},
  });

  List<MobileEventSummary> events;
  List<MobileEventAssignment> assignments;
  List<MobileEventAvailability> requests;
  Map<int, MobileEventDetail> details;
  Object? listError;
  Object? answerError;
  final List<(DateTime, DateTime)> listCalls = [];
  final List<(String, MobileAvailabilityStatus)> answers = [];

  @override
  Future<List<MobileEventSummary>> listEvents({
    required DateTime from,
    required DateTime to,
  }) async {
    listCalls.add((from, to));

    if (listError != null) {
      throw listError!;
    }

    final end = DateTime(to.year, to.month, to.day + 1);

    return events
        .where((item) => !item.start.isBefore(from) && item.start.isBefore(end))
        .toList();
  }

  @override
  Future<MobileEventDetail> getEvent(int eventId) async =>
      details[eventId] ?? (throw problem(404));

  @override
  Future<List<MobileEventAssignment>> listAssignments() async {
    if (listError != null) {
      throw listError!;
    }

    return assignments;
  }

  @override
  Future<List<MobileEventAvailability>> listAvailabilities() async => requests;

  @override
  Future<MobileEventAvailability> answer(
    MobileEventAvailability request,
    MobileAvailabilityStatus status,
  ) async {
    answers.add(('${request.event.id}-${request.service.id}', status));

    if (answerError != null) {
      throw answerError!;
    }

    return request.withStatus(status);
  }

  @override
  Future<void> withdraw(MobileEventAvailability request) async {
    answers.add((
      '${request.event.id}-${request.service.id}',
      MobileAvailabilityStatus.notSet,
    ));

    if (answerError != null) {
      throw answerError!;
    }
  }
}
