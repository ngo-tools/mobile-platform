import 'dart:async';

import 'package:flutter/material.dart';
import 'package:ngotools_api/ngotools_api.dart';
import 'package:ngotools_chat/ngotools_chat.dart';
import 'package:ngotools_design_system/ngotools_design_system.dart';

import 'chat_client.dart';
import 'chat_connection_state.dart';
import 'chat_connection_view.dart';
import 'chat_connector.dart';
import 'chat_gateway.dart';
import 'chat_image_picker.dart';
import 'chat_labels.dart';
import 'new_chat_page.dart';
import 'room_details_page.dart';
import 'room_list_view.dart';
import 'room_view.dart';

/// Opens rooms from outside the chat, e.g. from a deep link or a push.
final class ChatHomeController extends ChangeNotifier {
  String? _pendingRoomId;

  /// Room waiting to be opened.
  String? get pendingRoomId => _pendingRoomId;

  /// Opens [roomId] as soon as the chat is connected and the room is known.
  void openRoom(String roomId) {
    _pendingRoomId = roomId;
    notifyListeners();
  }

  /// Takes the pending room.
  String? takePendingRoom() {
    final roomId = _pendingRoomId;
    _pendingRoomId = null;

    return roomId;
  }
}

/// Paths of the chat module: `/chat` and `/chat/rooms/{id}`.
abstract final class ChatDeepLink {
  /// Room id of a `/chat/rooms/{id}` link; `null` for `/chat` and other paths.
  static String? roomId(Uri uri) {
    final segments = uri.pathSegments;

    if (segments.length == 3 &&
        segments[0] == 'chat' &&
        segments[1] == 'rooms') {
      return segments[2].isEmpty ? null : segments[2];
    }

    return null;
  }

  /// Whether [uri] belongs to the chat module.
  static bool matches(Uri uri) =>
      uri.pathSegments.isNotEmpty && uri.pathSegments.first == 'chat';
}

/// The chat destination of an organization app: connection states, room
/// list, rooms, new direct chats and details. Uses a list and a room side by
/// side from [splitBreakpoint] on.
final class ChatHome extends StatefulWidget {
  /// Creates the chat destination.
  const ChatHome({
    required this.connector,
    required this.api,
    required this.labels,
    this.controller,
    this.imagePicker = const PlatformChatImagePicker(),
    this.splitBreakpoint = NgoToolsLayout.navigationRailBreakpoint,
    this.gatewayFor = _sessionGateway,
    this.now,
    super.key,
  });

  /// Connection to the chat.
  final ChatConnector connector;

  /// NGO.Tools address book.
  final MobileChatApi api;

  /// Texts.
  final ChatLabels labels;

  /// Opens rooms from deep links.
  final ChatHomeController? controller;

  /// Picks images to send.
  final ChatImagePicker imagePicker;

  /// Width from which list and room are shown side by side.
  final double splitBreakpoint;

  /// Gateway of a connected client; replaceable in tests.
  final ChatGateway Function(ChatClient client) gatewayFor;

  static ChatGateway _sessionGateway(ChatClient client) =>
      SessionChatGateway(client.session);

  /// Current time, injectable for tests.
  final DateTime Function()? now;

  @override
  State<ChatHome> createState() => _ChatHomeState();
}

final class _ChatHomeState extends State<ChatHome> {
  StreamSubscription<ChatConnectionState>? _subscription;
  late ChatConnectionState _state = widget.connector.state;
  ChatGateway? _gateway;
  ChatClient? _gatewayClient;
  ChatRoomListSource? _rooms;
  RoomSummary? _selected;
  final _navigator = GlobalKey<NavigatorState>();

  @override
  void initState() {
    super.initState();
    _subscription = widget.connector.stream.listen((state) {
      setState(() => _state = state);
      unawaited(_updateGateway());
    });
    widget.controller?.addListener(_openPending);
    unawaited(_updateGateway());

    if (_state is ChatDisconnected) {
      unawaited(widget.connector.connect());
    }
  }

  @override
  void dispose() {
    unawaited(_subscription?.cancel());
    widget.controller?.removeListener(_openPending);
    _rooms?.rooms.removeListener(_openPending);
    unawaited(_rooms?.dispose());
    super.dispose();
  }

  Future<void> _updateGateway() async {
    final state = _state;

    if (state is! ChatConnected) {
      return;
    }

    if (identical(state.client, _gatewayClient)) {
      return;
    }

    _rooms?.rooms.removeListener(_openPending);
    unawaited(_rooms?.dispose());
    _gatewayClient = state.client;
    final gateway = widget.gatewayFor(state.client);
    final rooms = await gateway.rooms();

    if (!mounted) {
      await rooms.dispose();
      return;
    }

    rooms.rooms.addListener(_openPending);
    setState(() {
      _gateway = gateway;
      _rooms = rooms;
      _selected = null;
    });
    _openPending();
  }

