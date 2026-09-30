import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:ngotools_chat/ngotools_chat.dart';
import 'package:ngotools_design_system/ngotools_design_system.dart';

import 'chat_gateway.dart';
import 'chat_image_picker.dart';
import 'chat_image_views.dart';
import 'chat_labels.dart';
import 'thread_list_view.dart';
import 'timeline_tiles.dart';

/// Quick reactions offered in the message actions.
const chatQuickReactions = ['👍', '❤️', '😂', '😮', '😢', '🙏'];

/// A chat room or thread as a full page with app bar.
final class ChatRoomPage extends StatelessWidget {
  /// Creates the page of room [roomId]; with [threadRootId] the thread.
  const ChatRoomPage({
    required this.gateway,
    required this.labels,
    required this.roomId,
    required this.title,
    required this.isGroup,
    this.threadRootId,
    this.actions = const [],
    this.imagePicker = const PlatformChatImagePicker(),
    this.now,
    super.key,
  });

  /// Chat access.
  final ChatGateway gateway;

  /// Texts.
  final ChatLabels labels;

  /// Room shown.
  final String roomId;

  /// Room name (or thread title).
  final String title;

  /// Whether sender names are shown.
  final bool isGroup;

  /// Root event of a thread.
  final String? threadRootId;

  /// Further app bar actions, e.g. room details.
  final List<Widget> actions;

  /// Picks images to send.
  final ChatImagePicker imagePicker;

  /// Current time, injectable for tests.
  final DateTime Function()? now;

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(
      title: Text(title),
      actions: [
        if (threadRootId == null)
          IconButton(
            tooltip: labels.threads,
            icon: const Icon(Icons.forum_outlined),
            onPressed: () => Navigator.of(context).push(
              MaterialPageRoute<void>(
                builder: (_) => ChatThreadListPage(
                  gateway: gateway,
                  labels: labels,
                  roomId: roomId,
                  isGroup: isGroup,
                  imagePicker: imagePicker,
                  now: now,
                ),
              ),
            ),
          ),
        ...actions,
      ],
    ),
    body: ChatRoomView(
      gateway: gateway,
      labels: labels,
      roomId: roomId,
      isGroup: isGroup,
      threadRootId: threadRootId,
      imagePicker: imagePicker,
      now: now,
    ),
  );
}

/// Timeline and composer of a room or thread.
final class ChatRoomView extends StatefulWidget {
  /// Creates the view of room [roomId]; with [threadRootId] the thread.
  const ChatRoomView({
    required this.gateway,
    required this.labels,
    required this.roomId,
    required this.isGroup,
    this.threadRootId,
    this.imagePicker = const PlatformChatImagePicker(),
    this.now,
    super.key,
  });

  /// Chat access.
  final ChatGateway gateway;

  /// Texts.
  final ChatLabels labels;

  /// Room shown.
  final String roomId;

  /// Whether sender names are shown.
  final bool isGroup;

  /// Root event of a thread.
  final String? threadRootId;

  /// Picks images to send.
  final ChatImagePicker imagePicker;

  /// Current time, injectable for tests.
  final DateTime Function()? now;

  @override
  State<ChatRoomView> createState() => _ChatRoomViewState();
}

final class _ChatRoomViewState extends State<ChatRoomView> {
  ChatTimelineSource? _timeline;
  final _scroll = ScrollController();
  final _text = TextEditingController();
  final _focus = FocusNode();
  final _requestedReplies = <String>{};
  final _media = <ChatMedia, Future<Uint8List>>{};
  EventItem? _replyTo;
  EventItem? _editing;
  Timer? _typingTimer;
  bool _typing = false;

  ChatLabels get _labels => widget.labels;

  @override
  void initState() {
    super.initState();
    _scroll.addListener(_onScroll);
    unawaited(_open());
  }

  Future<void> _open() async {
    final threadRootId = widget.threadRootId;
    final timeline = threadRootId == null
        ? await widget.gateway.openTimeline(widget.roomId)
        : await widget.gateway.openThread(widget.roomId, threadRootId);

    if (!mounted) {
      await timeline.dispose();
      return;
    }

    timeline.items.addListener(_onItems);
    setState(() => _timeline = timeline);
    unawaited(_quietly(timeline.paginateBack));
    unawaited(_quietly(timeline.markRead));
  }

  @override
  void dispose() {
    _typingTimer?.cancel();

    if (_typing) {
      unawaited(_quietly(() => _timeline!.setTyping(false)));
    }

    _timeline?.items.removeListener(_onItems);
    unawaited(_timeline?.dispose());
    _scroll.dispose();
    _text.dispose();
    _focus.dispose();
    super.dispose();
  }

