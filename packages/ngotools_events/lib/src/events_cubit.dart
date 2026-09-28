import 'package:bloc/bloc.dart';
import 'package:ngotools_api/ngotools_api.dart';

import 'events_failure.dart';
import 'events_repository.dart';

/// Adds calendar days, keeping midnight across daylight saving changes.
DateTime addDays(DateTime day, int days) =>
    DateTime(day.year, day.month, day.day + days);

/// Observable lifecycle of the event list.
enum EventsStatus { initial, loading, ready, loadingMore, failure }

/// Immutable state emitted by [EventsCubit].
final class EventsState {
  /// Creates event-list state.
  EventsState({
    required this.from,
    this.status = EventsStatus.initial,
    Iterable<MobileEventSummary> events = const [],
    this.days = EventsCubit.initialDays,
    this.onlyMine = false,
    this.failure,
  }) : events = List.unmodifiable(events);

  /// Current lifecycle.
  final EventsStatus status;

  /// Loaded events ordered by start.
  final List<MobileEventSummary> events;

  /// First calendar day of the loaded range.
  final DateTime from;

  /// Number of days after [from] that are loaded.
  final int days;

  /// Whether only events with own services or open requests are shown.
  final bool onlyMine;

  /// The last failure, if [status] is [EventsStatus.failure].
  final EventsFailureCode? failure;

  /// Last calendar day of the loaded range.
  DateTime get to => addDays(from, days);

  /// Whether the range can grow by another step.
  bool get canLoadMore => days < EventsCubit.maxDays;

  /// Events after applying [onlyMine].
  List<MobileEventSummary> get visibleEvents => onlyMine
      ? events
            .where(
              (event) => event.myServices.isNotEmpty || event.availabilityOpen,
            )
            .toList(growable: false)
      : events;

  /// Returns a copy with the given fields replaced.
  EventsState copyWith({
    EventsStatus? status,
    Iterable<MobileEventSummary>? events,
    DateTime? from,
    int? days,
    bool? onlyMine,
    EventsFailureCode? failure,
  }) => EventsState(
    status: status ?? this.status,
    events: events ?? this.events,
    from: from ?? this.from,
    days: days ?? this.days,
    onlyMine: onlyMine ?? this.onlyMine,
    failure: failure,
  );
}

/// Loads events for a growing date range while discarding stale responses.
final class EventsCubit extends Cubit<EventsState> {
  /// Creates an event-list Cubit; [today] is injectable for tests.
  EventsCubit({
    required EventsRepository repository,
    DateTime Function()? today,
  }) : _repository = repository,
       super(EventsState(from: _calendarDay((today ?? DateTime.now)())));

  /// Days loaded initially.
  static const initialDays = 60;

  /// Days added by [loadMore].
  static const stepDays = 60;

  /// Longest range the server accepts.
  static const maxDays = 366;

  final EventsRepository _repository;
  int _generation = 0;

  /// Loads the current range from scratch.
  Future<void> load() => _reload(from: state.from, days: state.days);

  /// Reloads the current range, e.g. after pull-to-refresh.
  Future<void> refresh() => load();

  /// Replaces the range with [days] days starting at [from].
  Future<void> changeRange({required DateTime from, required int days}) {
    if (days < 0 || days > maxDays) {
      throw ArgumentError.value(
        days,
        'days',
        'Must be between 0 and $maxDays.',
      );
    }

    return _reload(from: _calendarDay(from), days: days);
  }

  /// Shows only events with own services or open availability requests.
  void showOnlyMine({required bool onlyMine}) =>
      emit(state.copyWith(onlyMine: onlyMine, failure: state.failure));

  /// Extends the range by [stepDays] and appends the additional events.
  Future<void> loadMore() async {
    if (!state.canLoadMore ||
        state.status == EventsStatus.loading ||
        state.status == EventsStatus.loadingMore) {
      return;
    }

    final generation = ++_generation;
    final previous = state;
    final days = (previous.days + stepDays).clamp(0, maxDays);
    emit(previous.copyWith(status: EventsStatus.loadingMore));

    try {
      final more = await _repository.listEvents(
        from: addDays(previous.to, 1),
        to: addDays(previous.from, days),
      );

      if (generation != _generation || isClosed) {
        return;
      }

      emit(
        previous.copyWith(
          status: EventsStatus.ready,
          events: [...previous.events, ...more],
          days: days,
        ),
      );
    } on Object catch (error) {
      if (generation != _generation || isClosed) {
        return;
      }

      emit(
        previous.copyWith(
          status: EventsStatus.failure,
          failure: eventsFailureFor(error),
        ),
      );
    }
  }

  Future<void> _reload({required DateTime from, required int days}) async {
    final generation = ++_generation;
    emit(
      state.copyWith(
        status: EventsStatus.loading,
        from: from,
        days: days,
        events: state.from == from ? state.events : const [],
      ),
    );

    try {
      final events = await _repository.listEvents(
        from: from,
        to: addDays(from, days),
      );

      if (generation != _generation || isClosed) {
        return;
      }

      emit(state.copyWith(status: EventsStatus.ready, events: events));
    } on Object catch (error) {
      if (generation != _generation || isClosed) {
        return;
      }

      emit(
        state.copyWith(
          status: EventsStatus.failure,
          failure: eventsFailureFor(error),
        ),
      );
    }
  }

  static DateTime _calendarDay(DateTime value) =>
      DateTime(value.year, value.month, value.day);
}
