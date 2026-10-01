import 'dart:async';

import 'package:flutter/material.dart';
import 'package:ngotools_chat/ngotools_chat.dart';
import 'package:ngotools_chat_module/ngotools_chat_module.dart';

/// The chat screens of `ngotools_chat_module` on a session signed in by the
/// example app: room list, rooms, details, security and recovery. Without
/// NGO.Tools there is no address book, so new direct chats start from the
/// technical view.
class ModuleChatScreen extends StatefulWidget {
  const ModuleChatScreen({
    super.key,
    required this.session,
    required this.onLogout,
    required this.onTechnicalView,
  });

  final ChatSession session;
  final Future<void> Function() onLogout;
  final VoidCallback onTechnicalView;

  @override
  State<ModuleChatScreen> createState() => _ModuleChatScreenState();
}

class _ModuleChatScreenState extends State<ModuleChatScreen> {
  late final ChatGateway _gateway = SessionChatGateway(widget.session);
  late final ChatLifecycleObserver _lifecycle;
  bool _recoveryOffered = false;

  final _labels = ChatLabels.german;

  @override
  void initState() {
    super.initState();
    _lifecycle = ChatLifecycleObserver(widget.session)..attach();
    _gateway.encryption.addListener(_offerRecovery);
    WidgetsBinding.instance.addPostFrameCallback((_) => _offerRecovery());
  }

  @override
  void dispose() {
    _gateway.encryption.removeListener(_offerRecovery);
    _lifecycle.detach();
    super.dispose();
  }

  /// Like `ChatHome`: once, when the chat opens without recovery or without
  /// the key on this device.
  void _offerRecovery() {
    final recovery = _gateway.encryption.value?.recovery;

    if (_recoveryOffered || !mounted) {
      return;
    }

    if (recovery == RecoveryStatus.disabled) {
      _recoveryOffered = true;
      unawaited(_setUpRecovery());
    } else if (recovery == RecoveryStatus.incomplete) {
      _recoveryOffered = true;
      unawaited(_recover());
    }
  }

  Future<void> _setUpRecovery() => Navigator.of(context).push<bool>(
    MaterialPageRoute(
      builder: (_) =>
          ChatRecoverySetupPage(gateway: _gateway, labels: _labels.encryption),
    ),
  );

  Future<void> _recover() => Navigator.of(context).push<bool>(
    MaterialPageRoute(
      builder: (_) =>
          ChatRecoverPage(gateway: _gateway, labels: _labels.encryption),
    ),
  );

  Future<void> _signOut() async {
    final allowed = await confirmChatSignOut(
      context,
      gateway: _gateway,
      labels: _labels.encryption,
    );

    if (allowed) {
      await widget.onLogout();
    }
  }

  Future<void> _openRoom(RoomSummary room) => Navigator.of(context).push(
    MaterialPageRoute<void>(
      builder: (_) => ChatRoomPage(
        gateway: _gateway,
        labels: _labels,
        roomId: room.id,
        title: room.name,
        isGroup: room.kind == RoomKind.group,
        onEnterRecoveryKey: () => unawaited(_recover()),
        actions: [
          Builder(
            builder: (context) => IconButton(
              tooltip: _labels.details,
              icon: const Icon(Icons.info_outline),
              onPressed: () async {
                final navigator = Navigator.of(context);
                final result = await navigator.push<ChatRoomDetailsResult>(
                  MaterialPageRoute(
                    builder: (_) => ChatRoomDetailsPage(
                      gateway: _gateway,
                      labels: _labels,
                      room: room,
                    ),
                  ),
                );

                if (result == ChatRoomDetailsResult.left &&
                    navigator.canPop()) {
                  navigator.pop();
                }
              },
            ),
          ),
        ],
      ),
    ),
  );

  @override
  Widget build(BuildContext context) {
    final labels = _labels;

    return Scaffold(
      appBar: AppBar(
        title: Text(labels.title),
        actions: [
          IconButton(
            tooltip: 'Technische Ansicht',
            icon: const Icon(Icons.developer_mode),
            onPressed: widget.onTechnicalView,
          ),
          IconButton(
            tooltip: 'Abmelden',
            icon: const Icon(Icons.logout),
            onPressed: () => unawaited(_signOut()),
          ),
        ],
      ),
      body: SafeArea(
        child: ChatRoomListView(
          gateway: _gateway,
          labels: labels,
          onOpenRoom: (room) => unawaited(_openRoom(room)),
          header: ChatRecoveryBanner(
            gateway: _gateway,
            labels: labels.encryption,
            onSetUp: () => unawaited(_setUpRecovery()),
            onRecover: () => unawaited(_recover()),
          ),
          actions: [
            IconButton(
              tooltip: labels.encryption.security,
              icon: const Icon(Icons.shield_outlined),
              onPressed: () => Navigator.of(context).push(
                MaterialPageRoute<void>(
                  builder: (_) => ChatSecurityPage(
                    gateway: _gateway,
                    labels: labels.encryption,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
