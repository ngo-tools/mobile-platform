import 'dart:async';

import 'package:flutter/foundation.dart';

import 'diff_list.dart';
import 'rust/api/client.dart';
import 'rust/api/rooms.dart';

/// Keeps the room list of a [ChatClient] up to date from its diff stream.
///
/// The sync must be running before the controller is created.
class RoomListController {
  RoomListController(ChatClient client)
    : this.fromSource(
        diffs: client.watchRoomList(),
        setFilter: (filter) => client.setRoomFilter(filter: filter),
        loadMore: client.loadMoreRooms,
        close: client.stopRoomList,
      );

  @visibleForTesting
  RoomListController.fromSource({
    required Stream<List<RoomListDiff>> diffs,
    required Future<void> Function(RoomFilter filter) setFilter,
    required Future<void> Function() loadMore,
    required Future<void> Function() close,
  }) : _setFilter = setFilter,
       _loadMore = loadMore,
       _close = close {
    _subscription = diffs.listen(
      (batch) =>
          _rooms.value = applyDiffs(_rooms.value, batch.map(roomListDiff)),
    );
  }

  final Future<void> Function(RoomFilter filter) _setFilter;
  final Future<void> Function() _loadMore;
  final Future<void> Function() _close;
  final _rooms = ValueNotifier<List<RoomSummary>>(const []);
  final _filter = ValueNotifier<RoomFilter>(RoomFilter.all);
  late final StreamSubscription<List<RoomListDiff>> _subscription;

  ValueListenable<List<RoomSummary>> get rooms => _rooms;

  ValueListenable<RoomFilter> get filter => _filter;

  Future<void> setFilter(RoomFilter filter) async {
    _filter.value = filter;
    await _setFilter(filter);
  }

  Future<void> loadMore() => _loadMore();

  /// Stops the Rust stream first: cancelling an idle generated stream only
  /// completes once it delivers another event or closes.
  Future<void> dispose() async {
    await _close();
    await _subscription.cancel();
    _rooms.dispose();
    _filter.dispose();
  }
}

/// Translates the generated room list diff into a generic [ListDiff].
ListDiff<RoomSummary> roomListDiff(RoomListDiff diff) => switch (diff) {
  RoomListDiff_Append(:final values) => ListAppend(values),
  RoomListDiff_Clear() => const ListClear(),
  RoomListDiff_PushFront(:final value) => ListPushFront(value),
  RoomListDiff_PushBack(:final value) => ListPushBack(value),
  RoomListDiff_PopFront() => const ListPopFront(),
  RoomListDiff_PopBack() => const ListPopBack(),
  RoomListDiff_Insert(:final index, :final value) => ListInsert(index, value),
  RoomListDiff_Set(:final index, :final value) => ListSet(index, value),
  RoomListDiff_Remove(:final index) => ListRemove(index),
  RoomListDiff_Truncate(:final length) => ListTruncate(length),
  RoomListDiff_Reset(:final values) => ListReset(values),
};
