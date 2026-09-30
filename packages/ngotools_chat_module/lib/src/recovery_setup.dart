import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:ngotools_chat/ngotools_chat.dart';
import 'package:ngotools_design_system/ngotools_design_system.dart';

import 'chat_encryption_labels.dart';
import 'chat_gateway.dart';
import 'recovery_restore.dart';

enum _SetupStep { intro, working, failed, key, confirm }

/// Sets up recovery: explanation, the recovery key to save, and a check that
/// it was saved. Pops `true` once recovery is set up.
///
/// With [replaceKey] it skips the explanation and creates a new key for an
/// account that already has recovery.
final class ChatRecoverySetupPage extends StatefulWidget {
  /// Creates the setup.
  const ChatRecoverySetupPage({
    required this.gateway,
    required this.labels,
    this.replaceKey = false,
    super.key,
  });

  /// Chat access.
  final ChatGateway gateway;

  /// Texts.
  final ChatEncryptionLabels labels;

  /// Creates a new key right away instead of explaining first.
  final bool replaceKey;

  @override
  State<ChatRecoverySetupPage> createState() => _ChatRecoverySetupPageState();
}

final class _ChatRecoverySetupPageState extends State<ChatRecoverySetupPage> {
  late _SetupStep _step = widget.replaceKey
      ? _SetupStep.working
      : _SetupStep.intro;
  String? _key;
  bool _copied = false;
  bool _mismatch = false;
  final _confirmation = TextEditingController();

  @override
  void initState() {
    super.initState();

    if (widget.replaceKey) {
      unawaited(_enable());
    }
  }

  @override
  void dispose() {
    _confirmation.dispose();
    super.dispose();
  }

  bool get _canLeave => _step == _SetupStep.intro || _step == _SetupStep.failed;

  Future<void> _enable() async {
    setState(() => _step = _SetupStep.working);

    try {
      final key = await widget.gateway.enableRecovery();

      if (mounted) {
        setState(() {
          _key = key;
          _step = _SetupStep.key;
        });
      }
    } on ChatException {
      if (mounted) {
        setState(() => _step = _SetupStep.failed);
      }
    }
  }

  Future<void> _copy() async {
    await Clipboard.setData(ClipboardData(text: _key!));

    if (mounted) {
      setState(() => _copied = true);
    }
  }

  void _confirm() {
    if (chatRecoveryKeyEnding(_key!) !=
        chatRecoveryKeyEnding(_confirmation.text)) {
      setState(() => _mismatch = true);
      return;
    }

    Navigator.of(context).pop(true);
  }

