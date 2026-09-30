import 'package:flutter/material.dart';
import 'package:ngotools_chat/ngotools_chat.dart';
import 'package:ngotools_design_system/ngotools_design_system.dart';

import 'chat_labels.dart';
import 'undecryptable_message.dart';

/// Short name of a Matrix user: display name or the localpart of the id.
String chatUserName(ChatUser user) {
  final displayName = user.displayName?.trim();

  if (displayName != null && displayName.isNotEmpty) {
    return displayName;
  }

  return chatUserIdName(user.id);
}

/// Localpart of a Matrix user id (`@maria.muster:example.org` → `maria.muster`).
String chatUserIdName(String userId) {
  final localpart = userId.startsWith('@') ? userId.substring(1) : userId;
  final colon = localpart.indexOf(':');

  return colon < 0 ? localpart : localpart.substring(0, colon);
}

/// Centered, muted line such as a date or "user joined".
final class ChatNoticeTile extends StatelessWidget {
  /// Creates a notice.
  const ChatNoticeTile(this.text, {this.chip = false, super.key});

  /// Text shown.
  final String text;

  /// Shows the text on a chip (date dividers).
  final bool chip;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final label = Text(
      text,
      textAlign: TextAlign.center,
      style: theme.textTheme.labelMedium?.copyWith(
        color: chip
            ? theme.colorScheme.onSecondaryContainer
            : theme.colorScheme.onSurfaceVariant,
        fontWeight: chip ? FontWeight.w600 : null,
      ),
    );

    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: NgoToolsLayout.spacing,
        vertical: NgoToolsLayout.compactSpacing,
      ),
      child: Center(
        child: chip
            ? DecoratedBox(
                decoration: BoxDecoration(
                  color: theme.colorScheme.secondaryContainer,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 4,
                  ),
                  child: label,
                ),
              )
            : label,
      ),
    );
  }
}

/// Marks where unread messages begin.
final class ChatReadMarkerTile extends StatelessWidget {
  /// Creates the marker.
  const ChatReadMarkerTile({required this.label, super.key});

  /// Text of the marker.
  final String label;

  @override
  Widget build(BuildContext context) {
    final color = Theme.of(context).colorScheme.primary;

    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: NgoToolsLayout.spacing,
        vertical: NgoToolsLayout.compactSpacing,
      ),
      child: Row(
        children: [
          Expanded(child: Divider(color: color)),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Text(
              label,
              style: Theme.of(
                context,
              ).textTheme.labelSmall?.copyWith(color: color),
            ),
          ),
          Expanded(child: Divider(color: color)),
        ],
      ),
    );
  }
}

/// One message with reply quote, content, reactions and thread summary.
final class ChatMessageTile extends StatelessWidget {
  /// Creates the tile for [event].
  const ChatMessageTile({
    required this.event,
    required this.labels,
    required this.showSender,
    required this.onLongPress,
    required this.onToggleReaction,
    required this.onLoadReply,
    this.onOpenThread,
    this.content,
    super.key,
  });

  /// The message.
  final EventItem event;

  /// Texts.
  final ChatLabels labels;

  /// Shows the sender above the bubble (first message of a group run).
  final bool showSender;

  /// Opens the message actions.
  final VoidCallback onLongPress;

  /// Adds or removes a reaction.
  final void Function(String key) onToggleReaction;

  /// Requests details of the replied-to message.
  final void Function(String eventId) onLoadReply;

  /// Opens the thread started by this message.
  final VoidCallback? onOpenThread;

  /// Replaces the default content, e.g. an image preview.
  final Widget? content;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final muted = theme.textTheme.labelSmall?.copyWith(
      color: theme.colorScheme.onSurfaceVariant,
    );
    final replyTo = event.replyTo;

