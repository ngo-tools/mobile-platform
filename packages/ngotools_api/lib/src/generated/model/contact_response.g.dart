// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'contact_response.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$ContactResponseCWProxy {
  ContactResponse data(Contact data);

  /// Creates a new instance with the provided field values.
  /// Passing `null` to a nullable field nullifies it, while `null` for a non-nullable field is ignored. To update a single field use `ContactResponse(...).copyWith.fieldName(value)`.
  ///
  /// Example:
  /// ```dart
  /// ContactResponse(...).copyWith(id: 12, name: "My name")
  /// ```
  ContactResponse call({Contact data});
}

/// Callable proxy for `copyWith` functionality.
/// Use as `instanceOfContactResponse.copyWith(...)` or call `instanceOfContactResponse.copyWith.fieldName(value)` for a single field.
class _$ContactResponseCWProxyImpl implements _$ContactResponseCWProxy {
  const _$ContactResponseCWProxyImpl(this._value);

  final ContactResponse _value;

  @override
  ContactResponse data(Contact data) => call(data: data);

  /// Creates a new instance with the provided field values.
  /// Passing `null` to a nullable field nullifies it, while `null` for a non-nullable field is ignored. To update a single field use `ContactResponse(...).copyWith.fieldName(value)`.
  ///
  /// Example:
  /// ```dart
  /// ContactResponse(...).copyWith(id: 12, name: "My name")
  /// ```
  @override
  ContactResponse call({Object? data = const $CopyWithPlaceholder()}) {
    return ContactResponse(
      data: data == const $CopyWithPlaceholder() || data == null
          ? _value.data
          // ignore: cast_nullable_to_non_nullable
          : data as Contact,
    );
  }
}

extension $ContactResponseCopyWith on ContactResponse {
  /// Returns a callable class used to build a new instance with modified fields.
  /// Example: `instanceOfContactResponse.copyWith(...)` or `instanceOfContactResponse.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$ContactResponseCWProxy get copyWith => _$ContactResponseCWProxyImpl(this);
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ContactResponse _$ContactResponseFromJson(Map<String, dynamic> json) =>
    $checkedCreate('ContactResponse', json, ($checkedConvert) {
      $checkKeys(json, requiredKeys: const ['data']);
      final val = ContactResponse(
        data: $checkedConvert(
          'data',
          (v) => Contact.fromJson(v as Map<String, dynamic>),
        ),
      );
      return val;
    });

Map<String, dynamic> _$ContactResponseToJson(ContactResponse instance) =>
    <String, dynamic>{'data': instance.data.toJson()};
