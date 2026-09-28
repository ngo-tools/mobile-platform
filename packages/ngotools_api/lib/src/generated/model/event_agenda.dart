//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:ngotools_api/src/generated/model/event_agenda_entry.dart';
import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:json_annotation/json_annotation.dart';

part 'event_agenda.g.dart';

@CopyWith()
@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class EventAgenda {
  /// Returns a new [EventAgenda] instance.
  EventAgenda({required this.completed, required this.items});

  @JsonKey(name: r'completed', required: true, includeIfNull: false)
  final bool completed;

  @JsonKey(name: r'items', required: true, includeIfNull: false)
  final List<EventAgendaEntry> items;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is EventAgenda &&
          other.completed == completed &&
          other.items == items;

  @override
  int get hashCode => completed.hashCode + items.hashCode;

  factory EventAgenda.fromJson(Map<String, dynamic> json) =>
      _$EventAgendaFromJson(json);

  Map<String, dynamic> toJson() => _$EventAgendaToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }
}
