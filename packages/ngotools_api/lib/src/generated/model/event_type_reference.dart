//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:json_annotation/json_annotation.dart';

part 'event_type_reference.g.dart';

@CopyWith()
@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class EventTypeReference {
  /// Returns a new [EventTypeReference] instance.
  EventTypeReference({required this.id, required this.name});

  @JsonKey(name: r'id', required: true, includeIfNull: false)
  final int id;

  @JsonKey(name: r'name', required: true, includeIfNull: false)
  final String name;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is EventTypeReference && other.id == id && other.name == name;

  @override
  int get hashCode => id.hashCode + name.hashCode;

  factory EventTypeReference.fromJson(Map<String, dynamic> json) =>
      _$EventTypeReferenceFromJson(json);

  Map<String, dynamic> toJson() => _$EventTypeReferenceToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }
}
