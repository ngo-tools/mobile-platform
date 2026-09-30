import 'dart:async';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:ngotools_chat/ngotools_chat.dart';
import 'package:ngotools_design_system/ngotools_design_system.dart';

import 'chat_gateway.dart';
import 'chat_labels.dart';

/// The user's chats: open invites first, then rooms by latest activity, with
/// filter, search and paging.
final class ChatRoomListView extends StatefulWidget {
  /// Creates the room list of [gateway].
  const ChatRoomListView({
    required this.gateway,
    required this.labels,
    required this.onOpenRoom,
    this.selectedRoomId,
    this.source,
    this.header,
    this.actions = const [],
    this.now,
    super.key,
  });

  /// Chat access.
  final ChatGateway gateway;

  /// Texts and formats.
  final ChatLabels labels;

  /// Opens a joined room.
  final void Function(RoomSummary room) onOpenRoom;

  /// Room shown next to the list (tablet layout).
  final String? selectedRoomId;

  /// Room list owned by the caller; opened (and stopped) by the view when
  /// `null`.
  final ChatRoomListSource? source;

  /// Shown above the search, e.g. a reminder to set up recovery.
  final Widget? header;

  /// Buttons next to the search, e.g. the security settings.
  final List<Widget> actions;

  /// Current time, injectable for tests.
  final DateTime Function()? now;

  @override
  State<ChatRoomListView> createState() => _ChatRoomListViewState();
}

final class _ChatRoomListViewState extends State<ChatRoomListView> {
  static const _filters = [
    RoomFilter.all,
    RoomFilter.unread,
    RoomFilter.people,
    RoomFilter.groups,
  ];

  ChatRoomListSource? _source;
  final _search = TextEditingController();
  final _busyInvites = <String>{};
  final _thumbnails = <ChatMedia, Future<Uint8List>>{};

  @override
  void initState() {
    super.initState();
    unawaited(_open());
    _search.addListener(() => setState(() {}));
  }

  Future<void> _open() async {
    final external = widget.source;

    if (external != null) {
      setState(() => _source = external);
      return;
    }

    final source = await widget.gateway.rooms();

    if (!mounted) {
      await source.dispose();
      return;
    }

    setState(() => _source = source);
  }

