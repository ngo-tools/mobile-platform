import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_web_auth_2/flutter_web_auth_2.dart';
import 'package:image_picker/image_picker.dart';
import 'package:ngotools_chat/ngotools_chat.dart';
import 'package:path_provider/path_provider.dart';

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
  await RustLib.init();
  await initLogging(
    logFile: '${(await getApplicationSupportDirectory()).path}/chat-rust.log',
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
      theme: ThemeData(colorSchemeSeed: const Color(0xFF1B6E5A)),
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
  ChatClient? _client;
  SessionInfo? _session;
  String? _error;
  bool _busy = true;

  @override
  void initState() {
    super.initState();
    unawaited(_start());
  }

  Future<List<int>> _storeKey() async {
    const storage = FlutterSecureStorage();
    const keyName = 'ngotools.matrix.store_key';
    final existing = await storage.read(key: keyName);

    if (existing != null) {
      return base64Decode(existing);
    }

    final random = Random.secure();
    final key = List<int>.generate(32, (_) => random.nextInt(256));
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
      final client = await ChatClient.create(
        config: ChatConfig(
          homeserverUrl: homeserverUrl,
          dataDir: '$support/matrix',
          cacheDir: group == null ? '$cache/matrix' : cache,
          crossProcessHolder: group == null ? null : 'main',
          storeKey: Uint8List.fromList(await _storeKey()),
          clientName: 'NGO.Tools Chat Example',
          clientUri: 'https://ngo.tools/',
          redirectUri: '$callbackScheme:/oauth-callback',
          devRootCertificatePem: devRootCaBase64.isEmpty
              ? null
              : utf8.decode(base64Decode(devRootCaBase64)),
        ),
      );
      metrics.mark('client_created');
      final session = await client.restoreSession();
      metrics.mark('session_restored');

      if (session != null) {
        await client.startSync();
      }

      setState(() {
        _client = client;
        _session = session;
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
    final client = _client!;
    setState(() => _busy = true);

    try {
      final url = await client.loginUrl();
      final callback = await FlutterWebAuth2.authenticate(
        url: url,
        callbackUrlScheme: callbackScheme,
        options: const FlutterWebAuth2Options(preferEphemeral: true),
      );
      final session = await client.finishLogin(callbackUrl: callback);
      await client.startSync();
      setState(() {
        _session = session;
        _busy = false;
      });
    } on PlatformException catch (error) {
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
    await _client!.logout();
    setState(() => _session = null);
  }

  @override
  Widget build(BuildContext context) {
    if (_busy) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    if (_session == null) {
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
                onPressed: _client == null ? null : _login,
                child: const Text('Mit NGO.Tools Chat anmelden'),
              ),
            ],
          ),
        ),
      );
    }

    return RoomListScreen(
      client: _client!,
      session: _session!,
      onLogout: _logout,
    );
  }
}

class RoomListScreen extends StatefulWidget {
  const RoomListScreen({
    super.key,
    required this.client,
    required this.session,
    required this.onLogout,
  });

  final ChatClient client;
  final SessionInfo session;
  final VoidCallback onLogout;

  @override
  State<RoomListScreen> createState() => _RoomListScreenState();
}

class _RoomListScreenState extends State<RoomListScreen> {
  late final RoomListController _rooms;
  late final Stream<String> _syncState;

  @override
  void initState() {
    super.initState();
    _rooms = RoomListController(widget.client);
    _rooms.rooms.addListener(_markFirstRoomList);
    _syncState = widget.client.watchSyncState().asBroadcastStream();
  }

  void _markFirstRoomList() {
    if (_rooms.rooms.value.isNotEmpty) {
      metrics.mark('first_room_list');
    }
  }

  @override
  void dispose() {
    _rooms.rooms.removeListener(_markFirstRoomList);
    unawaited(_rooms.dispose());
    super.dispose();
  }

  Future<void> _startDm() async {
    final userId = await _prompt(context, 'Matrix-ID', '@bob:chat-e2e.test');

    if (userId == null || userId.isEmpty) {
      return;
    }

    final roomId = await widget.client.createDm(userId: userId);

    if (!mounted) {
      return;
    }

    await _openRoom(roomId, userId);
  }

