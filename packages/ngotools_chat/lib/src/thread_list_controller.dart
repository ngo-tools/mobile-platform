import 'dart:async';

import 'package:flutter/foundation.dart';

import 'chat_models.dart';
import 'diff_list.dart';
import 'mapping.dart';
import 'rust/api/threads.dart' as rust;

/// Keeps the thread overview of a room up to date and loads further pages.
/// Open it via `ChatSession.openThreads`.
class ThreadListController {
  ThreadListController._(rust.ChatThreadList threads)
    : this.fromSource(
        diffs: threads.watch(),
        paginate: threads.paginate,
        close: threads.close,
      );

  @visibleForTesting
  ThreadListController.fromSource({
    required Stream<List<rust.ThreadListDiff>> diffs,
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

  final Future<bool> Function() _paginate;
  final Future<void> Function() _close;
  final _threads = ValueNotifier<List<ThreadInfo>>(const []);
  final _loading = ValueNotifier<bool>(false);
  final _complete = ValueNotifier<bool>(false);
  late final StreamSubscription<List<rust.ThreadListDiff>> _subscription;

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
      _complete.value = await guard(_paginate);
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

/// Wraps a native thread list and loads the first page (used by
/// `ChatSession`).
Future<ThreadListController> threadListController(
  rust.ChatThreadList threads,
) async {
  final controller = ThreadListController._(threads);
  await controller.loadMore();

  return controller;
}

/// Translates a generated thread list diff into a [ListDiff] of threads.
ListDiff<ThreadInfo> threadListDiff(rust.ThreadListDiff diff) => switch (diff) {
  rust.ThreadListDiff_Append(:final values) => ListAppend(
    values.map(threadInfo).toList(),
  ),
  rust.ThreadListDiff_Clear() => const ListClear(),
  rust.ThreadListDiff_PushFront(:final value) => ListPushFront(
    threadInfo(value),
  ),
  rust.ThreadListDiff_PushBack(:final value) => ListPushBack(threadInfo(value)),
  rust.ThreadListDiff_PopFront() => const ListPopFront(),
  rust.ThreadListDiff_PopBack() => const ListPopBack(),
  rust.ThreadListDiff_Insert(:final index, :final value) => ListInsert(
    index,
    threadInfo(value),
  ),
  rust.ThreadListDiff_Set(:final index, :final value) => ListSet(
    index,
    threadInfo(value),
  ),
  rust.ThreadListDiff_Remove(:final index) => ListRemove(index),
  rust.ThreadListDiff_Truncate(:final length) => ListTruncate(length),
  rust.ThreadListDiff_Reset(:final values) => ListReset(
    values.map(threadInfo).toList(),
  ),
};
