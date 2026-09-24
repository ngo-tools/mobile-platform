// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'update_contact_request.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$UpdateContactRequestCWProxy {
  UpdateContactRequest baseVersion(String baseVersion);

  UpdateContactRequest name(String? name);

  UpdateContactRequest firstName(String? firstName);

  UpdateContactRequest lastName(String? lastName);

  UpdateContactRequest email(String? email);

  UpdateContactRequest salutation(String? salutation);

  UpdateContactRequest title(String? title);

  UpdateContactRequest gender(String? gender);

  UpdateContactRequest birthday(String? birthday);

  /// Creates a new instance with the provided field values.
  /// Passing `null` to a nullable field nullifies it, while `null` for a non-nullable field is ignored. To update a single field use `UpdateContactRequest(...).copyWith.fieldName(value)`.
  ///
  /// Example:
  /// ```dart
  /// UpdateContactRequest(...).copyWith(id: 12, name: "My name")
  /// ```
  UpdateContactRequest call({
    String baseVersion,
    String? name,
    String? firstName,
    String? lastName,
    String? email,
    String? salutation,
    String? title,
    String? gender,
    String? birthday,
  });
}

/// Callable proxy for `copyWith` functionality.
/// Use as `instanceOfUpdateContactRequest.copyWith(...)` or call `instanceOfUpdateContactRequest.copyWith.fieldName(value)` for a single field.
class _$UpdateContactRequestCWProxyImpl
    implements _$UpdateContactRequestCWProxy {
  const _$UpdateContactRequestCWProxyImpl(this._value);

  final UpdateContactRequest _value;

  @override
  UpdateContactRequest baseVersion(String baseVersion) =>
      call(baseVersion: baseVersion);

  @override
  UpdateContactRequest name(String? name) => call(name: name);

  @override
  UpdateContactRequest firstName(String? firstName) =>
      call(firstName: firstName);

  @override
  UpdateContactRequest lastName(String? lastName) => call(lastName: lastName);

  @override
  UpdateContactRequest email(String? email) => call(email: email);

  @override
  UpdateContactRequest salutation(String? salutation) =>
      call(salutation: salutation);

  @override
  UpdateContactRequest title(String? title) => call(title: title);

  @override
  UpdateContactRequest gender(String? gender) => call(gender: gender);

  @override
  UpdateContactRequest birthday(String? birthday) => call(birthday: birthday);

  /// Creates a new instance with the provided field values.
  /// Passing `null` to a nullable field nullifies it, while `null` for a non-nullable field is ignored. To update a single field use `UpdateContactRequest(...).copyWith.fieldName(value)`.
  ///
  /// Example:
  /// ```dart
  /// UpdateContactRequest(...).copyWith(id: 12, name: "My name")
  /// ```
  @override
  UpdateContactRequest call({
    Object? baseVersion = const $CopyWithPlaceholder(),
    Object? name = const $CopyWithPlaceholder(),
    Object? firstName = const $CopyWithPlaceholder(),
    Object? lastName = const $CopyWithPlaceholder(),
    Object? email = const $CopyWithPlaceholder(),
    Object? salutation = const $CopyWithPlaceholder(),
    Object? title = const $CopyWithPlaceholder(),
    Object? gender = const $CopyWithPlaceholder(),
    Object? birthday = const $CopyWithPlaceholder(),
  }) {
    return UpdateContactRequest(
      baseVersion:
          baseVersion == const $CopyWithPlaceholder() || baseVersion == null
          ? _value.baseVersion
          // ignore: cast_nullable_to_non_nullable
          : baseVersion as String,
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
          : birthday as String?,
    );
  }
}

extension $UpdateContactRequestCopyWith on UpdateContactRequest {
  /// Returns a callable class used to build a new instance with modified fields.
  /// Example: `instanceOfUpdateContactRequest.copyWith(...)` or `instanceOfUpdateContactRequest.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$UpdateContactRequestCWProxy get copyWith =>
      _$UpdateContactRequestCWProxyImpl(this);
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UpdateContactRequest _$UpdateContactRequestFromJson(
  Map<String, dynamic> json,
) => $checkedCreate(
  'UpdateContactRequest',
  json,
  ($checkedConvert) {
    $checkKeys(
      json,
      requiredKeys: const [
        'base_version',
        'name',
        'first_name',
        'last_name',
        'email',
        'salutation',
        'title',
        'gender',
        'birthday',
      ],
    );
    final val = UpdateContactRequest(
      baseVersion: $checkedConvert('base_version', (v) => v as String),
      name: $checkedConvert('name', (v) => v as String?),
      firstName: $checkedConvert('first_name', (v) => v as String?),
      lastName: $checkedConvert('last_name', (v) => v as String?),
      email: $checkedConvert('email', (v) => v as String?),
      salutation: $checkedConvert('salutation', (v) => v as String?),
      title: $checkedConvert('title', (v) => v as String?),
      gender: $checkedConvert('gender', (v) => v as String?),
      birthday: $checkedConvert('birthday', (v) => v as String?),
    );
    return val;
  },
  fieldKeyMap: const {
    'baseVersion': 'base_version',
    'firstName': 'first_name',
    'lastName': 'last_name',
  },
);

Map<String, dynamic> _$UpdateContactRequestToJson(
  UpdateContactRequest instance,
) => <String, dynamic>{
  'base_version': instance.baseVersion,
  'name': instance.name,
  'first_name': instance.firstName,
  'last_name': instance.lastName,
  'email': instance.email,
  'salutation': instance.salutation,
  'title': instance.title,
  'gender': instance.gender,
  'birthday': instance.birthday,
};
