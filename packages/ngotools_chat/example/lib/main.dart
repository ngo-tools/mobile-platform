import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:flutter/foundation.dart' show kDebugMode;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_web_auth_2/flutter_web_auth_2.dart';
import 'package:image_picker/image_picker.dart';
import 'package:ngotools_chat/ngotools_chat.dart';
import 'package:ngotools_design_system/ngotools_design_system.dart';
import 'package:path_provider/path_provider.dart';

import 'module_chat.dart';

const homeserverUrl = String.fromEnvironment(
  'HOMESERVER',
  defaultValue: 'https://localhost:28448',
);
const devRootCaBase64 = String.fromEnvironment('DEV_ROOT_CA_B64');
const callbackScheme = 'tools.ngo.mobile.chat-example';

final metrics = Metrics();

Future<void> main() async {
  metrics.mark('main');
  WidgetsFlutterBinding.ensureInitialized();
  await ChatSession.initialize(
    logFile: '${(await getApplicationSupportDirectory()).path}/chat-rust.log',
    level: kDebugMode ? ChatLogLevel.debug : ChatLogLevel.info,
  );
  metrics.mark('rust_init');
  runApp(const ChatExampleApp());
}

/// Collects e2e measurements and prints them in a greppable format.
class Metrics {
  final _stopwatch = Stopwatch()..start();
  final Map<String, int> values = {};

  void mark(String name) {
    if (values.containsKey(name)) {
      return;
    }
    values[name] = _stopwatch.elapsedMilliseconds;
    debugPrint('E2E_METRIC $name=${values[name]}ms');
  }

  void record(String name, int milliseconds) {
    values[name] = milliseconds;
    debugPrint('E2E_METRIC $name=${milliseconds}ms');
  }
}

class ChatExampleApp extends StatelessWidget {
  const ChatExampleApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'NGO.Tools Chat Example',
      theme: NgoToolsTheme.community(),
      home: const Bootstrap(),
    );
  }
}

class Bootstrap extends StatefulWidget {
  const Bootstrap({super.key});

  @override
  State<Bootstrap> createState() => _BootstrapState();
}

class _BootstrapState extends State<Bootstrap> {
  ChatSession? _session;
  ChatAccount? _account;
  String? _error;
  bool _busy = true;

  @override
  void initState() {
    super.initState();
    unawaited(_start());
  }

  Future<Uint8List> _storeKey() async {
    const storage = FlutterSecureStorage();
    const keyName = 'ngotools.matrix.store_key';
    final existing = await storage.read(key: keyName);

    if (existing != null) {
      return base64Decode(existing);
    }

    final random = Random.secure();
    final key = Uint8List.fromList(
      List<int>.generate(32, (_) => random.nextInt(256)),
    );
    await storage.write(key: keyName, value: base64Encode(key));

    return key;
  }

  Future<void> _start() async {
    try {
      // iOS: store in the App Group so the Notification Service Extension can open it.
      final group = await NgotoolsChatPlatform.appGroupDirectory(
        'group.tools.ngo.mobile.chat-example',
      );
      final support = group ?? (await getApplicationSupportDirectory()).path;
      final cache = group == null
          ? (await getApplicationCacheDirectory()).path
          : '$group/matrix-cache';
      final session = await ChatSession.open(
        ChatSessionConfig(
          homeserverUrl: homeserverUrl,
          dataDirectory: '$support/matrix',
          cacheDirectory: group == null ? '$cache/matrix' : cache,
          crossProcessHolder: group == null ? null : 'main',
          storeKey: await _storeKey(),
          clientName: 'NGO.Tools Chat Example',
          clientUri: 'https://ngo.tools/',
          redirectUri: '$callbackScheme:/oauth-callback',
          devRootCertificatePem: devRootCaBase64.isEmpty
              ? null
              : utf8.decode(base64Decode(devRootCaBase64)),
        ),
      );
      metrics.mark('client_created');
      final account = await session.restore();
      metrics.mark('session_restored');

      if (account != null) {
        await session.startSync();
      }

      setState(() {
        _session = session;
        _account = account;
        _busy = false;
      });
    } catch (error) {
      setState(() {
        _error = '$error';
        _busy = false;
      });
    }
  }

