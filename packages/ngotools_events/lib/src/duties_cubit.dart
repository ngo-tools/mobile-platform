import 'package:bloc/bloc.dart';
import 'package:ngotools_api/ngotools_api.dart';

import 'availability_answers.dart';
import 'events_failure.dart';
import 'events_repository.dart';

/// Observable lifecycle of the duties overview.
enum DutiesStatus { initial, loading, ready, failure }

/// Immutable state emitted by [DutiesCubit].
final class DutiesState {
  /// Creates duties state.
  DutiesState({
    this.status = DutiesStatus.initial,
    Iterable<MobileEventAssignment> assignments = const [],
    Iterable<MobileEventAvailability> requests = const [],
    Set<String> pending = const {},
    this.readOnly = false,
    this.failure,
    this.answerFailure,
    this.lastAnswer,
  }) : assignments = List.unmodifiable(assignments),
       requests = List.unmodifiable(requests),
       pending = Set.unmodifiable(pending);

  /// Current lifecycle.
  final DutiesStatus status;

  /// Own assignments ordered by event start.
  final List<MobileEventAssignment> assignments;

  /// Availability requests ordered by event start.
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

  /// Requests that still need an answer.
  List<MobileEventAvailability> get openRequests => requests
      .where((request) => request.status == MobileAvailabilityStatus.notSet)
      .toList(growable: false);

  /// Requests that were already answered.
  List<MobileEventAvailability> get answeredRequests => requests
      .where((request) => request.status != MobileAvailabilityStatus.notSet)
      .toList(growable: false);

  /// Returns a copy with the given fields replaced.
  DutiesState copyWith({
    DutiesStatus? status,
    Iterable<MobileEventAssignment>? assignments,
    Iterable<MobileEventAvailability>? requests,
    Set<String>? pending,
    bool? readOnly,
    EventsFailureCode? failure,
    EventsFailureCode? answerFailure,
    MobileAvailabilityStatus? lastAnswer,
  }) => DutiesState(
    status: status ?? this.status,
    assignments: assignments ?? this.assignments,
    requests: requests ?? this.requests,
    pending: pending ?? this.pending,
    readOnly: readOnly ?? this.readOnly,
    failure: failure,
    answerFailure: answerFailure,
    lastAnswer: lastAnswer,
  );
}

/// Coordinates own assignments and availability answers.
final class DutiesCubit extends Cubit<DutiesState> {
  /// Creates a duties Cubit.
  DutiesCubit({required EventsRepository repository})
    : _repository = repository,
      super(DutiesState());

  final EventsRepository _repository;
  int _generation = 0;

  /// Loads assignments and availability requests.
  Future<void> load() async {
    final generation = ++_generation;
    emit(state.copyWith(status: DutiesStatus.loading));

    try {
      final assignments = await _repository.listAssignments();
      final requests = await _repository.listAvailabilities();

      if (generation != _generation || isClosed) {
        return;
      }

      emit(
        state.copyWith(
          status: DutiesStatus.ready,
          assignments: assignments,
          requests: requests,
        ),
      );
    } on Object catch (error) {
      if (generation != _generation || isClosed) {
        return;
      }

      emit(
        state.copyWith(
          status: DutiesStatus.failure,
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
