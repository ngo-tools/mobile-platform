// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'chat_person.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$ChatPersonCWProxy {
  ChatPerson matrixUserId(String matrixUserId);

  ChatPerson displayName(String displayName);

  ChatPerson kind(ChatPersonKindEnum kind);

  /// Creates a new instance with the provided field values.
  /// Passing `null` to a nullable field nullifies it, while `null` for a non-nullable field is ignored. To update a single field use `ChatPerson(...).copyWith.fieldName(value)`.
  ///
  /// Example:
  /// ```dart
  /// ChatPerson(...).copyWith(id: 12, name: "My name")
  /// ```
  ChatPerson call({
    String matrixUserId,
    String displayName,
    ChatPersonKindEnum kind,
  });
}

/// Callable proxy for `copyWith` functionality.
/// Use as `instanceOfChatPerson.copyWith(...)` or call `instanceOfChatPerson.copyWith.fieldName(value)` for a single field.
class _$ChatPersonCWProxyImpl implements _$ChatPersonCWProxy {
  const _$ChatPersonCWProxyImpl(this._value);

  final ChatPerson _value;

  @override
  ChatPerson matrixUserId(String matrixUserId) =>
      call(matrixUserId: matrixUserId);

  @override
  ChatPerson displayName(String displayName) => call(displayName: displayName);

  @override
  ChatPerson kind(ChatPersonKindEnum kind) => call(kind: kind);

  /// Creates a new instance with the provided field values.
  /// Passing `null` to a nullable field nullifies it, while `null` for a non-nullable field is ignored. To update a single field use `ChatPerson(...).copyWith.fieldName(value)`.
  ///
  /// Example:
  /// ```dart
  /// ChatPerson(...).copyWith(id: 12, name: "My name")
  /// ```
  @override
  ChatPerson call({
    Object? matrixUserId = const $CopyWithPlaceholder(),
    Object? displayName = const $CopyWithPlaceholder(),
    Object? kind = const $CopyWithPlaceholder(),
  }) {
    return ChatPerson(
      matrixUserId:
          matrixUserId == const $CopyWithPlaceholder() || matrixUserId == null
          ? _value.matrixUserId
          // ignore: cast_nullable_to_non_nullable
          : matrixUserId as String,
      displayName:
          displayName == const $CopyWithPlaceholder() || displayName == null
          ? _value.displayName
          // ignore: cast_nullable_to_non_nullable
          : displayName as String,
      kind: kind == const $CopyWithPlaceholder() || kind == null
          ? _value.kind
          // ignore: cast_nullable_to_non_nullable
          : kind as ChatPersonKindEnum,
    );
  }
}

extension $ChatPersonCopyWith on ChatPerson {
  /// Returns a callable class used to build a new instance with modified fields.
  /// Example: `instanceOfChatPerson.copyWith(...)` or `instanceOfChatPerson.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$ChatPersonCWProxy get copyWith => _$ChatPersonCWProxyImpl(this);
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ChatPerson _$ChatPersonFromJson(Map<String, dynamic> json) => $checkedCreate(
  'ChatPerson',
  json,
  ($checkedConvert) {
    $checkKeys(
      json,
      requiredKeys: const ['matrix_user_id', 'display_name', 'kind'],
    );
    final val = ChatPerson(
      matrixUserId: $checkedConvert('matrix_user_id', (v) => v as String),
      displayName: $checkedConvert('display_name', (v) => v as String),
      kind: $checkedConvert(
        'kind',
        (v) => $enumDecode(
          _$ChatPersonKindEnumEnumMap,
          v,
          unknownValue: ChatPersonKindEnum.unknownDefaultOpenApi,
        ),
      ),
    );
    return val;
  },
  fieldKeyMap: const {
    'matrixUserId': 'matrix_user_id',
    'displayName': 'display_name',
  },
);

Map<String, dynamic> _$ChatPersonToJson(ChatPerson instance) =>
    <String, dynamic>{
      'matrix_user_id': instance.matrixUserId,
      'display_name': instance.displayName,
      'kind': _$ChatPersonKindEnumEnumMap[instance.kind]!,
    };

const _$ChatPersonKindEnumEnumMap = {
  ChatPersonKindEnum.teamMember: 'team_member',
  ChatPersonKindEnum.contact: 'contact',
  ChatPersonKindEnum.unknownDefaultOpenApi: 'unknown_default_open_api',
};