    if (replyTo != null && replyTo.sender == null) {
      WidgetsBinding.instance.addPostFrameCallback(
        (_) => onLoadReply(replyTo.eventId),
      );
    }

    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: NgoToolsLayout.spacing,
        vertical: 2,
      ),
      child: Column(
        crossAxisAlignment: event.isOwn
            ? CrossAxisAlignment.end
            : CrossAxisAlignment.start,
        children: [
          if (showSender && !event.isOwn)
            Padding(
              padding: const EdgeInsets.only(left: 12, top: 6, bottom: 2),
              child: Text(
                chatUserName(event.sender),
                style: theme.textTheme.labelMedium?.copyWith(
                  color: theme.colorScheme.primary,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          GestureDetector(
            onLongPress: onLongPress,
            child: NgoToolsBubble(
              outgoing: event.isOwn,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (replyTo != null) _ReplyQuote(replyTo, labels),
                  content ?? ChatMessageContent(event.content, labels),
                  const SizedBox(height: 2),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (event.isEdited)
                        Text('${labels.edited} · ', style: muted),
                      Text(labels.messageTime(event.timestamp), style: muted),
                      if (event.isOwn) ...[
                        const SizedBox(width: 4),
                        _SendStateIcon(event.sendState, labels),
                      ],
                    ],
                  ),
                ],
              ),
            ),
          ),
          if (event.reactions.isNotEmpty)
            Padding(
              padding: const EdgeInsets.only(top: 2),
              child: Wrap(
                spacing: 4,
                runSpacing: 4,
                children: [
                  for (final reaction in event.reactions)
                    FilterChip(
                      visualDensity: VisualDensity.compact,
                      materialTapTargetSize: MaterialTapTargetSize.padded,
                      label: Text('${reaction.key} ${reaction.count}'),
                      selected: reaction.byMe,
                      showCheckmark: false,
                      onSelected: (_) => onToggleReaction(reaction.key),
                    ),
                ],
              ),
            ),
          if (event.thread != null && onOpenThread != null)
            TextButton.icon(
              onPressed: onOpenThread,
              icon: const Icon(Icons.forum_outlined, size: 18),
              label: Text(labels.threadReplies(event.thread!.replyCount)),
            ),
        ],
      ),
    );
  }
}

/// Text or placeholder of a message's content.
final class ChatMessageContent extends StatelessWidget {
  /// Creates the content view.
  const ChatMessageContent(this.content, this.labels, {super.key});

  /// Content of the message.
  final EventContent content;

  /// Texts.
  final ChatLabels labels;

  @override
  Widget build(BuildContext context) {
    const italic = TextStyle(fontStyle: FontStyle.italic);

    return switch (content) {
      TextContent(:final body) => Text(body),
      ImageContent(:final caption) => _Attachment(
        Icons.image_outlined,
        caption ?? labels.imagePreview,
      ),
      VideoContent(:final filename) => _Attachment(
        Icons.movie_outlined,
        filename,
      ),
      AudioContent(:final filename) => _Attachment(
        Icons.mic_none_outlined,
        filename,
      ),
      FileContent(:final filename) => _Attachment(
        Icons.insert_drive_file_outlined,
        filename,
      ),
      RedactedContent() => Text(labels.redactedPreview, style: italic),
      UnableToDecryptContent(:final reason) => ChatUndecryptableMessage(
        reason: reason,
        labels: labels.encryption,
      ),
      _ => Text(labels.unsupportedMessage, style: italic),
    };
  }
}

/// Notice text for membership, profile and room state events; `null` for
/// messages.
String? chatNoticeText(EventContent content, ChatLabels labels) =>
    switch (content) {
      MembershipContent(:final userId, :final change) => labels.membership(
        chatUserIdName(userId),
        change,
      ),
      ProfileChangeContent(:final userId) => labels.profileChanged(
        chatUserIdName(userId),
      ),
      RoomStateContent() => labels.roomChanged,
      _ => null,
    };

final class _Attachment extends StatelessWidget {
  const _Attachment(this.icon, this.label);

  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) => Row(
    mainAxisSize: MainAxisSize.min,
    children: [
      Icon(icon, size: 20),
      const SizedBox(width: 6),
      Flexible(child: Text(label)),
    ],
  );
}

final class _ReplyQuote extends StatelessWidget {
  const _ReplyQuote(this.reply, this.labels);

  final ReplyPreview reply;
  final ChatLabels labels;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final sender = reply.sender;
    final preview = reply.preview;

    return Container(
      margin: const EdgeInsets.only(bottom: 4),
      padding: const EdgeInsets.only(left: 8),
      decoration: BoxDecoration(
        border: Border(
          left: BorderSide(color: theme.colorScheme.primary, width: 3),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (sender != null)
            Text(
              chatUserName(sender),
              style: theme.textTheme.labelMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
          Text(
            preview == null ? labels.replyLoading : labels.preview(preview),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: theme.textTheme.bodySmall,
          ),
        ],
      ),
    );
  }
}

final class _SendStateIcon extends StatelessWidget {
  const _SendStateIcon(this.state, this.labels);

  final SendState state;
  final ChatLabels labels;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return switch (state) {
      Sending() => Icon(
        Icons.schedule,
        size: 14,
        semanticLabel: labels.sending,
        color: colors.onSurfaceVariant,
      ),
      Sent() => Icon(
        Icons.done,
        size: 14,
        semanticLabel: labels.sent,
        color: colors.onSurfaceVariant,
      ),
      SendFailed() => Icon(
        Icons.error_outline,
        size: 14,
        semanticLabel: labels.sendFailed,
        color: colors.error,
      ),
    };
  }
}
