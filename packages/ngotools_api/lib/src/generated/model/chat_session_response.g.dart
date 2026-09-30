// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'chat_session_response.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$ChatSessionResponseCWProxy {
  ChatSessionResponse data(ChatSession data);

  /// Creates a new instance with the provided field values.
  /// Passing `null` to a nullable field nullifies it, while `null` for a non-nullable field is ignored. To update a single field use `ChatSessionResponse(...).copyWith.fieldName(value)`.
  ///
  /// Example:
  /// ```dart
  /// ChatSessionResponse(...).copyWith(id: 12, name: "My name")
  /// ```
  ChatSessionResponse call({ChatSession data});
}

/// Callable proxy for `copyWith` functionality.
/// Use as `instanceOfChatSessionResponse.copyWith(...)` or call `instanceOfChatSessionResponse.copyWith.fieldName(value)` for a single field.
class _$ChatSessionResponseCWProxyImpl implements _$ChatSessionResponseCWProxy {
  const _$ChatSessionResponseCWProxyImpl(this._value);

  final ChatSessionResponse _value;

  @override
  ChatSessionResponse data(ChatSession data) => call(data: data);

  /// Creates a new instance with the provided field values.
  /// Passing `null` to a nullable field nullifies it, while `null` for a non-nullable field is ignored. To update a single field use `ChatSessionResponse(...).copyWith.fieldName(value)`.
  ///
  /// Example:
  /// ```dart
  /// ChatSessionResponse(...).copyWith(id: 12, name: "My name")
  /// ```
  @override
  ChatSessionResponse call({Object? data = const $CopyWithPlaceholder()}) {
    return ChatSessionResponse(
      data: data == const $CopyWithPlaceholder() || data == null
          ? _value.data
          // ignore: cast_nullable_to_non_nullable
          : data as ChatSession,
    );
  }
}

extension $ChatSessionResponseCopyWith on ChatSessionResponse {
  /// Returns a callable class used to build a new instance with modified fields.
  /// Example: `instanceOfChatSessionResponse.copyWith(...)` or `instanceOfChatSessionResponse.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$ChatSessionResponseCWProxy get copyWith =>
      _$ChatSessionResponseCWProxyImpl(this);
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ChatSessionResponse _$ChatSessionResponseFromJson(Map<String, dynamic> json) =>
    $checkedCreate('ChatSessionResponse', json, ($checkedConvert) {
      $checkKeys(json, requiredKeys: const ['data']);
      final val = ChatSessionResponse(
        data: $checkedConvert(
          'data',
          (v) => ChatSession.fromJson(v as Map<String, dynamic>),
        ),
      );
      return val;
    });

Map<String, dynamic> _$ChatSessionResponseToJson(
  ChatSessionResponse instance,
) => <String, dynamic>{'data': instance.data.toJson()};
