//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:json_annotation/json_annotation.dart';

part 'mobile_app_approved_release.g.dart';

@CopyWith()
@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class MobileAppApprovedRelease {
  /// Returns a new [MobileAppApprovedRelease] instance.
  MobileAppApprovedRelease({
    required this.id,

    required this.appId,

    required this.platform,

    required this.channel,

    required this.version,

    required this.buildNumber,

    required this.status,

    required this.managementUrl,
  });

  @JsonKey(name: r'id', required: true, includeIfNull: false)
  final String id;

  @JsonKey(name: r'app_id', required: true, includeIfNull: false)
  final String appId;

  @JsonKey(
    name: r'platform',
    required: true,
    includeIfNull: false,
    unknownEnumValue:
        MobileAppApprovedReleasePlatformEnum.unknownDefaultOpenApi,
  )
  final MobileAppApprovedReleasePlatformEnum platform;

  @JsonKey(
    name: r'channel',
    required: true,
    includeIfNull: false,
    unknownEnumValue: MobileAppApprovedReleaseChannelEnum.unknownDefaultOpenApi,
  )
  final MobileAppApprovedReleaseChannelEnum channel;

  @JsonKey(name: r'version', required: true, includeIfNull: false)
  final String version;

  @JsonKey(name: r'build_number', required: true, includeIfNull: false)
  final String buildNumber;

  @JsonKey(
    name: r'status',
    required: true,
    includeIfNull: false,
    unknownEnumValue: MobileAppApprovedReleaseStatusEnum.unknownDefaultOpenApi,
  )
  final MobileAppApprovedReleaseStatusEnum status;

  @JsonKey(name: r'management_url', required: true, includeIfNull: false)
  final String managementUrl;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is MobileAppApprovedRelease &&
          other.id == id &&
          other.appId == appId &&
          other.platform == platform &&
          other.channel == channel &&
          other.version == version &&
          other.buildNumber == buildNumber &&
          other.status == status &&
          other.managementUrl == managementUrl;

  @override
  int get hashCode =>
      id.hashCode +
      appId.hashCode +
      platform.hashCode +
      channel.hashCode +
      version.hashCode +
      buildNumber.hashCode +
      status.hashCode +
      managementUrl.hashCode;

  factory MobileAppApprovedRelease.fromJson(Map<String, dynamic> json) =>
      _$MobileAppApprovedReleaseFromJson(json);

  Map<String, dynamic> toJson() => _$MobileAppApprovedReleaseToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }
}

enum MobileAppApprovedReleasePlatformEnum {
  @JsonValue(r'ios')
  ios(r'ios'),
  @JsonValue(r'android')
  android(r'android'),
  @JsonValue(r'unknown_default_open_api')
  unknownDefaultOpenApi(r'unknown_default_open_api');

  const MobileAppApprovedReleasePlatformEnum(this.value);

  final String value;

  @override
  String toString() => value;
}

enum MobileAppApprovedReleaseChannelEnum {
  @JsonValue(r'internal')
  internal(r'internal'),
  @JsonValue(r'beta')
  beta(r'beta'),
  @JsonValue(r'production')
  production(r'production'),
  @JsonValue(r'unknown_default_open_api')
  unknownDefaultOpenApi(r'unknown_default_open_api');

  const MobileAppApprovedReleaseChannelEnum(this.value);

  final String value;

  @override
  String toString() => value;
}

enum MobileAppApprovedReleaseStatusEnum {
  @JsonValue(r'approved')
  approved(r'approved'),
  @JsonValue(r'unknown_default_open_api')
  unknownDefaultOpenApi(r'unknown_default_open_api');

  const MobileAppApprovedReleaseStatusEnum(this.value);

  final String value;

  @override
  String toString() => value;
}