  @override
  Widget build(BuildContext context) {
    final labels = widget.labels;

    return PopScope(
      // Once created, the key must be saved before leaving.
      canPop: _canLeave,
      child: Scaffold(
        appBar: AppBar(
          title: Text(labels.setupTitle),
          automaticallyImplyLeading: _canLeave,
        ),
        body: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(NgoToolsLayout.spacing),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: switch (_step) {
                _SetupStep.intro => _intro(context),
                _SetupStep.working => [
                  const SizedBox(height: NgoToolsLayout.spacing),
                  const Center(child: CircularProgressIndicator()),
                  const SizedBox(height: NgoToolsLayout.spacing),
                  Text(labels.settingUp, textAlign: TextAlign.center),
                ],
                _SetupStep.failed => [
                  Text(labels.setupFailed),
                  const SizedBox(height: NgoToolsLayout.spacing),
                  FilledButton(
                    onPressed: () => unawaited(_enable()),
                    child: Text(labels.tryAgain),
                  ),
                ],
                _SetupStep.key => _keyView(context),
                _SetupStep.confirm => _confirmView(context),
              },
            ),
          ),
        ),
      ),
    );
  }

  List<Widget> _intro(BuildContext context) {
    final labels = widget.labels;

    return [
      Icon(
        Icons.lock_outline,
        size: 48,
        color: Theme.of(context).colorScheme.primary,
      ),
      const SizedBox(height: NgoToolsLayout.spacing),
      Text(labels.setupIntro),
      const SizedBox(height: NgoToolsLayout.compactSpacing),
      Text(labels.setupKeyInfo),
      const SizedBox(height: NgoToolsLayout.spacing),
      FilledButton(
        onPressed: () => unawaited(_enable()),
        child: Text(labels.setUp),
      ),
      TextButton(
        onPressed: () => Navigator.of(context).pop(false),
        child: Text(labels.later),
      ),
    ];
  }

  List<Widget> _keyView(BuildContext context) {
    final labels = widget.labels;
    final theme = Theme.of(context);

    return [
      Text(labels.keyTitle, style: theme.textTheme.titleMedium),
      const SizedBox(height: NgoToolsLayout.compactSpacing),
      Text(labels.keyInfo),
      const SizedBox(height: NgoToolsLayout.spacing),
      DecoratedBox(
        decoration: BoxDecoration(
          color: theme.colorScheme.surfaceContainerHighest,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Padding(
          padding: const EdgeInsets.all(NgoToolsLayout.spacing),
          child: SelectableText(
            _key!,
            key: const Key('recovery-key'),
            textAlign: TextAlign.center,
            style: theme.textTheme.titleMedium?.copyWith(
              fontFamily: 'monospace',
              fontFamilyFallback: const ['Menlo', 'Roboto Mono', 'Courier'],
              height: 1.6,
            ),
          ),
        ),
      ),
      const SizedBox(height: NgoToolsLayout.compactSpacing),
      OutlinedButton.icon(
        onPressed: () => unawaited(_copy()),
        icon: Icon(_copied ? Icons.check : Icons.copy),
        label: Text(_copied ? labels.copied : labels.copyKey),
      ),
      const SizedBox(height: NgoToolsLayout.spacing),
      FilledButton(
        onPressed: () => setState(() {
          _confirmation.clear();
          _mismatch = false;
          _step = _SetupStep.confirm;
        }),
        child: Text(labels.next),
      ),
    ];
  }

  List<Widget> _confirmView(BuildContext context) {
    final labels = widget.labels;

    return [
      Text(labels.confirmTitle, style: Theme.of(context).textTheme.titleMedium),
      const SizedBox(height: NgoToolsLayout.compactSpacing),
      Text(labels.confirmInfo),
      const SizedBox(height: NgoToolsLayout.spacing),
      TextField(
        controller: _confirmation,
        autofocus: true,
        autocorrect: false,
        enableSuggestions: false,
        textCapitalization: TextCapitalization.none,
        decoration: InputDecoration(
          labelText: labels.confirmHint,
          errorText: _mismatch ? labels.confirmMismatch : null,
          errorMaxLines: 3,
          border: const OutlineInputBorder(),
        ),
        onChanged: (_) {
          if (_mismatch) {
            setState(() => _mismatch = false);
          }
        },
        onSubmitted: (_) => _confirm(),
      ),
      const SizedBox(height: NgoToolsLayout.spacing),
      FilledButton(onPressed: _confirm, child: Text(labels.done)),
      TextButton(
        onPressed: () => setState(() => _step = _SetupStep.key),
        child: Text(labels.showKeyAgain),
      ),
    ];
  }
}

/// Last four characters of a recovery key, ignoring spaces and case.
String chatRecoveryKeyEnding(String key) {
  final compact = key.replaceAll(RegExp(r'\s'), '').toLowerCase();

  return compact.length <= 4 ? compact : compact.substring(compact.length - 4);
}

/// Reminder above the room list while recovery is not set up, or while this
/// device lacks the recovery key.
final class ChatRecoveryBanner extends StatelessWidget {
  /// Creates the reminder.
  const ChatRecoveryBanner({
    required this.gateway,
    required this.labels,
    required this.onSetUp,
    required this.onRecover,
    super.key,
  });

  /// Chat access.
  final ChatGateway gateway;

  /// Texts.
  final ChatEncryptionLabels labels;

  /// Starts the setup.
  final VoidCallback onSetUp;

  /// Opens the recovery key entry.
  final VoidCallback onRecover;

