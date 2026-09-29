import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:ngotools_chat/src/rust/api/threads.dart';
import 'package:ngotools_chat/src/rust/api/timeline.dart';
import 'package:ngotools_chat/src/thread_list_controller.dart';

import 'support/rust_stream.dart';

ThreadInfo thread(String id, int replies) => ThreadInfo(
  root: ThreadEvent(
    eventId: id,
    sender: const Sender(id: '@alice:example.invalid'),
    timestampMs: 0,
    isOwn: false,
  ),
  replyCount: replies,
);

void main() {
  test('applies thread diffs and stops loading once complete', () async {
    final diffs = StreamController<List<ThreadListDiff>>();
    var pages = 0;
    final controller = ThreadListController.fromSource(
      diffs: diffs.stream,
      paginate: () async => ++pages == 2,
      close: () async {},
    );

    diffs.add([
      ThreadListDiff.reset(values: [thread(r'$a', 1)]),
    ]);
    diffs.add([
      ThreadListDiff.set_(index: 0, value: thread(r'$a', 2)),
      ThreadListDiff.pushBack(value: thread(r'$b', 1)),
    ]);
    await pumpEventQueue();

    expect(controller.threads.value.map((thread) => thread.replyCount), [2, 1]);

    await controller.loadMore();
    await controller.loadMore();
    await controller.loadMore();

    expect(pages, 2);
    expect(controller.isComplete.value, isTrue);

    await controller.dispose();
    await diffs.close();
  });

  test('dispose stops the Rust stream before cancelling it', () async {
    final source = StreamController<List<ThreadListDiff>>();
    final controller = ThreadListController.fromSource(
      diffs: rustLikeStream(source.stream),
      paginate: () async => true,
      close: source.close,
    );
    await pumpEventQueue();

    await controller.dispose().timeout(const Duration(seconds: 1));
  });
}
