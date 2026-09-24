//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:ngotools_api/src/generated/model/contact_address.dart';
import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:json_annotation/json_annotation.dart';

part 'contact.g.dart';

@CopyWith()
@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class Contact {
  /// Returns a new [Contact] instance.
  Contact({
    required this.id,

    required this.type,

    required this.version,

    this.name,

    this.firstName,

    this.lastName,

    this.email,

    this.salutation,

    this.title,

    this.gender,

    this.birthday,

    this.activeAddressId,

    this.updatedAt,

    this.addresses,
  });

  @JsonKey(name: r'id', required: true, includeIfNull: false)
  final int id;

  @JsonKey(name: r'type', required: true, includeIfNull: false)
  final String type;

  @JsonKey(name: r'version', required: true, includeIfNull: false)
  final String version;

  @JsonKey(name: r'name', required: false, includeIfNull: false)
  final String? name;

  @JsonKey(name: r'first_name', required: false, includeIfNull: false)
  final String? firstName;

  @JsonKey(name: r'last_name', required: false, includeIfNull: false)
  final String? lastName;

  @JsonKey(name: r'email', required: false, includeIfNull: false)
  final String? email;

  @JsonKey(name: r'salutation', required: false, includeIfNull: false)
  final String? salutation;

  @JsonKey(name: r'title', required: false, includeIfNull: false)
  final String? title;

  @JsonKey(name: r'gender', required: false, includeIfNull: false)
  final String? gender;

  @JsonKey(name: r'birthday', required: false, includeIfNull: false)
  final DateTime? birthday;

  @JsonKey(name: r'active_address_id', required: false, includeIfNull: false)
  final int? activeAddressId;

  @JsonKey(name: r'updated_at', required: false, includeIfNull: false)
  final DateTime? updatedAt;

  @JsonKey(name: r'addresses', required: false, includeIfNull: false)
  final List<ContactAddress>? addresses;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Contact &&
          other.id == id &&
          other.type == type &&
          other.version == version &&
          other.name == name &&
          other.firstName == firstName &&
          other.lastName == lastName &&
          other.email == email &&
          other.salutation == salutation &&
          other.title == title &&
          other.gender == gender &&
          other.birthday == birthday &&
          other.activeAddressId == activeAddressId &&
          other.updatedAt == updatedAt &&
          other.addresses == addresses;

  @override
  int get hashCode =>
      id.hashCode +
      type.hashCode +
      version.hashCode +
      (name == null ? 0 : name.hashCode) +
      (firstName == null ? 0 : firstName.hashCode) +
      (lastName == null ? 0 : lastName.hashCode) +
      (email == null ? 0 : email.hashCode) +
      (salutation == null ? 0 : salutation.hashCode) +
      (title == null ? 0 : title.hashCode) +
      (gender == null ? 0 : gender.hashCode) +
      (birthday == null ? 0 : birthday.hashCode) +
      (activeAddressId == null ? 0 : activeAddressId.hashCode) +
      (updatedAt == null ? 0 : updatedAt.hashCode) +
      addresses.hashCode;

  factory Contact.fromJson(Map<String, dynamic> json) =>
      _$ContactFromJson(json);

  Map<String, dynamic> toJson() => _$ContactToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }
}
