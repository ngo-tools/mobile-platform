// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'contact_address.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$ContactAddressCWProxy {
  ContactAddress id(int id);

  ContactAddress type(String? type);

  ContactAddress line1(String? line1);

  ContactAddress line2(String? line2);

  ContactAddress postalCode(String? postalCode);

  ContactAddress city(String? city);

  ContactAddress state(String? state);

  ContactAddress country(String? country);

  /// Creates a new instance with the provided field values.
  /// Passing `null` to a nullable field nullifies it, while `null` for a non-nullable field is ignored. To update a single field use `ContactAddress(...).copyWith.fieldName(value)`.
  ///
  /// Example:
  /// ```dart
  /// ContactAddress(...).copyWith(id: 12, name: "My name")
  /// ```
  ContactAddress call({
    int id,
    String? type,
    String? line1,
    String? line2,
    String? postalCode,
    String? city,
    String? state,
    String? country,
  });
}

/// Callable proxy for `copyWith` functionality.
/// Use as `instanceOfContactAddress.copyWith(...)` or call `instanceOfContactAddress.copyWith.fieldName(value)` for a single field.
class _$ContactAddressCWProxyImpl implements _$ContactAddressCWProxy {
  const _$ContactAddressCWProxyImpl(this._value);

  final ContactAddress _value;

  @override
  ContactAddress id(int id) => call(id: id);

  @override
  ContactAddress type(String? type) => call(type: type);

  @override
  ContactAddress line1(String? line1) => call(line1: line1);

  @override
  ContactAddress line2(String? line2) => call(line2: line2);

  @override
  ContactAddress postalCode(String? postalCode) => call(postalCode: postalCode);

  @override
  ContactAddress city(String? city) => call(city: city);

  @override
  ContactAddress state(String? state) => call(state: state);

  @override
  ContactAddress country(String? country) => call(country: country);

  /// Creates a new instance with the provided field values.
  /// Passing `null` to a nullable field nullifies it, while `null` for a non-nullable field is ignored. To update a single field use `ContactAddress(...).copyWith.fieldName(value)`.
  ///
  /// Example:
  /// ```dart
  /// ContactAddress(...).copyWith(id: 12, name: "My name")
  /// ```
  @override
  ContactAddress call({
    Object? id = const $CopyWithPlaceholder(),
    Object? type = const $CopyWithPlaceholder(),
    Object? line1 = const $CopyWithPlaceholder(),
    Object? line2 = const $CopyWithPlaceholder(),
    Object? postalCode = const $CopyWithPlaceholder(),
    Object? city = const $CopyWithPlaceholder(),
    Object? state = const $CopyWithPlaceholder(),
    Object? country = const $CopyWithPlaceholder(),
  }) {
    return ContactAddress(
      id: id == const $CopyWithPlaceholder() || id == null
          ? _value.id
          // ignore: cast_nullable_to_non_nullable
          : id as int,
      type: type == const $CopyWithPlaceholder()
          ? _value.type
          // ignore: cast_nullable_to_non_nullable
          : type as String?,
      line1: line1 == const $CopyWithPlaceholder()
          ? _value.line1
          // ignore: cast_nullable_to_non_nullable
          : line1 as String?,
      line2: line2 == const $CopyWithPlaceholder()
          ? _value.line2
          // ignore: cast_nullable_to_non_nullable
          : line2 as String?,
      postalCode: postalCode == const $CopyWithPlaceholder()
          ? _value.postalCode
          // ignore: cast_nullable_to_non_nullable
          : postalCode as String?,
      city: city == const $CopyWithPlaceholder()
          ? _value.city
          // ignore: cast_nullable_to_non_nullable
          : city as String?,
      state: state == const $CopyWithPlaceholder()
          ? _value.state
          // ignore: cast_nullable_to_non_nullable
          : state as String?,
      country: country == const $CopyWithPlaceholder()
          ? _value.country
          // ignore: cast_nullable_to_non_nullable
          : country as String?,
    );
  }
}

extension $ContactAddressCopyWith on ContactAddress {
  /// Returns a callable class used to build a new instance with modified fields.
  /// Example: `instanceOfContactAddress.copyWith(...)` or `instanceOfContactAddress.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$ContactAddressCWProxy get copyWith => _$ContactAddressCWProxyImpl(this);
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ContactAddress _$ContactAddressFromJson(Map<String, dynamic> json) =>
    $checkedCreate('ContactAddress', json, ($checkedConvert) {
      $checkKeys(json, requiredKeys: const ['id']);
      final val = ContactAddress(
        id: $checkedConvert('id', (v) => (v as num).toInt()),
        type: $checkedConvert('type', (v) => v as String?),
        line1: $checkedConvert('line1', (v) => v as String?),
        line2: $checkedConvert('line2', (v) => v as String?),
        postalCode: $checkedConvert('postal_code', (v) => v as String?),
        city: $checkedConvert('city', (v) => v as String?),
        state: $checkedConvert('state', (v) => v as String?),
        country: $checkedConvert('country', (v) => v as String?),
      );
      return val;
    }, fieldKeyMap: const {'postalCode': 'postal_code'});

Map<String, dynamic> _$ContactAddressToJson(ContactAddress instance) =>
    <String, dynamic>{
      'id': instance.id,
      'type': ?instance.type,
      'line1': ?instance.line1,
      'line2': ?instance.line2,
      'postal_code': ?instance.postalCode,
      'city': ?instance.city,
      'state': ?instance.state,
      'country': ?instance.country,
    };
