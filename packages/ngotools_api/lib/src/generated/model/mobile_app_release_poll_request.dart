//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:json_annotation/json_annotation.dart';

part 'mobile_app_release_poll_request.g.dart';

@CopyWith()
@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class MobileAppReleasePollRequest {
  /// Returns a new [MobileAppReleasePollRequest] instance.
  MobileAppReleasePollRequest({required this.pollToken});

  @JsonKey(name: r'poll_token', required: true, includeIfNull: false)
  final String pollToken;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is MobileAppReleasePollRequest && other.pollToken == pollToken;

  @override
  int get hashCode => pollToken.hashCode;

  factory MobileAppReleasePollRequest.fromJson(Map<String, dynamic> json) =>
      _$MobileAppReleasePollRequestFromJson(json);

  Map<String, dynamic> toJson() => _$MobileAppReleasePollRequestToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }
}
