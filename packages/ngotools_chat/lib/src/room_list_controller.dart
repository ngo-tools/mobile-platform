import 'dart:async';

import 'package:flutter/foundation.dart';

import 'chat_models.dart';
import 'diff_list.dart';
import 'mapping.dart';
import 'rust/api/client.dart' as rust;
import 'rust/api/rooms.dart' as rust;

/// Keeps the room list up to date from its diff stream. Get it via
/// `ChatSession.rooms()` after `startSync`; several room lists may run at
/// once, each with its own filter and paging.
class RoomListController {
  RoomListController._(rust.ChatClient client, BigInt watchId)
    : this.fromSource(
        diffs: client.watchRoomList(watchId: watchId),
        setFilter: (filter) =>
            client.setRoomFilter(watchId: watchId, filter: roomFilter(filter)),
        loadMore: () => client.loadMoreRooms(watchId: watchId),
        close: () => client.stopRoomList(watchId: watchId),
      );

  @visibleForTesting
  RoomListController.fromSource({
    required Stream<List<rust.RoomListDiff>> diffs,
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

  static int _nextWatchId = 0;

  final Future<void> Function(RoomFilter filter) _setFilter;
  final Future<void> Function() _loadMore;
  final Future<void> Function() _close;
  final _rooms = ValueNotifier<List<RoomSummary>>(const []);
  final _filter = ValueNotifier<RoomFilter>(RoomFilter.all);
  late final StreamSubscription<List<rust.RoomListDiff>> _subscription;

  /// Rooms, most recent activity first.
  ValueListenable<List<RoomSummary>> get rooms => _rooms;

  ValueListenable<RoomFilter> get filter => _filter;

  Future<void> setFilter(RoomFilter filter) async {
    _filter.value = filter;
    await guard(() => _setFilter(filter));
  }

  /// Extends the list by one page.
  Future<void> loadMore() => guard(_loadMore);

  /// Stops the Rust stream first: cancelling an idle generated stream only
  /// completes once it delivers another event or closes.
  Future<void> dispose() async {
    await _close();
    await _subscription.cancel();
    _rooms.dispose();
    _filter.dispose();
  }
}

/// Opens the room list of a client (used by `ChatSession`).
RoomListController roomListController(rust.ChatClient client) =>
    RoomListController._(
      client,
      BigInt.from(RoomListController._nextWatchId++),
    );

/// Translates a generated room list diff into a [ListDiff] of summaries.
ListDiff<RoomSummary> roomListDiff(rust.RoomListDiff diff) => switch (diff) {
  rust.RoomListDiff_Append(:final values) => ListAppend(
    values.map(roomSummary).toList(),
  ),
  rust.RoomListDiff_Clear() => const ListClear(),
  rust.RoomListDiff_PushFront(:final value) => ListPushFront(
    roomSummary(value),
  ),
  rust.RoomListDiff_PushBack(:final value) => ListPushBack(roomSummary(value)),
  rust.RoomListDiff_PopFront() => const ListPopFront(),
  rust.RoomListDiff_PopBack() => const ListPopBack(),
  rust.RoomListDiff_Insert(:final index, :final value) => ListInsert(
    index,
    roomSummary(value),
  ),
  rust.RoomListDiff_Set(:final index, :final value) => ListSet(
    index,
    roomSummary(value),
  ),
  rust.RoomListDiff_Remove(:final index) => ListRemove(index),
  rust.RoomListDiff_Truncate(:final length) => ListTruncate(length),
  rust.RoomListDiff_Reset(:final values) => ListReset(
    values.map(roomSummary).toList(),
  ),
};
