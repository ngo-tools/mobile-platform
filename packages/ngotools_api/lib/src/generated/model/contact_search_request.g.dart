// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'contact_search_request.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$ContactSearchRequestCWProxy {
  ContactSearchRequest search(ContactSearchTerm? search);

  ContactSearchRequest sort(List<ContactSort>? sort);

  /// Creates a new instance with the provided field values.
  /// Passing `null` to a nullable field nullifies it, while `null` for a non-nullable field is ignored. To update a single field use `ContactSearchRequest(...).copyWith.fieldName(value)`.
  ///
  /// Example:
  /// ```dart
  /// ContactSearchRequest(...).copyWith(id: 12, name: "My name")
  /// ```
  ContactSearchRequest call({
    ContactSearchTerm? search,
    List<ContactSort>? sort,
  });
}

/// Callable proxy for `copyWith` functionality.
/// Use as `instanceOfContactSearchRequest.copyWith(...)` or call `instanceOfContactSearchRequest.copyWith.fieldName(value)` for a single field.
class _$ContactSearchRequestCWProxyImpl
    implements _$ContactSearchRequestCWProxy {
  const _$ContactSearchRequestCWProxyImpl(this._value);

  final ContactSearchRequest _value;

  @override
  ContactSearchRequest search(ContactSearchTerm? search) =>
      call(search: search);

  @override
  ContactSearchRequest sort(List<ContactSort>? sort) => call(sort: sort);

  /// Creates a new instance with the provided field values.
  /// Passing `null` to a nullable field nullifies it, while `null` for a non-nullable field is ignored. To update a single field use `ContactSearchRequest(...).copyWith.fieldName(value)`.
  ///
  /// Example:
  /// ```dart
  /// ContactSearchRequest(...).copyWith(id: 12, name: "My name")
  /// ```
  @override
  ContactSearchRequest call({
    Object? search = const $CopyWithPlaceholder(),
    Object? sort = const $CopyWithPlaceholder(),
  }) {
    return ContactSearchRequest(
      search: search == const $CopyWithPlaceholder()
          ? _value.search
          // ignore: cast_nullable_to_non_nullable
          : search as ContactSearchTerm?,
      sort: sort == const $CopyWithPlaceholder()
          ? _value.sort
          // ignore: cast_nullable_to_non_nullable
          : sort as List<ContactSort>?,
    );
  }
}

extension $ContactSearchRequestCopyWith on ContactSearchRequest {
  /// Returns a callable class used to build a new instance with modified fields.
  /// Example: `instanceOfContactSearchRequest.copyWith(...)` or `instanceOfContactSearchRequest.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$ContactSearchRequestCWProxy get copyWith =>
      _$ContactSearchRequestCWProxyImpl(this);
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ContactSearchRequest _$ContactSearchRequestFromJson(
  Map<String, dynamic> json,
) => $checkedCreate('ContactSearchRequest', json, ($checkedConvert) {
  final val = ContactSearchRequest(
    search: $checkedConvert(
      'search',
      (v) => v == null
          ? null
          : ContactSearchTerm.fromJson(v as Map<String, dynamic>),
    ),
    sort: $checkedConvert(
      'sort',
      (v) => (v as List<dynamic>?)
          ?.map((e) => ContactSort.fromJson(e as Map<String, dynamic>))
          .toList(),
    ),
  );
  return val;
});

Map<String, dynamic> _$ContactSearchRequestToJson(
  ContactSearchRequest instance,
) => <String, dynamic>{
  'search': ?instance.search?.toJson(),
  'sort': ?instance.sort?.map((e) => e.toJson()).toList(),
};
