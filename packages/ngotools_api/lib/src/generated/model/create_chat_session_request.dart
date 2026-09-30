//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:json_annotation/json_annotation.dart';

part 'create_chat_session_request.g.dart';

@CopyWith()
@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class CreateChatSessionRequest {
  /// Returns a new [CreateChatSessionRequest] instance.
  CreateChatSessionRequest({this.deviceName});

  @JsonKey(name: r'device_name', required: false, includeIfNull: false)
  final String? deviceName;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CreateChatSessionRequest && other.deviceName == deviceName;

  @override
  int get hashCode => (deviceName == null ? 0 : deviceName.hashCode);

  factory CreateChatSessionRequest.fromJson(Map<String, dynamic> json) =>
      _$CreateChatSessionRequestFromJson(json);

  Map<String, dynamic> toJson() => _$CreateChatSessionRequestToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }
}
