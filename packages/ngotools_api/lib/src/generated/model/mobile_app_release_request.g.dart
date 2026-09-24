// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'mobile_app_release_request.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$MobileAppReleaseRequestCWProxy {
  MobileAppReleaseRequest appId(String appId);

  MobileAppReleaseRequest platform(
    MobileAppReleaseRequestPlatformEnum platform,
  );

  MobileAppReleaseRequest channel(MobileAppReleaseRequestChannelEnum channel);

  MobileAppReleaseRequest version(String version);

  MobileAppReleaseRequest buildNumber(String buildNumber);

  MobileAppReleaseRequest sourceRevision(String sourceRevision);

  MobileAppReleaseRequest artifactSha256(String artifactSha256);

  MobileAppReleaseRequest sdkVersion(String sdkVersion);

  MobileAppReleaseRequest contractVersion(String contractVersion);

  /// Creates a new instance with the provided field values.
  /// Passing `null` to a nullable field nullifies it, while `null` for a non-nullable field is ignored. To update a single field use `MobileAppReleaseRequest(...).copyWith.fieldName(value)`.
  ///
  /// Example:
  /// ```dart
  /// MobileAppReleaseRequest(...).copyWith(id: 12, name: "My name")
  /// ```
  MobileAppReleaseRequest call({
    String appId,
    MobileAppReleaseRequestPlatformEnum platform,
    MobileAppReleaseRequestChannelEnum channel,
    String version,
    String buildNumber,
    String sourceRevision,
    String artifactSha256,
    String sdkVersion,
    String contractVersion,
  });
}

/// Callable proxy for `copyWith` functionality.
/// Use as `instanceOfMobileAppReleaseRequest.copyWith(...)` or call `instanceOfMobileAppReleaseRequest.copyWith.fieldName(value)` for a single field.
class _$MobileAppReleaseRequestCWProxyImpl
    implements _$MobileAppReleaseRequestCWProxy {
  const _$MobileAppReleaseRequestCWProxyImpl(this._value);

  final MobileAppReleaseRequest _value;

  @override
  MobileAppReleaseRequest appId(String appId) => call(appId: appId);

  @override
  MobileAppReleaseRequest platform(
    MobileAppReleaseRequestPlatformEnum platform,
  ) => call(platform: platform);

  @override
  MobileAppReleaseRequest channel(MobileAppReleaseRequestChannelEnum channel) =>
      call(channel: channel);

  @override
  MobileAppReleaseRequest version(String version) => call(version: version);

  @override
  MobileAppReleaseRequest buildNumber(String buildNumber) =>
      call(buildNumber: buildNumber);

  @override
  MobileAppReleaseRequest sourceRevision(String sourceRevision) =>
      call(sourceRevision: sourceRevision);

  @override
  MobileAppReleaseRequest artifactSha256(String artifactSha256) =>
      call(artifactSha256: artifactSha256);

  @override
  MobileAppReleaseRequest sdkVersion(String sdkVersion) =>
      call(sdkVersion: sdkVersion);

  @override
  MobileAppReleaseRequest contractVersion(String contractVersion) =>
      call(contractVersion: contractVersion);

  /// Creates a new instance with the provided field values.
  /// Passing `null` to a nullable field nullifies it, while `null` for a non-nullable field is ignored. To update a single field use `MobileAppReleaseRequest(...).copyWith.fieldName(value)`.
  ///
  /// Example:
  /// ```dart
  /// MobileAppReleaseRequest(...).copyWith(id: 12, name: "My name")
  /// ```
  @override
  MobileAppReleaseRequest call({
    Object? appId = const $CopyWithPlaceholder(),
    Object? platform = const $CopyWithPlaceholder(),
    Object? channel = const $CopyWithPlaceholder(),
    Object? version = const $CopyWithPlaceholder(),
    Object? buildNumber = const $CopyWithPlaceholder(),
    Object? sourceRevision = const $CopyWithPlaceholder(),
    Object? artifactSha256 = const $CopyWithPlaceholder(),
    Object? sdkVersion = const $CopyWithPlaceholder(),
    Object? contractVersion = const $CopyWithPlaceholder(),
  }) {
    return MobileAppReleaseRequest(
      appId: appId == const $CopyWithPlaceholder() || appId == null
          ? _value.appId
          // ignore: cast_nullable_to_non_nullable
          : appId as String,
      platform: platform == const $CopyWithPlaceholder() || platform == null
          ? _value.platform
          // ignore: cast_nullable_to_non_nullable
          : platform as MobileAppReleaseRequestPlatformEnum,
      channel: channel == const $CopyWithPlaceholder() || channel == null
          ? _value.channel
          // ignore: cast_nullable_to_non_nullable
          : channel as MobileAppReleaseRequestChannelEnum,
      version: version == const $CopyWithPlaceholder() || version == null
          ? _value.version
          // ignore: cast_nullable_to_non_nullable
          : version as String,
      buildNumber:
          buildNumber == const $CopyWithPlaceholder() || buildNumber == null
          ? _value.buildNumber
          // ignore: cast_nullable_to_non_nullable
          : buildNumber as String,
      sourceRevision:
          sourceRevision == const $CopyWithPlaceholder() ||
              sourceRevision == null
          ? _value.sourceRevision
          // ignore: cast_nullable_to_non_nullable
          : sourceRevision as String,
      artifactSha256:
          artifactSha256 == const $CopyWithPlaceholder() ||
              artifactSha256 == null
          ? _value.artifactSha256
          // ignore: cast_nullable_to_non_nullable
          : artifactSha256 as String,
      sdkVersion:
          sdkVersion == const $CopyWithPlaceholder() || sdkVersion == null
          ? _value.sdkVersion
          // ignore: cast_nullable_to_non_nullable
          : sdkVersion as String,
      contractVersion:
          contractVersion == const $CopyWithPlaceholder() ||
              contractVersion == null
          ? _value.contractVersion
          // ignore: cast_nullable_to_non_nullable
          : contractVersion as String,
    );
  }
}

