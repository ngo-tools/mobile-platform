// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'create_contact_request.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$CreateContactRequestCWProxy {
  CreateContactRequest type(CreateContactRequestTypeEnum type);

  CreateContactRequest name(String? name);

  CreateContactRequest firstName(String? firstName);

  CreateContactRequest lastName(String? lastName);

  CreateContactRequest email(String? email);

  CreateContactRequest salutation(String? salutation);

  CreateContactRequest title(String? title);

  CreateContactRequest gender(String? gender);

  CreateContactRequest birthday(String? birthday);

  /// Creates a new instance with the provided field values.
  /// Passing `null` to a nullable field nullifies it, while `null` for a non-nullable field is ignored. To update a single field use `CreateContactRequest(...).copyWith.fieldName(value)`.
  ///
  /// Example:
  /// ```dart
  /// CreateContactRequest(...).copyWith(id: 12, name: "My name")
  /// ```
  CreateContactRequest call({
    CreateContactRequestTypeEnum type,
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
/// Use as `instanceOfCreateContactRequest.copyWith(...)` or call `instanceOfCreateContactRequest.copyWith.fieldName(value)` for a single field.
class _$CreateContactRequestCWProxyImpl
    implements _$CreateContactRequestCWProxy {
  const _$CreateContactRequestCWProxyImpl(this._value);

  final CreateContactRequest _value;

  @override
  CreateContactRequest type(CreateContactRequestTypeEnum type) =>
      call(type: type);

  @override
  CreateContactRequest name(String? name) => call(name: name);

  @override
  CreateContactRequest firstName(String? firstName) =>
      call(firstName: firstName);

  @override
  CreateContactRequest lastName(String? lastName) => call(lastName: lastName);

  @override
  CreateContactRequest email(String? email) => call(email: email);

  @override
  CreateContactRequest salutation(String? salutation) =>
      call(salutation: salutation);

  @override
  CreateContactRequest title(String? title) => call(title: title);

  @override
  CreateContactRequest gender(String? gender) => call(gender: gender);

  @override
  CreateContactRequest birthday(String? birthday) => call(birthday: birthday);

  /// Creates a new instance with the provided field values.
  /// Passing `null` to a nullable field nullifies it, while `null` for a non-nullable field is ignored. To update a single field use `CreateContactRequest(...).copyWith.fieldName(value)`.
  ///
  /// Example:
  /// ```dart
  /// CreateContactRequest(...).copyWith(id: 12, name: "My name")
  /// ```
  @override
  CreateContactRequest call({
    Object? type = const $CopyWithPlaceholder(),
    Object? name = const $CopyWithPlaceholder(),
    Object? firstName = const $CopyWithPlaceholder(),
    Object? lastName = const $CopyWithPlaceholder(),
    Object? email = const $CopyWithPlaceholder(),
    Object? salutation = const $CopyWithPlaceholder(),
    Object? title = const $CopyWithPlaceholder(),
    Object? gender = const $CopyWithPlaceholder(),
    Object? birthday = const $CopyWithPlaceholder(),
  }) {
    return CreateContactRequest(
      type: type == const $CopyWithPlaceholder() || type == null
          ? _value.type
          // ignore: cast_nullable_to_non_nullable
          : type as CreateContactRequestTypeEnum,
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

extension $CreateContactRequestCopyWith on CreateContactRequest {
  /// Returns a callable class used to build a new instance with modified fields.
  /// Example: `instanceOfCreateContactRequest.copyWith(...)` or `instanceOfCreateContactRequest.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$CreateContactRequestCWProxy get copyWith =>
      _$CreateContactRequestCWProxyImpl(this);
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CreateContactRequest _$CreateContactRequestFromJson(
  Map<String, dynamic> json,
) => $checkedCreate(
  'CreateContactRequest',
  json,
  ($checkedConvert) {
    $checkKeys(
      json,
      requiredKeys: const [
        'type',
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
    final val = CreateContactRequest(
      type: $checkedConvert(
        'type',
        (v) => $enumDecode(
          _$CreateContactRequestTypeEnumEnumMap,
          v,
          unknownValue: CreateContactRequestTypeEnum.unknownDefaultOpenApi,
        ),
      ),
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
  fieldKeyMap: const {'firstName': 'first_name', 'lastName': 'last_name'},
);

Map<String, dynamic> _$CreateContactRequestToJson(
  CreateContactRequest instance,
) => <String, dynamic>{
  'type': _$CreateContactRequestTypeEnumEnumMap[instance.type]!,
  'name': instance.name,
  'first_name': instance.firstName,
  'last_name': instance.lastName,
  'email': instance.email,
  'salutation': instance.salutation,
  'title': instance.title,
  'gender': instance.gender,
  'birthday': instance.birthday,
};

const _$CreateContactRequestTypeEnumEnumMap = {
  CreateContactRequestTypeEnum.person: 'person',
  CreateContactRequestTypeEnum.organization: 'organization',
  CreateContactRequestTypeEnum.unknownDefaultOpenApi:
      'unknown_default_open_api',
};
