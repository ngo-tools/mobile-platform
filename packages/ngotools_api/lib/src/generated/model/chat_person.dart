//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:json_annotation/json_annotation.dart';

part 'chat_person.g.dart';

@CopyWith()
@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class ChatPerson {
  /// Returns a new [ChatPerson] instance.
  ChatPerson({
    required this.matrixUserId,

    required this.displayName,

    required this.kind,
  });

  @JsonKey(name: r'matrix_user_id', required: true, includeIfNull: false)
  final String matrixUserId;

  @JsonKey(name: r'display_name', required: true, includeIfNull: false)
  final String displayName;

  @JsonKey(
    name: r'kind',
    required: true,
    includeIfNull: false,
    unknownEnumValue: ChatPersonKindEnum.unknownDefaultOpenApi,
  )
  final ChatPersonKindEnum kind;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ChatPerson &&
          other.matrixUserId == matrixUserId &&
          other.displayName == displayName &&
          other.kind == kind;

  @override
  int get hashCode =>
      matrixUserId.hashCode + displayName.hashCode + kind.hashCode;

  factory ChatPerson.fromJson(Map<String, dynamic> json) =>
      _$ChatPersonFromJson(json);

  Map<String, dynamic> toJson() => _$ChatPersonToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }
}

enum ChatPersonKindEnum {
  @JsonValue(r'team_member')
  teamMember(r'team_member'),
  @JsonValue(r'contact')
  contact(r'contact'),
  @JsonValue(r'unknown_default_open_api')
  unknownDefaultOpenApi(r'unknown_default_open_api');

  const ChatPersonKindEnum(this.value);

  final String value;

  @override
  String toString() => value;
}
