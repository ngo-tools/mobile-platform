import 'package:flutter/material.dart';
import 'package:ngotools_design_system/ngotools_design_system.dart';

import 'chat_connection_state.dart';
import 'chat_labels.dart';

/// Shows [builder] while the chat is connected and a matching state
/// otherwise: progress, retry after a failure, or why the chat is unavailable.
final class ChatConnectionView extends StatelessWidget {
  /// Creates the view for [state].
  const ChatConnectionView({
    required this.state,
    required this.labels,
    required this.onRetry,
    required this.builder,
    super.key,
  });

  /// Current connection.
  final ChatConnectionState state;

  /// Texts.
  final ChatLabels labels;

  /// Connects again.
  final VoidCallback onRetry;

  /// Content of a connected chat.
  final Widget Function(BuildContext context, ChatConnected connection) builder;

  @override
  Widget build(BuildContext context) => switch (state) {
    ChatConnected() => builder(context, state as ChatConnected),
    ChatConnecting() => Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const CircularProgressIndicator(),
          const SizedBox(height: NgoToolsLayout.spacing),
          Text(labels.connecting),
        ],
      ),
    ),
    ChatConnectionFailed() => NgoToolsEmptyState(
      icon: Icons.cloud_off_outlined,
      title: labels.connectionFailed,
      message: '',
      action: FilledButton(onPressed: onRetry, child: Text(labels.retry)),
    ),
    ChatUnavailable(:final reason) => NgoToolsEmptyState(
      icon: Icons.forum_outlined,
      title: labels.unavailableTitle,
      message: labels.unavailable(reason),
      action: reason == ChatUnavailableReason.homeserverUnavailable
          ? OutlinedButton(onPressed: onRetry, child: Text(labels.retry))
          : null,
    ),
    ChatDisconnected() => NgoToolsEmptyState(
      icon: Icons.forum_outlined,
      title: labels.disconnected,
      message: '',
      action: FilledButton(onPressed: onRetry, child: Text(labels.retry)),
    ),
  };
}
