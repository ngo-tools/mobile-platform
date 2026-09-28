import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ngotools_api/ngotools_api.dart';
import 'package:ngotools_design_system/ngotools_design_system.dart';

import 'event_details_page.dart';
import 'event_labels.dart';
import 'event_widgets.dart';
import 'events_cubit.dart';
import 'events_repository.dart';

/// Upcoming events grouped by day, with filter, range and paging.
final class EventsView extends StatefulWidget {
  /// Creates an event list backed by [repository].
  const EventsView({
    required this.repository,
    required this.labels,
    this.today,
    super.key,
  });

  /// Event access.
  final EventsRepository repository;

  /// Texts and formats.
  final EventLabels labels;

  /// Current day, injectable for tests.
  final DateTime Function()? today;

  @override
  State<EventsView> createState() => _EventsViewState();
}

final class _EventsViewState extends State<EventsView> {
  late final EventsCubit _cubit;

  @override
  void initState() {
    super.initState();
    _cubit = EventsCubit(repository: widget.repository, today: widget.today);
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
    child: BlocBuilder<EventsCubit, EventsState>(
      builder: (context, state) => Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _EventsToolbar(
            state: state,
            labels: widget.labels,
            onOnlyMine: (onlyMine) => _cubit.showOnlyMine(onlyMine: onlyMine),
            onRange: _chooseRange,
            onRefresh: _cubit.refresh,
          ),
          Expanded(child: _body(state)),
        ],
      ),
    ),
  );

  Widget _body(EventsState state) {
    final labels = widget.labels;

    if (state.status == EventsStatus.initial ||
        (state.status == EventsStatus.loading && state.events.isEmpty)) {
      return const Center(child: CircularProgressIndicator());
    }

    if (state.status == EventsStatus.failure && state.events.isEmpty) {
      return NgoToolsEmptyState(
        icon: Icons.cloud_off_outlined,
        title: labels.failure(state.failure!),
        message: '',
        action: FilledButton(onPressed: _cubit.load, child: Text(labels.retry)),
      );
    }

    final events = state.visibleEvents;
    final children = <Widget>[];
    DateTime? lastDay;

    for (final event in events) {
      final local = event.start.toLocal();
      final day = DateTime(local.year, local.month, local.day);

      if (day != lastDay) {
        children.add(_DayHeader(label: labels.longDay(event.start)));
        lastDay = day;
      }

      children.add(
        _EventTile(event: event, labels: labels, onTap: () => _open(event)),
      );
    }

    if (events.isEmpty) {
      children.add(
        NgoToolsEmptyState(
          icon: Icons.event_busy_outlined,
          title: labels.noEventsTitle,
          message: state.onlyMine
              ? labels.noOwnEventsMessage
              : labels.noEventsMessage,
        ),
      );
    }

    if (state.status == EventsStatus.failure) {
      children.add(
        Padding(
          padding: const EdgeInsets.all(NgoToolsLayout.spacing),
          child: NgoToolsStatusBanner(
            status: NgoToolsStatus.error,
            message: labels.failure(state.failure!),
          ),
        ),
      );
    }

    if (state.canLoadMore) {
      children.add(
        Padding(
          padding: const EdgeInsets.all(NgoToolsLayout.spacing),
          child: OutlinedButton(
            onPressed: state.status == EventsStatus.loadingMore
                ? null
                : _cubit.loadMore,
            child: state.status == EventsStatus.loadingMore
                ? const SizedBox.square(
                    dimension: 18,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : Text(labels.loadMore),
          ),
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: _cubit.refresh,
      child: ListView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.symmetric(horizontal: NgoToolsLayout.spacing),
        children: children,
      ),
    );
  }

  Future<void> _open(MobileEventSummary event) async {
    await Navigator.of(context).push<void>(
      MaterialPageRoute<void>(
        builder: (_) => EventDetailsPage(
          repository: widget.repository,
          eventId: event.id,
          title: event.name,
          labels: widget.labels,
        ),
      ),
    );

    if (mounted) {
      await _cubit.refresh();
    }
  }

  Future<void> _chooseRange() async {
    final labels = widget.labels;
    final today = (widget.today ?? DateTime.now)();
    final options = <(String, DateTime, int)>[
      (labels.rangeNext30, today, 30),
      (labels.rangeNext60, today, 60),
      (labels.rangeNext90, today, 90),
      (labels.rangePast30, addDays(today, -30), 30),
    ];

    final choice = await showModalBottomSheet<(String, DateTime, int)>(
      context: context,
      builder: (context) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              title: Text(labels.range),
              subtitle: Text(labels.rangeHint),
            ),
            for (final option in options)
              ListTile(
                title: Text(option.$1),
                onTap: () => Navigator.of(context).pop(option),
              ),
          ],
        ),
      ),
    );

    if (choice != null) {
      await _cubit.changeRange(from: choice.$2, days: choice.$3);
    }
  }
}

