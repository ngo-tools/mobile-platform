import 'package:flutter_test/flutter_test.dart';
import 'package:ngotools_api/ngotools_api.dart';
import 'package:ngotools_events/ngotools_events.dart';

import 'support/fake_events_repository.dart';

void main() {
  final shown = event(1, start: DateTime(2026, 10, 4, 10));
  final other = event(2, start: DateTime(2026, 10, 11, 10));

  test('loads the event with its own availability requests only', () async {
    final fake = FakeEventsRepository(
      requests: [request(shown), request(other)],
      details: {1: MobileEventDetail(summary: shown, team: const [])},
    );
    final cubit = EventDetailsCubit(repository: fake, eventId: 1);

    await cubit.load();

    expect(cubit.state.status, EventDetailsStatus.ready);
    expect(cubit.state.event?.summary.id, 1);
    expect(cubit.state.requests.single.event.id, 1);

    await cubit.answer(
      cubit.state.requests.single,
      MobileAvailabilityStatus.available,
    );

    expect(
      cubit.state.requests.single.status,
      MobileAvailabilityStatus.available,
    );

    await cubit.close();
  });

  test('reports an event that is no longer visible', () async {
    final cubit = EventDetailsCubit(
      repository: FakeEventsRepository(),
      eventId: 5,
    );

    await cubit.load();

    expect(cubit.state.status, EventDetailsStatus.failure);
    expect(cubit.state.failure, EventsFailureCode.notFound);

    await cubit.close();
  });
}
