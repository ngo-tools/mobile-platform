import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_web_auth_2/flutter_web_auth_2.dart';
import 'package:image_picker/image_picker.dart';
import 'package:ngotools_matrix/ngotools_matrix.dart';
import 'package:path_provider/path_provider.dart';

const homeserverUrl = String.fromEnvironment(
  'HOMESERVER',
  defaultValue: 'https://localhost:28448',
);
const devRootCaBase64 = String.fromEnvironment('DEV_ROOT_CA_B64');
const callbackScheme = 'tools.ngo.spike.matrix';

final metrics = Metrics();

Future<void> main() async {
  metrics.mark('main');
  WidgetsFlutterBinding.ensureInitialized();
  await RustLib.init();
  await initLogging(logFile: '${(await getApplicationSupportDirectory()).path}/spike-rust.log');
  metrics.mark('rust_init');
  runApp(const SpikeApp());
}

/// Collects spike measurements and prints them in a greppable format.
class Metrics {
  final _stopwatch = Stopwatch()..start();
  final Map<String, int> values = {};

  void mark(String name) {
    if (values.containsKey(name)) {
      return;
    }
    values[name] = _stopwatch.elapsedMilliseconds;
    debugPrint('SPIKE_METRIC $name=${values[name]}ms');
  }

  void record(String name, int milliseconds) {
    values[name] = milliseconds;
    debugPrint('SPIKE_METRIC $name=${milliseconds}ms');
  }
}

