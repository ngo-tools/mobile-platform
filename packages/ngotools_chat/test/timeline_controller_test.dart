import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:ngotools_chat/src/rust/api/timeline.dart';
import 'package:ngotools_chat/src/timeline_controller.dart';

TimelineItem divider(String id) => TimelineItem(
  id: id,
  kind: const TimelineItemKind.dateDivider(timestampMs: 0),
);

void main() {
  test('applies timeline diffs', () async {
    final diffs = StreamController<List<TimelineDiff>>();
    final controller = TimelineController.fromSource(
      diffs: diffs.stream,
      paginateBack: (_) async => false,
      close: () async {},
    );

    diffs.add([
      TimelineDiff.reset(values: [divider('a')]),
    ]);
    diffs.add([
      TimelineDiff.pushBack(value: divider('b')),
      TimelineDiff.pushFront(value: divider('start')),
    ]);
    await pumpEventQueue();

    expect(controller.items.value.map((item) => item.id), ['start', 'a', 'b']);

    await controller.dispose();
    await diffs.close();
  });

  test('paginates once at a time and stops at the start', () async {
    final diffs = StreamController<List<TimelineDiff>>();
    final pending = Completer<bool>();
    var calls = 0;
    var closed = false;
    final controller = TimelineController.fromSource(
      diffs: diffs.stream,
      paginateBack: (_) {
        calls++;
        return pending.future;
      },
      close: () async => closed = true,
    );

    final first = controller.paginateBack();
    await controller.paginateBack();
    expect(controller.isPaginating.value, isTrue);

    pending.complete(true);
    await first;
    await controller.paginateBack();

    expect(calls, 1);
    expect(controller.reachedStart.value, isTrue);
    expect(controller.isPaginating.value, isFalse);

    await controller.dispose();
    expect(closed, isTrue);
    await diffs.close();
  });
}
