import 'dart:io';
import 'dart:ui' as ui;

import 'package:flutter_test/flutter_test.dart';
import 'package:ngotools_chat/src/image_attachment.dart';

Future<File> writePng(Directory directory, int width, int height) async {
  final recorder = ui.PictureRecorder();
  ui.Canvas(recorder).drawRect(
    ui.Rect.fromLTWH(0, 0, width.toDouble(), height.toDouble()),
    ui.Paint()..color = const ui.Color(0xFF1B6E5A),
  );
  final image = await recorder.endRecording().toImage(width, height);
  final png = await image.toByteData(format: ui.ImageByteFormat.png);
  image.dispose();

  return File('${directory.path}/image-${width}x$height.png')
    ..writeAsBytesSync(png!.buffer.asUint8List());
}

void main() {
  late Directory directory;

  setUp(() => directory = Directory.systemTemp.createTempSync('chat-image-'));

  tearDown(() => directory.deleteSync(recursive: true));

  testWidgets('scales a preview for large images and keeps the ratio', (
    tester,
  ) async {
    final attachment = await tester.runAsync(() async {
      final file = await writePng(directory, 1200, 600);

      return prepareImageAttachment(
        filePath: file.path,
        mimeType: 'image/png',
        caption: 'Bild',
      );
    });

    expect((attachment!.width, attachment.height), (1200, 600));
    expect(attachment.caption, 'Bild');
    expect(attachment.thumbnail?.mimeType, 'image/png');
    expect(
      (attachment.thumbnail?.width, attachment.thumbnail?.height),
      (480, 240),
    );
    expect(attachment.thumbnail!.data, isNotEmpty);
  });

  testWidgets('sends small images without a separate preview', (tester) async {
    final attachment = await tester.runAsync(() async {
      final file = await writePng(directory, 300, 200);

      return prepareImageAttachment(filePath: file.path, mimeType: 'image/png');
    });

    expect((attachment!.width, attachment.height), (300, 200));
    expect(attachment.thumbnail, isNull);
  });
}
