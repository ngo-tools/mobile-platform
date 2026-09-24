// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'contact.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$ContactCWProxy {
  Contact id(int id);

  Contact type(String type);

  Contact name(String? name);

  Contact firstName(String? firstName);

  Contact lastName(String? lastName);

  Contact email(String? email);

  Contact salutation(String? salutation);

  Contact title(String? title);

  Contact gender(String? gender);

  Contact birthday(DateTime? birthday);

  Contact activeAddressId(int? activeAddressId);

  Contact updatedAt(DateTime? updatedAt);

  Contact addresses(List<ContactAddress>? addresses);

  /// Creates a new instance with the provided field values.
  /// Passing `null` to a nullable field nullifies it, while `null` for a non-nullable field is ignored. To update a single field use `Contact(...).copyWith.fieldName(value)`.
  ///
  /// Example:
  /// ```dart
  /// Contact(...).copyWith(id: 12, name: "My name")
  /// ```
  Contact call({
    int id,
    String type,
    String? name,
    String? firstName,
    String? lastName,
    String? email,
    String? salutation,
    String? title,
    String? gender,
    DateTime? birthday,
    int? activeAddressId,
    DateTime? updatedAt,
    List<ContactAddress>? addresses,
  });
}

/// Callable proxy for `copyWith` functionality.
/// Use as `instanceOfContact.copyWith(...)` or call `instanceOfContact.copyWith.fieldName(value)` for a single field.
class _$ContactCWProxyImpl implements _$ContactCWProxy {
  const _$ContactCWProxyImpl(this._value);

  final Contact _value;

  @override
  Contact id(int id) => call(id: id);

  @override
  Contact type(String type) => call(type: type);

  @override
  Contact name(String? name) => call(name: name);

  @override
  Contact firstName(String? firstName) => call(firstName: firstName);

  @override
  Contact lastName(String? lastName) => call(lastName: lastName);

  @override
  Contact email(String? email) => call(email: email);

  @override
  Contact salutation(String? salutation) => call(salutation: salutation);

  @override
  Contact title(String? title) => call(title: title);

  @override
  Contact gender(String? gender) => call(gender: gender);

  @override
  Contact birthday(DateTime? birthday) => call(birthday: birthday);

  @override
  Contact activeAddressId(int? activeAddressId) =>
      call(activeAddressId: activeAddressId);

  @override
  Contact updatedAt(DateTime? updatedAt) => call(updatedAt: updatedAt);

  @override
  Contact addresses(List<ContactAddress>? addresses) =>
      call(addresses: addresses);

  /// Creates a new instance with the provided field values.
  /// Passing `null` to a nullable field nullifies it, while `null` for a non-nullable field is ignored. To update a single field use `Contact(...).copyWith.fieldName(value)`.
  ///
  /// Example:
  /// ```dart
  /// Contact(...).copyWith(id: 12, name: "My name")
  /// ```
  @override
  Contact call({
    Object? id = const $CopyWithPlaceholder(),
    Object? type = const $CopyWithPlaceholder(),
    Object? name = const $CopyWithPlaceholder(),
    Object? firstName = const $CopyWithPlaceholder(),
    Object? lastName = const $CopyWithPlaceholder(),
    Object? email = const $CopyWithPlaceholder(),
    Object? salutation = const $CopyWithPlaceholder(),
    Object? title = const $CopyWithPlaceholder(),
    Object? gender = const $CopyWithPlaceholder(),
    Object? birthday = const $CopyWithPlaceholder(),
    Object? activeAddressId = const $CopyWithPlaceholder(),
    Object? updatedAt = const $CopyWithPlaceholder(),
    Object? addresses = const $CopyWithPlaceholder(),
  }) {
    return Contact(
      id: id == const $CopyWithPlaceholder() || id == null
          ? _value.id
          // ignore: cast_nullable_to_non_nullable
          : id as int,
      type: type == const $CopyWithPlaceholder() || type == null
          ? _value.type
          // ignore: cast_nullable_to_non_nullable
          : type as String,
      name: name == const $CopyWithPlaceholder()
          ? _value.name
          // ignore: cast_nullable_to_non_nullable
          : name as String?,
      firstName: firstName == const $CopyWithPlaceholder()
          ? _value.firstName
          // ignore: cast_nullable_to_non_nullable
          : firstName as String?,
      lastName: lastName == const $CopyWithPlaceholder()
          ? _value.lastName
          // ignore: cast_nullable_to_non_nullable
          : lastName as String?,
      email: email == const $CopyWithPlaceholder()
          ? _value.email
          // ignore: cast_nullable_to_non_nullable
          : email as String?,
      salutation: salutation == const $CopyWithPlaceholder()
          ? _value.salutation
          // ignore: cast_nullable_to_non_nullable
          : salutation as String?,
      title: title == const $CopyWithPlaceholder()
          ? _value.title
          // ignore: cast_nullable_to_non_nullable
          : title as String?,
      gender: gender == const $CopyWithPlaceholder()
          ? _value.gender
          // ignore: cast_nullable_to_non_nullable
          : gender as String?,
      birthday: birthday == const $CopyWithPlaceholder()
          ? _value.birthday
          // ignore: cast_nullable_to_non_nullable
          : birthday as DateTime?,
      activeAddressId: activeAddressId == const $CopyWithPlaceholder()
          ? _value.activeAddressId
          // ignore: cast_nullable_to_non_nullable
          : activeAddressId as int?,
      updatedAt: updatedAt == const $CopyWithPlaceholder()
          ? _value.updatedAt
          // ignore: cast_nullable_to_non_nullable
          : updatedAt as DateTime?,
      addresses: addresses == const $CopyWithPlaceholder()
          ? _value.addresses
          // ignore: cast_nullable_to_non_nullable
          : addresses as List<ContactAddress>?,
    );
  }
}

