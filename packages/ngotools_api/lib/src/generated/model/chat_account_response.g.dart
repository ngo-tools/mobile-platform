// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'chat_account_response.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$ChatAccountResponseCWProxy {
  ChatAccountResponse data(ChatAccount data);

  /// Creates a new instance with the provided field values.
  /// Passing `null` to a nullable field nullifies it, while `null` for a non-nullable field is ignored. To update a single field use `ChatAccountResponse(...).copyWith.fieldName(value)`.
  ///
  /// Example:
  /// ```dart
  /// ChatAccountResponse(...).copyWith(id: 12, name: "My name")
  /// ```
  ChatAccountResponse call({ChatAccount data});
}

/// Callable proxy for `copyWith` functionality.
/// Use as `instanceOfChatAccountResponse.copyWith(...)` or call `instanceOfChatAccountResponse.copyWith.fieldName(value)` for a single field.
class _$ChatAccountResponseCWProxyImpl implements _$ChatAccountResponseCWProxy {
  const _$ChatAccountResponseCWProxyImpl(this._value);

  final ChatAccountResponse _value;

  @override
  ChatAccountResponse data(ChatAccount data) => call(data: data);

  /// Creates a new instance with the provided field values.
  /// Passing `null` to a nullable field nullifies it, while `null` for a non-nullable field is ignored. To update a single field use `ChatAccountResponse(...).copyWith.fieldName(value)`.
  ///
  /// Example:
  /// ```dart
  /// ChatAccountResponse(...).copyWith(id: 12, name: "My name")
  /// ```
  @override
  ChatAccountResponse call({Object? data = const $CopyWithPlaceholder()}) {
    return ChatAccountResponse(
      data: data == const $CopyWithPlaceholder() || data == null
          ? _value.data
          // ignore: cast_nullable_to_non_nullable
          : data as ChatAccount,
    );
  }
}

extension $ChatAccountResponseCopyWith on ChatAccountResponse {
  /// Returns a callable class used to build a new instance with modified fields.
  /// Example: `instanceOfChatAccountResponse.copyWith(...)` or `instanceOfChatAccountResponse.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$ChatAccountResponseCWProxy get copyWith =>
      _$ChatAccountResponseCWProxyImpl(this);
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ChatAccountResponse _$ChatAccountResponseFromJson(Map<String, dynamic> json) =>
    $checkedCreate('ChatAccountResponse', json, ($checkedConvert) {
      $checkKeys(json, requiredKeys: const ['data']);
      final val = ChatAccountResponse(
        data: $checkedConvert(
          'data',
          (v) => ChatAccount.fromJson(v as Map<String, dynamic>),
        ),
      );
      return val;
    });

Map<String, dynamic> _$ChatAccountResponseToJson(
  ChatAccountResponse instance,
) => <String, dynamic>{'data': instance.data.toJson()};
