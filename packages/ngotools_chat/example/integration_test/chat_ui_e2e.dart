import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:ngotools_chat/ngotools_chat.dart';
import 'package:ngotools_chat_module/ngotools_chat_module.dart';
import 'package:ngotools_design_system/ngotools_design_system.dart';

import 'chat_flow_e2e.dart' as flow;
import 'support/ui_e2e.dart';

/// Acceptance of the chat screens (M4) against the local e2e server: room
/// list, invite, room, send, reply and image with the real SDK.
void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  setUpAll(() async {
    const hostLogFile = String.fromEnvironment('RUST_LOG_FILE');
    await ChatSession.initialize(
      logFile: hostLogFile.isNotEmpty
          ? hostLogFile
          : '${Directory.systemTemp.path}/chat-ui-rust.log',
      level: ChatLogLevel.debug,
    );
  });

  testWidgets('chat screens with the real SDK', (tester) async {
    final run = DateTime.now().millisecondsSinceEpoch;
    final alice = await flow.loginUser(
      'alice',
      flow.aliceName,
      'ui-$run-alice',
      await flow.storeKey('ui-alice-$run'),
    );
    final bob = await flow.loginUser(
      'bob',
      flow.bobName,
      'ui-$run-bob',
      await flow.storeKey('ui-bob-$run'),
    );

    // Bob starts a direct chat; Alice sees the invite in the room list.
    final roomId = await bob.session.createDirectChat(
      '@${flow.aliceName}:${flow.serverName}',
    );
    await bob.openTimeline(roomId);
    await bob.timeline.sendText('Hallo aus dem Test $run');

    final gateway = SessionChatGateway(alice.session);
    final picker = _FilePicker();
    await tester.pumpWidget(
      MaterialApp(
        theme: NgoToolsTheme.community(),
        home: Scaffold(
          appBar: AppBar(title: const Text('Chats')),
          body: Builder(
            builder: (context) => ChatRoomListView(
              gateway: gateway,
              labels: ChatLabels.german,
              onOpenRoom: (room) => Navigator.of(context).push(
                MaterialPageRoute<void>(
                  builder: (_) => ChatRoomPage(
                    gateway: gateway,
                    labels: ChatLabels.german,
                    roomId: room.id,
                    title: room.name,
                    isGroup: room.kind == RoomKind.group,
                    imagePicker: picker,
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );

    await waitFor(tester, find.text('Annehmen'));
    flow.metric('ui_invite_shown', 'ok');
    await checkAccessibility(tester, 'room_list');
    debugPrint('E2E_SCREENSHOT ui-room-list-invite');
    await settle(tester, const Duration(seconds: 2));

    await tester.tap(find.text('Annehmen'));
    await waitFor(tester, find.byType(ListTile), absent: find.text('Annehmen'));
    await tester.tap(find.byType(ListTile).first);
    await waitFor(tester, find.text('Hallo aus dem Test $run'));
    flow.metric('ui_message_decrypted', 'ok');
    await checkAccessibility(tester, 'room');

    final composer = find.descendant(
      of: find.byType(ChatRoomView),
      matching: find.byType(TextField),
    );

    // Send from the composer; Bob receives it.
    await tester.enterText(composer, 'Antwort aus der App $run');
    await tester.pump();
    await tester.tap(find.byTooltip('Senden'));
    await bob.waitForTimeline(
      (items) => flow.hasText(items, 'Antwort aus der App $run'),
    );
    flow.metric('ui_send_received', 'ok');

    // Reply through the message actions.
    await tester.longPress(find.text('Hallo aus dem Test $run'));
    await settle(tester, const Duration(seconds: 1));
    await tester.tap(find.text('Antworten'));
    await settle(tester, const Duration(milliseconds: 500));
    await tester.enterText(composer, 'Zitiert $run');
    await tester.pump();
    await tester.tap(find.byTooltip('Senden'));
    final withReply = await bob.waitForTimeline(
      (items) => items.any(
        (item) =>
            item is EventTimelineItem &&
            item.event.content == EventContent.text('Zitiert $run') &&
            item.event.replyTo != null,
      ),
    );
    flow.metric('ui_reply_received', withReply.isNotEmpty ? 'ok' : 'missing');

    // Image with caption.
    picker.path = await _writePng(run);
    await tester.tap(find.byTooltip('Bild senden'));
    await settle(tester, const Duration(seconds: 1));
    await tester.tap(find.text('Galerie'));
    await waitFor(tester, find.text('Bildunterschrift (optional)'));
    await tester.enterText(
      find.widgetWithText(TextField, 'Bildunterschrift (optional)'),
      'Testbild $run',
    );
    await tester.tap(find.widgetWithText(FilledButton, 'Senden'));
    await bob.waitForTimeline(
      (items) => items.any(
        (item) =>
            item is EventTimelineItem &&
            item.event.content is ImageContent &&
            (item.event.content as ImageContent).caption == 'Testbild $run',
      ),
    );
    flow.metric('ui_image_received', 'ok');
    await waitFor(tester, find.text('Testbild $run'));
    debugPrint('E2E_SCREENSHOT ui-room');
    await settle(tester, const Duration(seconds: 2));

    await tester.pumpWidget(const SizedBox());
    await settle(tester, const Duration(seconds: 1));
    await alice.session.dispose();
    await bob.session.dispose();
    expect(accessibilityFailures, isEmpty);
  }, timeout: const Timeout(Duration(minutes: 6)));
}

Future<String> _writePng(int run) async {
  final file = File('${Directory.systemTemp.path}/ui-e2e-$run.png');
  await file.writeAsBytes(await flow.renderPng());

  return file.path;
}

final class _FilePicker implements ChatImagePicker {
  String? path;

  @override
  Future<ImageAttachment?> pick(ChatImageSource source) async =>
      prepareImageAttachment(filePath: path!, mimeType: 'image/png');
}
