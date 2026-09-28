//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:ngotools_api/src/generated/model/event_person.dart';
import 'package:ngotools_api/src/generated/model/event_service_reference.dart';
import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:json_annotation/json_annotation.dart';

part 'event_team_slot.g.dart';

@CopyWith()
@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class EventTeamSlot {
  /// Returns a new [EventTeamSlot] instance.
  EventTeamSlot({
    required this.service,

    required this.required_,

    required this.open,

    required this.members,
  });

  @JsonKey(name: r'service', required: true, includeIfNull: false)
  final EventServiceReference service;

  // minimum: 0
  @JsonKey(name: r'required', required: true, includeIfNull: false)
  final int required_;

  // minimum: 0
  @JsonKey(name: r'open', required: true, includeIfNull: false)
  final int open;

  @JsonKey(name: r'members', required: true, includeIfNull: false)
  final List<EventPerson> members;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is EventTeamSlot &&
          other.service == service &&
          other.required_ == required_ &&
          other.open == open &&
          other.members == members;

  @override
  int get hashCode =>
      service.hashCode + required_.hashCode + open.hashCode + members.hashCode;

  factory EventTeamSlot.fromJson(Map<String, dynamic> json) =>
      _$EventTeamSlotFromJson(json);

  Map<String, dynamic> toJson() => _$EventTeamSlotToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }
}
