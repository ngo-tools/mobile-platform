//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:ngotools_api/src/generated/model/mobile_app_release_approval.dart';
import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:json_annotation/json_annotation.dart';

part 'mobile_app_release_start_response.g.dart';

@CopyWith()
@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class MobileAppReleaseStartResponse {
  /// Returns a new [MobileAppReleaseStartResponse] instance.
  MobileAppReleaseStartResponse({required this.data});

  @JsonKey(name: r'data', required: true, includeIfNull: false)
  final MobileAppReleaseApproval data;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is MobileAppReleaseStartResponse && other.data == data;

  @override
  int get hashCode => data.hashCode;

  factory MobileAppReleaseStartResponse.fromJson(Map<String, dynamic> json) =>
      _$MobileAppReleaseStartResponseFromJson(json);

  Map<String, dynamic> toJson() => _$MobileAppReleaseStartResponseToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }
}
