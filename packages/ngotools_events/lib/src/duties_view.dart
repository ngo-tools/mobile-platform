import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ngotools_api/ngotools_api.dart';
import 'package:ngotools_design_system/ngotools_design_system.dart';

import 'availability_answers.dart';
import 'duties_cubit.dart';
import 'event_details_page.dart';
import 'event_labels.dart';
import 'event_widgets.dart';
import 'events_repository.dart';

/// Own assignments and availability requests of the user.
final class DutiesView extends StatefulWidget {
  /// Creates the duties overview backed by [repository].
  const DutiesView({
    required this.repository,
    required this.labels,
    this.onOpenRequestsChanged,
    super.key,
  });

  /// Event access.
  final EventsRepository repository;

  /// Texts and formats.
  final EventLabels labels;

  /// Reports the number of unanswered requests, e.g. for a navigation badge.
  final ValueChanged<int>? onOpenRequestsChanged;

  @override
  State<DutiesView> createState() => _DutiesViewState();
}

final class _DutiesViewState extends State<DutiesView> {
  late final DutiesCubit _cubit;

  @override
  void initState() {
    super.initState();
    _cubit = DutiesCubit(repository: widget.repository);
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
    child: BlocConsumer<DutiesCubit, DutiesState>(
      listener: (context, state) {
        widget.onOpenRequestsChanged?.call(state.openRequests.length);

        final failure = state.answerFailure;
        final answer = state.lastAnswer;

        if (failure == null && answer == null) {
          return;
        }

        ScaffoldMessenger.of(context)
          ..hideCurrentSnackBar()
          ..showSnackBar(
            SnackBar(
              content: Text(
                failure == null
                    ? widget.labels.confirmation(answer!)
                    : widget.labels.answerFailure(failure),
              ),
            ),
          );
      },
      builder: (context, state) => _body(state),
    ),
  );

  Widget _body(DutiesState state) {
    final labels = widget.labels;

    if (state.status == DutiesStatus.initial ||
        (state.status == DutiesStatus.loading &&
            state.assignments.isEmpty &&
            state.requests.isEmpty)) {
      return const Center(child: CircularProgressIndicator());
    }

    if (state.status == DutiesStatus.failure) {
      return NgoToolsEmptyState(
        icon: Icons.cloud_off_outlined,
        title: labels.failure(state.failure!),
        message: '',
        action: FilledButton(onPressed: _cubit.load, child: Text(labels.retry)),
      );
    }

    final open = state.openRequests;
    final answered = state.answeredRequests;

    return RefreshIndicator(
      onRefresh: _cubit.load,
      child: ListView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.all(NgoToolsLayout.spacing),
        children: [
          if (state.readOnly)
            Padding(
              padding: const EdgeInsets.only(
                bottom: NgoToolsLayout.compactSpacing,
              ),
              child: NgoToolsStatusBanner(message: labels.readOnlyNotice),
            ),
          _SectionHeader(label: labels.assigned),
          if (state.assignments.isEmpty)
            _Placeholder(text: labels.noAssignments)
          else
            for (final assignment in state.assignments)
              _AssignmentTile(
                assignment: assignment,
                labels: labels,
                onTap: () => _open(assignment.event),
              ),
          _SectionHeader(
            label: open.isEmpty
                ? labels.pleaseAnswer
                : '${labels.pleaseAnswer} · ${open.length}',
          ),
          if (open.isEmpty)
            _Placeholder(text: labels.allAnswered)
          else
            for (final request in open) _requestCard(state, request),
          if (answered.isNotEmpty) ...[
            _SectionHeader(label: labels.answered),
            for (final request in answered) _requestCard(state, request),
          ],
        ],
      ),
    );
  }

  Widget _requestCard(DutiesState state, MobileEventAvailability request) =>
      AvailabilityRequestCard(
        key: ValueKey(availabilityKey(request)),
        request: request,
        labels: widget.labels,
        readOnly: state.readOnly,
        pending: state.pending.contains(availabilityKey(request)),
        onAnswer: (status) => unawaited(_cubit.answer(request, status)),
        onOpenEvent: () => _open(request.event),
      );

  Future<void> _open(MobileEventReference event) async {
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
      await _cubit.load();
    }
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

final class _Placeholder extends StatelessWidget {
  const _Placeholder({required this.text});

  final String text;

  @override
  Widget build(BuildContext context) => Card(
    child: Padding(
      padding: const EdgeInsets.all(NgoToolsLayout.spacing),
      child: Text(text),
    ),
  );
}

final class _AssignmentTile extends StatelessWidget {
  const _AssignmentTile({
    required this.assignment,
    required this.labels,
    required this.onTap,
  });

  final MobileEventAssignment assignment;
  final EventLabels labels;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final event = assignment.event;
    final when = event.allDay ? labels.allDay : labels.time(event.start);

    return Card(
      child: ListTile(
        onTap: onTap,
        title: Text(event.name),
        subtitle: Text(
          '${labels.shortDay(event.start)} · $when · ${assignment.service.name}',
        ),
        trailing: const Icon(Icons.chevron_right),
      ),
    );
  }
}
