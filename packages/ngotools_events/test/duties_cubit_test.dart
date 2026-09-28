import 'package:flutter_test/flutter_test.dart';
import 'package:ngotools_api/ngotools_api.dart';
import 'package:ngotools_events/ngotools_events.dart';

import 'support/fake_events_repository.dart';

void main() {
  final first = event(1, start: DateTime(2026, 10, 4, 10));
  final second = event(2, start: DateTime(2026, 10, 11, 10));

  FakeEventsRepository repository() => FakeEventsRepository(
    assignments: [
      MobileEventAssignment(id: 9, event: first.reference, service: technik),
    ],
    requests: [
      request(first),
      request(second, MobileAvailabilityStatus.available),
    ],
  );

  test('splits open and answered requests', () async {
    final cubit = DutiesCubit(repository: repository());

    await cubit.load();

    expect(cubit.state.assignments.single.id, 9);
    expect(cubit.state.openRequests.single.event.id, 1);
    expect(cubit.state.answeredRequests.single.event.id, 2);

    await cubit.close();
  });

  test('answers and withdraws a request', () async {
    final fake = repository();
    final cubit = DutiesCubit(repository: fake);
    await cubit.load();

    await cubit.answer(
      cubit.state.openRequests.single,
      MobileAvailabilityStatus.ifNeedsMust,
    );

    expect(cubit.state.openRequests, isEmpty);
    expect(cubit.state.lastAnswer, MobileAvailabilityStatus.ifNeedsMust);

    await cubit.answer(
      cubit.state.requests.first,
      MobileAvailabilityStatus.notSet,
    );

    expect(fake.answers, [
      ('1-1', MobileAvailabilityStatus.ifNeedsMust),
      ('1-1', MobileAvailabilityStatus.notSet),
    ]);
    expect(cubit.state.openRequests.single.event.id, 1);
    expect(cubit.state.pending, isEmpty);

    await cubit.close();
  });

  test('reverts a forbidden answer and becomes read-only', () async {
    final fake = repository()..answerError = problem(403);
    final cubit = DutiesCubit(repository: fake);
    await cubit.load();

    await cubit.answer(
      cubit.state.openRequests.single,
      MobileAvailabilityStatus.available,
    );

    expect(
      cubit.state.openRequests.single.status,
      MobileAvailabilityStatus.notSet,
    );
    expect(cubit.state.readOnly, isTrue);
    expect(cubit.state.answerFailure, EventsFailureCode.forbidden);

    await cubit.answer(
      cubit.state.openRequests.single,
      MobileAvailabilityStatus.available,
    );

    expect(fake.answers, hasLength(1));

    await cubit.close();
  });

  test(
    'reverts an answer for a started event without going read-only',
    () async {
      final fake = repository()..answerError = problem(422);
      final cubit = DutiesCubit(repository: fake);
      await cubit.load();

      await cubit.answer(
        cubit.state.answeredRequests.single,
        MobileAvailabilityStatus.notAvailable,
      );

      expect(
        cubit.state.answeredRequests.single.status,
        MobileAvailabilityStatus.available,
      );
      expect(cubit.state.readOnly, isFalse);
      expect(cubit.state.answerFailure, EventsFailureCode.rejected);

      await cubit.close();
    },
  );

  test('reports a failed load', () async {
    final fake = repository()..listError = problem(0, 'network_error');
    final cubit = DutiesCubit(repository: fake);

    await cubit.load();

    expect(cubit.state.status, DutiesStatus.failure);
    expect(cubit.state.failure, EventsFailureCode.network);

    await cubit.close();
  });
}