  void _openPending() {
    final controller = widget.controller;
    final rooms = _rooms;
    final roomId = controller?.pendingRoomId;

    if (controller == null || rooms == null || roomId == null) {
      return;
    }

    final room = rooms.rooms.value
        .where((room) => room.id == roomId)
        .firstOrNull;

    if (room == null) {
      return;
    }

    controller.takePendingRoom();
    WidgetsBinding.instance
      ..addPostFrameCallback((_) => _open(room))
      ..scheduleFrame();
  }

  @override
  Widget build(BuildContext context) => ChatConnectionView(
    state: _state,
    labels: widget.labels,
    onRetry: () => unawaited(widget.connector.connect()),
    builder: (context, _) {
      final gateway = _gateway;
      final rooms = _rooms;

      if (gateway == null || rooms == null) {
        return const Center(child: CircularProgressIndicator());
      }

      return LayoutBuilder(
        builder: (context, constraints) =>
            constraints.maxWidth >= widget.splitBreakpoint
            ? _split(gateway, rooms)
            : _single(gateway, rooms),
      );
    },
  );

  Widget _single(ChatGateway gateway, ChatRoomListSource rooms) => Navigator(
    key: _navigator,
    onGenerateRoute: (_) => MaterialPageRoute<void>(
      builder: (context) => Scaffold(
        body: _list(gateway, rooms),
        floatingActionButton: _newChatButton(gateway),
      ),
    ),
  );

  Widget _split(ChatGateway gateway, ChatRoomListSource rooms) {
    final selected = _selected;

    return Row(
      children: [
        SizedBox(
          width: 360,
          child: Scaffold(
            body: _list(gateway, rooms),
            floatingActionButton: _newChatButton(gateway),
          ),
        ),
        const VerticalDivider(width: 1),
        Expanded(
          child: selected == null
              ? NgoToolsEmptyState(
                  icon: Icons.forum_outlined,
                  title: widget.labels.title,
                  message: '',
                )
              : Navigator(
                  key: ValueKey(selected.id),
                  onGenerateRoute: (_) => MaterialPageRoute<void>(
                    builder: (_) => _roomPage(gateway, selected),
                  ),
                ),
        ),
      ],
    );
  }

  Widget _list(ChatGateway gateway, ChatRoomListSource rooms) =>
      ChatRoomListView(
        gateway: gateway,
        labels: widget.labels,
        source: rooms,
        selectedRoomId: _selected?.id,
        onOpenRoom: _open,
        now: widget.now,
      );

  Widget _newChatButton(ChatGateway gateway) => FloatingActionButton(
    tooltip: widget.labels.newChat,
    onPressed: () => unawaited(_startChat(gateway)),
    child: const Icon(Icons.edit_square),
  );

  Future<void> _startChat(ChatGateway gateway) async {
    final navigator = _navigatorFor();
    final result = await navigator.push<ChatStartedDirectChat>(
      MaterialPageRoute(
        builder: (_) => ChatNewChatPage(
          api: widget.api,
          gateway: gateway,
          labels: widget.labels,
        ),
      ),
    );

    if (result == null || !mounted) {
      return;
    }

    final known = _rooms?.rooms.value
        .where((room) => room.id == result.roomId)
        .firstOrNull;

    _open(
      known ??
          RoomSummary(
            id: result.roomId,
            name: result.name,
            kind: RoomKind.direct,
            membership: Membership.joined,
            isEncrypted: true,
            unreadMessages: 0,
            unreadMentions: 0,
          ),
    );
  }

  void _open(RoomSummary room) {
    if (!mounted) {
      return;
    }

    final split = (context.findRenderObject() as RenderBox?)?.size.width ?? 0;

    if (split >= widget.splitBreakpoint) {
      setState(() => _selected = room);
      return;
    }

    unawaited(
      _navigatorFor().push(
        MaterialPageRoute<void>(builder: (_) => _roomPage(_gateway!, room)),
      ),
    );
  }

  NavigatorState _navigatorFor() =>
      _navigator.currentState ?? Navigator.of(context);

  Widget _roomPage(ChatGateway gateway, RoomSummary room) => ChatRoomPage(
    gateway: gateway,
    labels: widget.labels,
    roomId: room.id,
    title: room.name,
    isGroup: room.kind == RoomKind.group,
    imagePicker: widget.imagePicker,
    now: widget.now,
    actions: [
      Builder(
        builder: (context) => IconButton(
          tooltip: widget.labels.details,
          icon: const Icon(Icons.info_outline),
          onPressed: () async {
            final navigator = Navigator.of(context);
            final result = await navigator.push<ChatRoomDetailsResult>(
              MaterialPageRoute(
                builder: (_) => ChatRoomDetailsPage(
                  gateway: gateway,
                  labels: widget.labels,
                  room: room,
                ),
              ),
            );

            if (result != ChatRoomDetailsResult.left || !mounted) {
              return;
            }

            if (_selected?.id == room.id) {
              setState(() => _selected = null);
            } else if (navigator.canPop()) {
              navigator.pop();
            }
          },
        ),
      ),
    ],
  );
}
