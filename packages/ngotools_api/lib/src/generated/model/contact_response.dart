//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:ngotools_api/src/generated/model/contact.dart';
import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:json_annotation/json_annotation.dart';

part 'contact_response.g.dart';

@CopyWith()
@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class ContactResponse {
  /// Returns a new [ContactResponse] instance.
  ContactResponse({required this.data});

  @JsonKey(name: r'data', required: true, includeIfNull: false)
  final Contact data;

  @override
  bool operator ==(Object other) =>
      identical(this, other) || other is ContactResponse && other.data == data;

  @override
  int get hashCode => data.hashCode;

  factory ContactResponse.fromJson(Map<String, dynamic> json) =>
      _$ContactResponseFromJson(json);

  Map<String, dynamic> toJson() => _$ContactResponseToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }
}
