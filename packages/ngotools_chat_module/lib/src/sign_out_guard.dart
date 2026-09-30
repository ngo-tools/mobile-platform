import 'package:flutter/material.dart';
import 'package:ngotools_chat/ngotools_chat.dart';

import 'chat_encryption_labels.dart';
import 'chat_gateway.dart';
import 'recovery_restore.dart';
import 'recovery_setup.dart';

enum _SignOutChoice { secure, signOut }

/// Asks before signing out when encrypted messages would be lost: recovery
/// is not set up (or this device lacks the key) and this is the account's
/// only device. Offers to set up recovery or enter the key first.
///
/// Returns whether the app may sign out; `false` when the user cancelled or
/// did not finish securing the messages.
Future<bool> confirmChatSignOut(
  BuildContext context, {
  required ChatGateway gateway,
  required ChatEncryptionLabels labels,
}) async {
  final recovery = gateway.encryption.value?.recovery;

  if (recovery == RecoveryStatus.enabled) {
    return true;
  }

  final navigator = Navigator.of(context);
  bool lastDevice;

  try {
    lastDevice = await gateway.isLastDevice();
  } on ChatException {
    // Unknown: warn rather than lose messages.
    lastDevice = true;
  }

  if (!lastDevice || !navigator.mounted) {
    return true;
  }

  final keyMissing = recovery == RecoveryStatus.incomplete;
  final choice = await showDialog<_SignOutChoice>(
    context: navigator.context,
    builder: (context) => AlertDialog(
      title: Text(labels.signOutTitle),
      content: SingleChildScrollView(
        child: Text(
          keyMissing ? labels.signOutKeyMissing : labels.signOutNoRecovery,
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text(labels.cancel),
        ),
        TextButton(
          style: TextButton.styleFrom(
            foregroundColor: Theme.of(context).colorScheme.error,
          ),
          onPressed: () => Navigator.of(context).pop(_SignOutChoice.signOut),
          child: Text(labels.signOutAnyway),
        ),
        FilledButton(
          onPressed: () => Navigator.of(context).pop(_SignOutChoice.secure),
          child: Text(keyMissing ? labels.enterRecoveryKey : labels.setUp),
        ),
      ],
    ),
  );

  switch (choice) {
    case null:
      return false;
    case _SignOutChoice.signOut:
      return true;
    case _SignOutChoice.secure:
      final secured = await navigator.push<bool>(
        MaterialPageRoute(
          builder: (_) => keyMissing
              ? ChatRecoverPage(gateway: gateway, labels: labels)
              : ChatRecoverySetupPage(gateway: gateway, labels: labels),
        ),
      );

      return secured ?? false;
  }
}
