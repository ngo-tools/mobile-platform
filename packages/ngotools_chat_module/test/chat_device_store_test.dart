import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ngotools_chat_module/ngotools_chat_module.dart';

void main() {
  setUp(() => FlutterSecureStorage.setMockInitialValues({}));

  test('keeps the device record without an access token', () async {
    final store = SecureChatDeviceStore();
    final record = ChatDeviceRecord(
      matrixUserId: '@anna.admin:example.org',
      deviceId: 'NGOAPPABCDEFGHIJKLMNOPQRST',
      homeserverUrl: Uri.parse('https://matrix-example.chat.ngo.tools'),
      expiresAt: DateTime.utc(2026, 10, 7, 12),
    ).withRecoveryPromptSeen();

    await store.write(record);
    final restored = await store.read();

    expect(restored?.matrixUserId, record.matrixUserId);
    expect(restored?.deviceId, record.deviceId);
    expect(restored?.homeserverUrl, record.homeserverUrl);
    expect(restored?.expiresAt, record.expiresAt);
    expect(restored?.recoveryPromptSeen, isTrue);
    expect(record.toJson().keys, isNot(contains('access_token')));
  });

  test('creates one random store key and forgets it on clear', () async {
    final store = SecureChatDeviceStore();

    final key = await store.readOrCreateStoreKey();
    final again = await store.readOrCreateStoreKey();
    await store.clear();
    final replaced = await store.readOrCreateStoreKey();

    expect(key, hasLength(32));
    expect(again, key);
    expect(replaced, isNot(key));
    expect(await store.read(), isNull);
  });

  test('ignores an unreadable record', () async {
    FlutterSecureStorage.setMockInitialValues({'chat-device-v1': 'not json'});

    expect(await SecureChatDeviceStore().read(), isNull);
  });
}
