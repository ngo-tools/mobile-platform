import 'package:flutter/material.dart';
import 'package:ngotools_chat/ngotools_chat.dart';
import 'package:ngotools_design_system/ngotools_design_system.dart';

import 'chat_encryption_labels.dart';

/// Placeholder for a message this device cannot read: the reason in one line;
/// tapping explains it and, where the recovery key helps, offers to enter it.
final class ChatUndecryptableMessage extends StatelessWidget {
  /// Creates the placeholder for a message that failed with [reason].
  const ChatUndecryptableMessage({
    required this.reason,
    required this.labels,
    this.onEnterRecoveryKey,
    super.key,
  });

  /// Why the message cannot be read.
  final DecryptionFailure reason;

  /// Texts.
  final ChatEncryptionLabels labels;

  /// Opens the recovery key entry; `null` when this device needs no key.
  final VoidCallback? onEnterRecoveryKey;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Semantics(
      button: true,
      hint: labels.showExplanation,
      child: InkWell(
        onTap: () => showUndecryptableExplanation(
          context,
          reason: reason,
          labels: labels,
          onEnterRecoveryKey: onEnterRecoveryKey,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.lock_outline, size: 16),
            const SizedBox(width: 4),
            Flexible(
              child: Text(
                labels.undecryptable(reason),
                style: const TextStyle(fontStyle: FontStyle.italic),
              ),
            ),
            const SizedBox(width: 4),
            Icon(
              Icons.info_outline,
              size: 16,
              color: theme.colorScheme.primary,
            ),
          ],
        ),
      ),
    );
  }
}

/// Explains why a message cannot be read and offers the recovery key when it
/// helps.
Future<void> showUndecryptableExplanation(
  BuildContext context, {
  required DecryptionFailure reason,
  required ChatEncryptionLabels labels,
  VoidCallback? onEnterRecoveryKey,
}) async {
  final enterKey =
      onEnterRecoveryKey != null &&
          ChatEncryptionLabels.recoveryKeyHelps(reason)
      ? onEnterRecoveryKey
      : null;
  final wantsKey = await showModalBottomSheet<bool>(
    context: context,
    showDragHandle: true,
    isScrollControlled: true,
    builder: (context) => SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(
          NgoToolsLayout.spacing,
          0,
          NgoToolsLayout.spacing,
          NgoToolsLayout.spacing,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              labels.undecryptableTitle,
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: NgoToolsLayout.compactSpacing),
            Text(labels.undecryptableExplanation(reason)),
            if (enterKey != null) ...[
              const SizedBox(height: NgoToolsLayout.spacing),
              FilledButton.icon(
                onPressed: () => Navigator.of(context).pop(true),
                icon: const Icon(Icons.key_outlined),
                label: Text(labels.enterRecoveryKey),
              ),
            ],
          ],
        ),
      ),
    ),
  );

  if (wantsKey == true) {
    enterKey?.call();
  }
}
