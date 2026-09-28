/// Answers a user can give to an availability request.
enum MobileAvailabilityStatus {
  /// The user is available.
  available,

  /// The user is available only if nobody else can serve.
  ifNeedsMust,

  /// The user is not available.
  notAvailable,

  /// The request has not been answered yet.
  notSet,
}

/// Read and answer access to events consumed by feature packages.
abstract interface class MobileEventsApi {
  /// Lists visible events starting between the calendar days [from] and [to].
  ///
  /// Without a range the server returns today and the next 60 days. A range may
  /// span at most 366 days.
  Future<List<MobileEventSummary>> listEvents({DateTime? from, DateTime? to});

  /// Loads one visible event with its agenda and team.
  Future<MobileEventDetail> fetchEvent(int eventId);

  /// Lists the user's own assignments for today and upcoming events.
  Future<List<MobileEventAssignment>> listEventAssignments();

  /// Lists upcoming availability requests with the current answer.
  Future<List<MobileEventAvailability>> listEventAvailabilities();

  /// Stores the user's answer for [serviceId] of the upcoming [eventId].
  Future<MobileEventAvailability> answerEventAvailability({
    required int eventId,
    required int serviceId,
    required MobileAvailabilityStatus status,
  });

  /// Withdraws the user's answer for [serviceId] of the upcoming [eventId].
  Future<void> withdrawEventAvailability({
    required int eventId,
    required int serviceId,
  });
}

/// A service people can be scheduled for, such as sound or moderation.
final class MobileEventService {
  /// Creates a service reference.
  const MobileEventService({required this.id, required this.name});

  /// Stable server identifier.
  final int id;

  /// Display name.
  final String name;
}

/// The type of an event, such as a service or a youth evening.
final class MobileEventType {
  /// Creates an event type reference.
  const MobileEventType({required this.id, required this.name});

  /// Stable server identifier.
  final int id;

  /// Display name.
  final String name;
}

/// A compact reference to an event used by assignments and availability.
final class MobileEventReference {
  /// Creates an event reference.
  const MobileEventReference({
    required this.id,
    required this.name,
    required this.start,
    required this.end,
    required this.allDay,
  });

  /// Stable server identifier.
  final int id;

  /// Display name.
  final String name;

  /// Start instant.
  final DateTime start;

  /// End instant.
  final DateTime end;

  /// Whether the event lasts whole days.
  final bool allDay;
}

/// One entry of the event list.
final class MobileEventSummary {
  /// Creates an event list entry.
  MobileEventSummary({
    required this.id,
    required this.name,
    required this.start,
    required this.end,
    required this.allDay,
    required this.planningCompleted,
    required Iterable<MobileEventService> myServices,
    required this.availabilityOpen,
    this.type,
  }) : myServices = List.unmodifiable(myServices);

  /// Stable server identifier.
  final int id;

  /// Display name.
  final String name;

  /// Event type, if the event has one.
  final MobileEventType? type;

  /// Start instant.
  final DateTime start;

  /// End instant.
  final DateTime end;

  /// Whether the event lasts whole days.
  final bool allDay;

  /// Whether the agenda has been marked as final.
  final bool planningCompleted;

  /// Services the user is scheduled for, directly or through a team.
  final List<MobileEventService> myServices;

  /// Whether the user still has to answer an availability request.
  final bool availabilityOpen;

  /// A reference usable by assignments and availability views.
  MobileEventReference get reference => MobileEventReference(
    id: id,
    name: name,
    start: start,
    end: end,
    allDay: allDay,
  );
}

/// A person in the agenda or the team, exposed by name only.
final class MobileEventPerson {
  /// Creates a named person.
  const MobileEventPerson({required this.name, required this.isMe});

  /// Display name of a contact or a team.
  final String name;

  /// Whether this is the user or one of the user's teams.
  final bool isMe;
}

