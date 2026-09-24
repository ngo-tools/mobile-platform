// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'contact_search_term.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$ContactSearchTermCWProxy {
  ContactSearchTerm value(String value);

  ContactSearchTerm caseSensitive(bool? caseSensitive);

  /// Creates a new instance with the provided field values.
  /// Passing `null` to a nullable field nullifies it, while `null` for a non-nullable field is ignored. To update a single field use `ContactSearchTerm(...).copyWith.fieldName(value)`.
  ///
  /// Example:
  /// ```dart
  /// ContactSearchTerm(...).copyWith(id: 12, name: "My name")
  /// ```
  ContactSearchTerm call({String value, bool? caseSensitive});
}

/// Callable proxy for `copyWith` functionality.
/// Use as `instanceOfContactSearchTerm.copyWith(...)` or call `instanceOfContactSearchTerm.copyWith.fieldName(value)` for a single field.
class _$ContactSearchTermCWProxyImpl implements _$ContactSearchTermCWProxy {
  const _$ContactSearchTermCWProxyImpl(this._value);

  final ContactSearchTerm _value;

  @override
  ContactSearchTerm value(String value) => call(value: value);

  @override
  ContactSearchTerm caseSensitive(bool? caseSensitive) =>
      call(caseSensitive: caseSensitive);

  /// Creates a new instance with the provided field values.
  /// Passing `null` to a nullable field nullifies it, while `null` for a non-nullable field is ignored. To update a single field use `ContactSearchTerm(...).copyWith.fieldName(value)`.
  ///
  /// Example:
  /// ```dart
  /// ContactSearchTerm(...).copyWith(id: 12, name: "My name")
  /// ```
  @override
  ContactSearchTerm call({
    Object? value = const $CopyWithPlaceholder(),
    Object? caseSensitive = const $CopyWithPlaceholder(),
  }) {
    return ContactSearchTerm(
      value: value == const $CopyWithPlaceholder() || value == null
          ? _value.value
          // ignore: cast_nullable_to_non_nullable
          : value as String,
      caseSensitive: caseSensitive == const $CopyWithPlaceholder()
          ? _value.caseSensitive
          // ignore: cast_nullable_to_non_nullable
          : caseSensitive as bool?,
    );
  }
}

extension $ContactSearchTermCopyWith on ContactSearchTerm {
  /// Returns a callable class used to build a new instance with modified fields.
  /// Example: `instanceOfContactSearchTerm.copyWith(...)` or `instanceOfContactSearchTerm.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$ContactSearchTermCWProxy get copyWith =>
      _$ContactSearchTermCWProxyImpl(this);
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ContactSearchTerm _$ContactSearchTermFromJson(Map<String, dynamic> json) =>
    $checkedCreate('ContactSearchTerm', json, ($checkedConvert) {
      $checkKeys(json, requiredKeys: const ['value']);
      final val = ContactSearchTerm(
        value: $checkedConvert('value', (v) => v as String),
        caseSensitive: $checkedConvert(
          'case_sensitive',
          (v) => v as bool? ?? false,
        ),
      );
      return val;
    }, fieldKeyMap: const {'caseSensitive': 'case_sensitive'});

Map<String, dynamic> _$ContactSearchTermToJson(ContactSearchTerm instance) =>
    <String, dynamic>{
      'value': instance.value,
      'case_sensitive': ?instance.caseSensitive,
    };
