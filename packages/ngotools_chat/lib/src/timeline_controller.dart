import 'dart:async';

import 'package:flutter/foundation.dart';

import 'chat_models.dart';
import 'diff_list.dart';
import 'mapping.dart';
import 'rust/api/timeline.dart' as rust;

/// A room or thread timeline: items streamed as diffs, back pagination,
/// message actions and typing. Open it via `ChatSession.openTimeline` or
/// `openThread`; dispose it when the screen closes.
class TimelineController {
  TimelineController._(rust.ChatTimeline timeline)
    : this.fromSource(
        diffs: timeline.watch(),
        typing: timeline.watchTyping(),
        paginateBack: (count) => timeline.paginateBack(count: count),
        close: timeline.close,
        timeline: timeline,
      );

  @visibleForTesting
  TimelineController.fromSource({
    required Stream<List<rust.TimelineDiff>> diffs,
    Stream<List<rust.Sender>> typing = const Stream.empty(),
    required Future<bool> Function(int count) paginateBack,
    required Future<void> Function() close,
    rust.ChatTimeline? timeline,
  }) : _paginateBack = paginateBack,
       _close = close,
       _timeline = timeline {
    _subscriptions = [
      diffs.listen(
        (batch) =>
            _items.value = applyDiffs(_items.value, batch.map(timelineDiff)),
      ),
      typing.listen(
        (users) => _typing.value = List.unmodifiable(users.map(user)),
      ),
    ];
  }

  final Future<bool> Function(int count) _paginateBack;
  final Future<void> Function() _close;
  final rust.ChatTimeline? _timeline;
  final _items = ValueNotifier<List<TimelineItem>>(const []);
  final _typing = ValueNotifier<List<ChatUser>>(const []);
  final _paginating = ValueNotifier<bool>(false);
  final _reachedStart = ValueNotifier<bool>(false);
  late final List<StreamSubscription<Object?>> _subscriptions;

  /// Items in chronological order (oldest first).
  ValueListenable<List<TimelineItem>> get items => _items;

  /// Other members currently typing.
  ValueListenable<List<ChatUser>> get typing => _typing;

  ValueListenable<bool> get isPaginating => _paginating;

  ValueListenable<bool> get reachedStart => _reachedStart;

  /// Loads older events unless a load is running or the start was reached.
  Future<void> paginateBack({int count = 30}) async {
    if (_paginating.value || _reachedStart.value) {
      return;
    }

    _paginating.value = true;

    try {
      _reachedStart.value = await guard(() => _paginateBack(count));
    } finally {
      _paginating.value = false;
    }
  }

  /// Sends a plain-text message, optionally as a reply to [replyTo].
  Future<void> sendText(String body, {EventItem? replyTo}) =>
      guard(() => _native.sendText(body: body, replyTo: replyTo?.eventId));

  /// Sends an image; create [image] with `prepareImageAttachment`. Upload
  /// progress appears on the local echo (`SendState.sending`).
  Future<void> sendImage(ImageAttachment image) =>
      guard(() => _native.sendImage(image: rustImageAttachment(image)));

  /// Replaces the text of an own message.
  Future<void> edit(EventItem item, String body) =>
      guard(() => _native.edit(key: rustEventKey(item.key), body: body));

  Future<void> redact(EventItem item, {String? reason}) =>
      guard(() => _native.redact(key: rustEventKey(item.key), reason: reason));

  /// Adds or removes the own reaction [key]; returns true when added.
  Future<bool> toggleReaction(EventItem item, String key) => guard(
    () => _native.toggleReaction(key: rustEventKey(item.key), reaction: key),
  );

  /// Sends a failed local echo again.
  Future<void> retry(EventItem item) =>
      guard(() => _native.retry(key: rustEventKey(item.key)));

  /// Discards an unsent local echo; returns false if it was already sent.
  Future<bool> cancel(EventItem item) =>
      guard(() => _native.cancel(key: rustEventKey(item.key)));

  /// Marks the timeline as read up to the latest event.
  Future<void> markRead() => guard(_native.markRead);

  /// Loads sender and text of the message that [eventId] replies to.
  Future<void> loadReplyDetails(String eventId) =>
      guard(() => _native.loadReplyDetails(eventId: eventId));

  /// Tells the others whether the user is typing.
  Future<void> setTyping(bool typing) =>
      guard(() => _native.setTyping(typing: typing));

  rust.ChatTimeline get _native =>
      _timeline ?? (throw StateError('No native timeline in this controller.'));

  /// Stops the Rust stream first: cancelling an idle generated stream only
  /// completes once it delivers another event or closes.
  Future<void> dispose() async {
    await _close();
    for (final subscription in _subscriptions) {
      await subscription.cancel();
    }
    _items.dispose();
    _typing.dispose();
    _paginating.dispose();
    _reachedStart.dispose();
  }
}

/// Wraps a native timeline (used by `ChatSession`).
TimelineController timelineController(rust.ChatTimeline timeline) =>
    TimelineController._(timeline);

/// Translates a generated timeline diff into a [ListDiff] of public items.
ListDiff<TimelineItem> timelineDiff(rust.TimelineDiff diff) => switch (diff) {
  rust.TimelineDiff_Append(:final values) => ListAppend(
    values.map(timelineItem).toList(),
  ),
  rust.TimelineDiff_Clear() => const ListClear(),
  rust.TimelineDiff_PushFront(:final value) => ListPushFront(
    timelineItem(value),
  ),
  rust.TimelineDiff_PushBack(:final value) => ListPushBack(timelineItem(value)),
  rust.TimelineDiff_PopFront() => const ListPopFront(),
  rust.TimelineDiff_PopBack() => const ListPopBack(),
  rust.TimelineDiff_Insert(:final index, :final value) => ListInsert(
    index,
    timelineItem(value),
  ),
  rust.TimelineDiff_Set(:final index, :final value) => ListSet(
    index,
    timelineItem(value),
  ),
  rust.TimelineDiff_Remove(:final index) => ListRemove(index),
  rust.TimelineDiff_Truncate(:final length) => ListTruncate(length),
  rust.TimelineDiff_Reset(:final values) => ListReset(
    values.map(timelineItem).toList(),
  ),
};
