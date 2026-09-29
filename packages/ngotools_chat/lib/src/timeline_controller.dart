import 'dart:async';

import 'package:flutter/foundation.dart';

import 'diff_list.dart';
import 'rust/api/client.dart';
import 'rust/api/timeline.dart';

/// Keeps a room timeline up to date from its diff stream and guards back
/// pagination. Message actions go through [timeline].
class TimelineController {
  TimelineController(ChatTimeline timeline)
    : this.fromSource(
        diffs: timeline.watch(),
        paginateBack: (count) => timeline.paginateBack(count: count),
        close: timeline.close,
        timeline: timeline,
      );

  @visibleForTesting
  TimelineController.fromSource({
    required Stream<List<TimelineDiff>> diffs,
    required Future<bool> Function(int count) paginateBack,
    required Future<void> Function() close,
    ChatTimeline? timeline,
  }) : _paginateBack = paginateBack,
       _close = close,
       _timeline = timeline {
    _subscription = diffs.listen(
      (batch) =>
          _items.value = applyDiffs(_items.value, batch.map(timelineDiff)),
    );
  }

  /// Opens the timeline of [roomId] and starts streaming it.
  static Future<TimelineController> open(
    ChatClient client,
    String roomId,
  ) async => TimelineController(await client.timeline(roomId: roomId));

  final Future<bool> Function(int count) _paginateBack;
  final Future<void> Function() _close;
  final ChatTimeline? _timeline;
  final _items = ValueNotifier<List<TimelineItem>>(const []);
  final _paginating = ValueNotifier<bool>(false);
  final _reachedStart = ValueNotifier<bool>(false);
  late final StreamSubscription<List<TimelineDiff>> _subscription;

  /// Items in chronological order (oldest first).
  ValueListenable<List<TimelineItem>> get items => _items;

  ValueListenable<bool> get isPaginating => _paginating;

  ValueListenable<bool> get reachedStart => _reachedStart;

  /// The native timeline for message actions (send, reply, edit, …).
  ChatTimeline get timeline =>
      _timeline ?? (throw StateError('No native timeline in this controller.'));

  /// Loads older events unless a load is running or the start was reached.
  Future<void> paginateBack({int count = 30}) async {
    if (_paginating.value || _reachedStart.value) {
      return;
    }

    _paginating.value = true;

    try {
      _reachedStart.value = await _paginateBack(count);
    } finally {
      _paginating.value = false;
    }
  }

  /// Stops the Rust stream first: cancelling an idle generated stream only
  /// completes once it delivers another event or closes.
  Future<void> dispose() async {
    await _close();
    await _subscription.cancel();
    _items.dispose();
    _paginating.dispose();
    _reachedStart.dispose();
  }
}

/// Translates the generated timeline diff into a generic [ListDiff].
ListDiff<TimelineItem> timelineDiff(TimelineDiff diff) => switch (diff) {
  TimelineDiff_Append(:final values) => ListAppend(values),
  TimelineDiff_Clear() => const ListClear(),
  TimelineDiff_PushFront(:final value) => ListPushFront(value),
  TimelineDiff_PushBack(:final value) => ListPushBack(value),
  TimelineDiff_PopFront() => const ListPopFront(),
  TimelineDiff_PopBack() => const ListPopBack(),
  TimelineDiff_Insert(:final index, :final value) => ListInsert(index, value),
  TimelineDiff_Set(:final index, :final value) => ListSet(index, value),
  TimelineDiff_Remove(:final index) => ListRemove(index),
  TimelineDiff_Truncate(:final length) => ListTruncate(length),
  TimelineDiff_Reset(:final values) => ListReset(values),
};