  Future<void> _openRoom(String roomId, String name) async {
    await Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) =>
            RoomScreen(client: widget.client, roomId: roomId, title: name),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.session.userId),
        actions: [
          StreamBuilder<String>(
            stream: _syncState,
            builder: (context, snapshot) =>
                Center(child: Text(snapshot.data ?? '…')),
          ),
          IconButton(
            key: const Key('recovery'),
            icon: const Icon(Icons.key),
            onPressed: () => Navigator.of(context).push(
              MaterialPageRoute<void>(
                builder: (_) => RecoveryScreen(client: widget.client),
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
                      await widget.client.joinRoom(roomId: room.id);
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
  MessagePreview_Text(:final body) => body,
  MessagePreview_Image() => 'Bild',
  MessagePreview_Video() => 'Video',
  MessagePreview_Audio() => 'Audio',
  MessagePreview_File() => 'Datei',
  MessagePreview_Location() => 'Standort',
  MessagePreview_Poll() => 'Umfrage',
  MessagePreview_Sticker() => 'Sticker',
  MessagePreview_Redacted() => 'Nachricht gelöscht',
  MessagePreview_UnableToDecrypt() => 'Verschlüsselte Nachricht',
  MessagePreview_Other() => '',
};

class RoomScreen extends StatefulWidget {
  const RoomScreen({
    super.key,
    required this.client,
    required this.roomId,
    required this.title,
  });

  final ChatClient client;
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
    final controller = await TimelineController.open(
      widget.client,
      widget.roomId,
    );
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
      if (item.kind case TimelineItemKind_Event(:final event)
          when event.isOwn &&
              event.sendState is SendState_Sent &&
              event.content is EventContent_Text) {
        final body = (event.content as EventContent_Text).body;
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
    await controller.timeline.sendText(body: body);
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

    await controller.timeline.sendImage(
      filePath: image.path,
      mimeType: image.mimeType ?? 'image/jpeg',
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
      appBar: AppBar(title: Text(widget.title)),
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
                            client: widget.client,
                            timeline: controller.timeline,
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
    required this.client,
    required this.timeline,
    required this.item,
  });

  final ChatClient client;
  final ChatTimeline timeline;
  final TimelineItem item;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return switch (item.kind) {
      TimelineItemKind_Event(:final event) => Align(
        alignment: event.isOwn ? Alignment.centerRight : Alignment.centerLeft,
        child: Card(
          child: Padding(
            padding: const EdgeInsets.all(8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  event.sender.name ?? event.sender.id,
                  style: textTheme.labelSmall,
                ),
                if (event.replyTo case final reply?)
                  Text(
                    '↪ ${reply.sender?.name ?? reply.sender?.id ?? '…'}: '
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
                          onPressed: () => timeline.toggleReaction(
                            key: event.key,
                            reaction: reaction.key,
                          ),
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
                  SendState_Sending() => const Text(
                    'sendet …',
                    style: TextStyle(fontSize: 10),
                  ),
                  SendState_Failed(:final recoverable) => TextButton(
                    onPressed: recoverable
                        ? () => timeline.retry(key: event.key)
                        : () => timeline.cancel(key: event.key),
                    child: Text(
                      recoverable
                          ? 'fehlgeschlagen – erneut senden'
                          : 'fehlgeschlagen – verwerfen',
                    ),
                  ),
                  SendState_Sent() => const SizedBox.shrink(),
                },
              ],
            ),
          ),
        ),
      ),
      TimelineItemKind_DateDivider(:final timestampMs) => Center(
        child: Text(
          DateTime.fromMillisecondsSinceEpoch(
            timestampMs,
          ).toLocal().toString().substring(0, 10),
        ),
      ),
      TimelineItemKind_ReadMarker() => const Divider(color: Colors.red),
      TimelineItemKind_TimelineStart() => const Center(
        child: Text('Anfang des Raums'),
      ),
    };
  }

  Widget _content(EventContent content) {
    return switch (content) {
      EventContent_Text(:final body) => Text(body),
      EventContent_Image(:final media, :final caption, :final filename) =>
        FutureBuilder<Uint8List>(
          future: client.fetchMedia(media: media),
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
      EventContent_Video(:final filename) => Text('Video: $filename'),
      EventContent_Audio(:final filename) => Text('Audio: $filename'),
      EventContent_File(:final filename) => Text('Datei: $filename'),
      EventContent_UnableToDecrypt() => const Text(
        '🔒 Nachricht kann nicht entschlüsselt werden',
      ),
      EventContent_Redacted() => const Text('Nachricht gelöscht'),
      EventContent_Membership(:final userId, :final change) => Text(
        '$userId: ${change.name}',
      ),
      EventContent_ProfileChange(:final userId) => Text(
        '$userId hat das Profil geändert',
      ),
      EventContent_RoomState(:final eventType) => Text(
        'Raumänderung ($eventType)',
      ),
      EventContent_Unsupported() => const Text('Nicht unterstützter Inhalt'),
    };
  }
}

class RecoveryScreen extends StatefulWidget {
  const RecoveryScreen({super.key, required this.client});

  final ChatClient client;

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
    final status = await widget.client.recoveryStatus();
    setState(() => _status = status);
  }

  Future<void> _enable() async {
    final key = await widget.client.enableRecovery();
    setState(() => _recoveryKey = key);
    await _refresh();
  }

  Future<void> _recover() async {
    try {
      await widget.client.recover(recoveryKey: _input.text.trim());
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