  @override
  void dispose() {
    if (widget.source == null) {
      unawaited(_source?.dispose());
    }

    _search.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final source = _source;

    if (source == null) {
      return const Center(child: CircularProgressIndicator());
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        ?widget.header,
        Padding(
          padding: const EdgeInsets.fromLTRB(
            NgoToolsLayout.spacing,
            NgoToolsLayout.compactSpacing,
            NgoToolsLayout.spacing,
            0,
          ),
          child: Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _search,
                  decoration: InputDecoration(
                    hintText: widget.labels.searchHint,
                    prefixIcon: const Icon(Icons.search),
                    border: const OutlineInputBorder(),
                    isDense: true,
                  ),
                ),
              ),
              ...widget.actions,
            ],
          ),
        ),
        ValueListenableBuilder<RoomFilter>(
          valueListenable: source.filter,
          builder: (context, filter, _) => SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(
              horizontal: NgoToolsLayout.spacing,
              vertical: NgoToolsLayout.compactSpacing,
            ),
            child: Row(
              children: [
                for (final option in _filters)
                  Padding(
                    padding: const EdgeInsets.only(
                      right: NgoToolsLayout.compactSpacing,
                    ),
                    child: ChoiceChip(
                      label: Text(_filterLabel(option)),
                      selected: filter == option,
                      onSelected: (_) => unawaited(source.setFilter(option)),
                    ),
                  ),
              ],
            ),
          ),
        ),
        Expanded(
          child: ValueListenableBuilder<List<RoomSummary>>(
            valueListenable: source.rooms,
            builder: (context, rooms, _) => _list(source, rooms),
          ),
        ),
      ],
    );
  }

  Widget _list(ChatRoomListSource source, List<RoomSummary> rooms) {
    final labels = widget.labels;
    final query = _search.text.trim().toLowerCase();
    final visible = query.isEmpty
        ? rooms
        : rooms
              .where((room) => room.name.toLowerCase().contains(query))
              .toList();
    final invites = visible
        .where((room) => room.membership == Membership.invited)
        .toList();
    final joined = visible
        .where((room) => room.membership == Membership.joined)
        .toList();

    if (visible.isEmpty) {
      return rooms.isEmpty && source.filter.value == RoomFilter.all
          ? NgoToolsEmptyState(
              icon: Icons.forum_outlined,
              title: labels.noRoomsTitle,
              message: labels.noRoomsMessage,
            )
          : NgoToolsEmptyState(
              icon: Icons.search_off,
              title: labels.noMatchesMessage,
              message: '',
            );
    }

    final entries = <Widget>[
      if (invites.isNotEmpty) ...[
        _SectionHeader(labels.invitesSection),
        for (final room in invites) _inviteTile(room),
        const Divider(height: 1),
      ],
      for (final room in joined) _roomTile(room),
    ];

    return NotificationListener<ScrollNotification>(
      onNotification: (notification) {
        if (notification.metrics.extentAfter < 400) {
          unawaited(source.loadMore().catchError((Object _) {}));
        }

        return false;
      },
      child: ListView.builder(
        itemCount: entries.length,
        itemBuilder: (context, index) => entries[index],
      ),
    );
  }

  Widget _roomTile(RoomSummary room) {
    final labels = widget.labels;
    final latest = room.latest;
    final now = (widget.now ?? DateTime.now)();
    final unread = room.unreadMessages > 0 || room.unreadMentions > 0;
    final muted = room.notificationMode == NotificationMode.mute;
    final preview = latest == null ? '' : _previewLine(room, latest);
    final theme = Theme.of(context);

    final semantics = [
      room.name,
      if (preview.isNotEmpty) preview,
      if (latest != null) labels.activityTime(latest.timestamp, now),
      if (room.unreadMentions > 0) labels.mentions(room.unreadMentions),
      if (room.unreadMessages > 0) labels.unread(room.unreadMessages),
      if (muted) labels.muted,
    ].join(', ');

    return Semantics(
      button: true,
      selected: widget.selectedRoomId == room.id,
      label: semantics,
      excludeSemantics: true,
      child: ListTile(
        selected: widget.selectedRoomId == room.id,
        leading: _avatar(room.name, room.avatar),
        title: Text(
          room.name,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: unread ? const TextStyle(fontWeight: FontWeight.w600) : null,
        ),
        subtitle: Row(
          children: [
            if (latest?.isUnsent ?? false)
              Padding(
                padding: const EdgeInsets.only(right: 4),
                child: Icon(
                  Icons.error_outline,
                  size: 16,
                  color: theme.colorScheme.error,
                  semanticLabel: labels.unsent,
                ),
              ),
            Expanded(
              child: Text(
                preview,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
        trailing: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            if (latest != null)
              Text(
                labels.activityTime(latest.timestamp, now),
                style: theme.textTheme.labelSmall,
              ),
            const SizedBox(height: 4),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (muted)
                  const Icon(Icons.notifications_off_outlined, size: 16),
                if (unread) ...[
                  const SizedBox(width: 4),
                  NgoToolsCountBadge(
                    count: room.unreadMentions > 0
                        ? room.unreadMentions
                        : room.unreadMessages,
                    emphasized: room.unreadMentions > 0 || !muted,
                  ),
                ],
              ],
            ),
          ],
        ),
        onTap: () => widget.onOpenRoom(room),
      ),
    );
  }

  Widget _inviteTile(RoomSummary room) {
    final labels = widget.labels;
    final busy = _busyInvites.contains(room.id);

    return Padding(
      padding: const EdgeInsets.only(bottom: NgoToolsLayout.compactSpacing),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          ListTile(
            leading: _avatar(room.name, room.avatar),
            title: Text(
              room.name,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            subtitle: Text(labels.invitedBy),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: NgoToolsLayout.spacing,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                OutlinedButton(
                  onPressed: busy
                      ? null
                      : () => _answerInvite(room, widget.gateway.leaveRoom),
                  child: Text(labels.decline),
                ),
                const SizedBox(width: NgoToolsLayout.compactSpacing),
                FilledButton(
                  onPressed: busy
                      ? null
                      : () => _answerInvite(room, widget.gateway.joinRoom),
                  child: Text(labels.accept),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _answerInvite(
    RoomSummary room,
    Future<void> Function(String roomId) answer,
  ) async {
    setState(() => _busyInvites.add(room.id));

    try {
      await answer(room.id);
    } on Object {
      if (mounted) {
        ScaffoldMessenger.maybeOf(
          context,
        )?.showSnackBar(SnackBar(content: Text(widget.labels.actionFailed)));
      }
    } finally {
      if (mounted) {
        setState(() => _busyInvites.remove(room.id));
      }
    }
  }

  String _previewLine(RoomSummary room, LatestEvent latest) {
    final text = widget.labels.preview(latest.preview);

    if (latest.isOwn) {
      return '${widget.labels.you}: $text';
    }

    if (room.kind == RoomKind.group) {
      final sender = latest.sender.displayName ?? latest.sender.id;

      return '$sender: $text';
    }

    return text;
  }

  Widget _avatar(String name, ChatMedia? media) {
    if (media == null) {
      return NgoToolsAvatar(name: name);
    }

    final bytes = _thumbnails.putIfAbsent(
      media,
      () => widget.gateway.thumbnail(media, 96),
    );

    return FutureBuilder<Uint8List>(
      future: bytes,
      builder: (context, snapshot) => NgoToolsAvatar(
        name: name,
        image: snapshot.hasData ? MemoryImage(snapshot.data!) : null,
      ),
    );
  }

  String _filterLabel(RoomFilter filter) => switch (filter) {
    RoomFilter.all || RoomFilter.invites => widget.labels.filterAll,
    RoomFilter.unread => widget.labels.filterUnread,
    RoomFilter.people => widget.labels.filterPeople,
    RoomFilter.groups => widget.labels.filterGroups,
  };
}

final class _SectionHeader extends StatelessWidget {
  const _SectionHeader(this.title);

  final String title;

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.fromLTRB(
      NgoToolsLayout.spacing,
      NgoToolsLayout.compactSpacing,
      NgoToolsLayout.spacing,
      0,
    ),
    child: Semantics(
      header: true,
      child: Text(title, style: Theme.of(context).textTheme.titleSmall),
    ),
  );
}
