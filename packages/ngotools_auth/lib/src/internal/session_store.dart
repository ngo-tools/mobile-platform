import 'dart:convert';

import 'package:crypto/crypto.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../mobile_auth_configuration.dart';
import '../mobile_auth_state.dart';
import 'auth_session.dart';

abstract interface class AuthSessionStore {
  Future<AuthSession?> read(MobileAuthConfiguration configuration);

  Future<void> write(
    MobileAuthConfiguration configuration,
    AuthSession session,
  );

  Future<void> delete(MobileAuthConfiguration configuration);
}

final class SecureAuthSessionStore implements AuthSessionStore {
  SecureAuthSessionStore({FlutterSecureStorage? storage})
    : _storage =
          storage ??
          const FlutterSecureStorage(
            iOptions: IOSOptions(
              accessibility: KeychainAccessibility.first_unlock_this_device,
              synchronizable: false,
            ),
            aOptions: AndroidOptions(
              resetOnError: true,
              migrateOnAlgorithmChange: true,
              migrateWithBackup: false,
              storageNamespace: 'ngotools_mobile_auth',
            ),
          );

  static const _key = 'session-envelope-v1';
  final FlutterSecureStorage _storage;

  @override
  Future<AuthSession?> read(MobileAuthConfiguration configuration) async {
    final serialized = await _storage.read(key: _storageKey(configuration));

    if (serialized == null) {
      return null;
    }

    try {
      final value = jsonDecode(serialized);

      if (value is! Map<String, Object?> ||
          value['version'] != 1 ||
          value['configuration'] != _configurationHash(configuration)) {
        await delete(configuration);

        return null;
      }

      final identity = value['identity'];
      final capabilities = identity is Map<String, Object?>
          ? identity['capabilities']
          : null;

      if (identity is! Map<String, Object?> ||
          identity['id'] is! String ||
          identity['display_name'] is! String ||
          capabilities is! List<Object?> ||
          !capabilities.every((value) => value is String) ||
          value['api_token'] is! String ||
          value['oidc_refresh_token'] is! String) {
        throw const FormatException('Invalid session envelope.');
      }

      return AuthSession(
        apiToken: value['api_token']! as String,
        oidcRefreshToken: value['oidc_refresh_token']! as String,
        oidcIdToken: value['oidc_id_token'] as String?,
        identity: MobileIdentity(
          id: identity['id']! as String,
          displayName: identity['display_name']! as String,
          email: identity['email'] as String?,
          capabilities: capabilities.cast<String>().toSet(),
        ),
      );
    } on Object {
      await delete(configuration);

      return null;
    }
  }

  @override
  Future<void> write(
    MobileAuthConfiguration configuration,
    AuthSession session,
  ) => _storage.write(
    key: _storageKey(configuration),
    value: jsonEncode({
      'version': 1,
      'configuration': _configurationHash(configuration),
      'api_token': session.apiToken,
      'oidc_refresh_token': session.oidcRefreshToken,
      'oidc_id_token': session.oidcIdToken,
      'identity': {
        'id': session.identity.id,
        'display_name': session.identity.displayName,
        'email': session.identity.email,
        'capabilities': session.identity.capabilities.toList()..sort(),
      },
    }),
  );

  @override
  Future<void> delete(MobileAuthConfiguration configuration) =>
      _storage.delete(key: _storageKey(configuration));

  String _storageKey(MobileAuthConfiguration configuration) =>
      '$_key-${_configurationHash(configuration)}';

  String _configurationHash(MobileAuthConfiguration configuration) => sha256
      .convert(
        utf8.encode(
          '${configuration.storageNamespace}|${configuration.issuer}|'
          '${configuration.clientId}|${configuration.apiBaseUrl.origin}',
        ),
      )
      .toString();
}
