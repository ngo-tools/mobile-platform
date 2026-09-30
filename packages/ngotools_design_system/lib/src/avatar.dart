import 'package:flutter/material.dart';

/// Round avatar with an image or the initials of [name].
final class NgoToolsAvatar extends StatelessWidget {
  /// Creates an avatar; [image] replaces the initials once loaded.
  const NgoToolsAvatar({
    required this.name,
    this.image,
    this.size = 40,
    super.key,
  });

  /// Name used for the initials and the placeholder color.
  final String name;

  /// Optional picture.
  final ImageProvider? image;

  /// Diameter.
  final double size;

  /// Up to two initials of [name].
  static String initialsOf(String name) {
    final words = name
        .trim()
        .split(RegExp(r'\s+'))
        .where((word) => word.isNotEmpty)
        .toList();

    if (words.isEmpty) {
      return '?';
    }

    final first = words.first.characters.first;
    final last = words.length > 1 ? words.last.characters.first : '';

    return (first + last).toUpperCase();
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final palette = [
      (colors.primaryContainer, colors.onPrimaryContainer),
      (colors.secondaryContainer, colors.onSecondaryContainer),
      (colors.tertiaryContainer, colors.onTertiaryContainer),
    ];
    final (background, foreground) =
        palette[name.hashCode.abs() % palette.length];

    return ExcludeSemantics(
      child: SizedBox.square(
        dimension: size,
        child: CircleAvatar(
          backgroundColor: background,
          foregroundImage: image,
          child: Text(
            initialsOf(name),
            style: TextStyle(
              color: foreground,
              fontSize: size * 0.38,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),
    );
  }
}

/// Small counter, e.g. unread messages; [emphasized] for mentions.
final class NgoToolsCountBadge extends StatelessWidget {
  /// Creates a badge for [count] (shown as 99+ above 99).
  const NgoToolsCountBadge({
    required this.count,
    this.emphasized = false,
    super.key,
  });

  /// Number shown.
  final int count;

  /// Uses the stronger primary color.
  final bool emphasized;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return Container(
      constraints: const BoxConstraints(minWidth: 22, minHeight: 22),
      padding: const EdgeInsets.symmetric(horizontal: 6),
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: emphasized ? colors.primary : colors.secondaryContainer,
        borderRadius: BorderRadius.circular(11),
      ),
      child: Text(
        count > 99 ? '99+' : '$count',
        style: Theme.of(context).textTheme.labelSmall?.copyWith(
          color: emphasized ? colors.onPrimary : colors.onSecondaryContainer,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
