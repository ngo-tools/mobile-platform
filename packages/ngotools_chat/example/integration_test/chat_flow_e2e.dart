import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'dart:ui' as ui;

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart' show MaterialApp;
import 'package:flutter/painting.dart';
import 'package:flutter/widgets.dart' show SizedBox, Widget;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:ngotools_chat/ngotools_chat.dart';
import 'package:ngotools_chat_example/main.dart'
    show RoomListScreen, RoomScreen;
import 'package:path_provider/path_provider.dart';

import 'support/mas_browser.dart';

const homeserver = String.fromEnvironment(
  'HOMESERVER',
  defaultValue: 'https://localhost:28448',
);
const pushGatewayForSynapse =
    'http://host.docker.internal:28451/_matrix/push/v1/notify';
const pushGatewayForTest = 'http://localhost:28451/pushes';
const password = String.fromEnvironment(
  'TEST_PASSWORD',
  defaultValue: 'e2e-password-1',
);
const callbackScheme = 'tools.ngo.mobile.chat-example';
const aliceName = String.fromEnvironment('ALICE', defaultValue: 'alice');
const bobName = String.fromEnvironment('BOB', defaultValue: 'bob');
const serverName = 'chat-e2e.test';
const devRootCaBase64 = String.fromEnvironment('DEV_ROOT_CA_B64');
const appGroup = 'group.tools.ngo.mobile.chat-example';

void metric(String name, Object value) => debugPrint('E2E_METRIC $name=$value');

/// Renders the real app screens with live data and lets the host script
/// (run_durchstich.sh) take a device screenshot.
Future<void> showForScreenshot(
  WidgetTester tester,
  Widget screen,
  String name,
) async {
  await tester.pumpWidget(MaterialApp(home: screen));
  for (var i = 0; i < 30; i++) {
    await tester.runAsync(
      () => Future<void>.delayed(const Duration(milliseconds: 100)),
    );
    await tester.pump();
  }
  debugPrint('E2E_SCREENSHOT $name');
  for (var i = 0; i < 25; i++) {
    await tester.runAsync(
      () => Future<void>.delayed(const Duration(milliseconds: 100)),
    );
    await tester.pump();
  }
}

/// A client together with broadcast views of its streams.
class TestUser {
  TestUser(this.name, this.client, this.roomList);

  final String name;
  final ChatClient client;
  final RoomListController roomList;

  List<RoomSummary> get lastRooms => roomList.rooms.value;

  /// Completes once the room list (diff-driven) satisfies [predicate].
  Future<List<RoomSummary>> waitForRooms(
    bool Function(List<RoomSummary>) predicate, {
    Duration timeout = const Duration(seconds: 60),
  }) async {
    if (predicate(lastRooms)) {
      return lastRooms;
    }

    final completer = Completer<List<RoomSummary>>();
    void check() {
      if (!completer.isCompleted && predicate(lastRooms)) {
        completer.complete(lastRooms);
      }
    }

    roomList.rooms.addListener(check);
    try {
      return await completer.future.timeout(timeout);
    } finally {
      roomList.rooms.removeListener(check);
    }
  }

  TimelineController? timelineController;

  ChatTimeline get timeline => timelineController!.timeline;

  List<TimelineItem> get lastTimeline =>
      timelineController?.items.value ?? const [];

  Future<void> openTimeline(String roomId) async {
    timelineController = await TimelineController.open(client, roomId);
  }

  /// Completes once the timeline (diff-driven) satisfies [predicate].
  Future<List<TimelineItem>> waitForTimeline(
    bool Function(List<TimelineItem>) predicate, {
    Duration timeout = const Duration(seconds: 60),
  }) async {
    if (predicate(lastTimeline)) {
      return lastTimeline;
    }

    final completer = Completer<List<TimelineItem>>();
    void check() {
      if (!completer.isCompleted && predicate(lastTimeline)) {
        completer.complete(lastTimeline);
      }
    }

    timelineController!.items.addListener(check);
    try {
      return await completer.future.timeout(timeout);
    } on TimeoutException {
      debugPrint('E2E_TIMELINE $name ${describeTimeline(lastTimeline)}');
      rethrow;
    } finally {
      timelineController!.items.removeListener(check);
    }
  }
}

