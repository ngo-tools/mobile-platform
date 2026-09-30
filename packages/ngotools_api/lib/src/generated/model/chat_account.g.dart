// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'chat_account.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$ChatAccountCWProxy {
  ChatAccount status(ChatAccountStatusEnum status);

  ChatAccount available(bool available);

  ChatAccount matrixUserId(String? matrixUserId);

  ChatAccount serverName(String? serverName);

  ChatAccount homeserverUrl(String? homeserverUrl);

  /// Creates a new instance with the provided field values.
  /// Passing `null` to a nullable field nullifies it, while `null` for a non-nullable field is ignored. To update a single field use `ChatAccount(...).copyWith.fieldName(value)`.
  ///
  /// Example:
  /// ```dart
  /// ChatAccount(...).copyWith(id: 12, name: "My name")
  /// ```
  ChatAccount call({
    ChatAccountStatusEnum status,
    bool available,
    String? matrixUserId,
    String? serverName,
    String? homeserverUrl,
  });
}

/// Callable proxy for `copyWith` functionality.
/// Use as `instanceOfChatAccount.copyWith(...)` or call `instanceOfChatAccount.copyWith.fieldName(value)` for a single field.
class _$ChatAccountCWProxyImpl implements _$ChatAccountCWProxy {
  const _$ChatAccountCWProxyImpl(this._value);

  final ChatAccount _value;

  @override
  ChatAccount status(ChatAccountStatusEnum status) => call(status: status);

  @override
  ChatAccount available(bool available) => call(available: available);

  @override
  ChatAccount matrixUserId(String? matrixUserId) =>
      call(matrixUserId: matrixUserId);

  @override
  ChatAccount serverName(String? serverName) => call(serverName: serverName);

  @override
  ChatAccount homeserverUrl(String? homeserverUrl) =>
      call(homeserverUrl: homeserverUrl);

  /// Creates a new instance with the provided field values.
  /// Passing `null` to a nullable field nullifies it, while `null` for a non-nullable field is ignored. To update a single field use `ChatAccount(...).copyWith.fieldName(value)`.
  ///
  /// Example:
  /// ```dart
  /// ChatAccount(...).copyWith(id: 12, name: "My name")
  /// ```
  @override
  ChatAccount call({
    Object? status = const $CopyWithPlaceholder(),
    Object? available = const $CopyWithPlaceholder(),
    Object? matrixUserId = const $CopyWithPlaceholder(),
    Object? serverName = const $CopyWithPlaceholder(),
    Object? homeserverUrl = const $CopyWithPlaceholder(),
  }) {
    return ChatAccount(
      status: status == const $CopyWithPlaceholder() || status == null
          ? _value.status
          // ignore: cast_nullable_to_non_nullable
          : status as ChatAccountStatusEnum,
      available: available == const $CopyWithPlaceholder() || available == null
          ? _value.available
          // ignore: cast_nullable_to_non_nullable
          : available as bool,
      matrixUserId: matrixUserId == const $CopyWithPlaceholder()
          ? _value.matrixUserId
          // ignore: cast_nullable_to_non_nullable
          : matrixUserId as String?,
      serverName: serverName == const $CopyWithPlaceholder()
          ? _value.serverName
          // ignore: cast_nullable_to_non_nullable
          : serverName as String?,
      homeserverUrl: homeserverUrl == const $CopyWithPlaceholder()
          ? _value.homeserverUrl
          // ignore: cast_nullable_to_non_nullable
          : homeserverUrl as String?,
    );
  }
}

extension $ChatAccountCopyWith on ChatAccount {
  /// Returns a callable class used to build a new instance with modified fields.
  /// Example: `instanceOfChatAccount.copyWith(...)` or `instanceOfChatAccount.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$ChatAccountCWProxy get copyWith => _$ChatAccountCWProxyImpl(this);
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ChatAccount _$ChatAccountFromJson(Map<String, dynamic> json) => $checkedCreate(
  'ChatAccount',
  json,
  ($checkedConvert) {
    $checkKeys(
      json,
      requiredKeys: const [
        'status',
        'available',
        'matrix_user_id',
        'server_name',
        'homeserver_url',
      ],
    );
    final val = ChatAccount(
      status: $checkedConvert(
        'status',
        (v) => $enumDecode(
          _$ChatAccountStatusEnumEnumMap,
          v,
          unknownValue: ChatAccountStatusEnum.unknownDefaultOpenApi,
        ),
      ),
      available: $checkedConvert('available', (v) => v as bool),
      matrixUserId: $checkedConvert('matrix_user_id', (v) => v as String?),
      serverName: $checkedConvert('server_name', (v) => v as String?),
      homeserverUrl: $checkedConvert('homeserver_url', (v) => v as String?),
    );
    return val;
  },
  fieldKeyMap: const {
    'matrixUserId': 'matrix_user_id',
    'serverName': 'server_name',
    'homeserverUrl': 'homeserver_url',
  },
);

Map<String, dynamic> _$ChatAccountToJson(ChatAccount instance) =>
    <String, dynamic>{
      'status': _$ChatAccountStatusEnumEnumMap[instance.status]!,
      'available': instance.available,
      'matrix_user_id': instance.matrixUserId,
      'server_name': instance.serverName,
      'homeserver_url': instance.homeserverUrl,
    };

const _$ChatAccountStatusEnumEnumMap = {
  ChatAccountStatusEnum.active: 'active',
  ChatAccountStatusEnum.locked: 'locked',
  ChatAccountStatusEnum.deactivated: 'deactivated',
  ChatAccountStatusEnum.none: 'none',
  ChatAccountStatusEnum.unknownDefaultOpenApi: 'unknown_default_open_api',
};
