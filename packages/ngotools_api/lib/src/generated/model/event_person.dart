//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:json_annotation/json_annotation.dart';

part 'event_person.g.dart';

@CopyWith()
@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class EventPerson {
  /// Returns a new [EventPerson] instance.
  EventPerson({required this.name, required this.isMe});

  @JsonKey(name: r'name', required: true, includeIfNull: false)
  final String name;

  @JsonKey(name: r'is_me', required: true, includeIfNull: false)
  final bool isMe;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is EventPerson && other.name == name && other.isMe == isMe;

  @override
  int get hashCode => name.hashCode + isMe.hashCode;

  factory EventPerson.fromJson(Map<String, dynamic> json) =>
      _$EventPersonFromJson(json);

  Map<String, dynamic> toJson() => _$EventPersonToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }
}
