// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'mobile_app_release_poll_response.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$MobileAppReleasePollResponseCWProxy {
  MobileAppReleasePollResponse status(
    MobileAppReleasePollResponseStatusEnum status,
  );

  MobileAppReleasePollResponse code(String? code);

  MobileAppReleasePollResponse release(MobileAppApprovedRelease? release);

  /// Creates a new instance with the provided field values.
  /// Passing `null` to a nullable field nullifies it, while `null` for a non-nullable field is ignored. To update a single field use `MobileAppReleasePollResponse(...).copyWith.fieldName(value)`.
  ///
  /// Example:
  /// ```dart
  /// MobileAppReleasePollResponse(...).copyWith(id: 12, name: "My name")
  /// ```
  MobileAppReleasePollResponse call({
    MobileAppReleasePollResponseStatusEnum status,
    String? code,
    MobileAppApprovedRelease? release,
  });
}

/// Callable proxy for `copyWith` functionality.
/// Use as `instanceOfMobileAppReleasePollResponse.copyWith(...)` or call `instanceOfMobileAppReleasePollResponse.copyWith.fieldName(value)` for a single field.
class _$MobileAppReleasePollResponseCWProxyImpl
    implements _$MobileAppReleasePollResponseCWProxy {
  const _$MobileAppReleasePollResponseCWProxyImpl(this._value);

  final MobileAppReleasePollResponse _value;

  @override
  MobileAppReleasePollResponse status(
    MobileAppReleasePollResponseStatusEnum status,
  ) => call(status: status);

  @override
  MobileAppReleasePollResponse code(String? code) => call(code: code);

  @override
  MobileAppReleasePollResponse release(MobileAppApprovedRelease? release) =>
      call(release: release);

  /// Creates a new instance with the provided field values.
  /// Passing `null` to a nullable field nullifies it, while `null` for a non-nullable field is ignored. To update a single field use `MobileAppReleasePollResponse(...).copyWith.fieldName(value)`.
  ///
  /// Example:
  /// ```dart
  /// MobileAppReleasePollResponse(...).copyWith(id: 12, name: "My name")
  /// ```
  @override
  MobileAppReleasePollResponse call({
    Object? status = const $CopyWithPlaceholder(),
    Object? code = const $CopyWithPlaceholder(),
    Object? release = const $CopyWithPlaceholder(),
  }) {
    return MobileAppReleasePollResponse(
      status: status == const $CopyWithPlaceholder() || status == null
          ? _value.status
          // ignore: cast_nullable_to_non_nullable
          : status as MobileAppReleasePollResponseStatusEnum,
      code: code == const $CopyWithPlaceholder()
          ? _value.code
          // ignore: cast_nullable_to_non_nullable
          : code as String?,
      release: release == const $CopyWithPlaceholder()
          ? _value.release
          // ignore: cast_nullable_to_non_nullable
          : release as MobileAppApprovedRelease?,
    );
  }
}

extension $MobileAppReleasePollResponseCopyWith
    on MobileAppReleasePollResponse {
  /// Returns a callable class used to build a new instance with modified fields.
  /// Example: `instanceOfMobileAppReleasePollResponse.copyWith(...)` or `instanceOfMobileAppReleasePollResponse.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$MobileAppReleasePollResponseCWProxy get copyWith =>
      _$MobileAppReleasePollResponseCWProxyImpl(this);
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MobileAppReleasePollResponse _$MobileAppReleasePollResponseFromJson(
  Map<String, dynamic> json,
) => $checkedCreate('MobileAppReleasePollResponse', json, ($checkedConvert) {
  $checkKeys(json, requiredKeys: const ['status']);
  final val = MobileAppReleasePollResponse(
    status: $checkedConvert(
      'status',
      (v) => $enumDecode(
        _$MobileAppReleasePollResponseStatusEnumEnumMap,
        v,
        unknownValue:
            MobileAppReleasePollResponseStatusEnum.unknownDefaultOpenApi,
      ),
    ),
    code: $checkedConvert('code', (v) => v as String?),
    release: $checkedConvert(
      'release',
      (v) => v == null
          ? null
          : MobileAppApprovedRelease.fromJson(v as Map<String, dynamic>),
    ),
  );
  return val;
});

Map<String, dynamic> _$MobileAppReleasePollResponseToJson(
  MobileAppReleasePollResponse instance,
) => <String, dynamic>{
  'status': _$MobileAppReleasePollResponseStatusEnumEnumMap[instance.status]!,
  'code': ?instance.code,
  'release': ?instance.release?.toJson(),
};

const _$MobileAppReleasePollResponseStatusEnumEnumMap = {
  MobileAppReleasePollResponseStatusEnum.pending: 'pending',
  MobileAppReleasePollResponseStatusEnum.approved: 'approved',
  MobileAppReleasePollResponseStatusEnum.unknownDefaultOpenApi:
      'unknown_default_open_api',
};
