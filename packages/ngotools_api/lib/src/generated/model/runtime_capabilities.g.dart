// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'runtime_capabilities.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$RuntimeCapabilitiesCWProxy {
  RuntimeCapabilities schemaVersion(int schemaVersion);

  RuntimeCapabilities features(Set<String> features);

  RuntimeCapabilities imports(ImportCapabilities imports);

  /// Creates a new instance with the provided field values.
  /// Passing `null` to a nullable field nullifies it, while `null` for a non-nullable field is ignored. To update a single field use `RuntimeCapabilities(...).copyWith.fieldName(value)`.
  ///
  /// Example:
  /// ```dart
  /// RuntimeCapabilities(...).copyWith(id: 12, name: "My name")
  /// ```
  RuntimeCapabilities call({
    int schemaVersion,
    Set<String> features,
    ImportCapabilities imports,
  });
}

/// Callable proxy for `copyWith` functionality.
/// Use as `instanceOfRuntimeCapabilities.copyWith(...)` or call `instanceOfRuntimeCapabilities.copyWith.fieldName(value)` for a single field.
class _$RuntimeCapabilitiesCWProxyImpl implements _$RuntimeCapabilitiesCWProxy {
  const _$RuntimeCapabilitiesCWProxyImpl(this._value);

  final RuntimeCapabilities _value;

  @override
  RuntimeCapabilities schemaVersion(int schemaVersion) =>
      call(schemaVersion: schemaVersion);

  @override
  RuntimeCapabilities features(Set<String> features) =>
      call(features: features);

  @override
  RuntimeCapabilities imports(ImportCapabilities imports) =>
      call(imports: imports);

  /// Creates a new instance with the provided field values.
  /// Passing `null` to a nullable field nullifies it, while `null` for a non-nullable field is ignored. To update a single field use `RuntimeCapabilities(...).copyWith.fieldName(value)`.
  ///
  /// Example:
  /// ```dart
  /// RuntimeCapabilities(...).copyWith(id: 12, name: "My name")
  /// ```
  @override
  RuntimeCapabilities call({
    Object? schemaVersion = const $CopyWithPlaceholder(),
    Object? features = const $CopyWithPlaceholder(),
    Object? imports = const $CopyWithPlaceholder(),
  }) {
    return RuntimeCapabilities(
      schemaVersion:
          schemaVersion == const $CopyWithPlaceholder() || schemaVersion == null
          ? _value.schemaVersion
          // ignore: cast_nullable_to_non_nullable
          : schemaVersion as int,
      features: features == const $CopyWithPlaceholder() || features == null
          ? _value.features
          // ignore: cast_nullable_to_non_nullable
          : features as Set<String>,
      imports: imports == const $CopyWithPlaceholder() || imports == null
          ? _value.imports
          // ignore: cast_nullable_to_non_nullable
          : imports as ImportCapabilities,
    );
  }
}

extension $RuntimeCapabilitiesCopyWith on RuntimeCapabilities {
  /// Returns a callable class used to build a new instance with modified fields.
  /// Example: `instanceOfRuntimeCapabilities.copyWith(...)` or `instanceOfRuntimeCapabilities.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$RuntimeCapabilitiesCWProxy get copyWith =>
      _$RuntimeCapabilitiesCWProxyImpl(this);
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

RuntimeCapabilities _$RuntimeCapabilitiesFromJson(Map<String, dynamic> json) =>
    $checkedCreate('RuntimeCapabilities', json, ($checkedConvert) {
      $checkKeys(
        json,
        requiredKeys: const ['schema_version', 'features', 'imports'],
      );
      final val = RuntimeCapabilities(
        schemaVersion: $checkedConvert(
          'schema_version',
          (v) => (v as num).toInt(),
        ),
        features: $checkedConvert(
          'features',
          (v) => (v as List<dynamic>).map((e) => e as String).toSet(),
        ),
        imports: $checkedConvert(
          'imports',
          (v) => ImportCapabilities.fromJson(v as Map<String, dynamic>),
        ),
      );
      return val;
    }, fieldKeyMap: const {'schemaVersion': 'schema_version'});

Map<String, dynamic> _$RuntimeCapabilitiesToJson(
  RuntimeCapabilities instance,
) => <String, dynamic>{
  'schema_version': instance.schemaVersion,
  'features': instance.features.toList(),
  'imports': instance.imports.toJson(),
};
