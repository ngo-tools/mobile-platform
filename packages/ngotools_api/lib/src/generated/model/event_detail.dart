//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:ngotools_api/src/generated/model/event_agenda.dart';
import 'package:ngotools_api/src/generated/model/event_type_reference.dart';
import 'package:ngotools_api/src/generated/model/event_service_reference.dart';
import 'package:ngotools_api/src/generated/model/event_team_slot.dart';
import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:json_annotation/json_annotation.dart';

part 'event_detail.g.dart';

@CopyWith()
@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class EventDetail {
  /// Returns a new [EventDetail] instance.
  EventDetail({
    required this.id,

    required this.name,

    this.type,

    required this.start,

    required this.end,

    required this.allDay,

    required this.planningCompleted,

    required this.myServices,

    required this.availabilityOpen,

    this.details,

    this.agenda,

    required this.team,
  });

  @JsonKey(name: r'id', required: true, includeIfNull: false)
  final int id;

  @JsonKey(name: r'name', required: true, includeIfNull: false)
  final String name;

  @JsonKey(name: r'type', required: false, includeIfNull: false)
  final EventTypeReference? type;

  @JsonKey(name: r'start', required: true, includeIfNull: false)
  final DateTime start;

  @JsonKey(name: r'end', required: true, includeIfNull: false)
  final DateTime end;

  @JsonKey(name: r'all_day', required: true, includeIfNull: false)
  final bool allDay;

  @JsonKey(name: r'planning_completed', required: true, includeIfNull: false)
  final bool planningCompleted;

  @JsonKey(name: r'my_services', required: true, includeIfNull: false)
  final List<EventServiceReference> myServices;

  @JsonKey(name: r'availability_open', required: true, includeIfNull: false)
  final bool availabilityOpen;

  @JsonKey(name: r'details', required: false, includeIfNull: false)
  final String? details;

  @JsonKey(name: r'agenda', required: false, includeIfNull: false)
  final EventAgenda? agenda;

  @JsonKey(name: r'team', required: true, includeIfNull: false)
  final List<EventTeamSlot> team;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is EventDetail &&
          other.id == id &&
          other.name == name &&
          other.type == type &&
          other.start == start &&
          other.end == end &&
          other.allDay == allDay &&
          other.planningCompleted == planningCompleted &&
          other.myServices == myServices &&
          other.availabilityOpen == availabilityOpen &&
          other.details == details &&
          other.agenda == agenda &&
          other.team == team;

  @override
  int get hashCode =>
      id.hashCode +
      name.hashCode +
      type.hashCode +
      start.hashCode +
      end.hashCode +
      allDay.hashCode +
      planningCompleted.hashCode +
      myServices.hashCode +
      availabilityOpen.hashCode +
      (details == null ? 0 : details.hashCode) +
      agenda.hashCode +
      team.hashCode;

  factory EventDetail.fromJson(Map<String, dynamic> json) =>
      _$EventDetailFromJson(json);

  Map<String, dynamic> toJson() => _$EventDetailToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }
}
