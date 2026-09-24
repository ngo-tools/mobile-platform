// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'contact_collection_response.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$ContactCollectionResponseCWProxy {
  ContactCollectionResponse data(List<Contact> data);

  ContactCollectionResponse links(PaginationLinks? links);

  ContactCollectionResponse meta(PaginationMeta? meta);

  /// Creates a new instance with the provided field values.
  /// Passing `null` to a nullable field nullifies it, while `null` for a non-nullable field is ignored. To update a single field use `ContactCollectionResponse(...).copyWith.fieldName(value)`.
  ///
  /// Example:
  /// ```dart
  /// ContactCollectionResponse(...).copyWith(id: 12, name: "My name")
  /// ```
  ContactCollectionResponse call({
    List<Contact> data,
    PaginationLinks? links,
    PaginationMeta? meta,
  });
}

/// Callable proxy for `copyWith` functionality.
/// Use as `instanceOfContactCollectionResponse.copyWith(...)` or call `instanceOfContactCollectionResponse.copyWith.fieldName(value)` for a single field.
class _$ContactCollectionResponseCWProxyImpl
    implements _$ContactCollectionResponseCWProxy {
  const _$ContactCollectionResponseCWProxyImpl(this._value);

  final ContactCollectionResponse _value;

  @override
  ContactCollectionResponse data(List<Contact> data) => call(data: data);

  @override
  ContactCollectionResponse links(PaginationLinks? links) => call(links: links);

  @override
  ContactCollectionResponse meta(PaginationMeta? meta) => call(meta: meta);

  /// Creates a new instance with the provided field values.
  /// Passing `null` to a nullable field nullifies it, while `null` for a non-nullable field is ignored. To update a single field use `ContactCollectionResponse(...).copyWith.fieldName(value)`.
  ///
  /// Example:
  /// ```dart
  /// ContactCollectionResponse(...).copyWith(id: 12, name: "My name")
  /// ```
  @override
  ContactCollectionResponse call({
    Object? data = const $CopyWithPlaceholder(),
    Object? links = const $CopyWithPlaceholder(),
    Object? meta = const $CopyWithPlaceholder(),
  }) {
    return ContactCollectionResponse(
      data: data == const $CopyWithPlaceholder() || data == null
          ? _value.data
          // ignore: cast_nullable_to_non_nullable
          : data as List<Contact>,
      links: links == const $CopyWithPlaceholder()
          ? _value.links
          // ignore: cast_nullable_to_non_nullable
          : links as PaginationLinks?,
      meta: meta == const $CopyWithPlaceholder()
          ? _value.meta
          // ignore: cast_nullable_to_non_nullable
          : meta as PaginationMeta?,
    );
  }
}

extension $ContactCollectionResponseCopyWith on ContactCollectionResponse {
  /// Returns a callable class used to build a new instance with modified fields.
  /// Example: `instanceOfContactCollectionResponse.copyWith(...)` or `instanceOfContactCollectionResponse.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$ContactCollectionResponseCWProxy get copyWith =>
      _$ContactCollectionResponseCWProxyImpl(this);
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ContactCollectionResponse _$ContactCollectionResponseFromJson(
  Map<String, dynamic> json,
) => $checkedCreate('ContactCollectionResponse', json, ($checkedConvert) {
  $checkKeys(json, requiredKeys: const ['data']);
  final val = ContactCollectionResponse(
    data: $checkedConvert(
      'data',
      (v) => (v as List<dynamic>)
          .map((e) => Contact.fromJson(e as Map<String, dynamic>))
          .toList(),
    ),
    links: $checkedConvert(
      'links',
      (v) => v == null
          ? null
          : PaginationLinks.fromJson(v as Map<String, dynamic>),
    ),
    meta: $checkedConvert(
      'meta',
      (v) =>
          v == null ? null : PaginationMeta.fromJson(v as Map<String, dynamic>),
    ),
  );
  return val;
});

Map<String, dynamic> _$ContactCollectionResponseToJson(
  ContactCollectionResponse instance,
) => <String, dynamic>{
  'data': instance.data.map((e) => e.toJson()).toList(),
  'links': ?instance.links?.toJson(),
  'meta': ?instance.meta?.toJson(),
};
