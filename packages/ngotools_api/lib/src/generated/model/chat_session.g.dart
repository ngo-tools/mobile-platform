// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'chat_session.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$ChatSessionCWProxy {
  ChatSession matrixUserId(String matrixUserId);

  ChatSession deviceId(String deviceId);

  ChatSession accessToken(String accessToken);

  ChatSession expiresAt(DateTime? expiresAt);

  ChatSession homeserverUrl(String homeserverUrl);

  ChatSession serverName(String serverName);

  /// Creates a new instance with the provided field values.
  /// Passing `null` to a nullable field nullifies it, while `null` for a non-nullable field is ignored. To update a single field use `ChatSession(...).copyWith.fieldName(value)`.
  ///
  /// Example:
  /// ```dart
  /// ChatSession(...).copyWith(id: 12, name: "My name")
  /// ```
  ChatSession call({
    String matrixUserId,
    String deviceId,
    String accessToken,
    DateTime? expiresAt,
    String homeserverUrl,
    String serverName,
  });
}

/// Callable proxy for `copyWith` functionality.
/// Use as `instanceOfChatSession.copyWith(...)` or call `instanceOfChatSession.copyWith.fieldName(value)` for a single field.
class _$ChatSessionCWProxyImpl implements _$ChatSessionCWProxy {
  const _$ChatSessionCWProxyImpl(this._value);

  final ChatSession _value;

  @override
  ChatSession matrixUserId(String matrixUserId) =>
      call(matrixUserId: matrixUserId);

  @override
  ChatSession deviceId(String deviceId) => call(deviceId: deviceId);

  @override
  ChatSession accessToken(String accessToken) => call(accessToken: accessToken);

  @override
  ChatSession expiresAt(DateTime? expiresAt) => call(expiresAt: expiresAt);

  @override
  ChatSession homeserverUrl(String homeserverUrl) =>
      call(homeserverUrl: homeserverUrl);

  @override
  ChatSession serverName(String serverName) => call(serverName: serverName);

  /// Creates a new instance with the provided field values.
  /// Passing `null` to a nullable field nullifies it, while `null` for a non-nullable field is ignored. To update a single field use `ChatSession(...).copyWith.fieldName(value)`.
  ///
  /// Example:
  /// ```dart
  /// ChatSession(...).copyWith(id: 12, name: "My name")
  /// ```
  @override
  ChatSession call({
    Object? matrixUserId = const $CopyWithPlaceholder(),
    Object? deviceId = const $CopyWithPlaceholder(),
    Object? accessToken = const $CopyWithPlaceholder(),
    Object? expiresAt = const $CopyWithPlaceholder(),
    Object? homeserverUrl = const $CopyWithPlaceholder(),
    Object? serverName = const $CopyWithPlaceholder(),
  }) {
    return ChatSession(
      matrixUserId:
          matrixUserId == const $CopyWithPlaceholder() || matrixUserId == null
          ? _value.matrixUserId
          // ignore: cast_nullable_to_non_nullable
          : matrixUserId as String,
      deviceId: deviceId == const $CopyWithPlaceholder() || deviceId == null
          ? _value.deviceId
          // ignore: cast_nullable_to_non_nullable
          : deviceId as String,
      accessToken:
          accessToken == const $CopyWithPlaceholder() || accessToken == null
          ? _value.accessToken
          // ignore: cast_nullable_to_non_nullable
          : accessToken as String,
      expiresAt: expiresAt == const $CopyWithPlaceholder()
          ? _value.expiresAt
          // ignore: cast_nullable_to_non_nullable
          : expiresAt as DateTime?,
      homeserverUrl:
          homeserverUrl == const $CopyWithPlaceholder() || homeserverUrl == null
          ? _value.homeserverUrl
          // ignore: cast_nullable_to_non_nullable
          : homeserverUrl as String,
      serverName:
          serverName == const $CopyWithPlaceholder() || serverName == null
          ? _value.serverName
          // ignore: cast_nullable_to_non_nullable
          : serverName as String,
    );
  }
}

extension $ChatSessionCopyWith on ChatSession {
  /// Returns a callable class used to build a new instance with modified fields.
  /// Example: `instanceOfChatSession.copyWith(...)` or `instanceOfChatSession.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$ChatSessionCWProxy get copyWith => _$ChatSessionCWProxyImpl(this);
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ChatSession _$ChatSessionFromJson(Map<String, dynamic> json) => $checkedCreate(
  'ChatSession',
  json,
  ($checkedConvert) {
    $checkKeys(
      json,
      requiredKeys: const [
        'matrix_user_id',
        'device_id',
        'access_token',
        'expires_at',
        'homeserver_url',
        'server_name',
      ],
    );
    final val = ChatSession(
      matrixUserId: $checkedConvert('matrix_user_id', (v) => v as String),
      deviceId: $checkedConvert('device_id', (v) => v as String),
      accessToken: $checkedConvert('access_token', (v) => v as String),
      expiresAt: $checkedConvert(
        'expires_at',
        (v) => v == null ? null : DateTime.parse(v as String),
      ),
      homeserverUrl: $checkedConvert('homeserver_url', (v) => v as String),
      serverName: $checkedConvert('server_name', (v) => v as String),
    );
    return val;
  },
  fieldKeyMap: const {
    'matrixUserId': 'matrix_user_id',
    'deviceId': 'device_id',
    'accessToken': 'access_token',
    'expiresAt': 'expires_at',
    'homeserverUrl': 'homeserver_url',
    'serverName': 'server_name',
  },
);

Map<String, dynamic> _$ChatSessionToJson(ChatSession instance) =>
    <String, dynamic>{
      'matrix_user_id': instance.matrixUserId,
      'device_id': instance.deviceId,
      'access_token': instance.accessToken,
      'expires_at': instance.expiresAt?.toIso8601String(),
      'homeserver_url': instance.homeserverUrl,
      'server_name': instance.serverName,
    };
