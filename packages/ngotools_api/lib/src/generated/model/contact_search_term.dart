//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:json_annotation/json_annotation.dart';

part 'contact_search_term.g.dart';

@CopyWith()
@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class ContactSearchTerm {
  /// Returns a new [ContactSearchTerm] instance.
  ContactSearchTerm({required this.value, this.caseSensitive = false});

  @JsonKey(name: r'value', required: true, includeIfNull: false)
  final String value;

  @JsonKey(
    defaultValue: false,
    name: r'case_sensitive',
    required: false,
    includeIfNull: false,
  )
  final bool? caseSensitive;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ContactSearchTerm &&
          other.value == value &&
          other.caseSensitive == caseSensitive;

  @override
  int get hashCode => value.hashCode + caseSensitive.hashCode;

  factory ContactSearchTerm.fromJson(Map<String, dynamic> json) =>
      _$ContactSearchTermFromJson(json);

  Map<String, dynamic> toJson() => _$ContactSearchTermToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }
}