/// A nested agenda item, such as a song within a music block.
final class MobileEventAgendaItem {
  /// Creates a nested agenda item.
  MobileEventAgendaItem({
    required this.id,
    required this.type,
    required Iterable<MobileEventAgendaItem> children,
    this.name,
    this.key,
    this.language,
  }) : children = List.unmodifiable(children);

  /// Stable server identifier.
  final int id;

  /// Server item type, such as `Song`, `Music` or `Medley`.
  final String type;

  /// Display name; songs use their title.
  final String? name;

  /// Musical key after transposition, if the item is a song.
  final String? key;

  /// Language code of a song, if set.
  final String? language;

  /// Nested items, such as the songs of a medley.
  final List<MobileEventAgendaItem> children;
}

/// A top-level agenda entry with its computed start time.
final class MobileEventAgendaEntry {
  /// Creates a top-level agenda entry.
  MobileEventAgendaEntry({
    required this.item,
    required this.startsAt,
    required Iterable<MobileEventPerson> responsible,
    required this.isMine,
    this.durationMinutes,
    this.responsibleService,
  }) : responsible = List.unmodifiable(responsible);

  /// The agenda item with its nested items.
  final MobileEventAgendaItem item;

  /// Start instant computed like the web plan.
  final DateTime startsAt;

  /// Planned duration; `null` for items before the event starts.
  final int? durationMinutes;

  /// Service responsible for this item, if any.
  final MobileEventService? responsibleService;

  /// People responsible for this item.
  final List<MobileEventPerson> responsible;

  /// Whether the user is responsible for this item.
  final bool isMine;

  /// Whether the item takes place before the event starts.
  bool get isBeforeStart => durationMinutes == null;
}

/// The agenda of an event.
final class MobileEventAgenda {
  /// Creates an agenda.
  MobileEventAgenda({
    required this.completed,
    required Iterable<MobileEventAgendaEntry> entries,
  }) : entries = List.unmodifiable(entries);

  /// Whether planners marked the agenda as final.
  final bool completed;

  /// Entries before the start followed by the main items.
  final List<MobileEventAgendaEntry> entries;
}

/// The staffing of one service at an event.
final class MobileEventTeamSlot {
  /// Creates a staffing slot.
  MobileEventTeamSlot({
    required this.service,
    required this.required,
    required this.open,
    required Iterable<MobileEventPerson> members,
  }) : members = List.unmodifiable(members);

  /// The service.
  final MobileEventService service;

  /// Number of people the service needs.
  final int required;

  /// Number of places that are still open.
  final int open;

  /// Assigned people and teams.
  final List<MobileEventPerson> members;
}

/// An event with details, agenda and team.
final class MobileEventDetail {
  /// Creates event details.
  MobileEventDetail({
    required this.summary,
    required Iterable<MobileEventTeamSlot> team,
    this.details,
    this.agenda,
  }) : team = List.unmodifiable(team);

  /// The list fields of the event.
  final MobileEventSummary summary;

  /// Free-text details.
  final String? details;

  /// The agenda, or `null` if the event type does not plan one.
  final MobileEventAgenda? agenda;

  /// Staffing per service.
  final List<MobileEventTeamSlot> team;
}

/// A service the user is scheduled for at an event.
final class MobileEventAssignment {
  /// Creates an assignment.
  const MobileEventAssignment({
    required this.id,
    required this.event,
    required this.service,
  });

  /// Stable server identifier.
  final int id;

  /// The event.
  final MobileEventReference event;

  /// The service.
  final MobileEventService service;
}

/// An availability request and the user's current answer.
final class MobileEventAvailability {
  /// Creates an availability request.
  const MobileEventAvailability({
    required this.event,
    required this.service,
    required this.status,
  });

  /// The event.
  final MobileEventReference event;

  /// The service the user could serve in.
  final MobileEventService service;

  /// The current answer.
  final MobileAvailabilityStatus status;

  /// Returns a copy with [status].
  MobileEventAvailability withStatus(MobileAvailabilityStatus status) =>
      MobileEventAvailability(event: event, service: service, status: status);
}
