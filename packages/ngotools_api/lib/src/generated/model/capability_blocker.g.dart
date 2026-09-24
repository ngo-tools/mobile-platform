// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'capability_blocker.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$CapabilityBlockerCWProxy {
  CapabilityBlocker code(String code);

  CapabilityBlocker message(String message);

  /// Creates a new instance with the provided field values.
  /// Passing `null` to a nullable field nullifies it, while `null` for a non-nullable field is ignored. To update a single field use `CapabilityBlocker(...).copyWith.fieldName(value)`.
  ///
  /// Example:
  /// ```dart
  /// CapabilityBlocker(...).copyWith(id: 12, name: "My name")
  /// ```
  CapabilityBlocker call({String code, String message});
}

/// Callable proxy for `copyWith` functionality.
/// Use as `instanceOfCapabilityBlocker.copyWith(...)` or call `instanceOfCapabilityBlocker.copyWith.fieldName(value)` for a single field.
class _$CapabilityBlockerCWProxyImpl implements _$CapabilityBlockerCWProxy {
  const _$CapabilityBlockerCWProxyImpl(this._value);

  final CapabilityBlocker _value;

  @override
  CapabilityBlocker code(String code) => call(code: code);

  @override
  CapabilityBlocker message(String message) => call(message: message);

  /// Creates a new instance with the provided field values.
  /// Passing `null` to a nullable field nullifies it, while `null` for a non-nullable field is ignored. To update a single field use `CapabilityBlocker(...).copyWith.fieldName(value)`.
  ///
  /// Example:
  /// ```dart
  /// CapabilityBlocker(...).copyWith(id: 12, name: "My name")
  /// ```
  @override
  CapabilityBlocker call({
    Object? code = const $CopyWithPlaceholder(),
    Object? message = const $CopyWithPlaceholder(),
  }) {
    return CapabilityBlocker(
      code: code == const $CopyWithPlaceholder() || code == null
          ? _value.code
          // ignore: cast_nullable_to_non_nullable
          : code as String,
      message: message == const $CopyWithPlaceholder() || message == null
          ? _value.message
          // ignore: cast_nullable_to_non_nullable
          : message as String,
    );
  }
}

extension $CapabilityBlockerCopyWith on CapabilityBlocker {
  /// Returns a callable class used to build a new instance with modified fields.
  /// Example: `instanceOfCapabilityBlocker.copyWith(...)` or `instanceOfCapabilityBlocker.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$CapabilityBlockerCWProxy get copyWith =>
      _$CapabilityBlockerCWProxyImpl(this);
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CapabilityBlocker _$CapabilityBlockerFromJson(Map<String, dynamic> json) =>
    $checkedCreate('CapabilityBlocker', json, ($checkedConvert) {
      $checkKeys(json, requiredKeys: const ['code', 'message']);
      final val = CapabilityBlocker(
        code: $checkedConvert('code', (v) => v as String),
        message: $checkedConvert('message', (v) => v as String),
      );
      return val;
    });

Map<String, dynamic> _$CapabilityBlockerToJson(CapabilityBlocker instance) =>
    <String, dynamic>{'code': instance.code, 'message': instance.message};
