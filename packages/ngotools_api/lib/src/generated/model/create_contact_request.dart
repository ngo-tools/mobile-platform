//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:json_annotation/json_annotation.dart';

part 'create_contact_request.g.dart';

@CopyWith()
@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class CreateContactRequest {
  /// Returns a new [CreateContactRequest] instance.
  CreateContactRequest({
    required this.type,

    required this.name,

    required this.firstName,

    required this.lastName,

    required this.email,

    required this.salutation,

    required this.title,

    required this.gender,

    required this.birthday,
  });

  @JsonKey(
    name: r'type',
    required: true,
    includeIfNull: false,
    unknownEnumValue: CreateContactRequestTypeEnum.unknownDefaultOpenApi,
  )
  final CreateContactRequestTypeEnum type;

  @JsonKey(name: r'name', required: true, includeIfNull: true)
  final String? name;

  @JsonKey(name: r'first_name', required: true, includeIfNull: true)
  final String? firstName;

  @JsonKey(name: r'last_name', required: true, includeIfNull: true)
  final String? lastName;

  @JsonKey(name: r'email', required: true, includeIfNull: true)
  final String? email;

  @JsonKey(name: r'salutation', required: true, includeIfNull: true)
  final String? salutation;

  @JsonKey(name: r'title', required: true, includeIfNull: true)
  final String? title;

  @JsonKey(name: r'gender', required: true, includeIfNull: true)
  final String? gender;

  @JsonKey(name: r'birthday', required: true, includeIfNull: true)
  final String? birthday;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CreateContactRequest &&
          other.type == type &&
          other.name == name &&
          other.firstName == firstName &&
          other.lastName == lastName &&
          other.email == email &&
          other.salutation == salutation &&
          other.title == title &&
          other.gender == gender &&
          other.birthday == birthday;

  @override
  int get hashCode =>
      type.hashCode +
      (name == null ? 0 : name.hashCode) +
      (firstName == null ? 0 : firstName.hashCode) +
      (lastName == null ? 0 : lastName.hashCode) +
      (email == null ? 0 : email.hashCode) +
      (salutation == null ? 0 : salutation.hashCode) +
      (title == null ? 0 : title.hashCode) +
      (gender == null ? 0 : gender.hashCode) +
      (birthday == null ? 0 : birthday.hashCode);

  factory CreateContactRequest.fromJson(Map<String, dynamic> json) =>
      _$CreateContactRequestFromJson(json);

  Map<String, dynamic> toJson() => _$CreateContactRequestToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }
}

enum CreateContactRequestTypeEnum {
  @JsonValue(r'person')
  person(r'person'),
  @JsonValue(r'organization')
  organization(r'organization'),
  @JsonValue(r'unknown_default_open_api')
  unknownDefaultOpenApi(r'unknown_default_open_api');

  const CreateContactRequestTypeEnum(this.value);

  final String value;

  @override
  String toString() => value;
}
