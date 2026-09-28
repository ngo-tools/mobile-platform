//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:json_annotation/json_annotation.dart';

part 'event_agenda_sub_item.g.dart';

@CopyWith()
@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class EventAgendaSubItem {
  /// Returns a new [EventAgendaSubItem] instance.
  EventAgendaSubItem({
    required this.id,

    required this.type,

    this.name,

    this.key,

    this.language,

    required this.items,
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

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is EventAgendaSubItem &&
          other.id == id &&
          other.type == type &&
          other.name == name &&
          other.key == key &&
          other.language == language &&
          other.items == items;

  @override
  int get hashCode =>
      id.hashCode +
      type.hashCode +
      (name == null ? 0 : name.hashCode) +
      (key == null ? 0 : key.hashCode) +
      (language == null ? 0 : language.hashCode) +
      items.hashCode;

  factory EventAgendaSubItem.fromJson(Map<String, dynamic> json) =>
      _$EventAgendaSubItemFromJson(json);

  Map<String, dynamic> toJson() => _$EventAgendaSubItemToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }
}
