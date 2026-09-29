import 'dart:async';

import 'package:flutter/foundation.dart';

import 'diff_list.dart';
import 'rust/api/client.dart';
import 'rust/api/threads.dart';

/// Keeps the thread overview of a room up to date and loads further pages.
class ThreadListController {
  ThreadListController(ChatThreadList threads)
    : this.fromSource(
        diffs: threads.watch(),
        paginate: threads.paginate,
        close: threads.close,
      );

  @visibleForTesting
  ThreadListController.fromSource({
    required Stream<List<ThreadListDiff>> diffs,
    required Future<bool> Function() paginate,
    required Future<void> Function() close,
  }) : _paginate = paginate,
       _close = close {
    _subscription = diffs.listen(
      (batch) => _threads.value = applyDiffs(
        _threads.value,
        batch.map(threadListDiff),
      ),
    );
  }

  /// Opens the thread overview of [roomId] and loads the first page.
  static Future<ThreadListController> open(
    ChatClient client,
    String roomId,
  ) async {
    final controller = ThreadListController(
      await client.threadList(roomId: roomId),
    );
    await controller.loadMore();

    return controller;
  }

  final Future<bool> Function() _paginate;
  final Future<void> Function() _close;
  final _threads = ValueNotifier<List<ThreadInfo>>(const []);
  final _loading = ValueNotifier<bool>(false);
  final _complete = ValueNotifier<bool>(false);
  late final StreamSubscription<List<ThreadListDiff>> _subscription;

  ValueListenable<List<ThreadInfo>> get threads => _threads;

  ValueListenable<bool> get isLoading => _loading;

  /// True once every thread of the room is loaded.
  ValueListenable<bool> get isComplete => _complete;

  Future<void> loadMore() async {
    if (_loading.value || _complete.value) {
      return;
    }

    _loading.value = true;

    try {
      _complete.value = await _paginate();
    } finally {
      _loading.value = false;
    }
  }

  /// Stops the Rust stream first: cancelling an idle generated stream only
  /// completes once it delivers another event or closes.
  Future<void> dispose() async {
    await _close();
    await _subscription.cancel();
    _threads.dispose();
    _loading.dispose();
    _complete.dispose();
  }
}

/// Translates the generated thread list diff into a generic [ListDiff].
ListDiff<ThreadInfo> threadListDiff(ThreadListDiff diff) => switch (diff) {
  ThreadListDiff_Append(:final values) => ListAppend(values),
  ThreadListDiff_Clear() => const ListClear(),
  ThreadListDiff_PushFront(:final value) => ListPushFront(value),
  ThreadListDiff_PushBack(:final value) => ListPushBack(value),
  ThreadListDiff_PopFront() => const ListPopFront(),
  ThreadListDiff_PopBack() => const ListPopBack(),
  ThreadListDiff_Insert(:final index, :final value) => ListInsert(index, value),
  ThreadListDiff_Set(:final index, :final value) => ListSet(index, value),
  ThreadListDiff_Remove(:final index) => ListRemove(index),
  ThreadListDiff_Truncate(:final length) => ListTruncate(length),
  ThreadListDiff_Reset(:final values) => ListReset(values),
};
