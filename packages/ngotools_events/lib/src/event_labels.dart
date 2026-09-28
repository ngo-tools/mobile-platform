import 'package:ngotools_api/ngotools_api.dart';

import 'events_failure.dart';

/// Localized texts and date formats of the events module.
final class EventLabels {
  /// Creates labels.
  const EventLabels({
    required this.all,
    required this.onlyMine,
    required this.refresh,
    required this.range,
    required this.rangeHint,
    required this.rangeNext30,
    required this.rangeNext60,
    required this.rangeNext90,
    required this.rangePast30,
    required this.loadMore,
    required this.noEventsTitle,
    required this.noEventsMessage,
    required this.noOwnEventsMessage,
    required this.allDay,
    required this.youServe,
    required this.availabilityOpen,
    required this.agendaFinal,
    required this.agendaDraft,
    required this.agendaTab,
    required this.teamTab,
    required this.infoTab,
    required this.noAgendaTitle,
    required this.noAgendaMessage,
    required this.draftNotice,
    required this.beforeStart,
    required this.agendaSection,
    required this.beforeStartSection,
    required this.end,
    required this.noTeamTitle,
    required this.noTeamMessage,
    required this.openPlaces,
    required this.staffed,
    required this.stillOpen,
    required this.namesOnly,
    required this.me,
    required this.noDetails,
    required this.areYouIn,
    required this.service,
    required this.available,
    required this.ifNeedsMust,
    required this.notAvailable,
    required this.withdraw,
    required this.assigned,
    required this.noAssignments,
    required this.pleaseAnswer,
    required this.allAnswered,
    required this.answered,
    required this.readOnlyNotice,
    required this.savedAvailable,
    required this.savedIfNeedsMust,
    required this.savedNotAvailable,
    required this.withdrawn,
    required this.retry,
    required this.weekdays,
    required this.shortWeekdays,
    required this.months,
    required this.failureMessages,
    required this.answerFailureMessages,
  });

  /// Filter chip for all events.
  final String all;

  /// Filter chip for events with own services or open requests.
  final String onlyMine;

  /// Refresh action.
  final String refresh;

  /// Range picker title.
  final String range;

  /// Range picker explanation.
  final String rangeHint;

  /// Range option: next 30 days.
  final String rangeNext30;

  /// Range option: next 60 days.
  final String rangeNext60;

  /// Range option: next 90 days.
  final String rangeNext90;

  /// Range option: last 30 days.
  final String rangePast30;

  /// Button that extends the range.
  final String loadMore;

  /// Empty list title.
  final String noEventsTitle;

  /// Empty list message.
  final String noEventsMessage;

  /// Empty list message with the own-events filter.
  final String noOwnEventsMessage;

  /// Marker for whole-day events.
  final String allDay;

  /// Badge for an own service, e.g. "Du: Technik".
  final String Function(String service) youServe;

  /// Badge for an open availability request.
  final String availabilityOpen;

  /// Badge for a final agenda.
  final String agendaFinal;

  /// Badge for a draft agenda.
  final String agendaDraft;

  /// Agenda tab.
  final String agendaTab;

  /// Team tab.
  final String teamTab;

  /// Details tab.
  final String infoTab;

  /// Title when the event type plans no agenda.
  final String noAgendaTitle;

  /// Message when the event type plans no agenda.
  final String noAgendaMessage;

  /// Notice for draft agendas.
  final String draftNotice;

  /// Caption for items before the start.
  final String beforeStart;

  /// Section header of the main agenda.
  final String agendaSection;

  /// Section header of items before the start.
  final String beforeStartSection;

  /// Label of the computed end.
  final String end;

  /// Title when an event has no services.
  final String noTeamTitle;

  /// Message when an event has no services.
  final String noTeamMessage;

  /// Badge for open places, e.g. "1 offen".
  final String Function(int count) openPlaces;

  /// Badge for a fully staffed service.
  final String staffed;

  /// Placeholder for an open place.
  final String stillOpen;

  /// Hint that only names are shown.
  final String namesOnly;

  /// Marker for the user, e.g. "Du".
  final String me;

  /// Placeholder when an event has no details.
  final String noDetails;

  /// Question on the event page.
  final String areYouIn;

  /// Service caption, e.g. "Dienst: Technik".
  final String Function(String service) service;

  /// Answer: available.
  final String available;

  /// Answer: only if needed.
  final String ifNeedsMust;

  /// Answer: not available.
  final String notAvailable;

  /// Withdraw action.
  final String withdraw;

  /// Section: own assignments.
  final String assigned;

  /// Placeholder without assignments.
  final String noAssignments;

  /// Section: open requests.
  final String pleaseAnswer;

  /// Placeholder when everything is answered.
  final String allAnswered;

  /// Section: answered requests.
  final String answered;

  /// Notice for read-only sessions.
  final String readOnlyNotice;

  /// Confirmation: available.
  final String savedAvailable;

  /// Confirmation: only if needed.
  final String savedIfNeedsMust;

