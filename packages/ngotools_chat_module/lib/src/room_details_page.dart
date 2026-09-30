import 'dart:async';

import 'package:flutter/material.dart';
import 'package:ngotools_chat/ngotools_chat.dart';
import 'package:ngotools_design_system/ngotools_design_system.dart';

import 'chat_gateway.dart';
import 'chat_labels.dart';
import 'timeline_tiles.dart';

/// Result of the room details page.
enum ChatRoomDetailsResult {
  /// The user left the chat.
  left,
}

/// Encryption, notification mode and members of a room; direct chats can be
/// left here. Groups are managed by the organization.
final class ChatRoomDetailsPage extends StatefulWidget {
  /// Creates the page of [room].
  const ChatRoomDetailsPage({
    required this.gateway,
    required this.labels,
    required this.room,
    super.key,
  });

  /// Chat access.
  final ChatGateway gateway;

  /// Texts.
  final ChatLabels labels;

  /// The room.
  final RoomSummary room;

  @override
  State<ChatRoomDetailsPage> createState() => _ChatRoomDetailsPageState();
}

final class _ChatRoomDetailsPageState extends State<ChatRoomDetailsPage> {
  late Future<List<ChatMember>> _members;
  RoomNotificationSettings? _notifications;
  bool _busy = false;

  ChatLabels get _labels => widget.labels;

  @override
  void initState() {
    super.initState();
    _members = widget.gateway.members(widget.room.id);
    unawaited(_loadNotifications());
  }

  Future<void> _loadNotifications() async {
    try {
      final settings = await widget.gateway.notificationSettings(
        widget.room.id,
      );

      if (mounted) {
        setState(() => _notifications = settings);
      }
    } on Object {
      // The section stays hidden when the settings cannot be loaded.
    }
  }

  @override
  Widget build(BuildContext context) {
    final room = widget.room;
    final labels = _labels;

    return Scaffold(
      appBar: AppBar(title: Text(labels.details)),
      body: ListView(
        padding: const EdgeInsets.symmetric(vertical: NgoToolsLayout.spacing),
        children: [
          Center(child: NgoToolsAvatar(name: room.name, size: 72)),
          const SizedBox(height: NgoToolsLayout.compactSpacing),
          Center(
            child: Semantics(
              header: true,
              child: Text(
                room.name,
                style: Theme.of(context).textTheme.titleLarge,
                textAlign: TextAlign.center,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(NgoToolsLayout.spacing),
            child: NgoToolsStatusBanner(
              message: room.isEncrypted
                  ? labels.encryptedRoom
                  : labels.managedRoom,
              status: room.isEncrypted
                  ? NgoToolsStatus.success
                  : NgoToolsStatus.info,
            ),
          ),
          if (_notifications != null) _notificationSection(_notifications!),
          _memberSection(),
          if (room.kind == RoomKind.direct)
            Padding(
              padding: const EdgeInsets.all(NgoToolsLayout.spacing),
              child: OutlinedButton.icon(
                onPressed: _busy ? null : _leave,
                icon: const Icon(Icons.logout),
                label: Text(labels.leaveChat),
              ),
            ),
        ],
      ),
    );
  }

  Widget _notificationSection(RoomNotificationSettings settings) {
    final labels = _labels;
    final selected = settings.isDefault ? null : settings.mode;
    final options = <(NotificationMode?, String)>[
      (null, labels.notifyDefault),
      (NotificationMode.allMessages, labels.notifyAll),
      (NotificationMode.mentionsOnly, labels.notifyMentions),
      (NotificationMode.mute, labels.notifyMute),
    ];

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: NgoToolsLayout.spacing),
      child: NgoToolsSectionCard(
        title: labels.notifications,
        child: RadioGroup<NotificationMode?>(
          groupValue: selected,
          onChanged: _setMode,
          child: Column(
            children: [
              for (final (mode, label) in options)
                RadioListTile<NotificationMode?>(
                  value: mode,
                  title: Text(label),
                  contentPadding: EdgeInsets.zero,
                ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _setMode(NotificationMode? mode) async {
    final previous = _notifications;
    setState(() {
      _notifications = RoomNotificationSettings(
        mode: mode ?? previous?.mode ?? NotificationMode.allMessages,
        isDefault: mode == null,
      );
    });

    try {
      await widget.gateway.setNotificationMode(widget.room.id, mode);
      await _loadNotifications();
    } on Object {
      if (mounted) {
        setState(() => _notifications = previous);
        _snack(_labels.actionFailed);
      }
    }
  }

  Widget _memberSection() => FutureBuilder<List<ChatMember>>(
    future: _members,
    builder: (context, snapshot) {
      final labels = _labels;
      final members = snapshot.data;

      if (members == null) {
        return snapshot.hasError
            ? const SizedBox.shrink()
            : const Padding(
                padding: EdgeInsets.all(NgoToolsLayout.spacing),
                child: Center(child: CircularProgressIndicator()),
              );
      }

      final sorted = [...members]
        ..sort((a, b) {
          final byRole = a.role.index.compareTo(b.role.index);

          return byRole != 0
              ? byRole
              : chatUserName(
                  a.user,
                ).toLowerCase().compareTo(chatUserName(b.user).toLowerCase());
        });

      return Padding(
        padding: const EdgeInsets.all(NgoToolsLayout.spacing),
        child: NgoToolsSectionCard(
          title: labels.members(members.length),
          child: Column(
            children: [
              for (final member in sorted)
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: NgoToolsAvatar(name: chatUserName(member.user)),
                  title: Text(
                    member.isOwn
                        ? '${chatUserName(member.user)} (${labels.you})'
                        : chatUserName(member.user),
                  ),
                  subtitle: _memberNote(member) == null
                      ? null
                      : Text(_memberNote(member)!),
                ),
            ],
          ),
        ),
      );
    },
  );

  String? _memberNote(ChatMember member) {
    final labels = _labels;
    final notes = [
      if (member.role == MemberRole.admin) labels.admin,
      if (member.role == MemberRole.moderator) labels.moderator,
      if (member.state == MemberState.invited) labels.invited,
    ];

    return notes.isEmpty ? null : notes.join(' · ');
  }

  Future<void> _leave() async {
    final labels = _labels;
    final confirmed =
        await showDialog<bool>(
          context: context,
          builder: (context) => AlertDialog(
            title: Text(labels.leaveTitle),
            content: Text(labels.leaveMessage),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: Text(labels.cancel),
              ),
              FilledButton(
                onPressed: () => Navigator.of(context).pop(true),
                child: Text(labels.leaveChat),
              ),
            ],
          ),
        ) ??
        false;

    if (!confirmed || !mounted) {
      return;
    }

    setState(() => _busy = true);

    try {
      await widget.gateway.leaveRoom(widget.room.id);

      if (mounted) {
        Navigator.of(context).pop(ChatRoomDetailsResult.left);
      }
    } on Object {
      if (mounted) {
        setState(() => _busy = false);
        _snack(labels.actionFailed);
      }
    }
  }

  void _snack(String message) => ScaffoldMessenger.maybeOf(
    context,
  )?.showSnackBar(SnackBar(content: Text(message)));
}
