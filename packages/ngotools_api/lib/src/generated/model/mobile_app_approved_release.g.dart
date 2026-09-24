// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'mobile_app_approved_release.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$MobileAppApprovedReleaseCWProxy {
  MobileAppApprovedRelease id(String id);

  MobileAppApprovedRelease appId(String appId);

  MobileAppApprovedRelease platform(
    MobileAppApprovedReleasePlatformEnum platform,
  );

  MobileAppApprovedRelease channel(MobileAppApprovedReleaseChannelEnum channel);

  MobileAppApprovedRelease version(String version);

  MobileAppApprovedRelease buildNumber(String buildNumber);

  MobileAppApprovedRelease status(MobileAppApprovedReleaseStatusEnum status);

  MobileAppApprovedRelease managementUrl(String managementUrl);

  /// Creates a new instance with the provided field values.
  /// Passing `null` to a nullable field nullifies it, while `null` for a non-nullable field is ignored. To update a single field use `MobileAppApprovedRelease(...).copyWith.fieldName(value)`.
  ///
  /// Example:
  /// ```dart
  /// MobileAppApprovedRelease(...).copyWith(id: 12, name: "My name")
  /// ```
  MobileAppApprovedRelease call({
    String id,
    String appId,
    MobileAppApprovedReleasePlatformEnum platform,
    MobileAppApprovedReleaseChannelEnum channel,
    String version,
    String buildNumber,
    MobileAppApprovedReleaseStatusEnum status,
    String managementUrl,
  });
}

/// Callable proxy for `copyWith` functionality.
/// Use as `instanceOfMobileAppApprovedRelease.copyWith(...)` or call `instanceOfMobileAppApprovedRelease.copyWith.fieldName(value)` for a single field.
class _$MobileAppApprovedReleaseCWProxyImpl
    implements _$MobileAppApprovedReleaseCWProxy {
  const _$MobileAppApprovedReleaseCWProxyImpl(this._value);

  final MobileAppApprovedRelease _value;

  @override
  MobileAppApprovedRelease id(String id) => call(id: id);

  @override
  MobileAppApprovedRelease appId(String appId) => call(appId: appId);

  @override
  MobileAppApprovedRelease platform(
    MobileAppApprovedReleasePlatformEnum platform,
  ) => call(platform: platform);

  @override
  MobileAppApprovedRelease channel(
    MobileAppApprovedReleaseChannelEnum channel,
  ) => call(channel: channel);

  @override
  MobileAppApprovedRelease version(String version) => call(version: version);

  @override
  MobileAppApprovedRelease buildNumber(String buildNumber) =>
      call(buildNumber: buildNumber);

  @override
  MobileAppApprovedRelease status(MobileAppApprovedReleaseStatusEnum status) =>
      call(status: status);

  @override
  MobileAppApprovedRelease managementUrl(String managementUrl) =>
      call(managementUrl: managementUrl);

  /// Creates a new instance with the provided field values.
  /// Passing `null` to a nullable field nullifies it, while `null` for a non-nullable field is ignored. To update a single field use `MobileAppApprovedRelease(...).copyWith.fieldName(value)`.
  ///
  /// Example:
  /// ```dart
  /// MobileAppApprovedRelease(...).copyWith(id: 12, name: "My name")
  /// ```
  @override
  MobileAppApprovedRelease call({
    Object? id = const $CopyWithPlaceholder(),
    Object? appId = const $CopyWithPlaceholder(),
    Object? platform = const $CopyWithPlaceholder(),
    Object? channel = const $CopyWithPlaceholder(),
    Object? version = const $CopyWithPlaceholder(),
    Object? buildNumber = const $CopyWithPlaceholder(),
    Object? status = const $CopyWithPlaceholder(),
    Object? managementUrl = const $CopyWithPlaceholder(),
  }) {
    return MobileAppApprovedRelease(
      id: id == const $CopyWithPlaceholder() || id == null
          ? _value.id
          // ignore: cast_nullable_to_non_nullable
          : id as String,
      appId: appId == const $CopyWithPlaceholder() || appId == null
          ? _value.appId
          // ignore: cast_nullable_to_non_nullable
          : appId as String,
      platform: platform == const $CopyWithPlaceholder() || platform == null
          ? _value.platform
          // ignore: cast_nullable_to_non_nullable
          : platform as MobileAppApprovedReleasePlatformEnum,
      channel: channel == const $CopyWithPlaceholder() || channel == null
          ? _value.channel
          // ignore: cast_nullable_to_non_nullable
          : channel as MobileAppApprovedReleaseChannelEnum,
      version: version == const $CopyWithPlaceholder() || version == null
          ? _value.version
          // ignore: cast_nullable_to_non_nullable
          : version as String,
      buildNumber:
          buildNumber == const $CopyWithPlaceholder() || buildNumber == null
          ? _value.buildNumber
          // ignore: cast_nullable_to_non_nullable
          : buildNumber as String,
      status: status == const $CopyWithPlaceholder() || status == null
          ? _value.status
          // ignore: cast_nullable_to_non_nullable
          : status as MobileAppApprovedReleaseStatusEnum,
      managementUrl:
          managementUrl == const $CopyWithPlaceholder() || managementUrl == null
          ? _value.managementUrl
          // ignore: cast_nullable_to_non_nullable
          : managementUrl as String,
    );
  }
}