/// Number of event ids that appear on more than one timeline item.
int duplicateEventIds(List<TimelineItem> items) {
  final counts = <String, int>{};
  for (final eventId in items.map(eventOf).nonNulls.map((e) => e.eventId)) {
    if (eventId != null) {
      counts.update(eventId, (count) => count + 1, ifAbsent: () => 1);
    }
  }

  return counts.values.where((count) => count > 1).length;
}

/// Compact view of a timeline for failure diagnostics.
String describeTimeline(List<TimelineItem> items) => items
    .map((item) {
      final event = eventOf(item);
      if (event == null) {
        return item.kind.runtimeType.toString();
      }
      final content = event.content;
      final text = content is EventContent_Text ? content.body : '';

      final key = event.key is EventKey_Local ? 'L' : 'R';

      return '$key:${event.eventId ?? 'local'}:${content.runtimeType}:$text'
          ':thread=${event.thread?.replyCount}:${event.sendState.runtimeType}';
    })
    .join(' | ');

/// Completes once [listenable] satisfies [predicate].
Future<T> waitForValue<T>(
  ValueListenable<T> listenable,
  bool Function(T) predicate, {
  Duration timeout = const Duration(seconds: 60),
}) async {
  if (predicate(listenable.value)) {
    return listenable.value;
  }

  final completer = Completer<T>();
  void check() {
    if (!completer.isCompleted && predicate(listenable.value)) {
      completer.complete(listenable.value);
    }
  }

  listenable.addListener(check);
  try {
    return await completer.future.timeout(timeout);
  } finally {
    listenable.removeListener(check);
  }
}

EventItem? eventOf(TimelineItem item) => switch (item.kind) {
  TimelineItemKind_Event(:final event) => event,
  _ => null,
};

/// The latest event whose text is [body], if any.
EventItem? findText(List<TimelineItem> items, String body) => items
    .map(eventOf)
    .nonNulls
    .where(
      (event) => switch (event.content) {
        EventContent_Text(body: final text) => text == body,
        _ => false,
      },
    )
    .lastOrNull;

bool hasText(List<TimelineItem> items, String body, {bool confirmed = false}) {
  final event = findText(items, body);

  return event != null && (!confirmed || event.sendState is SendState_Sent);
}

