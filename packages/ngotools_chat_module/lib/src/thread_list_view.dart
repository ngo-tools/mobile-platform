import 'dart:async';

import 'package:flutter/material.dart';
import 'package:ngotools_chat/ngotools_chat.dart';
import 'package:ngotools_design_system/ngotools_design_system.dart';

import 'chat_gateway.dart';
import 'chat_image_picker.dart';
import 'chat_labels.dart';
import 'room_view.dart';
import 'timeline_tiles.dart';

/// Threads of a room as a page; opens a thread on tap.
final class ChatThreadListPage extends StatefulWidget {
  /// Creates the thread overview of [roomId].
  const ChatThreadListPage({
    required this.gateway,
    required this.labels,
    required this.roomId,
    required this.isGroup,
    this.imagePicker = const PlatformChatImagePicker(),
    this.now,
    super.key,
  });

  /// Chat access.
  final ChatGateway gateway;

  /// Texts.
  final ChatLabels labels;

  /// Room of the threads.
  final String roomId;

  /// Whether sender names are shown in threads.
  final bool isGroup;

  /// Picks images to send in threads.
  final ChatImagePicker imagePicker;

  /// Current time, injectable for tests.
  final DateTime Function()? now;

  @override
  State<ChatThreadListPage> createState() => _ChatThreadListPageState();
}

final class _ChatThreadListPageState extends State<ChatThreadListPage> {
  ChatThreadListSource? _threads;

  @override
  void initState() {
    super.initState();
    unawaited(_open());
  }

  Future<void> _open() async {
    final threads = await widget.gateway.openThreads(widget.roomId);

    if (!mounted) {
      await threads.dispose();
      return;
    }

    setState(() => _threads = threads);
  }

  @override
  void dispose() {
    unawaited(_threads?.dispose());
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final threads = _threads;
    final labels = widget.labels;

    return Scaffold(
      appBar: AppBar(title: Text(labels.threads)),
      body: threads == null
          ? const Center(child: CircularProgressIndicator())
          : ValueListenableBuilder<List<ThreadInfo>>(
              valueListenable: threads.threads,
              builder: (context, items, _) => ValueListenableBuilder<bool>(
                valueListenable: threads.isLoading,
                builder: (context, loading, _) {
                  if (items.isEmpty && loading) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  if (items.isEmpty) {
                    return NgoToolsEmptyState(
                      icon: Icons.forum_outlined,
                      title: labels.threads,
                      message: labels.noThreads,
                    );
                  }

                  return NotificationListener<ScrollNotification>(
                    onNotification: (notification) {
                      if (notification.metrics.extentAfter < 400 &&
                          !threads.isComplete.value &&
                          !loading) {
                        unawaited(threads.loadMore().catchError((Object _) {}));
                      }

                      return false;
                    },
                    child: ListView.separated(
                      itemCount: items.length,
                      separatorBuilder: (_, _) => const Divider(height: 1),
                      itemBuilder: (context, index) => _tile(items[index]),
                    ),
                  );
                },
              ),
            ),
    );
  }

  Widget _tile(ThreadInfo thread) {
    final labels = widget.labels;
    final root = thread.root;
    final latest = thread.latest ?? root;
    final now = (widget.now ?? DateTime.now)();
    final rootText = root.preview == null
        ? labels.encryptedPreview
        : labels.preview(root.preview!);

    return ListTile(
      leading: NgoToolsAvatar(name: chatUserName(root.sender)),
      title: Text(rootText, maxLines: 2, overflow: TextOverflow.ellipsis),
      subtitle: Text(
        '${chatUserName(root.sender)} · ${labels.threadReplies(thread.replyCount)}',
      ),
      trailing: Text(
        labels.activityTime(latest.timestamp, now),
        style: Theme.of(context).textTheme.labelSmall,
      ),
      onTap: () => Navigator.of(context).push(
        MaterialPageRoute<void>(
          builder: (_) => ChatRoomPage(
            gateway: widget.gateway,
            labels: labels,
            roomId: widget.roomId,
            title: labels.thread,
            isGroup: widget.isGroup,
            threadRootId: root.eventId,
            imagePicker: widget.imagePicker,
            now: widget.now,
          ),
        ),
      ),
    );
  }
}
