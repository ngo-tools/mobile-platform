import 'dart:io';
import 'dart:math';
import 'dart:ui' as ui;

import 'rust/api/timeline.dart';

/// Reads the pixel size of an image file and renders a PNG preview whose
/// longest side is at most [maxThumbnailSize].
///
/// Encrypted rooms need the preview: the server cannot scale encrypted
/// media. Images that are already small enough get no separate preview.
Future<ImageAttachment> prepareImageAttachment({
  required String filePath,
  required String mimeType,
  String? caption,
  int maxThumbnailSize = 480,
}) async {
  final buffer = await ui.ImmutableBuffer.fromUint8List(
    await File(filePath).readAsBytes(),
  );
  final descriptor = await ui.ImageDescriptor.encoded(buffer);

  try {
    final width = descriptor.width;
    final height = descriptor.height;

    return ImageAttachment(
      filePath: filePath,
      mimeType: mimeType,
      caption: caption,
      width: width,
      height: height,
      thumbnail: max(width, height) > maxThumbnailSize
          ? await _thumbnail(descriptor, maxThumbnailSize)
          : null,
    );
  } finally {
    descriptor.dispose();
    buffer.dispose();
  }
}

Future<ImageThumbnail> _thumbnail(
  ui.ImageDescriptor descriptor,
  int maxSize,
) async {
  final scale = maxSize / max(descriptor.width, descriptor.height);
  final codec = await descriptor.instantiateCodec(
    targetWidth: max(1, (descriptor.width * scale).round()),
    targetHeight: max(1, (descriptor.height * scale).round()),
  );

  try {
    final image = (await codec.getNextFrame()).image;

    try {
      final png = await image.toByteData(format: ui.ImageByteFormat.png);

      return ImageThumbnail(
        data: png!.buffer.asUint8List(),
        mimeType: 'image/png',
        width: image.width,
        height: image.height,
      );
    } finally {
      image.dispose();
    }
  } finally {
    codec.dispose();
  }
}
