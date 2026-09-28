import 'package:ngotools_api/ngotools_api.dart';

/// Event access used by event state and views.
abstract interface class EventsRepository {
  /// Lists visible events starting between the calendar days [from] and [to].
  Future<List<MobileEventSummary>> listEvents({
    required DateTime from,
    required DateTime to,
  });

  /// Loads one visible event with its agenda and team.
  Future<MobileEventDetail> getEvent(int eventId);

  /// Lists the user's own assignments for today and upcoming events.
  Future<List<MobileEventAssignment>> listAssignments();

  /// Lists upcoming availability requests with the current answer.
  Future<List<MobileEventAvailability>> listAvailabilities();

  /// Stores [status] as the answer to [request].
  Future<MobileEventAvailability> answer(
    MobileEventAvailability request,
    MobileAvailabilityStatus status,
  );

  /// Withdraws the answer to [request].
  Future<void> withdraw(MobileEventAvailability request);
}

/// Events repository backed by the stable NGO.Tools mobile API boundary.
final class NgoToolsEventsRepository implements EventsRepository {
  /// Creates an API-backed repository.
  const NgoToolsEventsRepository(this._api);

  final MobileEventsApi _api;

  @override
  Future<List<MobileEventSummary>> listEvents({
    required DateTime from,
    required DateTime to,
  }) => _api.listEvents(from: from, to: to);

  @override
  Future<MobileEventDetail> getEvent(int eventId) => _api.fetchEvent(eventId);

  @override
  Future<List<MobileEventAssignment>> listAssignments() =>
      _api.listEventAssignments();

  @override
  Future<List<MobileEventAvailability>> listAvailabilities() =>
      _api.listEventAvailabilities();

  @override
  Future<MobileEventAvailability> answer(
    MobileEventAvailability request,
    MobileAvailabilityStatus status,
  ) => _api.answerEventAvailability(
    eventId: request.event.id,
    serviceId: request.service.id,
    status: status,
  );

  @override
  Future<void> withdraw(MobileEventAvailability request) =>
      _api.withdrawEventAvailability(
        eventId: request.event.id,
        serviceId: request.service.id,
      );
}