  Future<void> _login() async {
    final session = _session!;
    setState(() => _busy = true);

    try {
      final url = await session.startLogin();
      final callback = await FlutterWebAuth2.authenticate(
        url: url.toString(),
        callbackUrlScheme: callbackScheme,
        options: const FlutterWebAuth2Options(preferEphemeral: true),
      );
      final account = await session.finishLogin(Uri.parse(callback));
      await session.startSync();
      setState(() {
        _account = account;
        _busy = false;
      });
    } on PlatformException catch (error) {
      await session.abortLogin();
      setState(() {
        _error = 'Anmeldung abgebrochen: ${error.message}';
        _busy = false;
      });
    } catch (error) {
      setState(() {
        _error = '$error';
        _busy = false;
      });
    }
  }

  Future<void> _logout() async {
    Navigator.of(context).popUntil((route) => route.isFirst);
    await _session!.logout();
    setState(() => _account = null);
  }

  @override
  Widget build(BuildContext context) {
    if (_busy) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    if (_account == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Chat-Beispiel')),
        body: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (_error != null)
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Text(
                    _error!,
                    style: const TextStyle(color: Colors.red),
                  ),
                ),
              FilledButton(
                key: const Key('login'),
                onPressed: _session == null ? null : _login,
                child: const Text('Mit NGO.Tools Chat anmelden'),
              ),
            ],
          ),
        ),
      );
    }

    return ModuleChatScreen(
      session: _session!,
      onLogout: _logout,
      onTechnicalView: () => Navigator.of(context).push(
        MaterialPageRoute<void>(
          builder: (_) => RoomListScreen(
            session: _session!,
            account: _account!,
            onLogout: _logout,
          ),
        ),
      ),
    );
  }
}

class RoomListScreen extends StatefulWidget {
  const RoomListScreen({
    super.key,
    required this.session,
    required this.account,
    required this.onLogout,
  });

  final ChatSession session;
  final ChatAccount account;
  final VoidCallback onLogout;

  @override
  State<RoomListScreen> createState() => _RoomListScreenState();
}

class _RoomListScreenState extends State<RoomListScreen> {
  late final RoomListController _rooms;
  late final ChatLifecycleObserver _lifecycle;

  @override
  void initState() {
    super.initState();
    _rooms = widget.session.rooms();
    _rooms.rooms.addListener(_markFirstRoomList);
    _lifecycle = ChatLifecycleObserver(widget.session)..attach();
  }

  void _markFirstRoomList() {
    if (_rooms.rooms.value.isNotEmpty) {
      metrics.mark('first_room_list');
    }
  }

  @override
  void dispose() {
    _rooms.rooms.removeListener(_markFirstRoomList);
    _lifecycle.detach();
    unawaited(_rooms.dispose());
    super.dispose();
  }

  Future<void> _startDm() async {
    final userId = await _prompt(context, 'Matrix-ID', '@bob:chat-e2e.test');

    if (userId == null || userId.isEmpty) {
      return;
    }

    final roomId = await widget.session.createDirectChat(userId);

    if (!mounted) {
      return;
    }

    await _openRoom(roomId, userId);
  }

  Future<void> _openRoom(String roomId, String name) async {
    await Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) =>
            RoomScreen(session: widget.session, roomId: roomId, title: name),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.account.userId),
        actions: [
          ValueListenableBuilder<ChatSyncStatus>(
            valueListenable: widget.session.syncStatus,
            builder: (context, status, _) => Center(child: Text(status.name)),
          ),
          IconButton(
            key: const Key('recovery'),
            icon: const Icon(Icons.key),
            onPressed: () => Navigator.of(context).push(
              MaterialPageRoute<void>(
                builder: (_) => RecoveryScreen(session: widget.session),
              ),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: widget.onLogout,
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        key: const Key('new_dm'),
        onPressed: _startDm,
        child: const Icon(Icons.chat),
      ),
      body: ValueListenableBuilder<List<RoomSummary>>(
        valueListenable: _rooms.rooms,
        builder: (context, rooms, _) {
          if (rooms.isEmpty) {
            return const Center(child: Text('Noch keine Räume'));
          }

          return ListView(
            children: [
              for (final room in rooms)
                ListTile(
                  leading: Icon(room.isEncrypted ? Icons.lock : Icons.forum),
                  title: Text(room.name),
                  subtitle: Text(
                    [
                      if (room.kind == RoomKind.direct) 'Direktnachricht',
                      if (room.membership == Membership.invited) 'Einladung',
                      if (room.unreadMessages > 0)
                        '${room.unreadMessages} ungelesen',
                      if (room.latest case final latest?)
                        _preview(latest.preview),
                    ].join(' · '),
                  ),
                  onTap: () async {
                    if (room.membership == Membership.invited) {
                      await widget.session.joinRoom(room.id);
                    }
                    await _openRoom(room.id, room.name);
                  },
                ),
            ],
          );
        },
      ),
    );
  }
}