  @override
  Widget build(
    BuildContext context,
  ) => ValueListenableBuilder<EncryptionStatus?>(
    valueListenable: gateway.encryption,
    builder: (context, status, _) {
      final (text, action, onPressed) = switch (status?.recovery) {
        RecoveryStatus.disabled => (
          labels.setupReminder,
          labels.setUp,
          onSetUp,
        ),
        RecoveryStatus.incomplete => (
          labels.recoverReminder,
          labels.enterRecoveryKey,
          onRecover,
        ),
        _ => (null, null, null),
      };

      if (text == null || action == null || onPressed == null) {
        return const SizedBox.shrink();
      }

      final colors = Theme.of(context).colorScheme;

      return Padding(
        padding: const EdgeInsets.fromLTRB(
          NgoToolsLayout.spacing,
          NgoToolsLayout.compactSpacing,
          NgoToolsLayout.spacing,
          0,
        ),
        child: Material(
          color: colors.secondaryContainer,
          borderRadius: BorderRadius.circular(12),
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(
                      Icons.lock_outline,
                      color: colors.onSecondaryContainer,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        text,
                        style: TextStyle(color: colors.onSecondaryContainer),
                      ),
                    ),
                  ],
                ),
                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(onPressed: onPressed, child: Text(action)),
                ),
              ],
            ),
          ),
        ),
      );
    },
  );
}

/// Encryption state of the account and this device, with setting up recovery
/// and creating a new recovery key.
final class ChatSecurityPage extends StatelessWidget {
  /// Creates the page.
  const ChatSecurityPage({
    required this.gateway,
    required this.labels,
    super.key,
  });

  /// Chat access.
  final ChatGateway gateway;

  /// Texts.
  final ChatEncryptionLabels labels;

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: Text(labels.security)),
    body: SafeArea(
      child: ValueListenableBuilder<EncryptionStatus?>(
        valueListenable: gateway.encryption,
        builder: (context, status, _) => ListView(
          padding: const EdgeInsets.all(NgoToolsLayout.spacing),
          children: [
            Text(labels.setupIntro),
            const SizedBox(height: NgoToolsLayout.spacing),
            ListTile(
              contentPadding: EdgeInsets.zero,
              leading: Icon(
                status?.recovery == RecoveryStatus.enabled
                    ? Icons.verified_user_outlined
                    : Icons.gpp_maybe_outlined,
              ),
              title: Text(switch (status?.recovery) {
                RecoveryStatus.enabled => labels.recoveryEnabled,
                RecoveryStatus.disabled => labels.recoveryDisabled,
                RecoveryStatus.incomplete => labels.recoveryIncomplete,
                RecoveryStatus.unknown || null => labels.recoveryChecking,
              }),
              subtitle: status == null
                  ? null
                  : Text(
                      status.deviceVerified
                          ? labels.deviceVerified
                          : labels.deviceNotVerified,
                    ),
            ),
            const SizedBox(height: NgoToolsLayout.compactSpacing),
            if (status?.recovery == RecoveryStatus.disabled)
              FilledButton(
                onPressed: () => unawaited(
                  Navigator.of(context).push(
                    MaterialPageRoute<bool>(
                      builder: (_) => ChatRecoverySetupPage(
                        gateway: gateway,
                        labels: labels,
                      ),
                    ),
                  ),
                ),
                child: Text(labels.setUp),
              ),
            if (status?.recovery == RecoveryStatus.enabled)
              OutlinedButton(
                onPressed: () => unawaited(_replaceKey(context)),
                child: Text(labels.newKey),
              ),
            if (status?.recovery == RecoveryStatus.incomplete) ...[
              FilledButton(
                onPressed: () => unawaited(
                  Navigator.of(context).push(
                    MaterialPageRoute<bool>(
                      builder: (_) =>
                          ChatRecoverPage(gateway: gateway, labels: labels),
                    ),
                  ),
                ),
                child: Text(labels.enterRecoveryKey),
              ),
              TextButton(
                onPressed: () =>
                    unawaited(showChatLostKeyHelp(context, labels: labels)),
                child: Text(labels.lostKey),
              ),
            ],
          ],
        ),
      ),
    ),
  );

  Future<void> _replaceKey(BuildContext context) async {
    final navigator = Navigator.of(context);
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(labels.newKeyTitle),
        content: Text(labels.newKeyMessage),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: Text(labels.cancel),
          ),
          FilledButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: Text(labels.newKey),
          ),
        ],
      ),
    );

    if (confirmed != true) {
      return;
    }

    await navigator.push(
      MaterialPageRoute<bool>(
        builder: (_) => ChatRecoverySetupPage(
          gateway: gateway,
          labels: labels,
          replaceKey: true,
        ),
      ),
    );
  }
}