extension $ContactCopyWith on Contact {
  /// Returns a callable class used to build a new instance with modified fields.
  /// Example: `instanceOfContact.copyWith(...)` or `instanceOfContact.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$ContactCWProxy get copyWith => _$ContactCWProxyImpl(this);
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Contact _$ContactFromJson(Map<String, dynamic> json) => $checkedCreate(
  'Contact',
  json,
  ($checkedConvert) {
    $checkKeys(json, requiredKeys: const ['id', 'type']);
    final val = Contact(
      id: $checkedConvert('id', (v) => (v as num).toInt()),
      type: $checkedConvert('type', (v) => v as String),
      name: $checkedConvert('name', (v) => v as String?),
      firstName: $checkedConvert('first_name', (v) => v as String?),
      lastName: $checkedConvert('last_name', (v) => v as String?),
      email: $checkedConvert('email', (v) => v as String?),
      salutation: $checkedConvert('salutation', (v) => v as String?),
      title: $checkedConvert('title', (v) => v as String?),
      gender: $checkedConvert('gender', (v) => v as String?),
      birthday: $checkedConvert(
        'birthday',
        (v) => v == null ? null : DateTime.parse(v as String),
      ),
      activeAddressId: $checkedConvert(
        'active_address_id',
        (v) => (v as num?)?.toInt(),
      ),
      updatedAt: $checkedConvert(
        'updated_at',
        (v) => v == null ? null : DateTime.parse(v as String),
      ),
      addresses: $checkedConvert(
        'addresses',
        (v) => (v as List<dynamic>?)
            ?.map((e) => ContactAddress.fromJson(e as Map<String, dynamic>))
            .toList(),
      ),
    );
    return val;
  },
  fieldKeyMap: const {
    'firstName': 'first_name',
    'lastName': 'last_name',
    'activeAddressId': 'active_address_id',
    'updatedAt': 'updated_at',
  },
);

Map<String, dynamic> _$ContactToJson(Contact instance) => <String, dynamic>{
  'id': instance.id,
  'type': instance.type,
  'name': ?instance.name,
  'first_name': ?instance.firstName,
  'last_name': ?instance.lastName,
  'email': ?instance.email,
  'salutation': ?instance.salutation,
  'title': ?instance.title,
  'gender': ?instance.gender,
  'birthday': ?instance.birthday?.toIso8601String(),
  'active_address_id': ?instance.activeAddressId,
  'updated_at': ?instance.updatedAt?.toIso8601String(),
  'addresses': ?instance.addresses?.map((e) => e.toJson()).toList(),
};