final class _EventsToolbar extends StatelessWidget {
  const _EventsToolbar({
    required this.state,
    required this.labels,
    required this.onOnlyMine,
    required this.onRange,
    required this.onRefresh,
  });

  final EventsState state;
  final EventLabels labels;
  final ValueChanged<bool> onOnlyMine;
  final VoidCallback onRange;
  final Future<void> Function() onRefresh;

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.fromLTRB(
      NgoToolsLayout.spacing,
      NgoToolsLayout.compactSpacing,
      NgoToolsLayout.compactSpacing,
      0,
    ),
    child: Row(
      children: [
        ChoiceChip(
          label: Text(labels.all),
          selected: !state.onlyMine,
          onSelected: (_) => onOnlyMine(false),
        ),
        const SizedBox(width: NgoToolsLayout.compactSpacing),
        ChoiceChip(
          label: Text(labels.onlyMine),
          selected: state.onlyMine,
          onSelected: (_) => onOnlyMine(true),
        ),
        const Spacer(),
        IconButton(
          tooltip: labels.range,
          icon: const Icon(Icons.date_range_outlined),
          onPressed: onRange,
        ),
        IconButton(
          tooltip: labels.refresh,
          icon: const Icon(Icons.refresh),
          onPressed: () => unawaited(onRefresh()),
        ),
      ],
    ),
  );
}

final class _DayHeader extends StatelessWidget {
  const _DayHeader({required this.label});

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

final class _EventTile extends StatelessWidget {
  const _EventTile({
    required this.event,
    required this.labels,
    required this.onTap,
  });

  final MobileEventSummary event;
  final EventLabels labels;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final badges = <Widget>[
      for (final service in event.myServices)
        EventBadge(
          label: labels.youServe(service.name),
          tone: EventBadgeTone.primary,
        ),
      if (event.availabilityOpen)
        EventBadge(
          label: labels.availabilityOpen,
          tone: EventBadgeTone.attention,
        ),
      if (event.planningCompleted)
        EventBadge(label: labels.agendaFinal, tone: EventBadgeTone.success),
    ];

    return Card(
      margin: const EdgeInsets.only(bottom: NgoToolsLayout.compactSpacing),
      child: InkWell(
        borderRadius: BorderRadius.circular(NgoToolsLayout.cornerRadius),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(NgoToolsLayout.spacing),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                width: 56,
                child: event.allDay
                    ? Text(labels.allDay, style: textTheme.labelMedium)
                    : Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            labels.time(event.start),
                            style: textTheme.titleSmall,
                          ),
                          Text(
                            labels.time(event.end),
                            style: textTheme.bodySmall,
                          ),
                        ],
                      ),
              ),
              const SizedBox(width: NgoToolsLayout.compactSpacing),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(event.name, style: textTheme.titleMedium),
                    if (event.type != null)
                      Text(event.type!.name, style: textTheme.bodySmall),
                    if (badges.isNotEmpty) ...[
                      const SizedBox(height: NgoToolsLayout.compactSpacing),
                      Wrap(spacing: 6, runSpacing: 6, children: badges),
                    ],
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
