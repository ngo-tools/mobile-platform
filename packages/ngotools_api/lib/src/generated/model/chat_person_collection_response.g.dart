// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'chat_person_collection_response.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$ChatPersonCollectionResponseCWProxy {
  ChatPersonCollectionResponse data(List<ChatPerson> data);

  ChatPersonCollectionResponse meta(PaginationMeta meta);

  /// Creates a new instance with the provided field values.
  /// Passing `null` to a nullable field nullifies it, while `null` for a non-nullable field is ignored. To update a single field use `ChatPersonCollectionResponse(...).copyWith.fieldName(value)`.
  ///
  /// Example:
  /// ```dart
  /// ChatPersonCollectionResponse(...).copyWith(id: 12, name: "My name")
  /// ```
  ChatPersonCollectionResponse call({
    List<ChatPerson> data,
    PaginationMeta meta,
  });
}

/// Callable proxy for `copyWith` functionality.
/// Use as `instanceOfChatPersonCollectionResponse.copyWith(...)` or call `instanceOfChatPersonCollectionResponse.copyWith.fieldName(value)` for a single field.
class _$ChatPersonCollectionResponseCWProxyImpl
    implements _$ChatPersonCollectionResponseCWProxy {
  const _$ChatPersonCollectionResponseCWProxyImpl(this._value);

  final ChatPersonCollectionResponse _value;

  @override
  ChatPersonCollectionResponse data(List<ChatPerson> data) => call(data: data);

  @override
  ChatPersonCollectionResponse meta(PaginationMeta meta) => call(meta: meta);

  /// Creates a new instance with the provided field values.
  /// Passing `null` to a nullable field nullifies it, while `null` for a non-nullable field is ignored. To update a single field use `ChatPersonCollectionResponse(...).copyWith.fieldName(value)`.
  ///
  /// Example:
  /// ```dart
  /// ChatPersonCollectionResponse(...).copyWith(id: 12, name: "My name")
  /// ```
  @override
  ChatPersonCollectionResponse call({
    Object? data = const $CopyWithPlaceholder(),
    Object? meta = const $CopyWithPlaceholder(),
  }) {
    return ChatPersonCollectionResponse(
      data: data == const $CopyWithPlaceholder() || data == null
          ? _value.data
          // ignore: cast_nullable_to_non_nullable
          : data as List<ChatPerson>,
      meta: meta == const $CopyWithPlaceholder() || meta == null
          ? _value.meta
          // ignore: cast_nullable_to_non_nullable
          : meta as PaginationMeta,
    );
  }
}

extension $ChatPersonCollectionResponseCopyWith
    on ChatPersonCollectionResponse {
  /// Returns a callable class used to build a new instance with modified fields.
  /// Example: `instanceOfChatPersonCollectionResponse.copyWith(...)` or `instanceOfChatPersonCollectionResponse.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$ChatPersonCollectionResponseCWProxy get copyWith =>
      _$ChatPersonCollectionResponseCWProxyImpl(this);
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ChatPersonCollectionResponse _$ChatPersonCollectionResponseFromJson(
  Map<String, dynamic> json,
) => $checkedCreate('ChatPersonCollectionResponse', json, ($checkedConvert) {
  $checkKeys(json, requiredKeys: const ['data', 'meta']);
  final val = ChatPersonCollectionResponse(
    data: $checkedConvert(
      'data',
      (v) => (v as List<dynamic>)
          .map((e) => ChatPerson.fromJson(e as Map<String, dynamic>))
          .toList(),
    ),
    meta: $checkedConvert(
      'meta',
      (v) => PaginationMeta.fromJson(v as Map<String, dynamic>),
    ),
  );
  return val;
});

Map<String, dynamic> _$ChatPersonCollectionResponseToJson(
  ChatPersonCollectionResponse instance,
) => <String, dynamic>{
  'data': instance.data.map((e) => e.toJson()).toList(),
  'meta': instance.meta.toJson(),
};
