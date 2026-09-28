import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ngotools_api/ngotools_api.dart';
import 'package:ngotools_design_system/ngotools_design_system.dart';

import 'availability_answers.dart';
import 'event_details_cubit.dart';
import 'event_labels.dart';
import 'event_widgets.dart';
import 'events_repository.dart';

/// One event with agenda, team and details.
final class EventDetailsPage extends StatefulWidget {
  /// Creates the page for [eventId].
  const EventDetailsPage({
    required this.repository,
    required this.eventId,
    required this.labels,
    this.title,
    super.key,
  });

  /// Event access.
  final EventsRepository repository;

  /// The event.
  final int eventId;

  /// Texts and formats.
  final EventLabels labels;

  /// Title shown while the event loads.
  final String? title;

  @override
  State<EventDetailsPage> createState() => _EventDetailsPageState();
}

final class _EventDetailsPageState extends State<EventDetailsPage> {
  late final EventDetailsCubit _cubit;

  @override
  void initState() {
    super.initState();
    _cubit = EventDetailsCubit(
      repository: widget.repository,
      eventId: widget.eventId,
    );
    unawaited(_cubit.load());
  }

  @override
  void dispose() {
    unawaited(_cubit.close());
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => BlocProvider.value(
    value: _cubit,
    child: BlocConsumer<EventDetailsCubit, EventDetailsState>(
      listenWhen: (previous, current) =>
          current.lastAnswer != null || current.answerFailure != null,
      listener: (context, state) {
        final failure = state.answerFailure;
        final message = failure == null
            ? widget.labels.confirmation(state.lastAnswer!)
            : widget.labels.answerFailure(failure);

        ScaffoldMessenger.of(context)
          ..hideCurrentSnackBar()
          ..showSnackBar(SnackBar(content: Text(message)));
      },
      builder: (context, state) {
        final event = state.event;

        return DefaultTabController(
          length: 3,
          child: Scaffold(
            appBar: AppBar(
              title: Text(event?.summary.name ?? widget.title ?? ''),
              bottom: event == null
                  ? null
                  : TabBar(
                      tabs: [
                        Tab(text: widget.labels.agendaTab),
                        Tab(text: widget.labels.teamTab),
                        Tab(text: widget.labels.infoTab),
                      ],
                    ),
            ),
            body: _body(state),
          ),
        );
      },
    ),
  );

  Widget _body(EventDetailsState state) {
    final labels = widget.labels;
    final event = state.event;

    if (event == null) {
      if (state.status == EventDetailsStatus.failure) {
        return NgoToolsEmptyState(
          icon: Icons.cloud_off_outlined,
          title: labels.failure(state.failure!),
          message: '',
          action: FilledButton(
            onPressed: _cubit.load,
            child: Text(labels.retry),
          ),
        );
      }

      return const Center(child: CircularProgressIndicator());
    }

    final header = _EventHeader(event: event.summary, labels: labels);
    final requests = [
      if (state.readOnly && state.requests.isNotEmpty)
        Padding(
          padding: const EdgeInsets.only(bottom: NgoToolsLayout.compactSpacing),
          child: NgoToolsStatusBanner(message: labels.readOnlyNotice),
        ),
      for (final request in state.requests)
        AvailabilityRequestCard(
          request: request,
          labels: labels,
          compact: true,
          readOnly: state.readOnly,
          pending: state.pending.contains(availabilityKey(request)),
          onAnswer: (status) => unawaited(_cubit.answer(request, status)),
        ),
    ];

    return TabBarView(
      children: [
        _tab([header, ...requests, ..._agenda(event.agenda)]),
        _tab([header, ...requests, ..._team(event.team)]),
        _tab([
          header,
          ...requests,
          Text(
            event.details?.trim().isNotEmpty == true
                ? event.details!.trim()
                : labels.noDetails,
          ),
        ]),
      ],
    );
  }

  Widget _tab(List<Widget> children) => RefreshIndicator(
    onRefresh: _cubit.load,
    child: ListView(
      physics: const AlwaysScrollableScrollPhysics(),
      padding: const EdgeInsets.all(NgoToolsLayout.spacing),
      children: children,
    ),
  );

  List<Widget> _agenda(MobileEventAgenda? agenda) {
    final labels = widget.labels;

    if (agenda == null) {
      return [
        NgoToolsEmptyState(
          icon: Icons.notes_outlined,
          title: labels.noAgendaTitle,
          message: labels.noAgendaMessage,
        ),
      ];
    }

    final before = agenda.entries.where((entry) => entry.isBeforeStart);
    final main = agenda.entries.where((entry) => !entry.isBeforeStart).toList();
    final last = main.isEmpty ? null : main.last;
    final end = last?.startsAt.add(
      Duration(minutes: last.durationMinutes ?? 0),
    );

    return [
      if (!agenda.completed)
        Padding(
          padding: const EdgeInsets.only(bottom: NgoToolsLayout.compactSpacing),
          child: NgoToolsStatusBanner(
            status: NgoToolsStatus.warning,
            message: labels.draftNotice,
          ),
        ),
      if (before.isNotEmpty) ...[
        _SectionHeader(label: labels.beforeStartSection),
        for (final entry in before)
          _AgendaEntryTile(entry: entry, labels: labels),
      ],
      _SectionHeader(label: labels.agendaSection),
      for (final entry in main) _AgendaEntryTile(entry: entry, labels: labels),
      if (end != null)
        ListTile(
          dense: true,
          leading: SizedBox(width: 48, child: Text(labels.time(end))),
          title: Text(labels.end),
        ),
    ];
  }

  List<Widget> _team(List<MobileEventTeamSlot> team) {
    final labels = widget.labels;

    if (team.isEmpty) {
      return [
        NgoToolsEmptyState(
          icon: Icons.groups_outlined,
          title: labels.noTeamTitle,
          message: labels.noTeamMessage,
        ),
      ];
    }

    return [
      for (final slot in team)
        Card(
          child: Padding(
            padding: const EdgeInsets.all(NgoToolsLayout.spacing),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        slot.service.name,
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                    ),
                    EventBadge(
                      label: slot.open > 0
                          ? labels.openPlaces(slot.open)
                          : labels.staffed,
                      tone: slot.open > 0
                          ? EventBadgeTone.attention
                          : EventBadgeTone.success,
                    ),
                  ],
                ),
                for (final member in slot.members)
                  EventPersonLine(person: member, labels: labels),
                for (var index = 0; index < slot.open; index++)
                  ListTile(
                    dense: true,
                    contentPadding: EdgeInsets.zero,
                    leading: const CircleAvatar(
                      radius: 16,
                      child: Icon(Icons.person_add_alt, size: 16),
                    ),
                    title: Text(
                      labels.stillOpen,
                      style: const TextStyle(fontStyle: FontStyle.italic),
                    ),
                  ),
              ],
            ),
          ),
        ),
      Padding(
        padding: const EdgeInsets.only(top: NgoToolsLayout.compactSpacing),
        child: Text(
          labels.namesOnly,
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.bodySmall,
        ),
      ),
    ];
  }
}

