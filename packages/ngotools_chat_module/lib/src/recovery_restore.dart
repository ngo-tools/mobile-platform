import 'dart:async';

import 'package:flutter/material.dart';
import 'package:ngotools_chat/ngotools_chat.dart';
import 'package:ngotools_design_system/ngotools_design_system.dart';

import 'chat_encryption_labels.dart';
import 'chat_gateway.dart';

/// Restores the keys on a new device with the recovery key. Pops `true` once
/// restored; older messages are decrypted afterwards.
final class ChatRecoverPage extends StatefulWidget {
  /// Creates the page.
  const ChatRecoverPage({
    required this.gateway,
    required this.labels,
    super.key,
  });

  /// Chat access.
  final ChatGateway gateway;

  /// Texts.
  final ChatEncryptionLabels labels;

  @override
  State<ChatRecoverPage> createState() => _ChatRecoverPageState();
}

final class _ChatRecoverPageState extends State<ChatRecoverPage> {
  final _key = TextEditingController();
  bool _working = false;
  String? _error;

  @override
  void initState() {
    super.initState();
    _key.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _key.dispose();
    super.dispose();
  }

  Future<void> _recover() async {
    // The SDK ignores whitespace in keys; a passphrase must stay as typed.
    final key = _key.text.trim();

    if (key.isEmpty || _working) {
      return;
    }

    final messenger = ScaffoldMessenger.maybeOf(context);
    final navigator = Navigator.of(context);
    setState(() {
      _working = true;
      _error = null;
    });

    try {
      await widget.gateway.recover(key);
      messenger?.showSnackBar(SnackBar(content: Text(widget.labels.recovered)));
      navigator.pop(true);
    } on ChatException catch (error) {
      if (mounted) {
        setState(() {
          _working = false;
          _error = error.kind == ChatErrorKind.invalidInput
              ? widget.labels.wrongKey
              : widget.labels.recoverFailed;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final labels = widget.labels;

    return Scaffold(
      appBar: AppBar(title: Text(labels.recoverTitle)),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(NgoToolsLayout.spacing),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Icon(
                Icons.key_outlined,
                size: 48,
                color: Theme.of(context).colorScheme.primary,
              ),
              const SizedBox(height: NgoToolsLayout.spacing),
              Text(labels.recoverInfo),
              const SizedBox(height: NgoToolsLayout.spacing),
              TextField(
                controller: _key,
                enabled: !_working,
                autocorrect: false,
                enableSuggestions: false,
                keyboardType: TextInputType.visiblePassword,
                minLines: 2,
                maxLines: 4,
                style: const TextStyle(
                  fontFamily: 'monospace',
                  fontFamilyFallback: ['Menlo', 'Roboto Mono', 'Courier'],
                ),
                decoration: InputDecoration(
                  labelText: labels.recoveryKeyField,
                  errorText: _error,
                  errorMaxLines: 3,
                  border: const OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: NgoToolsLayout.spacing),
              FilledButton(
                onPressed: _working || _key.text.trim().isEmpty
                    ? null
                    : () => unawaited(_recover()),
                child: _working
                    ? Text(labels.recovering)
                    : Text(labels.recover),
              ),
              TextButton(
                onPressed: () =>
                    unawaited(showChatLostKeyHelp(context, labels: labels)),
                child: Text(labels.lostKey),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Explains that a lost key can only be reset, and where (web chat).
Future<void> showChatLostKeyHelp(
  BuildContext context, {
  required ChatEncryptionLabels labels,
}) => showDialog<void>(
  context: context,
  builder: (context) => AlertDialog(
    title: Text(labels.lostKeyTitle),
    content: SingleChildScrollView(child: Text(labels.lostKeyMessage)),
    actions: [
      TextButton(
        onPressed: () => Navigator.of(context).pop(),
        child: Text(labels.done),
      ),
    ],
  ),
);
