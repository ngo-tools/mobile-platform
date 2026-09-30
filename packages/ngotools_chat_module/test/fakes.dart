import 'package:flutter/foundation.dart';
import 'package:ngotools_chat/ngotools_chat.dart';
import 'package:ngotools_chat_module/ngotools_chat_module.dart';

final class FakeRoomList implements ChatRoomListSource {
  @override
  final ValueNotifier<List<RoomSummary>> rooms = ValueNotifier(const []);

  @override
  final ValueNotifier<RoomFilter> filter = ValueNotifier(RoomFilter.all);

  int loadMoreCalls = 0;
  bool disposed = false;

  @override
  Future<void> setFilter(RoomFilter filter) async => this.filter.value = filter;

  @override
  Future<void> loadMore() async => loadMoreCalls++;

  @override
  Future<void> dispose() async => disposed = true;
}

final class FakeTimeline implements ChatTimelineSource {
  FakeTimeline(this.calls);

  final List<String> calls;

  @override
  final ValueNotifier<List<TimelineItem>> items = ValueNotifier(const []);

  @override
  final ValueNotifier<List<ChatUser>> typing = ValueNotifier(const []);

  @override
  final ValueNotifier<bool> isPaginating = ValueNotifier(false);

  @override
  final ValueNotifier<bool> reachedStart = ValueNotifier(false);

  bool failSend = false;
  bool disposed = false;

  @override
  Future<void> paginateBack() async => calls.add('paginate');

  @override
  Future<void> sendText(String body, {EventItem? replyTo}) async {
    calls.add(
      replyTo == null ? 'send:$body' : 'reply:${replyTo.eventId}:$body',
    );

    if (failSend) {
      throw const ChatException(ChatErrorKind.network);
    }
  }

  @override
  Future<void> edit(EventItem item, String body) async =>
      calls.add('edit:${item.eventId}:$body');

  @override
  Future<void> redact(EventItem item) async =>
      calls.add('redact:${item.eventId}');

  @override
  Future<void> toggleReaction(EventItem item, String key) async =>
      calls.add('react:${item.eventId}:$key');

  @override
  Future<void> retry(EventItem item) async => calls.add('retry');

  @override
  Future<void> cancel(EventItem item) async => calls.add('cancel');

  @override
  Future<void> markRead() async => calls.add('read');

  @override
  Future<void> loadReplyDetails(String eventId) async =>
      calls.add('replyDetails:$eventId');

  @override
  Future<void> setTyping(bool typing) async => calls.add('typing:$typing');

  @override
  Future<void> dispose() async => disposed = true;
}

final class FakeThreads implements ChatThreadListSource {
  @override
  final ValueNotifier<List<ThreadInfo>> threads = ValueNotifier(const []);

  @override
  final ValueNotifier<bool> isLoading = ValueNotifier(false);

  @override
  final ValueNotifier<bool> isComplete = ValueNotifier(true);

  @override
  Future<void> loadMore() async {}

  @override
  Future<void> dispose() async {}
}

final class FakeChatGateway implements ChatGateway {
  final list = FakeRoomList();
  final calls = <String>[];
  late final timeline = FakeTimeline(calls);
  final threads = FakeThreads();
  bool failJoin = false;

  @override
  Future<ChatRoomListSource> rooms() async => list;

  @override
  Future<ChatTimelineSource> openTimeline(String roomId) async {
    calls.add('open:$roomId');

    return timeline;
  }

  @override
  Future<ChatTimelineSource> openThread(
    String roomId,
    String rootEventId,
  ) async {
    calls.add('openThread:$rootEventId');

    return timeline;
  }

  @override
  Future<ChatThreadListSource> openThreads(String roomId) async => threads;

  @override
  Future<void> joinRoom(String roomId) async {
    calls.add('join:$roomId');

    if (failJoin) {
      throw const ChatException(ChatErrorKind.network);
    }
  }

  @override
  Future<void> leaveRoom(String roomId) async => calls.add('leave:$roomId');

  @override
  Future<Uint8List> thumbnail(ChatMedia media, int size) async => Uint8List(0);
}

EventItem chatEvent(
  String id,
  String body, {
  String sender = '@maria:example.org',
  String? senderName = 'Maria',
  bool isOwn = false,
  SendState sendState = const SendState.sent(),
  EventContent? content,
  ReplyPreview? replyTo,
  List<Reaction> reactions = const [],
  ThreadSummary? thread,
  bool isEdited = false,
  DateTime? timestamp,
}) => EventItem(
  key: EventKey.remote(id),
  eventId: id,
  sender: ChatUser(id: sender, displayName: senderName),
  timestamp: timestamp ?? DateTime(2026, 10, 1, 14, 30),
  isOwn: isOwn,
  canEdit: isOwn,
  canReply: true,
  sendState: sendState,
  content: content ?? EventContent.text(body),
  replyTo: replyTo,
  reactions: reactions,
  isEdited: isEdited,
  thread: thread,
);

TimelineItem eventItem(EventItem event) =>
    TimelineItem.event(id: 'item-${event.eventId}', event: event);
