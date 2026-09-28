import 'package:bloc/bloc.dart';
import 'package:ngotools_api/ngotools_api.dart';

import 'availability_answers.dart';
import 'events_failure.dart';
import 'events_repository.dart';

/// Observable lifecycle of one event.
enum EventDetailsStatus { initial, loading, ready, failure }

/// Immutable state emitted by [EventDetailsCubit].
final class EventDetailsState {
  /// Creates event state.
  EventDetailsState({
    this.status = EventDetailsStatus.initial,
    this.event,
    Iterable<MobileEventAvailability> requests = const [],
    Set<String> pending = const {},
    this.readOnly = false,
    this.failure,
    this.answerFailure,
    this.lastAnswer,
  }) : requests = List.unmodifiable(requests),
       pending = Set.unmodifiable(pending);

  /// Current lifecycle.
  final EventDetailsStatus status;

  /// The loaded event.
  final MobileEventDetail? event;

  /// Availability requests of this event.
  final List<MobileEventAvailability> requests;

  /// Keys of requests whose answer is being sent.
  final Set<String> pending;

  /// Whether answering is denied for this session.
  final bool readOnly;

  /// Why loading failed.
  final EventsFailureCode? failure;

  /// Why the last answer was rejected.
  final EventsFailureCode? answerFailure;

  /// The last confirmed answer, for a short confirmation.
  final MobileAvailabilityStatus? lastAnswer;

  /// Returns a copy with the given fields replaced.
  EventDetailsState copyWith({
    EventDetailsStatus? status,
    MobileEventDetail? event,
    Iterable<MobileEventAvailability>? requests,
    Set<String>? pending,
    bool? readOnly,
    EventsFailureCode? failure,
    EventsFailureCode? answerFailure,
    MobileAvailabilityStatus? lastAnswer,
  }) => EventDetailsState(
    status: status ?? this.status,
    event: event ?? this.event,
    requests: requests ?? this.requests,
    pending: pending ?? this.pending,
    readOnly: readOnly ?? this.readOnly,
    failure: failure,
    answerFailure: answerFailure,
    lastAnswer: lastAnswer,
  );
}

/// Loads one event with its open availability requests.
final class EventDetailsCubit extends Cubit<EventDetailsState> {
  /// Creates a Cubit for [eventId].
  EventDetailsCubit({
    required EventsRepository repository,
    required this.eventId,
  }) : _repository = repository,
       super(EventDetailsState());

  /// The event shown.
  final int eventId;

  final EventsRepository _repository;

  /// Loads the event and its availability requests.
  Future<void> load() async {
    emit(state.copyWith(status: EventDetailsStatus.loading));

    try {
      final event = await _repository.getEvent(eventId);
      final requests = await _repository.listAvailabilities();

      if (isClosed) {
        return;
      }

      emit(
        state.copyWith(
          status: EventDetailsStatus.ready,
          event: event,
          requests: requests.where((request) => request.event.id == eventId),
        ),
      );
    } on Object catch (error) {
      if (isClosed) {
        return;
      }

      emit(
        state.copyWith(
          status: EventDetailsStatus.failure,
          failure: eventsFailureFor(error),
        ),
      );
    }
  }

  /// Answers [request] with [status]; [MobileAvailabilityStatus.notSet]
  /// withdraws the answer.
  Future<void> answer(
    MobileEventAvailability request,
    MobileAvailabilityStatus status,
  ) async {
    final key = availabilityKey(request);

    if (state.readOnly || state.pending.contains(key)) {
      return;
    }

    emit(
      state.copyWith(
        requests: replaceAvailability(
          state.requests,
          request.withStatus(status),
        ),
        pending: {...state.pending, key},
      ),
    );

    final result = await submitAvailability(
      repository: _repository,
      request: request,
      status: status,
    );

    if (isClosed) {
      return;
    }

    final failure = result.failure;

    emit(
      state.copyWith(
        requests: replaceAvailability(state.requests, result.request),
        pending: {...state.pending}..remove(key),
        readOnly: state.readOnly || failure == EventsFailureCode.forbidden,
        answerFailure: failure,
        lastAnswer: failure == null ? status : null,
      ),
    );
  }
}
