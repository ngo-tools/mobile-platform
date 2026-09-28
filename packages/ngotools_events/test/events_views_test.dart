import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ngotools_api/ngotools_api.dart';
import 'package:ngotools_events/ngotools_events.dart';

import 'support/fake_events_repository.dart';

void main() {
  final today = DateTime(2026, 9, 28);
  final sunday = event(
    1,
    start: DateTime(2026, 10, 4, 10),
    myServices: [technik],
    planningCompleted: true,
  );
  final training = event(
    2,
    name: 'Mitarbeiterschulung',
    start: DateTime(2026, 10, 10, 9, 30),
    availabilityOpen: true,
  );

  MobileEventDetail detail() => MobileEventDetail(
    summary: sunday,
    details: 'Mit Kinderbetreuung.',
    agenda: MobileEventAgenda(
      completed: false,
      entries: [
        MobileEventAgendaEntry(
          item: MobileEventAgendaItem(
            id: 1,
            type: 'Custom',
            name: 'Soundcheck',
            children: const [],
          ),
          startsAt: DateTime(2026, 10, 4, 9, 30),
          responsible: const [MobileEventPerson(name: 'Mira', isMe: true)],
          isMine: true,
        ),
        MobileEventAgendaEntry(
          item: MobileEventAgendaItem(
            id: 2,
            type: 'Music',
            name: 'Lobpreis',
            children: [
              MobileEventAgendaItem(
                id: 3,
                type: 'Song',
                name: '10.000 Gründe',
                key: 'D',
                children: const [],
              ),
            ],
          ),
          startsAt: DateTime(2026, 10, 4, 10),
          durationMinutes: 15,
          responsible: const [],
          isMine: false,
        ),
      ],
    ),
    team: [
      MobileEventTeamSlot(
        service: technik,
        required: 2,
        open: 1,
        members: const [MobileEventPerson(name: 'Mira Muster', isMe: true)],
      ),
    ],
  );

  Widget app(Widget child) => MaterialApp(home: Scaffold(body: child));

  testWidgets('lists events by day and opens agenda and team', (tester) async {
    final repository = FakeEventsRepository(
      events: [sunday, training],
      details: {1: detail()},
    );

    await tester.pumpWidget(
      app(
        EventsView(
          repository: repository,
          labels: EventLabels.german,
          today: () => today,
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('SONNTAG, 4. OKTOBER'), findsOneWidget);
    expect(find.text('Du: Technik'), findsOneWidget);
    expect(find.text('Ablauf fertig'), findsOneWidget);
    expect(find.text('Verfügbarkeit offen'), findsOneWidget);

    await tester.tap(find.text('Nur mit mir'));
    await tester.pumpAndSettle();

    expect(find.text('Mitarbeiterschulung'), findsOneWidget);

    await tester.tap(find.text('Gottesdienst').first);
    await tester.pumpAndSettle();

    expect(find.text('Soundcheck'), findsOneWidget);
    expect(find.text('vorher'), findsOneWidget);
    expect(find.text('10.000 Gründe'), findsOneWidget);
    expect(find.text('D'), findsOneWidget);
    expect(find.text('10:15'), findsOneWidget);
    expect(
      find.text('Der Ablauf ist noch ein Entwurf und kann sich ändern.'),
      findsOneWidget,
    );

    await tester.tap(find.text('Team'));
    await tester.pumpAndSettle();

    expect(find.text('1 offen'), findsOneWidget);
    expect(find.text('noch offen'), findsOneWidget);
    expect(find.text('Du'), findsOneWidget);
  });

  testWidgets('answers availability and confirms it', (tester) async {
    final repository = FakeEventsRepository(requests: [request(training)]);

    await tester.pumpWidget(
      app(DutiesView(repository: repository, labels: EventLabels.german)),
    );
    await tester.pumpAndSettle();

    expect(find.text('Du bist aktuell nirgends eingeteilt.'), findsOneWidget);
    expect(find.text('BITTE VERFÜGBARKEIT ANGEBEN · 1'), findsOneWidget);

    await tester.tap(find.text('Ja'));
    await tester.pumpAndSettle();

    expect(find.text('Gespeichert: Du bist dabei.'), findsOneWidget);
    expect(find.text('BEREITS BEANTWORTET'), findsOneWidget);
    expect(find.text('Alles beantwortet – danke!'), findsOneWidget);
    expect(repository.answers.single.$2, MobileAvailabilityStatus.available);
  });

  testWidgets('switches to read-only after a forbidden answer', (tester) async {
    final repository = FakeEventsRepository(requests: [request(training)])
      ..answerError = problem(403);

    await tester.pumpWidget(
      app(DutiesView(repository: repository, labels: EventLabels.german)),
    );
    await tester.pumpAndSettle();
    await tester.tap(find.text('Ja'));
    await tester.pumpAndSettle();

    expect(
      find.text('Du kannst hier keine Verfügbarkeit angeben.'),
      findsOneWidget,
    );
    expect(
      find.text(
        'Du kannst alles ansehen, aber hier keine Verfügbarkeit angeben.',
      ),
      findsOneWidget,
    );

    await tester.tap(find.text('Ja'));
    await tester.pumpAndSettle();

    expect(repository.answers, hasLength(1));
  });
}
