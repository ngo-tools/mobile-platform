//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:json_annotation/json_annotation.dart';

part 'contact_sort.g.dart';

@CopyWith()
@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class ContactSort {
  /// Returns a new [ContactSort] instance.
  ContactSort({required this.field, required this.direction});

  @JsonKey(
    name: r'field',
    required: true,
    includeIfNull: false,
    unknownEnumValue: ContactSortFieldEnum.unknownDefaultOpenApi,
  )
  final ContactSortFieldEnum field;

  @JsonKey(
    name: r'direction',
    required: true,
    includeIfNull: false,
    unknownEnumValue: ContactSortDirectionEnum.unknownDefaultOpenApi,
  )
  final ContactSortDirectionEnum direction;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ContactSort &&
          other.field == field &&
          other.direction == direction;

  @override
  int get hashCode => field.hashCode + direction.hashCode;

  factory ContactSort.fromJson(Map<String, dynamic> json) =>
      _$ContactSortFromJson(json);

  Map<String, dynamic> toJson() => _$ContactSortToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }
}

enum ContactSortFieldEnum {
  @JsonValue(r'name')
  name(r'name'),
  @JsonValue(r'first_name')
  firstName(r'first_name'),
  @JsonValue(r'last_name')
  lastName(r'last_name'),
  @JsonValue(r'updated_at')
  updatedAt(r'updated_at'),
  @JsonValue(r'created_at')
  createdAt(r'created_at'),
  @JsonValue(r'id')
  id(r'id'),
  @JsonValue(r'unknown_default_open_api')
  unknownDefaultOpenApi(r'unknown_default_open_api');

  const ContactSortFieldEnum(this.value);

  final String value;

  @override
  String toString() => value;
}

enum ContactSortDirectionEnum {
  @JsonValue(r'asc')
  asc(r'asc'),
  @JsonValue(r'desc')
  desc(r'desc'),
  @JsonValue(r'unknown_default_open_api')
  unknownDefaultOpenApi(r'unknown_default_open_api');

  const ContactSortDirectionEnum(this.value);

  final String value;

  @override
  String toString() => value;
}