String _preview(MessagePreview preview) => switch (preview) {
  TextPreview(:final body) => body,
  ImagePreview() => 'Bild',
  VideoPreview() => 'Video',
  AudioPreview() => 'Audio',
  FilePreview() => 'Datei',
  LocationPreview() => 'Standort',
  PollPreview() => 'Umfrage',
  StickerPreview() => 'Sticker',
  RedactedPreview() => 'Nachricht gelöscht',
  UnableToDecryptPreview() => 'Verschlüsselte Nachricht',
  OtherPreview() => '',
};

class RoomScreen extends StatefulWidget {
  const RoomScreen({
    super.key,
    required this.session,
    required this.roomId,
    required this.title,
  });

  final ChatSession session;
  final String roomId;
  final String title;

  @override
  State<RoomScreen> createState() => _RoomScreenState();
}

class _RoomScreenState extends State<RoomScreen> {
  final _input = TextEditingController();
  final _pendingSends = <String, Stopwatch>{};
  final _opened = Stopwatch()..start();
  TimelineController? _controller;

  @override
  void initState() {
    super.initState();
    unawaited(_open());
  }

  Future<void> _open() async {
    final controller = await widget.session.openTimeline(widget.roomId);
    controller.items.addListener(() => _onItems(controller.items.value));

    if (!mounted) {
      await controller.dispose();
      return;
    }

    setState(() => _controller = controller);
  }

  void _onItems(List<TimelineItem> items) {
    metrics.record('timeline_update_after_open', _opened.elapsedMilliseconds);

    for (final item in items) {
      if (item case EventTimelineItem(
        event: EventItem(
          isOwn: true,
          sendState: Sent(),
          content: TextContent(:final body),
        ),
      )) {
        final stopwatch = _pendingSends.remove(body);

        if (stopwatch != null) {
          metrics.record('send_latency', stopwatch.elapsedMilliseconds);
        }
      }
    }
  }

  Future<void> _send() async {
    final body = _input.text.trim();
    final controller = _controller;

    if (body.isEmpty || controller == null) {
      return;
    }

    _input.clear();
    _pendingSends[body] = Stopwatch()..start();
    await controller.sendText(body);
  }

  Future<void> _sendImage() async {
    final controller = _controller;
    final image = await ImagePicker().pickImage(
      source: ImageSource.gallery,
      maxWidth: 2048,
    );

    if (image == null || controller == null) {
      return;
    }

    await controller.sendImage(
      await prepareImageAttachment(
        filePath: image.path,
        mimeType: image.mimeType ?? 'image/jpeg',
      ),
    );
  }

