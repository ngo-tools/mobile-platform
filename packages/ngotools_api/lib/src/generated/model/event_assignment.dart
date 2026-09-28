//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:ngotools_api/src/generated/model/event_reference.dart';
import 'package:ngotools_api/src/generated/model/event_service_reference.dart';
import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:json_annotation/json_annotation.dart';

part 'event_assignment.g.dart';

@CopyWith()
@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class EventAssignment {
  /// Returns a new [EventAssignment] instance.
  EventAssignment({
    required this.id,

    required this.event,

    required this.service,
  });

  @JsonKey(name: r'id', required: true, includeIfNull: false)
  final int id;

  @JsonKey(name: r'event', required: true, includeIfNull: false)
  final EventReference event;

  @JsonKey(name: r'service', required: true, includeIfNull: false)
  final EventServiceReference service;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is EventAssignment &&
          other.id == id &&
          other.event == event &&
          other.service == service;

  @override
  int get hashCode => id.hashCode + event.hashCode + service.hashCode;

  factory EventAssignment.fromJson(Map<String, dynamic> json) =>
      _$EventAssignmentFromJson(json);

  Map<String, dynamic> toJson() => _$EventAssignmentToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }
}
