import 'package:flutter/material.dart';
import 'package:ngotools_api/ngotools_api.dart';
import 'package:ngotools_design_system/ngotools_design_system.dart';

import 'event_labels.dart';

/// A small rounded label used on event tiles and headers.
final class EventBadge extends StatelessWidget {
  /// Creates a badge with [label] in the given [tone].
  const EventBadge({
    required this.label,
    this.tone = EventBadgeTone.neutral,
    super.key,
  });

  /// Text of the badge.
  final String label;

  /// Color role of the badge.
  final EventBadgeTone tone;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final (background, foreground) = switch (tone) {
      EventBadgeTone.primary => (
        colors.primaryContainer,
        colors.onPrimaryContainer,
      ),
      EventBadgeTone.attention => (
        colors.tertiaryContainer,
        colors.onTertiaryContainer,
      ),
      EventBadgeTone.success => (
        colors.secondaryContainer,
        colors.onSecondaryContainer,
      ),
      EventBadgeTone.neutral => (
        colors.surfaceContainerHighest,
        colors.onSurfaceVariant,
      ),
    };

    return DecoratedBox(
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(999),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
        child: Text(
          label,
          style: Theme.of(context).textTheme.labelSmall?.copyWith(
            color: foreground,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}

/// Color roles of [EventBadge].
enum EventBadgeTone {
  /// Own services.
  primary,

  /// Something needs the user's attention.
  attention,

  /// Something is done.
  success,

  /// Neutral information.
  neutral,
}

/// One availability request with the three answers and a withdraw action.
final class AvailabilityRequestCard extends StatelessWidget {
  /// Creates a request card.
  const AvailabilityRequestCard({
    required this.request,
    required this.labels,
    required this.onAnswer,
    required this.readOnly,
    required this.pending,
    this.onOpenEvent,
    this.compact = false,
    super.key,
  });

  /// The request.
  final MobileEventAvailability request;

  /// Texts and formats.
  final EventLabels labels;

  /// Called with the chosen answer; `notSet` withdraws.
  final void Function(MobileAvailabilityStatus status) onAnswer;

  /// Whether answering is denied for this session.
  final bool readOnly;

  /// Whether an answer is being sent.
  final bool pending;

  /// Opens the event, if offered.
  final VoidCallback? onOpenEvent;

  /// Shows the question instead of the event name, for the event page.
  final bool compact;

  @override
  Widget build(BuildContext context) {
    final event = request.event;
    final textTheme = Theme.of(context).textTheme;
    final when = event.allDay
        ? '${labels.shortDay(event.start)} · ${labels.allDay}'
        : '${labels.shortDay(event.start)} · ${labels.time(event.start)}';
    final answered = request.status != MobileAvailabilityStatus.notSet;
    final disabled = readOnly || pending;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(NgoToolsLayout.spacing),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        compact ? labels.areYouIn : '$when · ${event.name}',
                        style: textTheme.titleSmall,
                      ),
                      Text(
                        labels.service(request.service.name),
                        style: textTheme.bodySmall,
                      ),
                    ],
                  ),
                ),
                if (onOpenEvent != null)
                  IconButton(
                    tooltip: event.name,
                    icon: const Icon(Icons.chevron_right),
                    onPressed: onOpenEvent,
                  ),
              ],
            ),
            const SizedBox(height: NgoToolsLayout.compactSpacing),
            SegmentedButton<MobileAvailabilityStatus>(
              key: ValueKey('availability-${event.id}-${request.service.id}'),
              emptySelectionAllowed: true,
              showSelectedIcon: false,
              segments: [
                ButtonSegment(
                  value: MobileAvailabilityStatus.available,
                  label: Text(labels.available),
                ),
                ButtonSegment(
                  value: MobileAvailabilityStatus.ifNeedsMust,
                  label: Text(labels.ifNeedsMust),
                ),
                ButtonSegment(
                  value: MobileAvailabilityStatus.notAvailable,
                  label: Text(labels.notAvailable),
                ),
              ],
              selected: answered ? {request.status} : const {},
              onSelectionChanged: disabled
                  ? null
                  : (selection) {
                      if (selection.isNotEmpty) {
                        onAnswer(selection.single);
                      }
                    },
            ),
            if (answered && !readOnly)
              Align(
                alignment: Alignment.centerLeft,
                child: TextButton(
                  onPressed: pending
                      ? null
                      : () => onAnswer(MobileAvailabilityStatus.notSet),
                  child: Text(labels.withdraw),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

/// A person or team, marked when it is the user.
final class EventPersonLine extends StatelessWidget {
  /// Creates a person line.
  const EventPersonLine({
    required this.person,
    required this.labels,
    super.key,
  });

  /// The person.
  final MobileEventPerson person;

  /// Texts.
  final EventLabels labels;

  @override
  Widget build(BuildContext context) {
    final initials = person.name
        .split(RegExp(r'\s+'))
        .where((part) => part.isNotEmpty)
        .take(2)
        .map((part) => part.characters.first.toUpperCase())
        .join();

    return ListTile(
      dense: true,
      contentPadding: EdgeInsets.zero,
      leading: CircleAvatar(radius: 16, child: Text(initials)),
      title: Text(person.name),
      trailing: person.isMe
          ? EventBadge(label: labels.me, tone: EventBadgeTone.attention)
          : null,
    );
  }
}