  void _onItems() {
    if (!_scroll.hasClients || _scroll.offset < 80) {
      unawaited(_quietly(_timeline!.markRead));
    }

    WidgetsBinding.instance.addPostFrameCallback((_) => _onScroll());
  }

  void _onScroll() {
    final timeline = _timeline;

    if (timeline == null || !_scroll.hasClients) {
      return;
    }

    final position = _scroll.position;

    if (position.extentAfter < 600 && !timeline.reachedStart.value) {
      unawaited(_quietly(timeline.paginateBack));
    }
  }

  @override
  Widget build(BuildContext context) {
    final timeline = _timeline;

    if (timeline == null) {
      return const Center(child: CircularProgressIndicator());
    }

    return Column(
      children: [
        Expanded(
          child: ValueListenableBuilder<List<TimelineItem>>(
            valueListenable: timeline.items,
            builder: (context, items, _) => ValueListenableBuilder<bool>(
              valueListenable: timeline.isPaginating,
              builder: (context, paginating, _) =>
                  _timelineList(items, paginating),
            ),
          ),
        ),
        ValueListenableBuilder<List<ChatUser>>(
          valueListenable: timeline.typing,
          builder: (context, typing, _) => typing.isEmpty
              ? const SizedBox.shrink()
              : Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: NgoToolsLayout.spacing,
                  ),
                  child: Semantics(
                    liveRegion: true,
                    child: Align(
                      alignment: AlignmentDirectional.centerStart,
                      child: Text(
                        _labels.typing(typing.map(chatUserName).toList()),
                        style: Theme.of(context).textTheme.labelMedium,
                      ),
                    ),
                  ),
                ),
        ),
        _composer(),
      ],
    );
  }

  Widget _timelineList(List<TimelineItem> items, bool paginating) {
    final count = items.length + (paginating ? 1 : 0);

    return ListView.builder(
      controller: _scroll,
      reverse: true,
      padding: const EdgeInsets.symmetric(vertical: NgoToolsLayout.spacing),
      itemCount: count,
      itemBuilder: (context, index) {
        if (index >= items.length) {
          return const Padding(
            padding: EdgeInsets.all(NgoToolsLayout.spacing),
            child: Center(child: CircularProgressIndicator()),
          );
        }

        final position = items.length - 1 - index;
        final item = items[position];

        return KeyedSubtree(
          key: ValueKey(item.id),
          child: _tile(item, position > 0 ? items[position - 1] : null),
        );
      },
    );
  }

  Widget _tile(TimelineItem item, TimelineItem? previous) {
    final now = (widget.now ?? DateTime.now)();

    return switch (item) {
      DateDividerItem(:final date) => ChatNoticeTile(
        _labels.dayLabel(date, now),
        chip: true,
      ),
      ReadMarkerItem() => ChatReadMarkerTile(label: _labels.newMessages),
      TimelineStartItem() => ChatNoticeTile(_labels.timelineStart),
      EventTimelineItem(:final event) => _eventTile(event, previous),
    };
  }

  Widget _eventTile(EventItem event, TimelineItem? previous) {
    final notice = chatNoticeText(event.content, _labels);

    if (notice != null) {
      return ChatNoticeTile(notice);
    }

    final previousEvent = switch (previous) {
      EventTimelineItem(:final event) => event,
      _ => null,
    };
    final showSender =
        widget.isGroup &&
        (previousEvent == null ||
            previousEvent.sender.id != event.sender.id ||
            chatNoticeText(previousEvent.content, _labels) != null);

    return ChatMessageTile(
      event: event,
      labels: _labels,
      showSender: showSender,
      onLongPress: () => _showActions(event),
      onToggleReaction: (key) =>
          _run(() => _timeline!.toggleReaction(event, key)),
      onLoadReply: (eventId) {
        if (_requestedReplies.add(eventId)) {
          unawaited(_quietly(() => _timeline!.loadReplyDetails(eventId)));
        }
      },
      onOpenThread: widget.threadRootId == null && event.eventId != null
          ? () => _openThread(event)
          : null,
      content: switch (event.content) {
        final ImageContent image => ChatImageMessage(
          content: image,
          sendState: event.sendState,
          labels: _labels,
          loadPreview: (media) =>
              _media.putIfAbsent(media, () => widget.gateway.media(media)),
          loadFull: (media) =>
              _media.putIfAbsent(media, () => widget.gateway.media(media)),
        ),
        _ => null,
      },
    );
  }

  Widget _composer() {
    final labels = _labels;
    final replyTo = _replyTo;
    final editing = _editing;

    return SafeArea(
      top: false,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(
          NgoToolsLayout.compactSpacing,
          4,
          NgoToolsLayout.compactSpacing,
          NgoToolsLayout.compactSpacing,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (replyTo != null || editing != null)
              Row(
                children: [
                  Icon(
                    editing != null ? Icons.edit_outlined : Icons.reply,
                    size: 18,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      editing != null
                          ? labels.editing
                          : labels.replyingTo(chatUserName(replyTo!.sender)),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.labelMedium,
                    ),
                  ),
                  IconButton(
                    tooltip: labels.cancel,
                    icon: const Icon(Icons.close),
                    onPressed: _resetComposer,
                  ),
                ],
              ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                if (editing == null)
                  IconButton(
                    tooltip: labels.attachImage,
                    icon: const Icon(Icons.add_photo_alternate_outlined),
                    onPressed: _pickImage,
                  ),
                Expanded(
                  child: TextField(
                    controller: _text,
                    focusNode: _focus,
                    minLines: 1,
                    maxLines: 5,
                    textCapitalization: TextCapitalization.sentences,
                    keyboardType: TextInputType.multiline,
                    onChanged: _onTyping,
                    decoration: InputDecoration(
                      hintText: labels.composerHint,
                      border: const OutlineInputBorder(),
                      isDense: true,
                    ),
                  ),
                ),
                const SizedBox(width: 4),
                ValueListenableBuilder<TextEditingValue>(
                  valueListenable: _text,
                  builder: (context, value, _) => IconButton.filled(
                    tooltip: labels.send,
                    icon: const Icon(Icons.send),
                    onPressed: value.text.trim().isEmpty ? null : _send,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _onTyping(String text) {
    final timeline = _timeline!;
    _typingTimer?.cancel();

    if (text.trim().isEmpty) {
      _setTyping(timeline, false);
      return;
    }

    _setTyping(timeline, true);
    _typingTimer = Timer(
      const Duration(seconds: 5),
      () => _setTyping(timeline, false),
    );
  }

  void _setTyping(ChatTimelineSource timeline, bool typing) {
    if (_typing == typing) {
      return;
    }

    _typing = typing;
    unawaited(_quietly(() => timeline.setTyping(typing)));
  }

  Future<void> _send() async {
    final timeline = _timeline!;
    final body = _text.text.trim();
    final replyTo = _replyTo;
    final editing = _editing;

    _typingTimer?.cancel();
    _setTyping(timeline, false);
    _resetComposer();

    await _run(
      () => editing != null
          ? timeline.edit(editing, body)
          : timeline.sendText(body, replyTo: replyTo),
    );
  }

  Future<void> _pickImage() async {
    final labels = _labels;
    final source = await showModalBottomSheet<ChatImageSource>(
      context: context,
      showDragHandle: true,
      builder: (context) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.photo_camera_outlined),
              title: Text(labels.camera),
              onTap: () => Navigator.of(context).pop(ChatImageSource.camera),
            ),
            ListTile(
              leading: const Icon(Icons.photo_library_outlined),
              title: Text(labels.gallery),
              onTap: () => Navigator.of(context).pop(ChatImageSource.gallery),
            ),
          ],
        ),
      ),
    );

    if (source == null || !mounted) {
      return;
    }

    ImageAttachment? image;

    try {
      image = await widget.imagePicker.pick(source);
    } on Object {
      _snack(labels.actionFailed);
    }

    if (image == null || !mounted) {
      return;
    }

    final caption = await _confirmImage(image);

    if (caption == null) {
      return;
    }

    final timeline = _timeline!;

    await _run(
      () => timeline.sendImage(
        image!.copyWith(caption: caption.isEmpty ? null : caption),
      ),
    );
  }

  /// Shows the picked image with a caption field; `null` when cancelled.
  Future<String?> _confirmImage(ImageAttachment image) => showDialog<String>(
    context: context,
    builder: (context) => _ImageConfirmDialog(image: image, labels: _labels),
  );

  void _resetComposer() {
    setState(() {
      _replyTo = null;
      _editing = null;
    });
    _text.clear();
  }

  Future<void> _showActions(EventItem event) async {
    final labels = _labels;
    final text = switch (event.content) {
      TextContent(:final body) => body,
      _ => null,
    };
    final failed = event.sendState is SendFailed;
    final redacted = event.content is RedactedContent;

    final action = await showModalBottomSheet<String>(
      context: context,
      showDragHandle: true,
      isScrollControlled: true,
      builder: (context) => SafeArea(
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (!redacted && event.eventId != null)
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: NgoToolsLayout.spacing,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      for (final reaction in chatQuickReactions)
                        IconButton(
                          tooltip: reaction,
                          onPressed: () =>
                              Navigator.of(context).pop('react:$reaction'),
                          icon: Text(
                            reaction,
                            style: const TextStyle(fontSize: 24),
                          ),
                        ),
                    ],
                  ),
                ),
              if (event.canReply && event.eventId != null)
                _action(context, Icons.reply, labels.reply, 'reply'),
              if (widget.threadRootId == null &&
                  event.canReply &&
                  event.eventId != null)
                _action(
                  context,
                  Icons.forum_outlined,
                  labels.replyInThread,
                  'thread',
                ),
              if (text != null)
                _action(context, Icons.copy, labels.copy, 'copy'),
              if (event.isOwn && event.canEdit && text != null)
                _action(context, Icons.edit_outlined, labels.edit, 'edit'),
              if (failed) ...[
                _action(context, Icons.refresh, labels.retrySend, 'retry'),
                _action(context, Icons.close, labels.discard, 'discard'),
              ],
              if (event.isOwn && !redacted && !failed)
                _action(context, Icons.delete_outline, labels.delete, 'delete'),
            ],
          ),
        ),
      ),
    );

    if (action == null || !mounted) {
      return;
    }

    final timeline = _timeline!;

    switch (action) {
      case 'reply':
        setState(() {
          _editing = null;
          _replyTo = event;
        });
        _focus.requestFocus();
      case 'thread':
        _openThread(event);
      case 'copy':
        await Clipboard.setData(ClipboardData(text: text!));
        _snack(labels.copied);
      case 'edit':
        setState(() {
          _replyTo = null;
          _editing = event;
        });
        _text.text = text!;
        _focus.requestFocus();
      case 'retry':
        await _run(() => timeline.retry(event));
      case 'discard':
        await _run(() => timeline.cancel(event));
      case 'delete':
        if (await _confirmDelete()) {
          await _run(() => timeline.redact(event));
        }
      default:
        if (action.startsWith('react:')) {
          await _run(() => timeline.toggleReaction(event, action.substring(6)));
        }
    }
  }

  Widget _action(
    BuildContext context,
    IconData icon,
    String label,
    String value,
  ) => ListTile(
    leading: Icon(icon),
    title: Text(label),
    onTap: () => Navigator.of(context).pop(value),
  );

  Future<bool> _confirmDelete() async =>
      await showDialog<bool>(
        context: context,
        builder: (context) => AlertDialog(
          title: Text(_labels.deleteTitle),
          content: Text(_labels.deleteMessage),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: Text(_labels.cancel),
            ),
            FilledButton(
              onPressed: () => Navigator.of(context).pop(true),
              child: Text(_labels.delete),
            ),
          ],
        ),
      ) ??
      false;

  void _openThread(EventItem event) {
    final eventId = event.eventId;

    if (eventId == null) {
      return;
    }

    unawaited(
      Navigator.of(context).push(
        MaterialPageRoute<void>(
          builder: (_) => ChatRoomPage(
            gateway: widget.gateway,
            labels: _labels,
            roomId: widget.roomId,
            title: _labels.thread,
            isGroup: widget.isGroup,
            threadRootId: eventId,
            imagePicker: widget.imagePicker,
            now: widget.now,
          ),
        ),
      ),
    );
  }

  Future<void> _run(Future<void> Function() action) async {
    try {
      await action();
    } on Object {
      _snack(_labels.actionFailed);
    }
  }

  void _snack(String message) {
    if (!mounted) {
      return;
    }

    ScaffoldMessenger.maybeOf(
      context,
    )?.showSnackBar(SnackBar(content: Text(message)));
  }

  static Future<void> _quietly(Future<void> Function() action) async {
    try {
      await action();
    } on Object {
      // Background work (read marker, typing, paging) is retried naturally.
    }
  }
}

