// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'mobile_app_release_poll_request.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$MobileAppReleasePollRequestCWProxy {
  MobileAppReleasePollRequest pollToken(String pollToken);

  /// Creates a new instance with the provided field values.
  /// Passing `null` to a nullable field nullifies it, while `null` for a non-nullable field is ignored. To update a single field use `MobileAppReleasePollRequest(...).copyWith.fieldName(value)`.
  ///
  /// Example:
  /// ```dart
  /// MobileAppReleasePollRequest(...).copyWith(id: 12, name: "My name")
  /// ```
  MobileAppReleasePollRequest call({String pollToken});
}

/// Callable proxy for `copyWith` functionality.
/// Use as `instanceOfMobileAppReleasePollRequest.copyWith(...)` or call `instanceOfMobileAppReleasePollRequest.copyWith.fieldName(value)` for a single field.
class _$MobileAppReleasePollRequestCWProxyImpl
    implements _$MobileAppReleasePollRequestCWProxy {
  const _$MobileAppReleasePollRequestCWProxyImpl(this._value);

  final MobileAppReleasePollRequest _value;

  @override
  MobileAppReleasePollRequest pollToken(String pollToken) =>
      call(pollToken: pollToken);

  /// Creates a new instance with the provided field values.
  /// Passing `null` to a nullable field nullifies it, while `null` for a non-nullable field is ignored. To update a single field use `MobileAppReleasePollRequest(...).copyWith.fieldName(value)`.
  ///
  /// Example:
  /// ```dart
  /// MobileAppReleasePollRequest(...).copyWith(id: 12, name: "My name")
  /// ```
  @override
  MobileAppReleasePollRequest call({
    Object? pollToken = const $CopyWithPlaceholder(),
  }) {
    return MobileAppReleasePollRequest(
      pollToken: pollToken == const $CopyWithPlaceholder() || pollToken == null
          ? _value.pollToken
          // ignore: cast_nullable_to_non_nullable
          : pollToken as String,
    );
  }
}

extension $MobileAppReleasePollRequestCopyWith on MobileAppReleasePollRequest {
  /// Returns a callable class used to build a new instance with modified fields.
  /// Example: `instanceOfMobileAppReleasePollRequest.copyWith(...)` or `instanceOfMobileAppReleasePollRequest.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$MobileAppReleasePollRequestCWProxy get copyWith =>
      _$MobileAppReleasePollRequestCWProxyImpl(this);
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MobileAppReleasePollRequest _$MobileAppReleasePollRequestFromJson(
  Map<String, dynamic> json,
) => $checkedCreate('MobileAppReleasePollRequest', json, ($checkedConvert) {
  $checkKeys(json, requiredKeys: const ['poll_token']);
  final val = MobileAppReleasePollRequest(
    pollToken: $checkedConvert('poll_token', (v) => v as String),
  );
  return val;
}, fieldKeyMap: const {'pollToken': 'poll_token'});

Map<String, dynamic> _$MobileAppReleasePollRequestToJson(
  MobileAppReleasePollRequest instance,
) => <String, dynamic>{'poll_token': instance.pollToken};
