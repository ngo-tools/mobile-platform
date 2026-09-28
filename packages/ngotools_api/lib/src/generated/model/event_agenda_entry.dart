//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:ngotools_api/src/generated/model/event_person.dart';
import 'package:ngotools_api/src/generated/model/event_agenda_sub_item.dart';
import 'package:ngotools_api/src/generated/model/event_service_reference.dart';
import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:json_annotation/json_annotation.dart';

part 'event_agenda_entry.g.dart';

@CopyWith()
@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class EventAgendaEntry {
  /// Returns a new [EventAgendaEntry] instance.
  EventAgendaEntry({
    required this.id,

    required this.type,

    this.name,

    this.key,

    this.language,

    required this.items,

    required this.startsAt,

    this.durationMinutes,

    this.responsibleService,

    required this.responsible,

    required this.isMine,
  });

  @JsonKey(name: r'id', required: true, includeIfNull: false)
  final int id;

  @JsonKey(name: r'type', required: true, includeIfNull: false)
  final String type;

  @JsonKey(name: r'name', required: false, includeIfNull: false)
  final String? name;

  @JsonKey(name: r'key', required: false, includeIfNull: false)
  final String? key;

  @JsonKey(name: r'language', required: false, includeIfNull: false)
  final String? language;

  @JsonKey(name: r'items', required: true, includeIfNull: false)
  final List<EventAgendaSubItem> items;

  @JsonKey(name: r'starts_at', required: true, includeIfNull: false)
  final DateTime startsAt;

  @JsonKey(name: r'duration_minutes', required: false, includeIfNull: false)
  final int? durationMinutes;

  @JsonKey(name: r'responsible_service', required: false, includeIfNull: false)
  final EventServiceReference? responsibleService;

  @JsonKey(name: r'responsible', required: true, includeIfNull: false)
  final List<EventPerson> responsible;

  @JsonKey(name: r'is_mine', required: true, includeIfNull: false)
  final bool isMine;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is EventAgendaEntry &&
          other.id == id &&
          other.type == type &&
          other.name == name &&
          other.key == key &&
          other.language == language &&
          other.items == items &&
          other.startsAt == startsAt &&
          other.durationMinutes == durationMinutes &&
          other.responsibleService == responsibleService &&
          other.responsible == responsible &&
          other.isMine == isMine;

  @override
  int get hashCode =>
      id.hashCode +
      type.hashCode +
      (name == null ? 0 : name.hashCode) +
      (key == null ? 0 : key.hashCode) +
      (language == null ? 0 : language.hashCode) +
      items.hashCode +
      startsAt.hashCode +
      (durationMinutes == null ? 0 : durationMinutes.hashCode) +
      responsibleService.hashCode +
      responsible.hashCode +
      isMine.hashCode;

  factory EventAgendaEntry.fromJson(Map<String, dynamic> json) =>
      _$EventAgendaEntryFromJson(json);

  Map<String, dynamic> toJson() => _$EventAgendaEntryToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }
}
