// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'current_user_response.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$CurrentUserResponseCWProxy {
  CurrentUserResponse user(CurrentUser user);

  CurrentUserResponse permissions(Set<String> permissions);

  CurrentUserResponse features(Set<String> features);

  /// Creates a new instance with the provided field values.
  /// Passing `null` to a nullable field nullifies it, while `null` for a non-nullable field is ignored. To update a single field use `CurrentUserResponse(...).copyWith.fieldName(value)`.
  ///
  /// Example:
  /// ```dart
  /// CurrentUserResponse(...).copyWith(id: 12, name: "My name")
  /// ```
  CurrentUserResponse call({
    CurrentUser user,
    Set<String> permissions,
    Set<String> features,
  });
}

/// Callable proxy for `copyWith` functionality.
/// Use as `instanceOfCurrentUserResponse.copyWith(...)` or call `instanceOfCurrentUserResponse.copyWith.fieldName(value)` for a single field.
class _$CurrentUserResponseCWProxyImpl implements _$CurrentUserResponseCWProxy {
  const _$CurrentUserResponseCWProxyImpl(this._value);

  final CurrentUserResponse _value;

  @override
  CurrentUserResponse user(CurrentUser user) => call(user: user);

  @override
  CurrentUserResponse permissions(Set<String> permissions) =>
      call(permissions: permissions);

  @override
  CurrentUserResponse features(Set<String> features) =>
      call(features: features);

  /// Creates a new instance with the provided field values.
  /// Passing `null` to a nullable field nullifies it, while `null` for a non-nullable field is ignored. To update a single field use `CurrentUserResponse(...).copyWith.fieldName(value)`.
  ///
  /// Example:
  /// ```dart
  /// CurrentUserResponse(...).copyWith(id: 12, name: "My name")
  /// ```
  @override
  CurrentUserResponse call({
    Object? user = const $CopyWithPlaceholder(),
    Object? permissions = const $CopyWithPlaceholder(),
    Object? features = const $CopyWithPlaceholder(),
  }) {
    return CurrentUserResponse(
      user: user == const $CopyWithPlaceholder() || user == null
          ? _value.user
          // ignore: cast_nullable_to_non_nullable
          : user as CurrentUser,
      permissions:
          permissions == const $CopyWithPlaceholder() || permissions == null
          ? _value.permissions
          // ignore: cast_nullable_to_non_nullable
          : permissions as Set<String>,
      features: features == const $CopyWithPlaceholder() || features == null
          ? _value.features
          // ignore: cast_nullable_to_non_nullable
          : features as Set<String>,
    );
  }
}

extension $CurrentUserResponseCopyWith on CurrentUserResponse {
  /// Returns a callable class used to build a new instance with modified fields.
  /// Example: `instanceOfCurrentUserResponse.copyWith(...)` or `instanceOfCurrentUserResponse.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$CurrentUserResponseCWProxy get copyWith =>
      _$CurrentUserResponseCWProxyImpl(this);
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CurrentUserResponse _$CurrentUserResponseFromJson(Map<String, dynamic> json) =>
    $checkedCreate('CurrentUserResponse', json, ($checkedConvert) {
      $checkKeys(json, requiredKeys: const ['user', 'permissions', 'features']);
      final val = CurrentUserResponse(
        user: $checkedConvert(
          'user',
          (v) => CurrentUser.fromJson(v as Map<String, dynamic>),
        ),
        permissions: $checkedConvert(
          'permissions',
          (v) => (v as List<dynamic>).map((e) => e as String).toSet(),
        ),
        features: $checkedConvert(
          'features',
          (v) => (v as List<dynamic>).map((e) => e as String).toSet(),
        ),
      );
      return val;
    });

Map<String, dynamic> _$CurrentUserResponseToJson(
  CurrentUserResponse instance,
) => <String, dynamic>{
  'user': instance.user.toJson(),
  'permissions': instance.permissions.toList(),
  'features': instance.features.toList(),
};