class SpikeApp extends StatelessWidget {
  const SpikeApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'NGO.Tools Chat Spike',
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
      final group = await NgotoolsMatrixPlatform.appGroupDirectory('group.tools.ngo.spike.matrix');
      final support = group ?? (await getApplicationSupportDirectory()).path;
      final cache = group == null ? (await getApplicationCacheDirectory()).path : '$group/matrix-cache';
      final client = await ChatClient.create(
        config: ChatConfig(
          homeserverUrl: homeserverUrl,
          dataDir: '$support/matrix',
          cacheDir: group == null ? '$cache/matrix' : cache,
          crossProcessHolder: group == null ? null : 'main',
          storeKey: Uint8List.fromList(await _storeKey()),
          clientName: 'NGO.Tools Chat Spike',
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
        appBar: AppBar(title: const Text('Chat-Spike')),
        body: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (_error != null)
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Text(_error!, style: const TextStyle(color: Colors.red)),
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

    return RoomListScreen(client: _client!, session: _session!, onLogout: _logout);
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
  late final Stream<List<RoomSummary>> _rooms;
  late final Stream<String> _syncState;

  @override
  void initState() {
    super.initState();
    _rooms = widget.client.watchRooms().map((rooms) {
      if (rooms.isNotEmpty) {
        metrics.mark('first_room_list');
      }
      return rooms;
    }).asBroadcastStream();
    _syncState = widget.client.watchSyncState().asBroadcastStream();
  }

  Future<void> _startDm() async {
    final userId = await _prompt(context, 'Matrix-ID', '@bob:ngo-spike.test');

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
        builder: (_) => RoomScreen(client: widget.client, roomId: roomId, title: name),
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
            builder: (context, snapshot) => Center(child: Text(snapshot.data ?? '…')),
          ),
          IconButton(
            key: const Key('recovery'),
            icon: const Icon(Icons.key),
            onPressed: () => Navigator.of(context).push(
              MaterialPageRoute<void>(builder: (_) => RecoveryScreen(client: widget.client)),
            ),
          ),
          IconButton(icon: const Icon(Icons.logout), onPressed: widget.onLogout),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        key: const Key('new_dm'),
        onPressed: _startDm,
        child: const Icon(Icons.chat),
      ),
      body: StreamBuilder<List<RoomSummary>>(
        stream: _rooms,
        builder: (context, snapshot) {
          final rooms = snapshot.data;

          if (rooms == null) {
            return const Center(child: CircularProgressIndicator());
          }

          if (rooms.isEmpty) {
            return const Center(child: Text('Noch keine Räume'));
          }

          return ListView(
            children: [
              for (final room in rooms)
                ListTile(
                  leading: Icon(room.isEncrypted ? Icons.lock : Icons.forum),
                  title: Text(room.displayName),
                  subtitle: Text(
                    [
                      if (room.isDirect) 'Direktnachricht',
                      if (room.isInvite) 'Einladung',
                      if (room.unreadCount > BigInt.zero) '${room.unreadCount} ungelesen',
                    ].join(' · '),
                  ),
                  onTap: () async {
                    if (room.isInvite) {
                      await widget.client.joinRoom(roomId: room.roomId);
                    }
                    await _openRoom(room.roomId, room.displayName);
                  },
                ),
            ],
          );
        },
      ),
    );
  }
}

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
  Stream<List<TimelineEntry>>? _timeline;
  bool _reachedStart = false;

  @override
  void initState() {
    super.initState();
    final opened = Stopwatch()..start();
    _timeline = Stream.fromFuture(widget.client.openTimeline(roomId: widget.roomId))
        .asyncExpand((_) => widget.client.watchTimeline())
        .map((entries) {
      metrics.record('timeline_update_after_open', opened.elapsedMilliseconds);
      _trackSendLatency(entries);
      return entries;
    });
  }

  void _trackSendLatency(List<TimelineEntry> entries) {
    for (final entry in entries) {
      if (entry case TimelineEntry_Message(:final isOwn, :final isSending, :final kind)
          when isOwn && !isSending && kind is MessageKind_Text) {
        final stopwatch = _pendingSends.remove(kind.body);

        if (stopwatch != null) {
          metrics.record('send_latency', stopwatch.elapsedMilliseconds);
        }
      }
    }
  }

  Future<void> _send() async {
    final body = _input.text.trim();

    if (body.isEmpty) {
      return;
    }

    _input.clear();
    _pendingSends[body] = Stopwatch()..start();
    await widget.client.sendText(body: body);
  }

  Future<void> _sendImage() async {
    final image = await ImagePicker().pickImage(source: ImageSource.gallery, maxWidth: 2048);

    if (image == null) {
      return;
    }

    await widget.client.sendImage(filePath: image.path, mimeType: image.mimeType ?? 'image/jpeg');
  }

  Future<void> _loadMore() async {
    final reachedStart = await widget.client.paginateBack(count: 30);
    setState(() => _reachedStart = reachedStart);
  }

  @override
  void dispose() {
    _input.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.title)),
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder<List<TimelineEntry>>(
              stream: _timeline,
              builder: (context, snapshot) {
                final entries = snapshot.data?.reversed.toList() ?? const [];

                return NotificationListener<ScrollEndNotification>(
                  onNotification: (notification) {
                    if (!_reachedStart && notification.metrics.extentAfter < 200) {
                      unawaited(_loadMore());
                    }
                    return false;
                  },
                  child: ListView.builder(
                    reverse: true,
                    itemCount: entries.length,
                    itemBuilder: (context, index) =>
                        TimelineTile(client: widget.client, entry: entries[index]),
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
                IconButton(key: const Key('send'), icon: const Icon(Icons.send), onPressed: _send),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class TimelineTile extends StatelessWidget {
  const TimelineTile({super.key, required this.client, required this.entry});

  final ChatClient client;
  final TimelineEntry entry;

  @override
  Widget build(BuildContext context) {
    return switch (entry) {
      TimelineEntry_Message(
        :final senderId,
        :final senderName,
        :final isOwn,
        :final isSending,
        :final isFailed,
        :final kind,
      ) =>
        Align(
          alignment: isOwn ? Alignment.centerRight : Alignment.centerLeft,
          child: Card(
            child: Padding(
              padding: const EdgeInsets.all(8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(senderName ?? senderId, style: Theme.of(context).textTheme.labelSmall),
                  _content(kind),
                  if (isSending) const Text('sendet …', style: TextStyle(fontSize: 10)),
                  if (isFailed) const Text('fehlgeschlagen', style: TextStyle(color: Colors.red)),
                ],
              ),
            ),
          ),
        ),
      TimelineEntry_State(:final description) => Center(
        child: Text(description, style: Theme.of(context).textTheme.bodySmall),
      ),
      TimelineEntry_DayDivider(:final timestampMs) => Center(
        child: Text(DateTime.fromMillisecondsSinceEpoch(timestampMs).toLocal().toString().substring(0, 10)),
      ),
      TimelineEntry_ReadMarker() => const Divider(color: Colors.red),
      TimelineEntry_TimelineStart() => const Center(child: Text('Anfang des Raums')),
    };
  }

  Widget _content(MessageKind kind) {
    return switch (kind) {
      MessageKind_Text(:final body) => Text(body),
      MessageKind_Image(:final sourceJson, :final body) => FutureBuilder<Uint8List>(
        future: client.fetchMedia(sourceJson: sourceJson),
        builder: (context, snapshot) => snapshot.hasData
            ? Image.memory(snapshot.data!, width: 220)
            : Text(snapshot.hasError ? 'Bild nicht ladbar: ${snapshot.error}' : 'Lade $body …'),
      ),
      MessageKind_UnableToDecrypt() => const Text('🔒 Nachricht kann nicht entschlüsselt werden'),
      MessageKind_Redacted() => const Text('Nachricht gelöscht'),
      MessageKind_Other(:final description) => Text(description),
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
          Text('Status: ${_status?.name ?? '…'}', key: const Key('recovery_status')),
          const SizedBox(height: 16),
          if (_status == RecoveryStatus.disabled)
            FilledButton(
              key: const Key('enable_recovery'),
              onPressed: _enable,
              child: const Text('Wiederherstellungsschlüssel erzeugen'),
            ),
          if (_recoveryKey != null) SelectableText(_recoveryKey!, key: const Key('recovery_key')),
          if (_status == RecoveryStatus.incomplete || _status == RecoveryStatus.enabled) ...[
            TextField(
              key: const Key('recovery_input'),
              controller: _input,
              decoration: const InputDecoration(labelText: 'Wiederherstellungsschlüssel'),
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
      content: TextField(key: const Key('prompt_input'), controller: controller),
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

// Keep dart:io referenced for platform checks in later spike steps.
bool get isIos => Platform.isIOS;
