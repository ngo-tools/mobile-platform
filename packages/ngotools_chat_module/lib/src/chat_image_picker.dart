import 'package:image_picker/image_picker.dart';
import 'package:ngotools_chat/ngotools_chat.dart';

/// Where an image to send comes from.
enum ChatImageSource { camera, gallery }

/// Picks an image and prepares it for sending; fakes replace it in tests.
abstract interface class ChatImagePicker {
  /// Returns the prepared image, or `null` when the user cancelled.
  Future<ImageAttachment?> pick(ChatImageSource source);
}

/// [ChatImagePicker] on the platform picker; scales photos down to 2048 px
/// before upload.
final class PlatformChatImagePicker implements ChatImagePicker {
  /// Creates the picker.
  const PlatformChatImagePicker();

  @override
  Future<ImageAttachment?> pick(ChatImageSource source) async {
    final image = await ImagePicker().pickImage(
      source: switch (source) {
        ChatImageSource.camera => ImageSource.camera,
        ChatImageSource.gallery => ImageSource.gallery,
      },
      maxWidth: 2048,
      maxHeight: 2048,
      imageQuality: 85,
    );

    if (image == null) {
      return null;
    }

    return prepareImageAttachment(
      filePath: image.path,
      mimeType: image.mimeType ?? 'image/jpeg',
    );
  }
}