extension $MobileAppReleaseRequestCopyWith on MobileAppReleaseRequest {
  /// Returns a callable class used to build a new instance with modified fields.
  /// Example: `instanceOfMobileAppReleaseRequest.copyWith(...)` or `instanceOfMobileAppReleaseRequest.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$MobileAppReleaseRequestCWProxy get copyWith =>
      _$MobileAppReleaseRequestCWProxyImpl(this);
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MobileAppReleaseRequest _$MobileAppReleaseRequestFromJson(
  Map<String, dynamic> json,
) => $checkedCreate(
  'MobileAppReleaseRequest',
  json,
  ($checkedConvert) {
    $checkKeys(
      json,
      requiredKeys: const [
        'app_id',
        'platform',
        'channel',
        'version',
        'build_number',
        'source_revision',
        'artifact_sha256',
        'sdk_version',
        'contract_version',
      ],
    );
    final val = MobileAppReleaseRequest(
      appId: $checkedConvert('app_id', (v) => v as String),
      platform: $checkedConvert(
        'platform',
        (v) => $enumDecode(
          _$MobileAppReleaseRequestPlatformEnumEnumMap,
          v,
          unknownValue:
              MobileAppReleaseRequestPlatformEnum.unknownDefaultOpenApi,
        ),
      ),
      channel: $checkedConvert(
        'channel',
        (v) => $enumDecode(
          _$MobileAppReleaseRequestChannelEnumEnumMap,
          v,
          unknownValue:
              MobileAppReleaseRequestChannelEnum.unknownDefaultOpenApi,
        ),
      ),
      version: $checkedConvert('version', (v) => v as String),
      buildNumber: $checkedConvert('build_number', (v) => v as String),
      sourceRevision: $checkedConvert('source_revision', (v) => v as String),
      artifactSha256: $checkedConvert('artifact_sha256', (v) => v as String),
      sdkVersion: $checkedConvert('sdk_version', (v) => v as String),
      contractVersion: $checkedConvert('contract_version', (v) => v as String),
    );
    return val;
  },
  fieldKeyMap: const {
    'appId': 'app_id',
    'buildNumber': 'build_number',
    'sourceRevision': 'source_revision',
    'artifactSha256': 'artifact_sha256',
    'sdkVersion': 'sdk_version',
    'contractVersion': 'contract_version',
  },
);

Map<String, dynamic> _$MobileAppReleaseRequestToJson(
  MobileAppReleaseRequest instance,
) => <String, dynamic>{
  'app_id': instance.appId,
  'platform': _$MobileAppReleaseRequestPlatformEnumEnumMap[instance.platform]!,
  'channel': _$MobileAppReleaseRequestChannelEnumEnumMap[instance.channel]!,
  'version': instance.version,
  'build_number': instance.buildNumber,
  'source_revision': instance.sourceRevision,
  'artifact_sha256': instance.artifactSha256,
  'sdk_version': instance.sdkVersion,
  'contract_version': instance.contractVersion,
};

const _$MobileAppReleaseRequestPlatformEnumEnumMap = {
  MobileAppReleaseRequestPlatformEnum.ios: 'ios',
  MobileAppReleaseRequestPlatformEnum.android: 'android',
  MobileAppReleaseRequestPlatformEnum.unknownDefaultOpenApi:
      'unknown_default_open_api',
};

const _$MobileAppReleaseRequestChannelEnumEnumMap = {
  MobileAppReleaseRequestChannelEnum.internal: 'internal',
  MobileAppReleaseRequestChannelEnum.beta: 'beta',
  MobileAppReleaseRequestChannelEnum.production: 'production',
  MobileAppReleaseRequestChannelEnum.unknownDefaultOpenApi:
      'unknown_default_open_api',
};
