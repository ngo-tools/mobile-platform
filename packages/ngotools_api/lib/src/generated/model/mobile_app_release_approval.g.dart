// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'mobile_app_release_approval.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$MobileAppReleaseApprovalCWProxy {
  MobileAppReleaseApproval releaseRequestId(String releaseRequestId);

  MobileAppReleaseApproval pollToken(String pollToken);

  MobileAppReleaseApproval userCode(String userCode);

  MobileAppReleaseApproval authorizationUrl(String authorizationUrl);

  MobileAppReleaseApproval expiresIn(int expiresIn);

  MobileAppReleaseApproval pollInterval(int pollInterval);

  /// Creates a new instance with the provided field values.
  /// Passing `null` to a nullable field nullifies it, while `null` for a non-nullable field is ignored. To update a single field use `MobileAppReleaseApproval(...).copyWith.fieldName(value)`.
  ///
  /// Example:
  /// ```dart
  /// MobileAppReleaseApproval(...).copyWith(id: 12, name: "My name")
  /// ```
  MobileAppReleaseApproval call({
    String releaseRequestId,
    String pollToken,
    String userCode,
    String authorizationUrl,
    int expiresIn,
    int pollInterval,
  });
}

/// Callable proxy for `copyWith` functionality.
/// Use as `instanceOfMobileAppReleaseApproval.copyWith(...)` or call `instanceOfMobileAppReleaseApproval.copyWith.fieldName(value)` for a single field.
class _$MobileAppReleaseApprovalCWProxyImpl
    implements _$MobileAppReleaseApprovalCWProxy {
  const _$MobileAppReleaseApprovalCWProxyImpl(this._value);

  final MobileAppReleaseApproval _value;

  @override
  MobileAppReleaseApproval releaseRequestId(String releaseRequestId) =>
      call(releaseRequestId: releaseRequestId);

  @override
  MobileAppReleaseApproval pollToken(String pollToken) =>
      call(pollToken: pollToken);

  @override
  MobileAppReleaseApproval userCode(String userCode) =>
      call(userCode: userCode);

  @override
  MobileAppReleaseApproval authorizationUrl(String authorizationUrl) =>
      call(authorizationUrl: authorizationUrl);

  @override
  MobileAppReleaseApproval expiresIn(int expiresIn) =>
      call(expiresIn: expiresIn);

  @override
  MobileAppReleaseApproval pollInterval(int pollInterval) =>
      call(pollInterval: pollInterval);

  /// Creates a new instance with the provided field values.
  /// Passing `null` to a nullable field nullifies it, while `null` for a non-nullable field is ignored. To update a single field use `MobileAppReleaseApproval(...).copyWith.fieldName(value)`.
  ///
  /// Example:
  /// ```dart
  /// MobileAppReleaseApproval(...).copyWith(id: 12, name: "My name")
  /// ```
  @override
  MobileAppReleaseApproval call({
    Object? releaseRequestId = const $CopyWithPlaceholder(),
    Object? pollToken = const $CopyWithPlaceholder(),
    Object? userCode = const $CopyWithPlaceholder(),
    Object? authorizationUrl = const $CopyWithPlaceholder(),
    Object? expiresIn = const $CopyWithPlaceholder(),
    Object? pollInterval = const $CopyWithPlaceholder(),
  }) {
    return MobileAppReleaseApproval(
      releaseRequestId:
          releaseRequestId == const $CopyWithPlaceholder() ||
              releaseRequestId == null
          ? _value.releaseRequestId
          // ignore: cast_nullable_to_non_nullable
          : releaseRequestId as String,
      pollToken: pollToken == const $CopyWithPlaceholder() || pollToken == null
          ? _value.pollToken
          // ignore: cast_nullable_to_non_nullable
          : pollToken as String,
      userCode: userCode == const $CopyWithPlaceholder() || userCode == null
          ? _value.userCode
          // ignore: cast_nullable_to_non_nullable
          : userCode as String,
      authorizationUrl:
          authorizationUrl == const $CopyWithPlaceholder() ||
              authorizationUrl == null
          ? _value.authorizationUrl
          // ignore: cast_nullable_to_non_nullable
          : authorizationUrl as String,
      expiresIn: expiresIn == const $CopyWithPlaceholder() || expiresIn == null
          ? _value.expiresIn
          // ignore: cast_nullable_to_non_nullable
          : expiresIn as int,
      pollInterval:
          pollInterval == const $CopyWithPlaceholder() || pollInterval == null
          ? _value.pollInterval
          // ignore: cast_nullable_to_non_nullable
          : pollInterval as int,
    );
  }
}

extension $MobileAppReleaseApprovalCopyWith on MobileAppReleaseApproval {
  /// Returns a callable class used to build a new instance with modified fields.
  /// Example: `instanceOfMobileAppReleaseApproval.copyWith(...)` or `instanceOfMobileAppReleaseApproval.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$MobileAppReleaseApprovalCWProxy get copyWith =>
      _$MobileAppReleaseApprovalCWProxyImpl(this);
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MobileAppReleaseApproval _$MobileAppReleaseApprovalFromJson(
  Map<String, dynamic> json,
) => $checkedCreate(
  'MobileAppReleaseApproval',
  json,
  ($checkedConvert) {
    $checkKeys(
      json,
      requiredKeys: const [
        'release_request_id',
        'poll_token',
        'user_code',
        'authorization_url',
        'expires_in',
        'poll_interval',
      ],
    );
    final val = MobileAppReleaseApproval(
      releaseRequestId: $checkedConvert(
        'release_request_id',
        (v) => v as String,
      ),
      pollToken: $checkedConvert('poll_token', (v) => v as String),
      userCode: $checkedConvert('user_code', (v) => v as String),
      authorizationUrl: $checkedConvert(
        'authorization_url',
        (v) => v as String,
      ),
      expiresIn: $checkedConvert('expires_in', (v) => (v as num).toInt()),
      pollInterval: $checkedConvert('poll_interval', (v) => (v as num).toInt()),
    );
    return val;
  },
  fieldKeyMap: const {
    'releaseRequestId': 'release_request_id',
    'pollToken': 'poll_token',
    'userCode': 'user_code',
    'authorizationUrl': 'authorization_url',
    'expiresIn': 'expires_in',
    'pollInterval': 'poll_interval',
  },
);

Map<String, dynamic> _$MobileAppReleaseApprovalToJson(
  MobileAppReleaseApproval instance,
) => <String, dynamic>{
  'release_request_id': instance.releaseRequestId,
  'poll_token': instance.pollToken,
  'user_code': instance.userCode,
  'authorization_url': instance.authorizationUrl,
  'expires_in': instance.expiresIn,
  'poll_interval': instance.pollInterval,
};
