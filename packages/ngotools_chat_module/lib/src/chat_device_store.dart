import 'dart:convert';
import 'dart:math';
import 'dart:typed_data';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';

/// The chat account this installation is signed into. The access token
/// itself lives in the encrypted chat store only.
final class ChatDeviceRecord {
  /// Creates a device record.
  const ChatDeviceRecord({
    required this.matrixUserId,
    required this.deviceId,
    required this.homeserverUrl,
    this.expiresAt,
    this.recoveryPromptSeen = false,
  });

  /// Restores a record written by [toJson]; `null` when unreadable.
  static ChatDeviceRecord? fromJson(Map<String, Object?> json) {
    final matrixUserId = json['matrix_user_id'];
    final deviceId = json['device_id'];
    final homeserverUrl = json['homeserver_url'];
    final expiresAt = json['expires_at'];
    final recoveryPromptSeen = json['recovery_prompt_seen'];

    if (matrixUserId is! String ||
        deviceId is! String ||
        homeserverUrl is! String) {
      return null;
    }

    return ChatDeviceRecord(
      matrixUserId: matrixUserId,
      deviceId: deviceId,
      homeserverUrl: Uri.parse(homeserverUrl),
      expiresAt: expiresAt is String ? DateTime.tryParse(expiresAt) : null,
      recoveryPromptSeen: recoveryPromptSeen == true,
    );
  }

  /// Matrix user id of the account.
  final String matrixUserId;

  /// Matrix device of this installation.
  final String deviceId;

  /// Homeserver of the account.
  final Uri homeserverUrl;

  /// When the current access token expires.
  final DateTime? expiresAt;

  /// Whether the user saw the offer to set up recovery on this device.
  final bool recoveryPromptSeen;

  /// Copies the record with a renewed expiry.
  ChatDeviceRecord renewedUntil(DateTime? expiresAt) => ChatDeviceRecord(
    matrixUserId: matrixUserId,
    deviceId: deviceId,
    homeserverUrl: homeserverUrl,
    expiresAt: expiresAt,
    recoveryPromptSeen: recoveryPromptSeen,
  );

  /// Copies the record after the recovery offer was shown.
  ChatDeviceRecord withRecoveryPromptSeen() => ChatDeviceRecord(
    matrixUserId: matrixUserId,
    deviceId: deviceId,
    homeserverUrl: homeserverUrl,
    expiresAt: expiresAt,
    recoveryPromptSeen: true,
  );

  /// Serializes the record.
  Map<String, Object?> toJson() => {
    'matrix_user_id': matrixUserId,
    'device_id': deviceId,
    'homeserver_url': homeserverUrl.toString(),
    'expires_at': expiresAt?.toUtc().toIso8601String(),
    'recovery_prompt_seen': recoveryPromptSeen,
  };
}

/// Keeps the device record and the key of the encrypted chat stores.
abstract interface class ChatDeviceStore {
  /// The stored record, if any.
  Future<ChatDeviceRecord?> read();

  /// Stores [record].
  Future<void> write(ChatDeviceRecord record);

  /// The key of the chat stores; created on first use.
  Future<Uint8List> readOrCreateStoreKey();

  /// Forgets the record and the store key.
  Future<void> clear();
}

/// Keeps the chat device in the platform keychain/keystore.
final class SecureChatDeviceStore implements ChatDeviceStore {
  /// Creates the store; [storage] replaces the platform storage in tests.
  SecureChatDeviceStore({FlutterSecureStorage? storage})
    : _storage =
          storage ??
          const FlutterSecureStorage(
            iOptions: IOSOptions(
              accountName: 'ngotools_mobile_chat',
              accessibility: KeychainAccessibility.first_unlock_this_device,
              synchronizable: false,
            ),
            mOptions: MacOsOptions(
              accountName: 'ngotools_mobile_chat',
              accessibility: KeychainAccessibility.first_unlock_this_device,
              synchronizable: false,
            ),
            aOptions: AndroidOptions(
              resetOnError: true,
              migrateOnAlgorithmChange: true,
              migrateWithBackup: false,
              storageNamespace: 'ngotools_mobile_chat',
            ),
          );

  static const _recordKey = 'chat-device-v1';
  static const _storeKeyKey = 'chat-store-key-v1';

  final FlutterSecureStorage _storage;

  @override
  Future<ChatDeviceRecord?> read() async {
    final encoded = await _storage.read(key: _recordKey);

    if (encoded == null) {
      return null;
    }

    try {
      final json = jsonDecode(encoded);

      return json is Map<String, Object?>
          ? ChatDeviceRecord.fromJson(json)
          : null;
    } on FormatException {
      return null;
    }
  }

  @override
  Future<void> write(ChatDeviceRecord record) =>
      _storage.write(key: _recordKey, value: jsonEncode(record.toJson()));

  @override
  Future<Uint8List> readOrCreateStoreKey() async {
    final encoded = await _storage.read(key: _storeKeyKey);

    if (encoded != null) {
      try {
        final key = base64Decode(encoded);

        if (key.length == 32) {
          return key;
        }
      } on FormatException {
        // Replaced below; the stores it encrypted are unreadable anyway.
      }
    }

    final random = Random.secure();
    final key = Uint8List.fromList(
      List.generate(32, (_) => random.nextInt(256)),
    );
    await _storage.write(key: _storeKeyKey, value: base64Encode(key));

    return key;
  }

  @override
  Future<void> clear() async {
    await _storage.delete(key: _recordKey);
    await _storage.delete(key: _storeKeyKey);
  }
}
