//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:ngotools_api/src/generated/model/mobile_app_approved_release.dart';
import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:json_annotation/json_annotation.dart';

part 'mobile_app_release_poll_response.g.dart';

@CopyWith()
@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class MobileAppReleasePollResponse {
  /// Returns a new [MobileAppReleasePollResponse] instance.
  MobileAppReleasePollResponse({required this.status, this.code, this.release});

  @JsonKey(
    name: r'status',
    required: true,
    includeIfNull: false,
    unknownEnumValue:
        MobileAppReleasePollResponseStatusEnum.unknownDefaultOpenApi,
  )
  final MobileAppReleasePollResponseStatusEnum status;

  @JsonKey(name: r'code', required: false, includeIfNull: false)
  final String? code;

  @JsonKey(name: r'release', required: false, includeIfNull: false)
  final MobileAppApprovedRelease? release;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is MobileAppReleasePollResponse &&
          other.status == status &&
          other.code == code &&
          other.release == release;

  @override
  int get hashCode =>
      status.hashCode +
      (code == null ? 0 : code.hashCode) +
      (release == null ? 0 : release.hashCode);

  factory MobileAppReleasePollResponse.fromJson(Map<String, dynamic> json) =>
      _$MobileAppReleasePollResponseFromJson(json);

  Map<String, dynamic> toJson() => _$MobileAppReleasePollResponseToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }
}

enum MobileAppReleasePollResponseStatusEnum {
  @JsonValue(r'pending')
  pending(r'pending'),
  @JsonValue(r'approved')
  approved(r'approved'),
  @JsonValue(r'unknown_default_open_api')
  unknownDefaultOpenApi(r'unknown_default_open_api');

  const MobileAppReleasePollResponseStatusEnum(this.value);

  final String value;

  @override
  String toString() => value;
}