final class _EventHeader extends StatelessWidget {
  const _EventHeader({required this.event, required this.labels});

  final MobileEventSummary event;
  final EventLabels labels;

  @override
  Widget build(BuildContext context) {
    final when = event.allDay
        ? '${labels.longDay(event.start)} · ${labels.allDay}'
        : '${labels.longDay(event.start)} · '
              '${labels.time(event.start)}–${labels.time(event.end)}';

    return Padding(
      padding: const EdgeInsets.only(bottom: NgoToolsLayout.spacing),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(when, style: Theme.of(context).textTheme.titleSmall),
          const SizedBox(height: NgoToolsLayout.compactSpacing),
          Wrap(
            spacing: 6,
            runSpacing: 6,
            children: [
              if (event.type != null) EventBadge(label: event.type!.name),
              for (final service in event.myServices)
                EventBadge(
                  label: labels.youServe(service.name),
                  tone: EventBadgeTone.primary,
                ),
            ],
          ),
        ],
      ),
    );
  }
}

final class _SectionHeader extends StatelessWidget {
  const _SectionHeader({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.only(
      top: NgoToolsLayout.spacing,
      bottom: NgoToolsLayout.compactSpacing,
    ),
    child: Text(
      label.toUpperCase(),
      style: Theme.of(context).textTheme.labelMedium?.copyWith(
        color: Theme.of(context).colorScheme.onSurfaceVariant,
        fontWeight: FontWeight.w700,
      ),
    ),
  );
}

final class _AgendaEntryTile extends StatelessWidget {
  const _AgendaEntryTile({required this.entry, required this.labels});

  final MobileEventAgendaEntry entry;
  final EventLabels labels;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final responsible = [
      for (final person in entry.responsible)
        person.isMe ? labels.me : person.name,
      if (entry.responsibleService != null) entry.responsibleService!.name,
    ].join(' · ');

    return Container(
      margin: const EdgeInsets.only(bottom: 2),
      padding: const EdgeInsets.symmetric(
        horizontal: NgoToolsLayout.compactSpacing,
        vertical: NgoToolsLayout.compactSpacing,
      ),
      decoration: BoxDecoration(
        color: entry.isMine
            ? colors.tertiaryContainer.withValues(alpha: 0.5)
            : null,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 56,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(labels.time(entry.startsAt), style: textTheme.titleSmall),
                Text(
                  entry.isBeforeStart
                      ? labels.beforeStart
                      : "${entry.durationMinutes}′",
                  style: textTheme.bodySmall,
                ),
              ],
            ),
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(entry.item.name ?? '', style: textTheme.titleSmall),
                if (responsible.isNotEmpty)
                  Text(responsible, style: textTheme.bodySmall),
                for (final child in entry.item.children)
                  _AgendaChild(item: child, depth: 0),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

final class _AgendaChild extends StatelessWidget {
  const _AgendaChild({required this.item, required this.depth});

  final MobileEventAgendaItem item;
  final int depth;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final meta = [
      if (item.key != null) item.key!,
      if (item.language != null) item.language!.toUpperCase(),
    ];

    return Padding(
      padding: EdgeInsets.only(left: 12.0 * depth, top: 4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.music_note, size: 14),
              const SizedBox(width: 4),
              Flexible(
                child: Text(item.name ?? '', style: textTheme.bodyMedium),
              ),
              for (final value in meta) ...[
                const SizedBox(width: 6),
                EventBadge(label: value),
              ],
            ],
          ),
          for (final child in item.children)
            _AgendaChild(item: child, depth: depth + 1),
        ],
      ),
    );
  }
}
