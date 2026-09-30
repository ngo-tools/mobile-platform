import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ngotools_chat/ngotools_chat.dart';
import 'package:ngotools_chat_module/ngotools_chat_module.dart';
import 'package:ngotools_design_system/ngotools_design_system.dart';

import 'fakes.dart';

void main() {
  late FakeChatGateway gateway;
  late FakeImagePicker picker;

  Future<void> pumpRoom(WidgetTester tester) async {
    tester.view.physicalSize = const Size(1080, 2340);
    tester.view.devicePixelRatio = 3;
    addTearDown(tester.view.reset);
    await tester.pumpWidget(
      MaterialApp(
        theme: NgoToolsTheme.community(),
        home: ChatRoomPage(
          gateway: gateway,
          labels: ChatLabels.german,
          roomId: '!room',
          title: 'Vorstand',
          isGroup: true,
          imagePicker: picker,
        ),
      ),
    );
    await tester.pumpAndSettle();
  }

  EventItem image({SendState sendState = const SendState.sent()}) => chatEvent(
    r'$img',
    '',
    isOwn: true,
    sendState: sendState,
    content: const EventContent.image(
      caption: 'Aufbau',
      filename: 'aufbau.jpg',
      media: ChatMedia('mxc://full'),
      thumbnail: ChatMedia('mxc://thumb'),
      width: 1600,
      height: 1200,
    ),
  );

  setUp(() {
    gateway = FakeChatGateway();
    picker = FakeImagePicker();
  });

  testWidgets('sends a picked image with a caption', (tester) async {
    await pumpRoom(tester);

    await tester.tap(find.byTooltip('Bild senden'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Galerie'));
    await tester.pumpAndSettle();
    await tester.enterText(
      find.widgetWithText(TextField, 'Bildunterschrift (optional)'),
      'Sommerfest',
    );
    await tester.tap(find.widgetWithText(FilledButton, 'Senden'));
    await tester.pumpAndSettle();

    expect(picker.sources, [ChatImageSource.gallery]);
    expect(gateway.calls, contains('image:/tmp/sommerfest.jpg:Sommerfest'));
  });

  testWidgets('sends nothing when picking is cancelled', (tester) async {
    picker.result = null;
    await pumpRoom(tester);

    await tester.tap(find.byTooltip('Bild senden'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Kamera'));
    await tester.pumpAndSettle();

    expect(picker.sources, [ChatImageSource.camera]);
    expect(gateway.calls.where((call) => call.startsWith('image:')), isEmpty);
  });

  testWidgets('shows the preview with its caption and upload progress', (
    tester,
  ) async {
    final semantics = tester.ensureSemantics();
    gateway.timeline.items.value = [
      eventItem(
        image(
          sendState: const SendState.sending(
            progress: UploadProgress(currentBytes: 40, totalBytes: 100),
          ),
        ),
      ),
    ];
    await pumpRoom(tester);

    expect(gateway.calls, contains('media:mxc://thumb'));
    expect(find.text('Aufbau'), findsOneWidget);
    expect(find.byType(LinearProgressIndicator), findsOneWidget);
    expect(find.bySemanticsLabel('Wird hochgeladen … 40 %'), findsOneWidget);
    semantics.dispose();
  });

  testWidgets('opens the full image and closes it again', (tester) async {
    gateway.timeline.items.value = [eventItem(image())];
    await pumpRoom(tester);

    await tester.tap(
      find.descendant(
        of: find.byType(ChatImageMessage),
        matching: find.byType(ClipRRect),
      ),
    );
    await tester.pumpAndSettle();

    expect(gateway.calls, contains('media:mxc://full'));
    expect(find.byType(InteractiveViewer), findsOneWidget);

    await tester.tap(find.byTooltip('Schließen'));
    await tester.pumpAndSettle();
    expect(find.byType(InteractiveViewer), findsNothing);
  });

  testWidgets('marks images that cannot be loaded', (tester) async {
    gateway.failMedia = true;
    gateway.timeline.items.value = [eventItem(image())];
    await pumpRoom(tester);

    expect(find.byIcon(Icons.broken_image_outlined), findsOneWidget);
  });
}
