// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'current_user.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$CurrentUserCWProxy {
  CurrentUser id(int id);

  CurrentUser name(String name);

  CurrentUser email(String email);

  /// Creates a new instance with the provided field values.
  /// Passing `null` to a nullable field nullifies it, while `null` for a non-nullable field is ignored. To update a single field use `CurrentUser(...).copyWith.fieldName(value)`.
  ///
  /// Example:
  /// ```dart
  /// CurrentUser(...).copyWith(id: 12, name: "My name")
  /// ```
  CurrentUser call({int id, String name, String email});
}

/// Callable proxy for `copyWith` functionality.
/// Use as `instanceOfCurrentUser.copyWith(...)` or call `instanceOfCurrentUser.copyWith.fieldName(value)` for a single field.
class _$CurrentUserCWProxyImpl implements _$CurrentUserCWProxy {
  const _$CurrentUserCWProxyImpl(this._value);

  final CurrentUser _value;

  @override
  CurrentUser id(int id) => call(id: id);

  @override
  CurrentUser name(String name) => call(name: name);

  @override
  CurrentUser email(String email) => call(email: email);

  /// Creates a new instance with the provided field values.
  /// Passing `null` to a nullable field nullifies it, while `null` for a non-nullable field is ignored. To update a single field use `CurrentUser(...).copyWith.fieldName(value)`.
  ///
  /// Example:
  /// ```dart
  /// CurrentUser(...).copyWith(id: 12, name: "My name")
  /// ```
  @override
  CurrentUser call({
    Object? id = const $CopyWithPlaceholder(),
    Object? name = const $CopyWithPlaceholder(),
    Object? email = const $CopyWithPlaceholder(),
  }) {
    return CurrentUser(
      id: id == const $CopyWithPlaceholder() || id == null
          ? _value.id
          // ignore: cast_nullable_to_non_nullable
          : id as int,
      name: name == const $CopyWithPlaceholder() || name == null
          ? _value.name
          // ignore: cast_nullable_to_non_nullable
          : name as String,
      email: email == const $CopyWithPlaceholder() || email == null
          ? _value.email
          // ignore: cast_nullable_to_non_nullable
          : email as String,
    );
  }
}

extension $CurrentUserCopyWith on CurrentUser {
  /// Returns a callable class used to build a new instance with modified fields.
  /// Example: `instanceOfCurrentUser.copyWith(...)` or `instanceOfCurrentUser.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$CurrentUserCWProxy get copyWith => _$CurrentUserCWProxyImpl(this);
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CurrentUser _$CurrentUserFromJson(Map<String, dynamic> json) =>
    $checkedCreate('CurrentUser', json, ($checkedConvert) {
      $checkKeys(json, requiredKeys: const ['id', 'name', 'email']);
      final val = CurrentUser(
        id: $checkedConvert('id', (v) => (v as num).toInt()),
        name: $checkedConvert('name', (v) => v as String),
        email: $checkedConvert('email', (v) => v as String),
      );
      return val;
    });

Map<String, dynamic> _$CurrentUserToJson(CurrentUser instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'email': instance.email,
    };
