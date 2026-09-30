import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:ngotools_chat/ngotools_chat.dart';
import 'package:ngotools_design_system/ngotools_design_system.dart';

import 'chat_labels.dart';

/// Loads media bytes; the room view caches the futures per media.
typedef ChatMediaLoader = Future<Uint8List> Function(ChatMedia media);

/// An image message: preview in the image's aspect ratio, upload progress
/// while sending, full screen on tap.
final class ChatImageMessage extends StatelessWidget {
  /// Creates the image view of [content].
  const ChatImageMessage({
    required this.content,
    required this.sendState,
    required this.labels,
    required this.loadPreview,
    required this.loadFull,
    super.key,
  });

  /// Image content of the message.
  final ImageContent content;

  /// Send state (upload progress).
  final SendState sendState;

  /// Texts.
  final ChatLabels labels;

  /// Loads the preview (thumbnail if available).
  final ChatMediaLoader loadPreview;

  /// Loads the full image.
  final ChatMediaLoader loadFull;

  @override
  Widget build(BuildContext context) {
    final width = content.width;
    final height = content.height;
    final aspectRatio =
        width != null && height != null && width > 0 && height > 0
        ? (width / height).clamp(0.5, 2.0)
        : 4 / 3;
    final progress = switch (sendState) {
      Sending(:final progress?) when progress.totalBytes > 0 =>
        progress.currentBytes / progress.totalBytes,
      _ => null,
    };
    final caption = content.caption;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        ConstrainedBox(
          constraints: const BoxConstraints(maxHeight: 320, maxWidth: 280),
          child: AspectRatio(
            aspectRatio: aspectRatio,
            child: Semantics(
              image: true,
              button: true,
              label: caption ?? labels.imagePreview,
              child: GestureDetector(
                onTap: () => Navigator.of(context).push(
                  MaterialPageRoute<void>(
                    fullscreenDialog: true,
                    builder: (_) => ChatImagePage(
                      title: caption ?? content.filename,
                      labels: labels,
                      load: () => loadFull(content.media),
                    ),
                  ),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(
                    NgoToolsLayout.cornerRadius / 2,
                  ),
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                      _MediaImage(
                        load: () =>
                            loadPreview(content.thumbnail ?? content.media),
                        labels: labels,
                      ),
                      if (progress != null)
                        Align(
                          alignment: Alignment.bottomCenter,
                          child: Semantics(
                            label: labels.uploading((progress * 100).round()),
                            child: LinearProgressIndicator(value: progress),
                          ),
                        ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
        if (caption != null && caption.isNotEmpty)
          Padding(padding: const EdgeInsets.only(top: 4), child: Text(caption)),
      ],
    );
  }
}

/// An image in full screen with zoom.
final class ChatImagePage extends StatelessWidget {
  /// Creates the page.
  const ChatImagePage({
    required this.title,
    required this.labels,
    required this.load,
    super.key,
  });

  /// Title (caption or file name).
  final String title;

  /// Texts.
  final ChatLabels labels;

  /// Loads the full image.
  final Future<Uint8List> Function() load;

  @override
  Widget build(BuildContext context) => Scaffold(
    backgroundColor: Colors.black,
    appBar: AppBar(
      backgroundColor: Colors.black,
      foregroundColor: Colors.white,
      title: Text(title, maxLines: 1, overflow: TextOverflow.ellipsis),
      leading: IconButton(
        tooltip: labels.close,
        icon: const Icon(Icons.close),
        onPressed: () => Navigator.of(context).pop(),
      ),
    ),
    body: InteractiveViewer(
      maxScale: 5,
      child: Center(
        child: _MediaImage(load: load, labels: labels, fit: BoxFit.contain),
      ),
    ),
  );
}

final class _MediaImage extends StatefulWidget {
  const _MediaImage({
    required this.load,
    required this.labels,
    this.fit = BoxFit.cover,
  });

  final Future<Uint8List> Function() load;
  final ChatLabels labels;
  final BoxFit fit;

  @override
  State<_MediaImage> createState() => _MediaImageState();
}

final class _MediaImageState extends State<_MediaImage> {
  late final Future<Uint8List> _bytes = widget.load();

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return FutureBuilder<Uint8List>(
      future: _bytes,
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return ColoredBox(
            color: colors.surfaceContainerHighest,
            child: Center(
              child: Icon(
                Icons.broken_image_outlined,
                semanticLabel: widget.labels.imageLoadFailed,
              ),
            ),
          );
        }

        final bytes = snapshot.data;

        if (bytes == null) {
          return ColoredBox(
            color: colors.surfaceContainerHighest,
            child: const Center(child: CircularProgressIndicator()),
          );
        }

        return Image.memory(
          bytes,
          fit: widget.fit,
          gaplessPlayback: true,
          errorBuilder: (context, _, _) => Center(
            child: Icon(
              Icons.broken_image_outlined,
              semanticLabel: widget.labels.imageLoadFailed,
            ),
          ),
        );
      },
    );
  }
}