  /// Confirmation: not available.
  final String savedNotAvailable;

  /// Confirmation: answer withdrawn.
  final String withdrawn;

  /// Retry action.
  final String retry;

  /// Weekday names, Monday first.
  final List<String> weekdays;

  /// Short weekday names, Monday first.
  final List<String> shortWeekdays;

  /// Month names, January first.
  final List<String> months;

  /// Loading failure messages.
  final Map<EventsFailureCode, String> failureMessages;

  /// Answer failure messages.
  final Map<EventsFailureCode, String> answerFailureMessages;

  /// "Sonntag, 4. Oktober" in local time.
  String longDay(DateTime value) {
    final local = value.toLocal();

    return '${weekdays[local.weekday - 1]}, ${local.day}. ${months[local.month - 1]}';
  }

  /// "So, 4.10." in local time.
  String shortDay(DateTime value) {
    final local = value.toLocal();

    return '${shortWeekdays[local.weekday - 1]}, ${local.day}.${local.month}.';
  }

  /// "09:30" in local time.
  String time(DateTime value) {
    final local = value.toLocal();

    return '${local.hour.toString().padLeft(2, '0')}:'
        '${local.minute.toString().padLeft(2, '0')}';
  }

  /// Confirmation for [status].
  String confirmation(MobileAvailabilityStatus status) => switch (status) {
    MobileAvailabilityStatus.available => savedAvailable,
    MobileAvailabilityStatus.ifNeedsMust => savedIfNeedsMust,
    MobileAvailabilityStatus.notAvailable => savedNotAvailable,
    MobileAvailabilityStatus.notSet => withdrawn,
  };

  /// Message for a loading failure.
  String failure(EventsFailureCode code) =>
      failureMessages[code] ?? failureMessages[EventsFailureCode.unknown]!;

  /// Message for a rejected answer.
  String answerFailure(EventsFailureCode code) =>
      answerFailureMessages[code] ??
      answerFailureMessages[EventsFailureCode.unknown]!;

  /// German labels.
  static final german = EventLabels(
    all: 'Alle',
    onlyMine: 'Nur mit mir',
    refresh: 'Aktualisieren',
    range: 'Zeitraum',
    rangeHint: 'Es werden höchstens 366 Tage auf einmal geladen.',
    rangeNext30: 'Nächste 30 Tage',
    rangeNext60: 'Nächste 60 Tage',
    rangeNext90: 'Nächste 90 Tage',
    rangePast30: 'Letzte 30 Tage',
    loadMore: 'Weitere Termine laden',
    noEventsTitle: 'Keine Termine',
    noEventsMessage: 'Im gewählten Zeitraum stehen keine Veranstaltungen an.',
    noOwnEventsMessage:
        'Im gewählten Zeitraum bist Du nirgends eingeteilt oder angefragt.',
    allDay: 'ganztägig',
    youServe: (service) => 'Du: $service',
    availabilityOpen: 'Verfügbarkeit offen',
    agendaFinal: 'Ablauf fertig',
    agendaDraft: 'Ablauf-Entwurf',
    agendaTab: 'Ablauf',
    teamTab: 'Team',
    infoTab: 'Infos',
    noAgendaTitle: 'Kein Ablauf',
    noAgendaMessage: 'Für diese Veranstaltung wird kein Ablauf geplant.',
    draftNotice: 'Der Ablauf ist noch ein Entwurf und kann sich ändern.',
    beforeStart: 'vorher',
    agendaSection: 'Ablauf',
    beforeStartSection: 'Vorlauf',
    end: 'Ende',
    noTeamTitle: 'Keine Dienste',
    noTeamMessage: 'Für diese Veranstaltung sind keine Dienste vorgesehen.',
    openPlaces: (count) => '$count offen',
    staffed: 'besetzt',
    stillOpen: 'noch offen',
    namesOnly: 'Es werden nur Namen angezeigt, keine Kontaktdaten.',
    me: 'Du',
    noDetails: 'Keine weiteren Infos.',
    areYouIn: 'Bist Du dabei?',
    service: (service) => 'Dienst: $service',
    available: 'Ja',
    ifNeedsMust: 'Wenn nötig',
    notAvailable: 'Nein',
    withdraw: 'Antwort zurücknehmen',
    assigned: 'Eingeteilt',
    noAssignments: 'Du bist aktuell nirgends eingeteilt.',
    pleaseAnswer: 'Bitte Verfügbarkeit angeben',
    allAnswered: 'Alles beantwortet – danke!',
    answered: 'Bereits beantwortet',
    readOnlyNotice:
        'Du kannst alles ansehen, aber hier keine Verfügbarkeit angeben.',
    savedAvailable: 'Gespeichert: Du bist dabei.',
    savedIfNeedsMust: 'Gespeichert: Wenn nötig.',
    savedNotAvailable: 'Gespeichert: Du kannst nicht.',
    withdrawn: 'Antwort zurückgenommen.',
    retry: 'Erneut versuchen',
    weekdays: const [
      'Montag',
      'Dienstag',
      'Mittwoch',
      'Donnerstag',
      'Freitag',
      'Samstag',
      'Sonntag',
    ],
    shortWeekdays: const ['Mo', 'Di', 'Mi', 'Do', 'Fr', 'Sa', 'So'],
    months: const [
      'Januar',
      'Februar',
      'März',
      'April',
      'Mai',
      'Juni',
      'Juli',
      'August',
      'September',
      'Oktober',
      'November',
      'Dezember',
    ],
    failureMessages: const {
      EventsFailureCode.unauthenticated: 'Bitte melde Dich erneut an.',
      EventsFailureCode.forbidden:
          'Veranstaltungen sind für Dein Konto nicht freigeschaltet.',
      EventsFailureCode.notFound: 'Diese Veranstaltung gibt es nicht mehr.',
      EventsFailureCode.network: 'Keine Verbindung zu NGO.Tools.',
      EventsFailureCode.unknown: 'Die Termine konnten nicht geladen werden.',
    },
    answerFailureMessages: const {
      EventsFailureCode.forbidden:
          'Du kannst hier keine Verfügbarkeit angeben.',
      EventsFailureCode.rejected:
          'Die Veranstaltung hat schon begonnen. Antworten ist nicht mehr möglich.',
      EventsFailureCode.network:
          'Keine Verbindung. Deine Antwort wurde nicht gespeichert.',
      EventsFailureCode.unknown: 'Deine Antwort wurde nicht gespeichert.',
    },
  );

