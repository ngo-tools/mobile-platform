// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'import_capabilities.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$ImportCapabilitiesCWProxy {
  ImportCapabilities enabled(bool enabled);

  ImportCapabilities types(Map<String, ImportCapability> types);

  /// Creates a new instance with the provided field values.
  /// Passing `null` to a nullable field nullifies it, while `null` for a non-nullable field is ignored. To update a single field use `ImportCapabilities(...).copyWith.fieldName(value)`.
  ///
  /// Example:
  /// ```dart
  /// ImportCapabilities(...).copyWith(id: 12, name: "My name")
  /// ```
  ImportCapabilities call({bool enabled, Map<String, ImportCapability> types});
}

/// Callable proxy for `copyWith` functionality.
/// Use as `instanceOfImportCapabilities.copyWith(...)` or call `instanceOfImportCapabilities.copyWith.fieldName(value)` for a single field.
class _$ImportCapabilitiesCWProxyImpl implements _$ImportCapabilitiesCWProxy {
  const _$ImportCapabilitiesCWProxyImpl(this._value);

  final ImportCapabilities _value;

  @override
  ImportCapabilities enabled(bool enabled) => call(enabled: enabled);

  @override
  ImportCapabilities types(Map<String, ImportCapability> types) =>
      call(types: types);

  /// Creates a new instance with the provided field values.
  /// Passing `null` to a nullable field nullifies it, while `null` for a non-nullable field is ignored. To update a single field use `ImportCapabilities(...).copyWith.fieldName(value)`.
  ///
  /// Example:
  /// ```dart
  /// ImportCapabilities(...).copyWith(id: 12, name: "My name")
  /// ```
  @override
  ImportCapabilities call({
    Object? enabled = const $CopyWithPlaceholder(),
    Object? types = const $CopyWithPlaceholder(),
  }) {
    return ImportCapabilities(
      enabled: enabled == const $CopyWithPlaceholder() || enabled == null
          ? _value.enabled
          // ignore: cast_nullable_to_non_nullable
          : enabled as bool,
      types: types == const $CopyWithPlaceholder() || types == null
          ? _value.types
          // ignore: cast_nullable_to_non_nullable
          : types as Map<String, ImportCapability>,
    );
  }
}

extension $ImportCapabilitiesCopyWith on ImportCapabilities {
  /// Returns a callable class used to build a new instance with modified fields.
  /// Example: `instanceOfImportCapabilities.copyWith(...)` or `instanceOfImportCapabilities.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$ImportCapabilitiesCWProxy get copyWith =>
      _$ImportCapabilitiesCWProxyImpl(this);
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ImportCapabilities _$ImportCapabilitiesFromJson(Map<String, dynamic> json) =>
    $checkedCreate('ImportCapabilities', json, ($checkedConvert) {
      $checkKeys(json, requiredKeys: const ['enabled', 'types']);
      final val = ImportCapabilities(
        enabled: $checkedConvert('enabled', (v) => v as bool),
        types: $checkedConvert(
          'types',
          (v) => (v as Map<String, dynamic>).map(
            (k, e) => MapEntry(
              k,
              ImportCapability.fromJson(e as Map<String, dynamic>),
            ),
          ),
        ),
      );
      return val;
    });

Map<String, dynamic> _$ImportCapabilitiesToJson(ImportCapabilities instance) =>
    <String, dynamic>{
      'enabled': instance.enabled,
      'types': instance.types.map((k, e) => MapEntry(k, e.toJson())),
    };
