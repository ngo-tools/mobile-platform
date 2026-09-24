import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'dart:typed_data';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';

/// Protected key storage boundary used by the encrypted cache.
abstract interface class ContactCacheKeyStore {
  Future<List<int>> readOrCreate();

  Future<void> delete();
}

/// Encrypted blob storage boundary used by the contact cache.
abstract interface class ContactCacheBlobStore {
  Future<Uint8List?> read();

  Future<void> write(Uint8List bytes);

  Future<void> delete();
}

/// Stores one random cache key in platform-protected storage.
final class SecureContactCacheKeyStore implements ContactCacheKeyStore {
  /// Creates key storage for a hashed [scopeId].
  SecureContactCacheKeyStore({
    required String scopeId,
    FlutterSecureStorage? storage,
  }) : _key = 'contact-cache-key-v1-$scopeId',
       _storage =
           storage ??
           const FlutterSecureStorage(
             iOptions: IOSOptions(
               accountName: 'ngotools_mobile_contacts',
               accessibility: KeychainAccessibility.first_unlock_this_device,
               synchronizable: false,
             ),
             mOptions: MacOsOptions(
               accountName: 'ngotools_mobile_contacts',
               accessibility: KeychainAccessibility.first_unlock_this_device,
               synchronizable: false,
             ),
             aOptions: AndroidOptions(
               resetOnError: true,
               migrateOnAlgorithmChange: true,
               migrateWithBackup: false,
               storageNamespace: 'ngotools_mobile_contacts',
             ),
           );

  final String _key;
  final FlutterSecureStorage _storage;

  @override
  Future<List<int>> readOrCreate() async {
    final encoded = await _storage.read(key: _key);

    if (encoded != null) {
      try {
        final decoded = base64Decode(encoded);

        if (decoded.length == 32) {
          return List<int>.unmodifiable(decoded);
        }
      } on FormatException {
        // An invalid key is replaced and its old blob will fail closed.
      }

      await _storage.delete(key: _key);
    }

    final random = Random.secure();
    final key = List<int>.generate(32, (_) => random.nextInt(256));
    await _storage.write(key: _key, value: base64Encode(key));

    return List<int>.unmodifiable(key);
  }

  @override
  Future<void> delete() => _storage.delete(key: _key);
}

/// Atomically persists one encrypted cache envelope in app support storage.
final class FileContactCacheBlobStore implements ContactCacheBlobStore {
  /// Creates file storage for a hashed [scopeId].
  FileContactCacheBlobStore({
    required String scopeId,
    Future<Directory> Function()? supportDirectory,
  }) : _scopeId = scopeId,
       _supportDirectory = supportDirectory ?? getApplicationSupportDirectory;

  final String _scopeId;
  final Future<Directory> Function() _supportDirectory;

  @override
  Future<Uint8List?> read() async {
    final file = await _file();

    if (!await file.exists()) {
      return null;
    }

    return file.readAsBytes();
  }

  @override
  Future<void> write(Uint8List bytes) async {
    final file = await _file();
    await file.parent.create(recursive: true);
    final suffix = Random.secure().nextInt(0x7fffffff).toRadixString(16);
    final temporary = File('${file.path}.$suffix.tmp');

    try {
      await temporary.writeAsBytes(bytes, flush: true);
      await temporary.rename(file.path);
    } on Object {
      if (await temporary.exists()) {
        await temporary.delete();
      }

      rethrow;
    }
  }

  @override
  Future<void> delete() async {
    final file = await _file();

    if (await file.exists()) {
      await file.delete();
    }
  }

  Future<File> _file() async {
    final support = await _supportDirectory();

    return File(
      path.join(
        support.path,
        'ngotools_mobile',
        'contacts',
        'contact-cache-v1-$_scopeId.enc',
      ),
    );
  }
}
