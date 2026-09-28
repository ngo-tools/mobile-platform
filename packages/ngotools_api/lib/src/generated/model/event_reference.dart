//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:json_annotation/json_annotation.dart';

part 'event_reference.g.dart';

@CopyWith()
@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class EventReference {
  /// Returns a new [EventReference] instance.
  EventReference({
    required this.id,

    required this.name,

    required this.start,

    required this.end,

    required this.allDay,
  });

  @JsonKey(name: r'id', required: true, includeIfNull: false)
  final int id;

  @JsonKey(name: r'name', required: true, includeIfNull: false)
  final String name;

  @JsonKey(name: r'start', required: true, includeIfNull: false)
  final DateTime start;

  @JsonKey(name: r'end', required: true, includeIfNull: false)
  final DateTime end;

  @JsonKey(name: r'all_day', required: true, includeIfNull: false)
  final bool allDay;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is EventReference &&
          other.id == id &&
          other.name == name &&
          other.start == start &&
          other.end == end &&
          other.allDay == allDay;

  @override
  int get hashCode =>
      id.hashCode +
      name.hashCode +
      start.hashCode +
      end.hashCode +
      allDay.hashCode;

  factory EventReference.fromJson(Map<String, dynamic> json) =>
      _$EventReferenceFromJson(json);

  Map<String, dynamic> toJson() => _$EventReferenceToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }
}
