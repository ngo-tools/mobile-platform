// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'mobile_app_release_start_response.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$MobileAppReleaseStartResponseCWProxy {
  MobileAppReleaseStartResponse data(MobileAppReleaseApproval data);

  /// Creates a new instance with the provided field values.
  /// Passing `null` to a nullable field nullifies it, while `null` for a non-nullable field is ignored. To update a single field use `MobileAppReleaseStartResponse(...).copyWith.fieldName(value)`.
  ///
  /// Example:
  /// ```dart
  /// MobileAppReleaseStartResponse(...).copyWith(id: 12, name: "My name")
  /// ```
  MobileAppReleaseStartResponse call({MobileAppReleaseApproval data});
}

/// Callable proxy for `copyWith` functionality.
/// Use as `instanceOfMobileAppReleaseStartResponse.copyWith(...)` or call `instanceOfMobileAppReleaseStartResponse.copyWith.fieldName(value)` for a single field.
class _$MobileAppReleaseStartResponseCWProxyImpl
    implements _$MobileAppReleaseStartResponseCWProxy {
  const _$MobileAppReleaseStartResponseCWProxyImpl(this._value);

  final MobileAppReleaseStartResponse _value;

  @override
  MobileAppReleaseStartResponse data(MobileAppReleaseApproval data) =>
      call(data: data);

  /// Creates a new instance with the provided field values.
  /// Passing `null` to a nullable field nullifies it, while `null` for a non-nullable field is ignored. To update a single field use `MobileAppReleaseStartResponse(...).copyWith.fieldName(value)`.
  ///
  /// Example:
  /// ```dart
  /// MobileAppReleaseStartResponse(...).copyWith(id: 12, name: "My name")
  /// ```
  @override
  MobileAppReleaseStartResponse call({
    Object? data = const $CopyWithPlaceholder(),
  }) {
    return MobileAppReleaseStartResponse(
      data: data == const $CopyWithPlaceholder() || data == null
          ? _value.data
          // ignore: cast_nullable_to_non_nullable
          : data as MobileAppReleaseApproval,
    );
  }
}

extension $MobileAppReleaseStartResponseCopyWith
    on MobileAppReleaseStartResponse {
  /// Returns a callable class used to build a new instance with modified fields.
  /// Example: `instanceOfMobileAppReleaseStartResponse.copyWith(...)` or `instanceOfMobileAppReleaseStartResponse.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$MobileAppReleaseStartResponseCWProxy get copyWith =>
      _$MobileAppReleaseStartResponseCWProxyImpl(this);
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MobileAppReleaseStartResponse _$MobileAppReleaseStartResponseFromJson(
  Map<String, dynamic> json,
) => $checkedCreate('MobileAppReleaseStartResponse', json, ($checkedConvert) {
  $checkKeys(json, requiredKeys: const ['data']);
  final val = MobileAppReleaseStartResponse(
    data: $checkedConvert(
      'data',
      (v) => MobileAppReleaseApproval.fromJson(v as Map<String, dynamic>),
    ),
  );
  return val;
});

Map<String, dynamic> _$MobileAppReleaseStartResponseToJson(
  MobileAppReleaseStartResponse instance,
) => <String, dynamic>{'data': instance.data.toJson()};