  /// English labels.
  static final english = EventLabels(
    all: 'All',
    onlyMine: 'Only mine',
    refresh: 'Refresh',
    range: 'Period',
    rangeHint: 'At most 366 days are loaded at once.',
    rangeNext30: 'Next 30 days',
    rangeNext60: 'Next 60 days',
    rangeNext90: 'Next 90 days',
    rangePast30: 'Last 30 days',
    loadMore: 'Load more events',
    noEventsTitle: 'No events',
    noEventsMessage: 'There are no events in the selected period.',
    noOwnEventsMessage:
        'You are not scheduled or asked for anything in this period.',
    allDay: 'all day',
    youServe: (service) => 'You: $service',
    availabilityOpen: 'Availability open',
    agendaFinal: 'Agenda final',
    agendaDraft: 'Agenda draft',
    agendaTab: 'Agenda',
    teamTab: 'Team',
    infoTab: 'Info',
    noAgendaTitle: 'No agenda',
    noAgendaMessage: 'This event has no planned agenda.',
    draftNotice: 'The agenda is still a draft and may change.',
    beforeStart: 'before',
    agendaSection: 'Agenda',
    beforeStartSection: 'Before start',
    end: 'End',
    noTeamTitle: 'No services',
    noTeamMessage: 'This event needs no services.',
    openPlaces: (count) => '$count open',
    staffed: 'staffed',
    stillOpen: 'still open',
    namesOnly: 'Only names are shown, no contact details.',
    me: 'You',
    noDetails: 'No further details.',
    areYouIn: 'Are you in?',
    service: (service) => 'Service: $service',
    available: 'Yes',
    ifNeedsMust: 'If needed',
    notAvailable: 'No',
    withdraw: 'Withdraw answer',
    assigned: 'Scheduled',
    noAssignments: 'You are not scheduled for anything.',
    pleaseAnswer: 'Please give your availability',
    allAnswered: 'Everything answered – thank you!',
    answered: 'Already answered',
    readOnlyNotice: 'You can view everything but cannot answer here.',
    savedAvailable: 'Saved: you are in.',
    savedIfNeedsMust: 'Saved: if needed.',
    savedNotAvailable: 'Saved: you cannot.',
    withdrawn: 'Answer withdrawn.',
    retry: 'Try again',
    weekdays: const [
      'Monday',
      'Tuesday',
      'Wednesday',
      'Thursday',
      'Friday',
      'Saturday',
      'Sunday',
    ],
    shortWeekdays: const ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'],
    months: const [
      'January',
      'February',
      'March',
      'April',
      'May',
      'June',
      'July',
      'August',
      'September',
      'October',
      'November',
      'December',
    ],
    failureMessages: const {
      EventsFailureCode.unauthenticated: 'Please sign in again.',
      EventsFailureCode.forbidden: 'Events are not enabled for your account.',
      EventsFailureCode.notFound: 'This event no longer exists.',
      EventsFailureCode.network: 'No connection to NGO.Tools.',
      EventsFailureCode.unknown: 'Events could not be loaded.',
    },
    answerFailureMessages: const {
      EventsFailureCode.forbidden: 'You cannot give your availability here.',
      EventsFailureCode.rejected:
          'The event has already started. Answering is no longer possible.',
      EventsFailureCode.network: 'No connection. Your answer was not saved.',
      EventsFailureCode.unknown: 'Your answer was not saved.',
    },
  );
}
