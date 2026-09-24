// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'capabilities_response.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$CapabilitiesResponseCWProxy {
  CapabilitiesResponse data(RuntimeCapabilities data);

  /// Creates a new instance with the provided field values.
  /// Passing `null` to a nullable field nullifies it, while `null` for a non-nullable field is ignored. To update a single field use `CapabilitiesResponse(...).copyWith.fieldName(value)`.
  ///
  /// Example:
  /// ```dart
  /// CapabilitiesResponse(...).copyWith(id: 12, name: "My name")
  /// ```
  CapabilitiesResponse call({RuntimeCapabilities data});
}

/// Callable proxy for `copyWith` functionality.
/// Use as `instanceOfCapabilitiesResponse.copyWith(...)` or call `instanceOfCapabilitiesResponse.copyWith.fieldName(value)` for a single field.
class _$CapabilitiesResponseCWProxyImpl
    implements _$CapabilitiesResponseCWProxy {
  const _$CapabilitiesResponseCWProxyImpl(this._value);

  final CapabilitiesResponse _value;

  @override
  CapabilitiesResponse data(RuntimeCapabilities data) => call(data: data);

  /// Creates a new instance with the provided field values.
  /// Passing `null` to a nullable field nullifies it, while `null` for a non-nullable field is ignored. To update a single field use `CapabilitiesResponse(...).copyWith.fieldName(value)`.
  ///
  /// Example:
  /// ```dart
  /// CapabilitiesResponse(...).copyWith(id: 12, name: "My name")
  /// ```
  @override
  CapabilitiesResponse call({Object? data = const $CopyWithPlaceholder()}) {
    return CapabilitiesResponse(
      data: data == const $CopyWithPlaceholder() || data == null
          ? _value.data
          // ignore: cast_nullable_to_non_nullable
          : data as RuntimeCapabilities,
    );
  }
}

extension $CapabilitiesResponseCopyWith on CapabilitiesResponse {
  /// Returns a callable class used to build a new instance with modified fields.
  /// Example: `instanceOfCapabilitiesResponse.copyWith(...)` or `instanceOfCapabilitiesResponse.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$CapabilitiesResponseCWProxy get copyWith =>
      _$CapabilitiesResponseCWProxyImpl(this);
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CapabilitiesResponse _$CapabilitiesResponseFromJson(
  Map<String, dynamic> json,
) => $checkedCreate('CapabilitiesResponse', json, ($checkedConvert) {
  $checkKeys(json, requiredKeys: const ['data']);
  final val = CapabilitiesResponse(
    data: $checkedConvert(
      'data',
      (v) => RuntimeCapabilities.fromJson(v as Map<String, dynamic>),
    ),
  );
  return val;
});

Map<String, dynamic> _$CapabilitiesResponseToJson(
  CapabilitiesResponse instance,
) => <String, dynamic>{'data': instance.data.toJson()};
