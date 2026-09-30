import 'package:flutter/foundation.dart';
import 'package:ngotools_chat/ngotools_chat.dart';

/// The live room list the chat screens show.
abstract interface class ChatRoomListSource {
  /// Rooms, most recent activity first.
  ValueListenable<List<RoomSummary>> get rooms;

  /// Active filter.
  ValueListenable<RoomFilter> get filter;

  /// Changes the filter.
  Future<void> setFilter(RoomFilter filter);

  /// Extends the list by one page.
  Future<void> loadMore();

  /// Stops the list.
  Future<void> dispose();
}

/// A live timeline of a room or thread (chronological, oldest first).
abstract interface class ChatTimelineSource {
  /// Items, oldest first.
  ValueListenable<List<TimelineItem>> get items;

  /// Other members typing right now.
  ValueListenable<List<ChatUser>> get typing;

  /// Whether older events are being loaded.
  ValueListenable<bool> get isPaginating;

  /// Whether the start of the timeline was reached.
  ValueListenable<bool> get reachedStart;

  /// Loads older events.
  Future<void> paginateBack();

  /// Sends a text, optionally as a reply.
  Future<void> sendText(String body, {EventItem? replyTo});

  /// Sends an image; the upload progress appears on the local echo.
  Future<void> sendImage(ImageAttachment image);

  /// Replaces the text of an own message.
  Future<void> edit(EventItem item, String body);

  /// Deletes a message.
  Future<void> redact(EventItem item);

  /// Adds or removes the own reaction.
  Future<void> toggleReaction(EventItem item, String key);

  /// Sends a failed message again.
  Future<void> retry(EventItem item);

  /// Discards an unsent message.
  Future<void> cancel(EventItem item);

  /// Marks everything as read.
  Future<void> markRead();

  /// Loads sender and text of a replied-to message.
  Future<void> loadReplyDetails(String eventId);

  /// Tells the others whether the user is typing.
  Future<void> setTyping(bool typing);

  /// Stops the timeline.
  Future<void> dispose();
}

/// Threads of a room, most recent first.
abstract interface class ChatThreadListSource {
  /// Threads loaded so far.
  ValueListenable<List<ThreadInfo>> get threads;

  /// Whether a page is loading.
  ValueListenable<bool> get isLoading;

  /// Whether all threads are loaded.
  ValueListenable<bool> get isComplete;

  /// Loads the next page.
  Future<void> loadMore();

  /// Stops the list.
  Future<void> dispose();
}

/// What the chat screens need from a running chat session; fakes replace it
/// in tests.
abstract interface class ChatGateway {
  /// Opens the timeline of a room.
  Future<ChatTimelineSource> openTimeline(String roomId);

  /// Opens the timeline of a thread; messages sent through it go into the
  /// thread.
  Future<ChatTimelineSource> openThread(String roomId, String rootEventId);

  /// Opens the thread overview of a room.
  Future<ChatThreadListSource> openThreads(String roomId);

  /// Opens the room list; one at a time.
  Future<ChatRoomListSource> rooms();

  /// Accepts an invite.
  Future<void> joinRoom(String roomId);

  /// Leaves a room or declines an invite.
  Future<void> leaveRoom(String roomId);

  /// Loads a scaled thumbnail, e.g. of an avatar.
  Future<Uint8List> thumbnail(ChatMedia media, int size);

  /// Downloads (and decrypts) media in full size.
  Future<Uint8List> media(ChatMedia media);
}

/// [ChatGateway] of a signed-in [ChatSession].
final class SessionChatGateway implements ChatGateway {
  /// Creates the gateway for [session].
  SessionChatGateway(this.session);

  /// The running session.
  final ChatSession session;

  @override
  Future<ChatRoomListSource> rooms() async => _RoomList(session.rooms());

  @override
  Future<ChatTimelineSource> openTimeline(String roomId) async =>
      _Timeline(await session.openTimeline(roomId));

  @override
  Future<ChatTimelineSource> openThread(
    String roomId,
    String rootEventId,
  ) async => _Timeline(await session.openThread(roomId, rootEventId));

  @override
  Future<ChatThreadListSource> openThreads(String roomId) async =>
      _Threads(await session.openThreads(roomId));

  @override
  Future<void> joinRoom(String roomId) => session.joinRoom(roomId);

  @override
  Future<void> leaveRoom(String roomId) => session.leaveRoom(roomId);

  @override
  Future<Uint8List> thumbnail(ChatMedia media, int size) =>
      session.fetchThumbnail(media, size, size);

  @override
  Future<Uint8List> media(ChatMedia media) => session.fetchMedia(media);
}

final class _RoomList implements ChatRoomListSource {
  _RoomList(this._controller);

  final RoomListController _controller;

  @override
  ValueListenable<List<RoomSummary>> get rooms => _controller.rooms;

  @override
  ValueListenable<RoomFilter> get filter => _controller.filter;

  @override
  Future<void> setFilter(RoomFilter filter) => _controller.setFilter(filter);

  @override
  Future<void> loadMore() => _controller.loadMore();

  @override
  Future<void> dispose() => _controller.dispose();
}

final class _Timeline implements ChatTimelineSource {
  _Timeline(this._controller);

  final TimelineController _controller;

  @override
  ValueListenable<List<TimelineItem>> get items => _controller.items;

  @override
  ValueListenable<List<ChatUser>> get typing => _controller.typing;

  @override
  ValueListenable<bool> get isPaginating => _controller.isPaginating;

  @override
  ValueListenable<bool> get reachedStart => _controller.reachedStart;

  @override
  Future<void> paginateBack() => _controller.paginateBack();

  @override
  Future<void> sendText(String body, {EventItem? replyTo}) =>
      _controller.sendText(body, replyTo: replyTo);

  @override
  Future<void> sendImage(ImageAttachment image) => _controller.sendImage(image);

  @override
  Future<void> edit(EventItem item, String body) =>
      _controller.edit(item, body);

  @override
  Future<void> redact(EventItem item) => _controller.redact(item);

  @override
  Future<void> toggleReaction(EventItem item, String key) =>
      _controller.toggleReaction(item, key);

  @override
  Future<void> retry(EventItem item) => _controller.retry(item);

  @override
  Future<void> cancel(EventItem item) => _controller.cancel(item);

  @override
  Future<void> markRead() => _controller.markRead();

  @override
  Future<void> loadReplyDetails(String eventId) =>
      _controller.loadReplyDetails(eventId);

  @override
  Future<void> setTyping(bool typing) => _controller.setTyping(typing);

  @override
  Future<void> dispose() => _controller.dispose();
}

final class _Threads implements ChatThreadListSource {
  _Threads(this._controller);

  final ThreadListController _controller;

  @override
  ValueListenable<List<ThreadInfo>> get threads => _controller.threads;

  @override
  ValueListenable<bool> get isLoading => _controller.isLoading;

  @override
  ValueListenable<bool> get isComplete => _controller.isComplete;

  @override
  Future<void> loadMore() => _controller.loadMore();

  @override
  Future<void> dispose() => _controller.dispose();
}