  /// Device test of the notification extension (gate M0): copies the
  /// command that pushes the newest message of this room to this iPhone.
  Future<void> _pushTest(TimelineController controller) async {
    String? token;

    try {
      token = await const MethodChannel(
        'tools.ngo.chat_example/push',
      ).invokeMethod<String>('apnsToken');
    } on PlatformException catch (error) {
      token = null;
      debugPrint('push test: ${error.message}');
    }

    final latest = controller.items.value.reversed
        .whereType<EventTimelineItem>()
        .map((item) => item.event.eventId)
        .firstWhere((eventId) => eventId != null, orElse: () => null);

    if (!mounted) {
      return;
    }

    final command = token == null || latest == null
        ? null
        : 'python3 e2e/device/send_push.py --token $token '
              "--room '${widget.roomId}' --event '$latest'";

    if (command != null) {
      await Clipboard.setData(ClipboardData(text: command));
    }

    if (!mounted) {
      return;
    }

    await showDialog<void>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Push-Test'),
        content: SelectableText(
          command == null
              ? 'Kein APNs-Token oder keine Nachricht. Mitteilungen erlauben '
                    'und in diesem Chat eine Nachricht empfangen.'
              : 'Befehl kopiert. App in den Hintergrund legen, dann auf dem '
                    'Mac im Paket ngotools_chat ausführen:\n\n$command',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _input.dispose();
    unawaited(_controller?.dispose());
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final controller = _controller;

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        actions: [
          IconButton(
            tooltip: 'Push-Test',
            icon: const Icon(Icons.notifications_active_outlined),
            onPressed: controller == null ? null : () => _pushTest(controller),
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: controller == null
                ? const Center(child: CircularProgressIndicator())
                : ValueListenableBuilder<List<TimelineItem>>(
                    valueListenable: controller.items,
                    builder: (context, items, _) {
                      final newestFirst = items.reversed.toList();

                      return NotificationListener<ScrollEndNotification>(
                        onNotification: (notification) {
                          if (notification.metrics.extentAfter < 200) {
                            unawaited(controller.paginateBack());
                          }
                          return false;
                        },
                        child: ListView.builder(
                          reverse: true,
                          itemCount: newestFirst.length,
                          itemBuilder: (context, index) => TimelineTile(
                            key: ValueKey(newestFirst[index].id),
                            session: widget.session,
                            controller: controller,
                            item: newestFirst[index],
                          ),
                        ),
                      );
                    },
                  ),
          ),
          SafeArea(
            child: Row(
              children: [
                IconButton(
                  key: const Key('send_image'),
                  icon: const Icon(Icons.image),
                  onPressed: _sendImage,
                ),
                Expanded(
                  child: TextField(
                    key: const Key('composer'),
                    controller: _input,
                    decoration: const InputDecoration(hintText: 'Nachricht'),
                    onSubmitted: (_) => _send(),
                  ),
                ),
                IconButton(
                  key: const Key('send'),
                  icon: const Icon(Icons.send),
                  onPressed: _send,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class TimelineTile extends StatelessWidget {
  const TimelineTile({
    super.key,
    required this.session,
    required this.controller,
    required this.item,
  });

  final ChatSession session;
  final TimelineController controller;
  final TimelineItem item;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return switch (item) {
      EventTimelineItem(:final event) => Align(
        alignment: event.isOwn ? Alignment.centerRight : Alignment.centerLeft,
        child: Card(
          child: Padding(
            padding: const EdgeInsets.all(8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  event.sender.displayName ?? event.sender.id,
                  style: textTheme.labelSmall,
                ),
                if (event.replyTo case final reply?)
                  Text(
                    '↪ ${reply.sender?.displayName ?? reply.sender?.id ?? '…'}: '
                    '${reply.preview == null ? '…' : _preview(reply.preview!)}',
                    style: textTheme.bodySmall,
                  ),
                _content(event.content),
                if (event.reactions.isNotEmpty)
                  Wrap(
                    spacing: 4,
                    children: [
                      for (final reaction in event.reactions)
                        ActionChip(
                          label: Text('${reaction.key} ${reaction.count}'),
                          backgroundColor: reaction.byMe
                              ? Theme.of(context).colorScheme.primaryContainer
                              : null,
                          onPressed: () =>
                              controller.toggleReaction(event, reaction.key),
                        ),
                    ],
                  ),
                if (event.isEdited)
                  Text('bearbeitet', style: textTheme.labelSmall),
                if (event.thread case final thread?)
                  Text(
                    '${thread.replyCount} Antworten im Thread',
                    style: textTheme.labelSmall,
                  ),
                switch (event.sendState) {
                  Sending(:final progress) => Text(
                    progress == null
                        ? 'sendet …'
                        : 'lädt hoch … ${progress.currentBytes * 100 ~/ max(progress.totalBytes, 1)} %',
                    style: const TextStyle(fontSize: 10),
                  ),
                  SendFailed(:final recoverable) => TextButton(
                    onPressed: recoverable
                        ? () => controller.retry(event)
                        : () => controller.cancel(event),
                    child: Text(
                      recoverable
                          ? 'fehlgeschlagen – erneut senden'
                          : 'fehlgeschlagen – verwerfen',
                    ),
                  ),
                  Sent() => const SizedBox.shrink(),
                },
              ],
            ),
          ),
        ),
      ),
      DateDividerItem(:final date) => Center(
        child: Text(date.toLocal().toString().substring(0, 10)),
      ),
      ReadMarkerItem() => const Divider(color: Colors.red),
      TimelineStartItem() => const Center(child: Text('Anfang des Raums')),
    };
  }

  Widget _content(EventContent content) {
    return switch (content) {
      TextContent(:final body) => Text(body),
      ImageContent(
        :final media,
        :final thumbnail,
        :final caption,
        :final filename,
      ) =>
        FutureBuilder<Uint8List>(
          future: session.fetchMedia(thumbnail ?? media),
          builder: (context, snapshot) => snapshot.hasData
              ? Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Image.memory(snapshot.data!, width: 220),
                    if (caption != null) Text(caption),
                  ],
                )
              : Text(
                  snapshot.hasError
                      ? 'Bild nicht ladbar: ${snapshot.error}'
                      : 'Lade $filename …',
                ),
        ),
      VideoContent(:final filename) => Text('Video: $filename'),
      AudioContent(:final filename) => Text('Audio: $filename'),
      FileContent(:final filename) => Text('Datei: $filename'),
      UnableToDecryptContent() => const Text(
        '🔒 Nachricht kann nicht entschlüsselt werden',
      ),
      RedactedContent() => const Text('Nachricht gelöscht'),
      MembershipContent(:final userId, :final change) => Text(
        '$userId: ${change.name}',
      ),
      ProfileChangeContent(:final userId) => Text(
        '$userId hat das Profil geändert',
      ),
      RoomStateContent(:final eventType) => Text('Raumänderung ($eventType)'),
      UnsupportedContent() => const Text('Nicht unterstützter Inhalt'),
    };
  }
}

class RecoveryScreen extends StatefulWidget {
  const RecoveryScreen({super.key, required this.session});

  final ChatSession session;

  @override
  State<RecoveryScreen> createState() => _RecoveryScreenState();
}

class _RecoveryScreenState extends State<RecoveryScreen> {
  RecoveryStatus? _status;
  String? _recoveryKey;
  String? _message;
  final _input = TextEditingController();

  @override
  void initState() {
    super.initState();
    unawaited(_refresh());
  }

  Future<void> _refresh() async {
    final status = await widget.session.recoveryStatus();
    setState(() => _status = status);
  }

  Future<void> _enable() async {
    final key = await widget.session.enableRecovery();
    setState(() => _recoveryKey = key);
    await _refresh();
  }

  Future<void> _recover() async {
    try {
      await widget.session.recover(_input.text.trim());
      setState(() => _message = 'Wiederhergestellt');
    } catch (error) {
      setState(() => _message = '$error');
    }
    await _refresh();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Schlüssel-Backup')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Text(
            'Status: ${_status?.name ?? '…'}',
            key: const Key('recovery_status'),
          ),
          const SizedBox(height: 16),
          if (_status == RecoveryStatus.disabled)
            FilledButton(
              key: const Key('enable_recovery'),
              onPressed: _enable,
              child: const Text('Wiederherstellungsschlüssel erzeugen'),
            ),
          if (_recoveryKey != null)
            SelectableText(_recoveryKey!, key: const Key('recovery_key')),
          if (_status == RecoveryStatus.incomplete ||
              _status == RecoveryStatus.enabled) ...[
            TextField(
              key: const Key('recovery_input'),
              controller: _input,
              decoration: const InputDecoration(
                labelText: 'Wiederherstellungsschlüssel',
              ),
            ),
            FilledButton(
              key: const Key('recover'),
              onPressed: _recover,
              child: const Text('Wiederherstellen'),
            ),
          ],
          if (_message != null) Text(_message!),
        ],
      ),
    );
  }
}

Future<String?> _prompt(BuildContext context, String label, String hint) {
  final controller = TextEditingController(text: hint);

  return showDialog<String>(
    context: context,
    builder: (context) => AlertDialog(
      title: Text(label),
      content: TextField(
        key: const Key('prompt_input'),
        controller: controller,
      ),
      actions: [
        TextButton(
          key: const Key('prompt_ok'),
          onPressed: () => Navigator.of(context).pop(controller.text.trim()),
          child: const Text('OK'),
        ),
      ],
    ),
  );
}

bool get isIos => Platform.isIOS;
