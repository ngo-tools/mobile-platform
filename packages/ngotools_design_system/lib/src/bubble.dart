import 'package:flutter/material.dart';

import 'layout.dart';

/// Message bubble: own messages on the trailing side in the primary
/// container color, others on the leading side.
final class NgoToolsBubble extends StatelessWidget {
  /// Creates a bubble around [child].
  const NgoToolsBubble({
    required this.outgoing,
    required this.child,
    this.maxWidthFactor = 0.8,
    super.key,
  });

  /// Whether the user sent the message.
  final bool outgoing;

  /// Content.
  final Widget child;

  /// Maximum share of the available width.
  final double maxWidthFactor;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    const radius = Radius.circular(NgoToolsLayout.cornerRadius);
    const tail = Radius.circular(4);

    return LayoutBuilder(
      builder: (context, constraints) => Align(
        alignment: outgoing
            ? AlignmentDirectional.centerEnd
            : AlignmentDirectional.centerStart,
        child: ConstrainedBox(
          constraints: BoxConstraints(
            maxWidth: constraints.maxWidth * maxWidthFactor,
          ),
          child: DecoratedBox(
            decoration: BoxDecoration(
              color: outgoing
                  ? colors.primaryContainer
                  : colors.surfaceContainerHigh,
              borderRadius: BorderRadiusDirectional.only(
                topStart: radius,
                topEnd: radius,
                bottomStart: outgoing ? radius : tail,
                bottomEnd: outgoing ? tail : radius,
              ),
            ),
            child: DefaultTextStyle.merge(
              style: TextStyle(
                color: outgoing ? colors.onPrimaryContainer : colors.onSurface,
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: NgoToolsLayout.compactSpacing,
                ),
                child: child,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
