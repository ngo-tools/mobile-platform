import 'package:flutter/foundation.dart';
import 'package:ngotools_api/ngotools_api.dart';
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
  Future<void> sendImage(ImageAttachment image) async =>
      calls.add('image:${image.filePath}:${image.caption}');

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

  bool failMedia = false;

  @override
  Future<Uint8List> media(ChatMedia media) async {
    calls.add('media:${media.reference}');

    if (failMedia) {
      throw const ChatException(ChatErrorKind.network);
    }

    return transparentPng;
  }

  List<ChatMember> roomMembers = const [];
  RoomNotificationSettings notifications = const RoomNotificationSettings(
    mode: NotificationMode.allMessages,
    isDefault: true,
  );
  bool failDirectChat = false;

  @override
  Future<String> createDirectChat(String userId) async {
    calls.add('dm:$userId');

    if (failDirectChat) {
      throw const ChatException(ChatErrorKind.network);
    }

    return '!dm-$userId';
  }

  @override
  Future<List<ChatMember>> members(String roomId) async => roomMembers;

  @override
  Future<RoomNotificationSettings> notificationSettings(String roomId) async =>
      notifications;

  @override
  Future<void> setNotificationMode(
    String roomId,
    NotificationMode? mode,
  ) async {
    calls.add('notify:${mode?.name ?? 'default'}');
    notifications = RoomNotificationSettings(
      mode: mode ?? NotificationMode.allMessages,
      isDefault: mode == null,
    );
  }
}

final class FakePeopleApi implements MobileChatApi {
  final searches = <String?>[];
  List<MobileChatPerson> people = const [
    MobileChatPerson(
      matrixUserId: '@maria.muster:example.org',
      displayName: 'Maria Muster',
      kind: MobileChatPersonKind.contact,
    ),
    MobileChatPerson(
      matrixUserId: '@tina.team:example.org',
      displayName: 'Tina Team',
      kind: MobileChatPersonKind.teamMember,
    ),
  ];
  bool fail = false;

  @override
  Future<MobileChatPeoplePage> listChatPeople({
    String? search,
    int page = 1,
    int perPage = 50,
  }) async {
    searches.add(search);

    if (fail) {
      throw Exception('offline');
    }

    final query = search?.toLowerCase() ?? '';

    return MobileChatPeoplePage(
      people: people.where(
        (person) => person.displayName.toLowerCase().contains(query),
      ),
      page: 1,
      lastPage: 1,
      total: people.length,
    );
  }

  @override
  Future<MobileChatAccount> fetchChatAccount() => throw UnimplementedError();

  @override
  Future<MobileChatSession> createChatSession({String? deviceName}) =>
      throw UnimplementedError();

  @override
  Future<MobileChatSession> renewChatSession() => throw UnimplementedError();

  @override
  Future<void> deleteChatSession() => throw UnimplementedError();
}

final class FakeImagePicker implements ChatImagePicker {
  ImageAttachment? result = const ImageAttachment(
    filePath: '/tmp/sommerfest.jpg',
    mimeType: 'image/jpeg',
    width: 1600,
    height: 1200,
  );
  final sources = <ChatImageSource>[];

  @override
  Future<ImageAttachment?> pick(ChatImageSource source) async {
    sources.add(source);

    return result;
  }
}

/// A 1×1 transparent PNG.
final transparentPng = Uint8List.fromList(const [
  0x89,
  0x50,
  0x4E,
  0x47,
  0x0D,
  0x0A,
  0x1A,
  0x0A,
  0x00,
  0x00,
  0x00,
  0x0D,
  0x49,
  0x48,
  0x44,
  0x52,
  0x00,
  0x00,
  0x00,
  0x01,
  0x00,
  0x00,
  0x00,
  0x01,
  0x08,
  0x06,
  0x00,
  0x00,
  0x00,
  0x1F,
  0x15,
  0xC4,
  0x89,
  0x00,
  0x00,
  0x00,
  0x0D,
  0x49,
  0x44,
  0x41,
  0x54,
  0x78,
  0x9C,
  0x63,
  0x00,
  0x01,
  0x00,
  0x00,
  0x05,
  0x00,
  0x01,
  0x0D,
  0x0A,
  0x2D,
  0xB4,
  0x00,
  0x00,
  0x00,
  0x00,
  0x49,
  0x45,
  0x4E,
  0x44,
  0xAE,
  0x42,
  0x60,
  0x82,
]);

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