final class _ImageConfirmDialog extends StatefulWidget {
  const _ImageConfirmDialog({required this.image, required this.labels});

  final ImageAttachment image;
  final ChatLabels labels;

  @override
  State<_ImageConfirmDialog> createState() => _ImageConfirmDialogState();
}

final class _ImageConfirmDialogState extends State<_ImageConfirmDialog> {
  final _caption = TextEditingController();

  @override
  void dispose() {
    _caption.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final labels = widget.labels;
    final thumbnail = widget.image.thumbnail;

    return AlertDialog(
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ConstrainedBox(
            constraints: const BoxConstraints(maxHeight: 280),
            child: thumbnail != null
                ? Image.memory(thumbnail.data, fit: BoxFit.contain)
                : Image.file(
                    File(widget.image.filePath),
                    fit: BoxFit.contain,
                    errorBuilder: (context, _, _) =>
                        const Icon(Icons.image_outlined, size: 64),
                  ),
          ),
          const SizedBox(height: NgoToolsLayout.spacing),
          TextField(
            controller: _caption,
            decoration: InputDecoration(hintText: labels.captionHint),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text(labels.cancel),
        ),
        FilledButton(
          onPressed: () => Navigator.of(context).pop(_caption.text.trim()),
          child: Text(labels.send),
        ),
      ],
    );
  }
}