Future<Uint8List> storeKey(String name) async {
  const storage = FlutterSecureStorage();
  final keyName = 'ngotools.matrix.store_key${name.isEmpty ? '' : '.$name'}';
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

/// Data/cache directories; the app's own store lives in the App Group on iOS
/// so that the Notification Service Extension can open it.
Future<(String, String)> storeDirs(String dir, {bool shared = false}) async {
  final group = shared
      ? await NgotoolsChatPlatform.appGroupDirectory(appGroup)
      : null;

  if (group != null) {
    return ('$group/$dir', '$group/$dir-cache');
  }

  final support = await getApplicationSupportDirectory();
  final cache = await getApplicationCacheDirectory();

  return ('${support.path}/$dir', '${cache.path}/$dir');
}

Future<ChatClient> createClient(
  String dir,
  Uint8List key, {
  bool shared = false,
}) async {
  final (dataDir, cacheDir) = await storeDirs(dir, shared: shared);

  return ChatClient.create(
    config: ChatConfig(
      homeserverUrl: homeserver,
      dataDir: dataDir,
      cacheDir: cacheDir,
      crossProcessHolder: shared && Platform.isIOS ? 'main' : null,
      storeKey: key,
      clientName: 'NGO.Tools Chat Example',
      clientUri: 'https://ngo.tools/',
      redirectUri: '$callbackScheme:/oauth-callback',
      devRootCertificatePem: devRootCaBase64.isEmpty
          ? null
          : utf8.decode(base64Decode(devRootCaBase64)),
    ),
  );
}

Future<TestUser> loginUser(
  String name,
  String username,
  String dir,
  Uint8List key, {
  bool shared = false,
}) async {
  final client = await createClient(dir, key, shared: shared);
  final stopwatch = Stopwatch()..start();
  final browser = MasBrowser(callbackScheme: callbackScheme);
  final callback = await browser.authorize(
    await client.loginUrl(),
    username,
    password,
  );
  browser.close();
  await client.finishLogin(callbackUrl: callback);
  metric('login_oauth_ms_$name', stopwatch.elapsedMilliseconds);

  stopwatch.reset();
  await client.startSync();
  client.watchSyncState().listen(
    (state) => debugPrint('E2E_SYNC $name=$state'),
  );
  final roomList = RoomListController(client);
  roomList.rooms.addListener(
    () => debugPrint(
      'E2E_ROOMS $name=${roomList.rooms.value.map((room) => '${room.id}${room.membership == Membership.invited ? '(invite)' : ''}').join(',')}',
    ),
  );
  final user = TestUser(name, client, roomList);
  final firstBatch = Completer<void>();
  void onFirstBatch() {
    if (!firstBatch.isCompleted) {
      firstBatch.complete();
    }
  }

  roomList.rooms.addListener(onFirstBatch);
  await firstBatch.future.timeout(const Duration(seconds: 60));
  roomList.rooms.removeListener(onFirstBatch);
  metric('room_list_ready_ms_$name', stopwatch.elapsedMilliseconds);

  return user;
}

Future<Uint8List> renderPng() async {
  final recorder = ui.PictureRecorder();
  final canvas = ui.Canvas(recorder);
  const size = ui.Size(800, 600);
  canvas.drawRect(
    ui.Offset.zero & size,
    ui.Paint()
      ..shader = ui.Gradient.linear(
        ui.Offset.zero,
        const ui.Offset(800, 600),
        const [Color(0xFF1B6E5A), Color(0xFFF2C14E)],
      ),
  );
  final image = await recorder.endRecording().toImage(800, 600);
  final bytes = await image.toByteData(format: ui.ImageByteFormat.png);

  return bytes!.buffer.asUint8List();
}

Future<(int, int)> imageSize(Uint8List bytes) async {
  final codec = await ui.instantiateImageCodec(bytes);
  final image = (await codec.getNextFrame()).image;
  final size = (image.width, image.height);
  image.dispose();
  codec.dispose();

  return size;
}

Future<Map<String, dynamic>> waitForPush(
  String pushKey,
  String eventId, {
  Duration timeout = const Duration(seconds: 30),
}) async {
  final http = HttpClient();
  final deadline = DateTime.now().add(timeout);

  try {
    while (DateTime.now().isBefore(deadline)) {
      final response = await (await http.getUrl(
        Uri.parse(pushGatewayForTest),
      )).close();
      final pushes =
          jsonDecode(await response.transform(utf8.decoder).join())
              as List<dynamic>;

      for (final push in pushes.cast<Map<String, dynamic>>()) {
        final notification = push['notification'] as Map<String, dynamic>;
        final devices = (notification['devices'] as List<dynamic>)
            .cast<Map<String, dynamic>>();

        if (notification['event_id'] == eventId &&
            devices.any((device) => device['pushkey'] == pushKey)) {
          return notification;
        }
      }

      await Future<void>.delayed(const Duration(milliseconds: 200));
    }
  } finally {
    http.close(force: true);
  }

  throw TimeoutException('no push for $eventId');
}

Future<String> waitForAnyPush(String pushKey) async {
  final http = HttpClient();
  final deadline = DateTime.now().add(const Duration(seconds: 30));

  try {
    while (DateTime.now().isBefore(deadline)) {
      final response = await (await http.getUrl(
        Uri.parse(pushGatewayForTest),
      )).close();
      final pushes =
          jsonDecode(await response.transform(utf8.decoder).join())
              as List<dynamic>;

      for (final push in pushes.cast<Map<String, dynamic>>().reversed) {
        final notification = push['notification'] as Map<String, dynamic>;
        final devices = (notification['devices'] as List<dynamic>)
            .cast<Map<String, dynamic>>();

        if (devices.any((device) => device['pushkey'] == pushKey) &&
            notification['event_id'] != null) {
          return notification['event_id'] as String;
        }
      }

      await Future<void>.delayed(const Duration(milliseconds: 200));
    }
  } finally {
    http.close(force: true);
  }

  throw TimeoutException('no push for $pushKey');
}

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  setUpAll(() async {
    await RustLib.init();
    const hostLogFile = String.fromEnvironment('RUST_LOG_FILE');
    final logFile = hostLogFile.isNotEmpty
        ? hostLogFile
        : '${(await getApplicationSupportDirectory()).path}/chat-rust.log';
    await initLogging(logFile: logFile);
    debugPrint('E2E_RUST_LOG=$logFile');
  });

  testWidgets('matrix-rust-sdk durchstich', (tester) async {
    final run = DateTime.now().millisecondsSinceEpoch;
    final platform = Platform.operatingSystem;
    metric('platform', platform);

    // Alice uses the example app's own store, so the app shows her chats afterwards.
    final (appStoreDir, appCacheDir) = await storeDirs('matrix', shared: true);
    for (final path in [appStoreDir, appCacheDir]) {
      if (Directory(path).existsSync()) {
        Directory(path).deleteSync(recursive: true);
      }
    }
    final alice = await loginUser(
      'alice',
      aliceName,
      'matrix',
      await storeKey(''),
      shared: true,
    );
    final bob = await loginUser(
      'bob',
      bobName,
      'test-$run-bob',
      await storeKey('bob-$run'),
    );

    // Key backup + recovery key (secret storage) for Alice's first device.
    var stopwatch = Stopwatch()..start();
    expect(await alice.client.recoveryStatus(), RecoveryStatus.disabled);
    expect(
      await alice.client.verificationState(),
      'verified',
      reason: 'cross-signing bootstrapped',
    );
    final recoveryKey = await alice.client.enableRecovery();
    metric('enable_recovery_ms', stopwatch.elapsedMilliseconds);
    expect(await alice.client.recoveryStatus(), RecoveryStatus.enabled);

    // Encrypted DM Alice -> Bob.
    stopwatch = Stopwatch()..start();
    final roomId = await alice.client.createDm(userId: '@$bobName:$serverName');
    final bobRooms = await bob.waitForRooms(
      (rooms) => rooms.any((room) => room.id == roomId),
    );

    if (bobRooms.firstWhere((room) => room.id == roomId).membership ==
        Membership.invited) {
      await bob.client.joinRoom(roomId: roomId);
    }
    metric('dm_created_and_joined_ms', stopwatch.elapsedMilliseconds);

    await alice.openTimeline(roomId);
    await bob.openTimeline(roomId);

    final aliceRooms = await alice.waitForRooms(
      (rooms) => rooms.any((room) => room.id == roomId && room.isEncrypted),
    );
    expect(
      aliceRooms.firstWhere((room) => room.id == roomId).isEncrypted,
      isTrue,
    );

    // Send / receive with latencies (local echo confirmed, delivered + decrypted at Bob).
    final sendLatencies = <int>[];
    final deliveryLatencies = <int>[];

    for (var i = 1; i <= 5; i++) {
      final body = 'Hallo Bob $i ($run)';
      final sent = Stopwatch()..start();
      await alice.timeline.sendText(body: body);
      await alice.waitForTimeline(
        (entries) => hasText(entries, body, confirmed: true),
      );
      sendLatencies.add(sent.elapsedMilliseconds);
      await bob.waitForTimeline((entries) => hasText(entries, body));
      deliveryLatencies.add(sent.elapsedMilliseconds);
    }
    metric('send_confirmed_ms', sendLatencies.join(','));
    metric('delivered_decrypted_ms', deliveryLatencies.join(','));

    // Room list: latest message preview and filters (diff-driven).
    final lastBody = 'Hallo Bob 5 ($run)';
    await bob.waitForRooms(
      (rooms) => rooms.any(
        (room) =>
            room.id == roomId &&
            room.latest?.preview == MessagePreview.text(body: lastBody),
      ),
    );
    await bob.roomList.setFilter(RoomFilter.groups);
    await bob.waitForRooms((rooms) => rooms.every((room) => room.id != roomId));
    await bob.roomList.setFilter(RoomFilter.people);
    await bob.waitForRooms((rooms) => rooms.any((room) => room.id == roomId));
    await bob.roomList.setFilter(RoomFilter.all);
    metric('room_list_filters', 'ok');

    final reply = 'Hallo Alice ($run)';
    await bob.timeline.sendText(body: reply);
    await alice.waitForTimeline((entries) => hasText(entries, reply));

    // Timeline actions: reply, edit, reaction and redaction.
    final firstBody = 'Hallo Bob 1 ($run)';
    final first = findText(alice.lastTimeline, firstBody)!;
    final replyBody = 'Antwort auf 1 ($run)';
    await bob.timeline.sendText(body: replyBody, replyTo: first.eventId);
    final withReply = await alice.waitForTimeline(
      (items) => findText(items, replyBody)?.replyTo != null,
    );
    final replyEvent = findText(withReply, replyBody)!;
    expect(replyEvent.replyTo!.eventId, first.eventId);
    if (replyEvent.replyTo!.preview == null) {
      await alice.timeline.loadReplyDetails(eventId: replyEvent.eventId!);
    }
    await alice.waitForTimeline(
      (items) =>
          findText(items, replyBody)?.replyTo?.preview ==
          MessagePreview.text(body: firstBody),
    );

    final second = findText(alice.lastTimeline, 'Hallo Bob 2 ($run)')!;
    final editedBody = 'Hallo Bob 2, bearbeitet ($run)';
    expect(second.canEdit, isTrue);
    await alice.timeline.edit(key: second.key, body: editedBody);
    await bob.waitForTimeline(
      (items) => findText(items, editedBody)?.isEdited ?? false,
    );

    final thirdBody = 'Hallo Bob 3 ($run)';
    final third = findText(bob.lastTimeline, thirdBody)!;
    await bob.timeline.toggleReaction(key: third.key, reaction: '👍');
    await alice.waitForTimeline(
      (items) =>
          findText(items, thirdBody)?.reactions.any(
            (reaction) =>
                reaction.key == '👍' && reaction.count == 1 && !reaction.byMe,
          ) ??
          false,
    );
    await bob.waitForTimeline(
      (items) =>
          findText(
            items,
            thirdBody,
          )?.reactions.any((reaction) => reaction.byMe) ??
          false,
    );

    final fourth = findText(alice.lastTimeline, 'Hallo Bob 4 ($run)')!;
    await alice.timeline.redact(key: fourth.key);
    await bob.waitForTimeline(
      (items) => items
          .map(eventOf)
          .nonNulls
          .any(
            (event) =>
                event.eventId == fourth.eventId &&
                event.content is EventContent_Redacted,
          ),
    );
    metric('timeline_actions', 'ok');

    // Threads: reply in a thread, summary on the root, thread list.
    final rootBody = 'Hallo Bob 5 ($run)';
    final root = findText(alice.lastTimeline, rootBody)!;
    final bobThread = TimelineController(
      await bob.client.threadTimeline(
        roomId: roomId,
        rootEventId: root.eventId!,
      ),
    );
    final threadBody = 'Im Thread ($run)';
    await bobThread.timeline
        .sendText(body: threadBody)
        .timeout(const Duration(seconds: 60));
    // Match the remote item: the SDK may keep the local echo of the root
    // next to it for a while (event ids are not unique, matrix-rust-sdk
    // #4758); the UI keys items by `TimelineItem.id`.
    await alice.waitForTimeline(
      (items) => items
          .map(eventOf)
          .nonNulls
          .where((event) => event.key is EventKey_Remote)
          .any(
            (event) =>
                event.content == EventContent.text(body: rootBody) &&
                event.thread?.replyCount == 1,
          ),
    );
    metric('duplicate_event_items', duplicateEventIds(alice.lastTimeline));
    expect(
      findText(alice.lastTimeline, threadBody),
      isNull,
      reason: 'thread replies stay out of the main timeline',
    );

    final aliceThread = TimelineController(
      await alice.client.threadTimeline(
        roomId: roomId,
        rootEventId: root.eventId!,
      ),
    );
    await waitForValue(
      aliceThread.items,
      (items) => hasText(items, threadBody),
    );
    final threadAnswer = 'Antwort im Thread ($run)';
    await aliceThread.timeline
        .sendText(body: threadAnswer)
        .timeout(const Duration(seconds: 60));
    final bobThreadItems = await waitForValue(
      bobThread.items,
      (items) => hasText(items, threadAnswer),
    );
    expect(findText(bobThreadItems, threadAnswer)!.threadRoot, root.eventId);

    final threads = await ThreadListController.open(
      alice.client,
      roomId,
    ).timeout(const Duration(seconds: 60));
    await waitForValue(
      threads.threads,
      (list) => list.any(
        (thread) =>
            thread.root.eventId == root.eventId && thread.replyCount >= 1,
      ),
    );
    await threads.dispose().timeout(const Duration(seconds: 30));
    await aliceThread.dispose().timeout(const Duration(seconds: 30));
    await bobThread.dispose().timeout(const Duration(seconds: 30));
    metric('threads', 'ok');

    // Image (encrypted attachment, authenticated media download at Bob).
    final png = await renderPng();
    final file = File(
      '${(await getTemporaryDirectory()).path}/chat-e2e-$run.png',
    )..writeAsBytesSync(png);
    final attachment = await prepareImageAttachment(
      filePath: file.path,
      mimeType: 'image/png',
      caption: 'Farbverlauf',
    );
    expect(attachment.thumbnail?.width, 480);
    var uploadProgressSeen = false;
    void watchUpload() {
      uploadProgressSeen |= alice.lastTimeline
          .map(eventOf)
          .nonNulls
          .any(
            (event) => switch (event.sendState) {
              SendState_Sending(:final progress) => progress != null,
              _ => false,
            },
          );
    }

    alice.timelineController!.items.addListener(watchUpload);
    stopwatch = Stopwatch()..start();
    await alice.timeline.sendImage(image: attachment);
    final withImage = await bob.waitForTimeline(
      (items) => items
          .map(eventOf)
          .nonNulls
          .any((event) => event.content is EventContent_Image),
    );
    final image = withImage
        .map(eventOf)
        .nonNulls
        .map((event) => event.content)
        .whereType<EventContent_Image>()
        .last;
    expect(image.caption, 'Farbverlauf');
    final downloaded = await bob.client.fetchMedia(media: image.media);
    metric('image_bytes', png.length);
    metric('image_send_to_download_ms', stopwatch.elapsedMilliseconds);
    expect(
      image.media,
      contains('"file"'),
      reason: 'encrypted rooms use EncryptedFile sources',
    );
    expect(listEquals(downloaded, png), isTrue);
    await alice.waitForTimeline(
      (items) => items
          .map(eventOf)
          .nonNulls
          .any(
            (event) =>
                event.content is EventContent_Image &&
                event.sendState is SendState_Sent,
          ),
    );
    alice.timelineController!.items.removeListener(watchUpload);
    metric('upload_progress_seen', uploadProgressSeen);

    // Encrypted media cannot be scaled by the server: the sender's preview
    // is used, the thumbnail endpoint falls back to the whole file.
    expect((image.width, image.height), (800, 600));
    final preview = await bob.client.fetchMedia(media: image.thumbnail!);
    expect(await imageSize(preview), (480, 360));
    expect(
      listEquals(
        await bob.client.fetchThumbnail(
          media: image.media,
          width: 100,
          height: 100,
        ),
        png,
      ),
      isTrue,
    );
    metric('image_thumbnail', 'ok');

    // Members and typing.
    final members = await alice.client.roomMembers(roomId: roomId);
    expect(
      {for (final member in members) member.userId: member.isOwn},
      {'@$aliceName:$serverName': true, '@$bobName:$serverName': false},
    );
    final typing = bob.timeline.watchTyping().asBroadcastStream();
    await alice.timeline.setTyping(typing: true);
    await typing
        .firstWhere(
          (users) => users.any((user) => user.id == '@$aliceName:$serverName'),
        )
        .timeout(const Duration(seconds: 30));
    await alice.timeline.setTyping(typing: false);
    await typing
        .firstWhere((users) => users.isEmpty)
        .timeout(const Duration(seconds: 30));
    metric('members_typing', 'ok');

    // Push: pusher for Bob (event_id_only), notification resolved + decrypted like the FCM handler / NSE.
    final pushKey = 'e2e-$platform-$run';
    await bob.client.registerPusher(
      pushKey: pushKey,
      appId: 'tools.ngo.mobile.chat-example.$platform',
      gatewayUrl: pushGatewayForSynapse,
      deviceName: 'E2E $platform',
    );
    final pushBody = 'Push an Bob ($run)';
    await alice.timeline.sendText(body: pushBody);
    await alice.waitForTimeline(
      (entries) => hasText(entries, pushBody, confirmed: true),
    );
    final eventId = findText(alice.lastTimeline, pushBody)!.eventId;
    stopwatch = Stopwatch()..start();
    final push = await waitForPush(pushKey, eventId!);
    metric('push_received_ms', stopwatch.elapsedMilliseconds);
    expect(
      push.containsKey('content'),
      isFalse,
      reason: 'event_id_only must not leak content',
    );
    stopwatch.reset();
    final notification = await bob.client.getNotification(
      roomId: roomId,
      eventId: eventId,
    );
    metric('notification_resolved_ms', stopwatch.elapsedMilliseconds);
    expect(notification?.body, pushBody);

    // Muting the room stops pushes; restoring follows the default again.
    final defaults = await bob.client.roomNotificationSettings(roomId: roomId);
    expect(defaults.isDefault, isTrue);
    await bob.client.setRoomNotificationMode(
      roomId: roomId,
      mode: NotificationMode.mute,
    );
    final muted = await bob.client.roomNotificationSettings(roomId: roomId);
    expect((muted.mode, muted.isDefault), (NotificationMode.mute, false));
    await bob.waitForRooms(
      (rooms) => rooms.any(
        (room) =>
            room.id == roomId && room.notificationMode == NotificationMode.mute,
      ),
    );
    final mutedBody = 'Stumm ($run)';
    await alice.timeline.sendText(body: mutedBody);
    await bob.waitForTimeline((items) => hasText(items, mutedBody));
    final mutedEventId = findText(bob.lastTimeline, mutedBody)!.eventId!;
    await expectLater(
      waitForPush(pushKey, mutedEventId, timeout: const Duration(seconds: 5)),
      throwsA(isA<TimeoutException>()),
    );
    await bob.client.setRoomNotificationMode(roomId: roomId, mode: null);
    expect(
      (await bob.client.roomNotificationSettings(roomId: roomId)).isDefault,
      isTrue,
    );
    metric('notification_mode', 'ok');

    // Real UI with live data (room list, encrypted DM with image) at Bob.
    await showForScreenshot(
      tester,
      RoomListScreen(
        client: bob.client,
        session: SessionInfo(userId: '@$bobName:$serverName', deviceId: ''),
        onLogout: () {},
      ),
      'room-list',
    );
    await showForScreenshot(
      tester,
      RoomScreen(client: bob.client, roomId: roomId, title: aliceName),
      'dm-timeline',
    );
    await tester.pumpWidget(const SizedBox());

    // Session persistence: reopen Alice's store without logging in again.
    await alice.client.shutdown();
    stopwatch = Stopwatch()..start();
    final aliceAgain = await createClient(
      'matrix',
      await storeKey(''),
      shared: true,
    );
    final restored = await aliceAgain.restoreSession();
    metric('session_restore_ms', stopwatch.elapsedMilliseconds);
    expect(restored?.userId, '@$aliceName:$serverName');
    expect(await aliceAgain.whoami(), '@$aliceName:$serverName');

    // Access token refresh (MAS access_token_ttl = 60 s in the e2e server).
    await tester.runAsync(
      () => Future<void>.delayed(const Duration(seconds: 65)),
    );
    expect(await aliceAgain.whoami(), '@$aliceName:$serverName');
    final refreshes = await aliceAgain.persistedRefreshes();
    metric('persisted_refreshes_after_ttl', refreshes);
    expect(refreshes, greaterThan(0));

    // iOS Notification Service Extension: separate process, same framework,
    // same encrypted store (App Group) with its own cross-process lock holder.
    if (Platform.isIOS) {
      await NgotoolsChatPlatform.requestProvisionalNotifications();
      final group = (await NgotoolsChatPlatform.appGroupDirectory(appGroup))!;
      final key = await storeKey('');
      File('$group/nse-config.json').writeAsStringSync(
        jsonEncode({
          'homeserver_url': homeserver,
          'data_dir': appStoreDir,
          'cache_dir': appCacheDir,
          'store_key_hex': key
              .map((byte) => byte.toRadixString(16).padLeft(2, '0'))
              .join(),
        }),
      );
      final alicePushKey = 'e2e-nse-$run';
      await aliceAgain.registerPusher(
        pushKey: alicePushKey,
        appId: 'tools.ngo.mobile.chat-example.ios',
        gatewayUrl: pushGatewayForSynapse,
        deviceName: 'E2E iOS NSE',
      );
      final nseBody = 'Für die NSE ($run)';
      await bob.timeline.sendText(body: nseBody);
      final nsePushEventId = await waitForAnyPush(alicePushKey);
      debugPrint('E2E_NSE_PUSH $roomId $nsePushEventId');
      final resultFile = File(
        '$group/nse-result-${nsePushEventId.replaceAll(r'$', '')}.json',
      );
      final deadline = DateTime.now().add(const Duration(seconds: 45));
      while (!resultFile.existsSync() && DateTime.now().isBefore(deadline)) {
        await tester.runAsync(
          () => Future<void>.delayed(const Duration(milliseconds: 250)),
        );
      }
      expect(resultFile.existsSync(), isTrue, reason: 'NSE did not run');
      final nse =
          jsonDecode(resultFile.readAsStringSync()) as Map<String, dynamic>;
      expect(nse['ok'], isTrue, reason: '${nse['error']}');
      expect(nse['body'], nseBody, reason: 'NSE must decrypt the event');
      metric('nse_result', jsonEncode(Map.of(nse)..remove('body')));
    }

    // Second device: log in again, restore with the recovery key, read history.
    final secondDevice = await loginUser(
      'alice2',
      aliceName,
      'test-$run-alice2',
      await storeKey('alice2-$run'),
    );
    expect(
      await secondDevice.client.recoveryStatus(),
      isNot(RecoveryStatus.enabled),
    );
    stopwatch = Stopwatch()..start();
    await secondDevice.client.recover(recoveryKey: recoveryKey);
    metric('recover_ms', stopwatch.elapsedMilliseconds);
    expect(await secondDevice.client.verificationState(), 'verified');

    stopwatch.reset();
    await secondDevice.openTimeline(roomId);
    final firstMessage = 'Hallo Bob 1 ($run)';
    final history = secondDevice.timelineController!;
    while (!hasText(secondDevice.lastTimeline, firstMessage) &&
        !history.reachedStart.value) {
      await history.paginateBack(count: 20);
    }
    await secondDevice.waitForTimeline(
      (entries) => hasText(entries, firstMessage),
    );
    metric(
      'history_decrypted_on_second_device_ms',
      stopwatch.elapsedMilliseconds,
    );

    // Logout removes the session; the store no longer restores it.
    await secondDevice.client.logout();
    await secondDevice.client.shutdown();
    final afterLogout = await createClient(
      'test-$run-alice2',
      await storeKey('alice2-$run'),
    );
    expect(await afterLogout.restoreSession(), isNull);
    await afterLogout.shutdown();

    await bob.client.shutdown();
    await aliceAgain.shutdown();
  }, timeout: const Timeout(Duration(minutes: 10)));
}
