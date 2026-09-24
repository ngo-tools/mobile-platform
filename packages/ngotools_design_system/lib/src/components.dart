import 'package:flutter/material.dart';

import 'layout.dart';

/// A titled content section with consistent spacing and semantics.
final class NgoToolsSectionCard extends StatelessWidget {
  /// Creates a section card.
  const NgoToolsSectionCard({
    required this.title,
    required this.child,
    this.leading,
    super.key,
  });

  final String title;
  final Widget child;
  final Widget? leading;

  @override
  Widget build(BuildContext context) => Card(
    child: Padding(
      padding: const EdgeInsets.all(NgoToolsLayout.spacing),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              if (leading != null) ...[
                leading!,
                const SizedBox(width: NgoToolsLayout.compactSpacing),
              ],
              Expanded(
                child: Semantics(
                  header: true,
                  child: Text(
                    title,
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: NgoToolsLayout.spacing),
          child,
        ],
      ),
    ),
  );
}

/// Visual meaning of an [NgoToolsStatusBanner].
enum NgoToolsStatus { info, success, warning, error }

/// Accessible inline status message.
final class NgoToolsStatusBanner extends StatelessWidget {
  /// Creates a status banner.
  const NgoToolsStatusBanner({
    required this.message,
    this.status = NgoToolsStatus.info,
    super.key,
  });

  final String message;
  final NgoToolsStatus status;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final (background, foreground, icon) = switch (status) {
      NgoToolsStatus.info => (
        colors.secondaryContainer,
        colors.onSecondaryContainer,
        Icons.info_outline,
      ),
      NgoToolsStatus.success => (
        colors.primaryContainer,
        colors.onPrimaryContainer,
        Icons.check_circle_outline,
      ),
      NgoToolsStatus.warning => (
        colors.tertiaryContainer,
        colors.onTertiaryContainer,
        Icons.warning_amber_outlined,
      ),
      NgoToolsStatus.error => (
        colors.errorContainer,
        colors.onErrorContainer,
        Icons.error_outline,
      ),
    };

    return Semantics(
      liveRegion: true,
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: background,
          borderRadius: BorderRadius.circular(NgoToolsLayout.cornerRadius),
        ),
        child: Padding(
          padding: const EdgeInsets.all(NgoToolsLayout.spacing),
          child: Row(
            children: [
              Icon(icon, color: foreground),
              const SizedBox(width: NgoToolsLayout.compactSpacing),
              Expanded(
                child: Text(message, style: TextStyle(color: foreground)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Consistent empty state for unavailable or not-yet-created content.
final class NgoToolsEmptyState extends StatelessWidget {
  /// Creates an empty state with an optional recovery action.
  const NgoToolsEmptyState({
    required this.title,
    required this.message,
    this.icon = Icons.inbox_outlined,
    this.action,
    super.key,
  });

  final String title;
  final String message;
  final IconData icon;
  final Widget? action;

  @override
  Widget build(BuildContext context) => Center(
    child: Padding(
      padding: const EdgeInsets.all(NgoToolsLayout.sectionSpacing),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ExcludeSemantics(
            child: Icon(
              icon,
              size: 48,
              color: Theme.of(context).colorScheme.primary,
            ),
          ),
          const SizedBox(height: NgoToolsLayout.spacing),
          Semantics(
            header: true,
            child: Text(
              title,
              style: Theme.of(context).textTheme.titleLarge,
              textAlign: TextAlign.center,
            ),
          ),
          const SizedBox(height: NgoToolsLayout.compactSpacing),
          Text(message, textAlign: TextAlign.center),
          if (action != null) ...[
            const SizedBox(height: NgoToolsLayout.spacing),
            action!,
          ],
        ],
      ),
    ),
  );
}