extension $MobileAppApprovedReleaseCopyWith on MobileAppApprovedRelease {
  /// Returns a callable class used to build a new instance with modified fields.
  /// Example: `instanceOfMobileAppApprovedRelease.copyWith(...)` or `instanceOfMobileAppApprovedRelease.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$MobileAppApprovedReleaseCWProxy get copyWith =>
      _$MobileAppApprovedReleaseCWProxyImpl(this);
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MobileAppApprovedRelease _$MobileAppApprovedReleaseFromJson(
  Map<String, dynamic> json,
) => $checkedCreate(
  'MobileAppApprovedRelease',
  json,
  ($checkedConvert) {
    $checkKeys(
      json,
      requiredKeys: const [
        'id',
        'app_id',
        'platform',
        'channel',
        'version',
        'build_number',
        'status',
        'management_url',
      ],
    );
    final val = MobileAppApprovedRelease(
      id: $checkedConvert('id', (v) => v as String),
      appId: $checkedConvert('app_id', (v) => v as String),
      platform: $checkedConvert(
        'platform',
        (v) => $enumDecode(
          _$MobileAppApprovedReleasePlatformEnumEnumMap,
          v,
          unknownValue:
              MobileAppApprovedReleasePlatformEnum.unknownDefaultOpenApi,
        ),
      ),
      channel: $checkedConvert(
        'channel',
        (v) => $enumDecode(
          _$MobileAppApprovedReleaseChannelEnumEnumMap,
          v,
          unknownValue:
              MobileAppApprovedReleaseChannelEnum.unknownDefaultOpenApi,
        ),
      ),
      version: $checkedConvert('version', (v) => v as String),
      buildNumber: $checkedConvert('build_number', (v) => v as String),
      status: $checkedConvert(
        'status',
        (v) => $enumDecode(
          _$MobileAppApprovedReleaseStatusEnumEnumMap,
          v,
          unknownValue:
              MobileAppApprovedReleaseStatusEnum.unknownDefaultOpenApi,
        ),
      ),
      managementUrl: $checkedConvert('management_url', (v) => v as String),
    );
    return val;
  },
  fieldKeyMap: const {
    'appId': 'app_id',
    'buildNumber': 'build_number',
    'managementUrl': 'management_url',
  },
);

Map<String, dynamic> _$MobileAppApprovedReleaseToJson(
  MobileAppApprovedRelease instance,
) => <String, dynamic>{
  'id': instance.id,
  'app_id': instance.appId,
  'platform': _$MobileAppApprovedReleasePlatformEnumEnumMap[instance.platform]!,
  'channel': _$MobileAppApprovedReleaseChannelEnumEnumMap[instance.channel]!,
  'version': instance.version,
  'build_number': instance.buildNumber,
  'status': _$MobileAppApprovedReleaseStatusEnumEnumMap[instance.status]!,
  'management_url': instance.managementUrl,
};

const _$MobileAppApprovedReleasePlatformEnumEnumMap = {
  MobileAppApprovedReleasePlatformEnum.ios: 'ios',
  MobileAppApprovedReleasePlatformEnum.android: 'android',
  MobileAppApprovedReleasePlatformEnum.unknownDefaultOpenApi:
      'unknown_default_open_api',
};

const _$MobileAppApprovedReleaseChannelEnumEnumMap = {
  MobileAppApprovedReleaseChannelEnum.internal: 'internal',
  MobileAppApprovedReleaseChannelEnum.beta: 'beta',
  MobileAppApprovedReleaseChannelEnum.production: 'production',
  MobileAppApprovedReleaseChannelEnum.unknownDefaultOpenApi:
      'unknown_default_open_api',
};

const _$MobileAppApprovedReleaseStatusEnumEnumMap = {
  MobileAppApprovedReleaseStatusEnum.approved: 'approved',
  MobileAppApprovedReleaseStatusEnum.unknownDefaultOpenApi:
      'unknown_default_open_api',
};
