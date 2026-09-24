//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:json_annotation/json_annotation.dart';

part 'mobile_app_release_request.g.dart';

@CopyWith()
@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class MobileAppReleaseRequest {
  /// Returns a new [MobileAppReleaseRequest] instance.
  MobileAppReleaseRequest({
    required this.appId,

    required this.platform,

    required this.channel,

    required this.version,

    required this.buildNumber,

    required this.sourceRevision,

    required this.artifactSha256,

    required this.sdkVersion,

    required this.contractVersion,
  });

  @JsonKey(name: r'app_id', required: true, includeIfNull: false)
  final String appId;

  @JsonKey(
    name: r'platform',
    required: true,
    includeIfNull: false,
    unknownEnumValue: MobileAppReleaseRequestPlatformEnum.unknownDefaultOpenApi,
  )
  final MobileAppReleaseRequestPlatformEnum platform;

  @JsonKey(
    name: r'channel',
    required: true,
    includeIfNull: false,
    unknownEnumValue: MobileAppReleaseRequestChannelEnum.unknownDefaultOpenApi,
  )
  final MobileAppReleaseRequestChannelEnum channel;

  @JsonKey(name: r'version', required: true, includeIfNull: false)
  final String version;

  @JsonKey(name: r'build_number', required: true, includeIfNull: false)
  final String buildNumber;

  @JsonKey(name: r'source_revision', required: true, includeIfNull: false)
  final String sourceRevision;

  @JsonKey(name: r'artifact_sha256', required: true, includeIfNull: false)
  final String artifactSha256;

  @JsonKey(name: r'sdk_version', required: true, includeIfNull: false)
  final String sdkVersion;

  @JsonKey(name: r'contract_version', required: true, includeIfNull: false)
  final String contractVersion;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is MobileAppReleaseRequest &&
          other.appId == appId &&
          other.platform == platform &&
          other.channel == channel &&
          other.version == version &&
          other.buildNumber == buildNumber &&
          other.sourceRevision == sourceRevision &&
          other.artifactSha256 == artifactSha256 &&
          other.sdkVersion == sdkVersion &&
          other.contractVersion == contractVersion;

  @override
  int get hashCode =>
      appId.hashCode +
      platform.hashCode +
      channel.hashCode +
      version.hashCode +
      buildNumber.hashCode +
      sourceRevision.hashCode +
      artifactSha256.hashCode +
      sdkVersion.hashCode +
      contractVersion.hashCode;

  factory MobileAppReleaseRequest.fromJson(Map<String, dynamic> json) =>
      _$MobileAppReleaseRequestFromJson(json);

  Map<String, dynamic> toJson() => _$MobileAppReleaseRequestToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }
}

enum MobileAppReleaseRequestPlatformEnum {
  @JsonValue(r'ios')
  ios(r'ios'),
  @JsonValue(r'android')
  android(r'android'),
  @JsonValue(r'unknown_default_open_api')
  unknownDefaultOpenApi(r'unknown_default_open_api');

  const MobileAppReleaseRequestPlatformEnum(this.value);

  final String value;

  @override
  String toString() => value;
}

enum MobileAppReleaseRequestChannelEnum {
  @JsonValue(r'internal')
  internal(r'internal'),
  @JsonValue(r'beta')
  beta(r'beta'),
  @JsonValue(r'production')
  production(r'production'),
  @JsonValue(r'unknown_default_open_api')
  unknownDefaultOpenApi(r'unknown_default_open_api');

  const MobileAppReleaseRequestChannelEnum(this.value);

  final String value;

  @override
  String toString() => value;
}
