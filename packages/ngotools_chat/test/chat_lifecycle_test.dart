import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ngotools_chat/src/chat_exception.dart';
import 'package:ngotools_chat/src/chat_lifecycle.dart';

void main() {
  late List<String> calls;
  late ChatLifecycleObserver observer;

  setUp(() {
    calls = [];
    observer = ChatLifecycleObserver.fromCallbacks(
      pause: () async => calls.add('pause'),
      resume: () async => calls.add('resume'),
    );
  });

  test('pauses in the background and resumes in the foreground', () async {
    for (final state in [
      AppLifecycleState.inactive,
      AppLifecycleState.hidden,
      AppLifecycleState.paused,
      AppLifecycleState.hidden,
      AppLifecycleState.inactive,
      AppLifecycleState.resumed,
      AppLifecycleState.resumed,
    ]) {
      observer.didChangeAppLifecycleState(state);
    }
    await observer.settled;

    expect(calls, ['pause', 'resume']);
  });

  test('keeps syncing while only inactive', () async {
    observer
      ..didChangeAppLifecycleState(AppLifecycleState.inactive)
      ..didChangeAppLifecycleState(AppLifecycleState.resumed);
    await observer.settled;

    expect(calls, isEmpty);
  });

  test('runs transitions in order and survives a failed resume', () async {
    final failing = ChatLifecycleObserver.fromCallbacks(
      pause: () async => calls.add('pause'),
      resume: () async {
        calls.add('resume');
        throw const ChatException(ChatErrorKind.sessionExpired);
      },
    );

    failing
      ..didChangeAppLifecycleState(AppLifecycleState.paused)
      ..didChangeAppLifecycleState(AppLifecycleState.resumed)
      ..didChangeAppLifecycleState(AppLifecycleState.paused);
    await failing.settled;

    expect(calls, ['pause', 'resume', 'pause']);
  });
}
