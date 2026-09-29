import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:ngotools_chat/src/room_list_controller.dart';
import 'package:ngotools_chat/src/rust/api/rooms.dart';

RoomSummary room(String id, {int unread = 0}) => RoomSummary(
  id: id,
  name: 'Room $id',
  kind: RoomKind.group,
  membership: Membership.joined,
  isEncrypted: false,
  unreadMessages: unread,
  unreadMentions: 0,
);

void main() {
  test('applies room list diffs and forwards filter and paging', () async {
    final diffs = StreamController<List<RoomListDiff>>();
    final filters = <RoomFilter>[];
    var pages = 0;
    final controller = RoomListController.fromSource(
      diffs: diffs.stream,
      setFilter: (filter) async => filters.add(filter),
      loadMore: () async => pages++,
    );

    diffs.add([
      RoomListDiff.reset(values: [room('a'), room('b')]),
    ]);
    diffs.add([
      RoomListDiff.set_(index: 1, value: room('b', unread: 3)),
      RoomListDiff.pushFront(value: room('c')),
    ]);
    await pumpEventQueue();

    expect(controller.rooms.value.map((room) => room.id), ['c', 'a', 'b']);
    expect(controller.rooms.value.last.unreadMessages, 3);

    await controller.setFilter(RoomFilter.people);
    await controller.loadMore();

    expect(filters, [RoomFilter.people]);
    expect(controller.filter.value, RoomFilter.people);
    expect(pages, 1);

    await controller.dispose();
    await diffs.close();
  });
}
