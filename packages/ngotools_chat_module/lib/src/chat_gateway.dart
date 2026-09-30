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

/// What the chat screens need from a running chat session; fakes replace it
/// in tests.
abstract interface class ChatGateway {
  /// Opens the room list; one at a time.
  Future<ChatRoomListSource> rooms();

  /// Accepts an invite.
  Future<void> joinRoom(String roomId);

  /// Leaves a room or declines an invite.
  Future<void> leaveRoom(String roomId);

  /// Loads a scaled thumbnail, e.g. of an avatar.
  Future<Uint8List> thumbnail(ChatMedia media, int size);
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
  Future<void> joinRoom(String roomId) => session.joinRoom(roomId);

  @override
  Future<void> leaveRoom(String roomId) => session.leaveRoom(roomId);

  @override
  Future<Uint8List> thumbnail(ChatMedia media, int size) =>
      session.fetchThumbnail(media, size, size);
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
