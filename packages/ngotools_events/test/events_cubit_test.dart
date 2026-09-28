import 'package:flutter_test/flutter_test.dart';
import 'package:ngotools_events/ngotools_events.dart';

import 'support/fake_events_repository.dart';

void main() {
  final today = DateTime(2026, 9, 28);

  test('loads today and the next 60 days', () async {
    final repository = FakeEventsRepository(
      events: [
        event(1, start: DateTime(2026, 10, 4, 10)),
        event(2, start: DateTime(2026, 12, 20, 10)),
      ],
    );
    final cubit = EventsCubit(repository: repository, today: () => today);

    await cubit.load();

    expect(repository.listCalls.single, (today, DateTime(2026, 11, 27)));
    expect(cubit.state.status, EventsStatus.ready);
    expect(cubit.state.events.map((item) => item.id), [1]);
    expect(cubit.state.canLoadMore, isTrue);

    await cubit.close();
  });

  test('loads the following 60 days and appends them', () async {
    final repository = FakeEventsRepository(
      events: [
        event(1, start: DateTime(2026, 10, 4, 10)),
        event(2, start: DateTime(2026, 12, 20, 10)),
      ],
    );
    final cubit = EventsCubit(repository: repository, today: () => today);

    await cubit.load();
    await cubit.loadMore();

    expect(repository.listCalls.last, (
      DateTime(2026, 11, 28),
      DateTime(2027, 1, 26),
    ));
    expect(cubit.state.events.map((item) => item.id), [1, 2]);
    expect(cubit.state.days, 120);

    await cubit.close();
  });

  test('stops growing at the 366 days the server accepts', () async {
    final cubit = EventsCubit(
      repository: FakeEventsRepository(),
      today: () => today,
    );

    await cubit.load();

    for (var step = 0; step < 10; step++) {
      await cubit.loadMore();
    }

    expect(cubit.state.days, EventsCubit.maxDays);
    expect(cubit.state.canLoadMore, isFalse);

    await cubit.close();
  });

  test('filters events with own services or open requests', () async {
    final cubit = EventsCubit(
      repository: FakeEventsRepository(
        events: [
          event(1, start: DateTime(2026, 10, 1, 10), myServices: [technik]),
          event(2, start: DateTime(2026, 10, 2, 10)),
          event(3, start: DateTime(2026, 10, 3, 10), availabilityOpen: true),
        ],
      ),
      today: () => today,
    );

    await cubit.load();
    cubit.showOnlyMine(onlyMine: true);

    expect(cubit.state.visibleEvents.map((item) => item.id), [1, 3]);

    await cubit.close();
  });

  test('reports a sanitized failure', () async {
    final repository = FakeEventsRepository()..listError = problem(403);
    final cubit = EventsCubit(repository: repository, today: () => today);

    await cubit.load();

    expect(cubit.state.status, EventsStatus.failure);
    expect(cubit.state.failure, EventsFailureCode.forbidden);

    await cubit.close();
  });
}
