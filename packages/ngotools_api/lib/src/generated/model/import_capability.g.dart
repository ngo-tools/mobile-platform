// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'import_capability.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$ImportCapabilityCWProxy {
  ImportCapability label(String? label);

  ImportCapability supported(bool supported);

  ImportCapability requiredFeature(String requiredFeature);

  ImportCapability featureEnabled(bool featureEnabled);

  ImportCapability permissionGranted(bool permissionGranted);

  ImportCapability available(bool available);

  ImportCapability requires(Set<String> requires);

  ImportCapability batchImportSupported(bool batchImportSupported);

  ImportCapability blockers(List<CapabilityBlocker> blockers);

  ImportCapability limits(ImportLimits? limits);

  /// Creates a new instance with the provided field values.
  /// Passing `null` to a nullable field nullifies it, while `null` for a non-nullable field is ignored. To update a single field use `ImportCapability(...).copyWith.fieldName(value)`.
  ///
  /// Example:
  /// ```dart
  /// ImportCapability(...).copyWith(id: 12, name: "My name")
  /// ```
  ImportCapability call({
    String? label,
    bool supported,
    String requiredFeature,
    bool featureEnabled,
    bool permissionGranted,
    bool available,
    Set<String> requires,
    bool batchImportSupported,
    List<CapabilityBlocker> blockers,
    ImportLimits? limits,
  });
}

/// Callable proxy for `copyWith` functionality.
/// Use as `instanceOfImportCapability.copyWith(...)` or call `instanceOfImportCapability.copyWith.fieldName(value)` for a single field.
class _$ImportCapabilityCWProxyImpl implements _$ImportCapabilityCWProxy {
  const _$ImportCapabilityCWProxyImpl(this._value);

  final ImportCapability _value;

  @override
  ImportCapability label(String? label) => call(label: label);

  @override
  ImportCapability supported(bool supported) => call(supported: supported);

  @override
  ImportCapability requiredFeature(String requiredFeature) =>
      call(requiredFeature: requiredFeature);

  @override
  ImportCapability featureEnabled(bool featureEnabled) =>
      call(featureEnabled: featureEnabled);

  @override
  ImportCapability permissionGranted(bool permissionGranted) =>
      call(permissionGranted: permissionGranted);

  @override
  ImportCapability available(bool available) => call(available: available);

  @override
  ImportCapability requires(Set<String> requires) => call(requires: requires);

  @override
  ImportCapability batchImportSupported(bool batchImportSupported) =>
      call(batchImportSupported: batchImportSupported);

  @override
  ImportCapability blockers(List<CapabilityBlocker> blockers) =>
      call(blockers: blockers);

  @override
  ImportCapability limits(ImportLimits? limits) => call(limits: limits);

  /// Creates a new instance with the provided field values.
  /// Passing `null` to a nullable field nullifies it, while `null` for a non-nullable field is ignored. To update a single field use `ImportCapability(...).copyWith.fieldName(value)`.
  ///
  /// Example:
  /// ```dart
  /// ImportCapability(...).copyWith(id: 12, name: "My name")
  /// ```
  @override
  ImportCapability call({
    Object? label = const $CopyWithPlaceholder(),
    Object? supported = const $CopyWithPlaceholder(),
    Object? requiredFeature = const $CopyWithPlaceholder(),
    Object? featureEnabled = const $CopyWithPlaceholder(),
    Object? permissionGranted = const $CopyWithPlaceholder(),
    Object? available = const $CopyWithPlaceholder(),
    Object? requires = const $CopyWithPlaceholder(),
    Object? batchImportSupported = const $CopyWithPlaceholder(),
    Object? blockers = const $CopyWithPlaceholder(),
    Object? limits = const $CopyWithPlaceholder(),
  }) {
    return ImportCapability(
      label: label == const $CopyWithPlaceholder()
          ? _value.label
          // ignore: cast_nullable_to_non_nullable
          : label as String?,
      supported: supported == const $CopyWithPlaceholder() || supported == null
          ? _value.supported
          // ignore: cast_nullable_to_non_nullable
          : supported as bool,
      requiredFeature:
          requiredFeature == const $CopyWithPlaceholder() ||
              requiredFeature == null
          ? _value.requiredFeature
          // ignore: cast_nullable_to_non_nullable
          : requiredFeature as String,
      featureEnabled:
          featureEnabled == const $CopyWithPlaceholder() ||
              featureEnabled == null
          ? _value.featureEnabled
          // ignore: cast_nullable_to_non_nullable
          : featureEnabled as bool,
      permissionGranted:
          permissionGranted == const $CopyWithPlaceholder() ||
              permissionGranted == null
          ? _value.permissionGranted
          // ignore: cast_nullable_to_non_nullable
          : permissionGranted as bool,
      available: available == const $CopyWithPlaceholder() || available == null
          ? _value.available
          // ignore: cast_nullable_to_non_nullable
          : available as bool,
      requires: requires == const $CopyWithPlaceholder() || requires == null
          ? _value.requires
          // ignore: cast_nullable_to_non_nullable
          : requires as Set<String>,
      batchImportSupported:
          batchImportSupported == const $CopyWithPlaceholder() ||
              batchImportSupported == null
          ? _value.batchImportSupported
          // ignore: cast_nullable_to_non_nullable
          : batchImportSupported as bool,
      blockers: blockers == const $CopyWithPlaceholder() || blockers == null
          ? _value.blockers
          // ignore: cast_nullable_to_non_nullable
          : blockers as List<CapabilityBlocker>,
      limits: limits == const $CopyWithPlaceholder()
          ? _value.limits
          // ignore: cast_nullable_to_non_nullable
          : limits as ImportLimits?,
    );
  }
}

extension $ImportCapabilityCopyWith on ImportCapability {
  /// Returns a callable class used to build a new instance with modified fields.
  /// Example: `instanceOfImportCapability.copyWith(...)` or `instanceOfImportCapability.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$ImportCapabilityCWProxy get copyWith => _$ImportCapabilityCWProxyImpl(this);
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ImportCapability _$ImportCapabilityFromJson(
  Map<String, dynamic> json,
) => $checkedCreate(
  'ImportCapability',
  json,
  ($checkedConvert) {
    $checkKeys(
      json,
      requiredKeys: const [
        'supported',
        'required_feature',
        'feature_enabled',
        'permission_granted',
        'available',
        'requires',
        'batch_import_supported',
        'blockers',
      ],
    );
    final val = ImportCapability(
      label: $checkedConvert('label', (v) => v as String?),
      supported: $checkedConvert('supported', (v) => v as bool),
      requiredFeature: $checkedConvert('required_feature', (v) => v as String),
      featureEnabled: $checkedConvert('feature_enabled', (v) => v as bool),
      permissionGranted: $checkedConvert(
        'permission_granted',
        (v) => v as bool,
      ),
      available: $checkedConvert('available', (v) => v as bool),
      requires: $checkedConvert(
        'requires',
        (v) => (v as List<dynamic>).map((e) => e as String).toSet(),
      ),
      batchImportSupported: $checkedConvert(
        'batch_import_supported',
        (v) => v as bool,
      ),
      blockers: $checkedConvert(
        'blockers',
        (v) => (v as List<dynamic>)
            .map((e) => CapabilityBlocker.fromJson(e as Map<String, dynamic>))
            .toList(),
      ),
      limits: $checkedConvert(
        'limits',
        (v) =>
            v == null ? null : ImportLimits.fromJson(v as Map<String, dynamic>),
      ),
    );
    return val;
  },
  fieldKeyMap: const {
    'requiredFeature': 'required_feature',
    'featureEnabled': 'feature_enabled',
    'permissionGranted': 'permission_granted',
    'batchImportSupported': 'batch_import_supported',
  },
);

Map<String, dynamic> _$ImportCapabilityToJson(ImportCapability instance) =>
    <String, dynamic>{
      'label': ?instance.label,
      'supported': instance.supported,
      'required_feature': instance.requiredFeature,
      'feature_enabled': instance.featureEnabled,
      'permission_granted': instance.permissionGranted,
      'available': instance.available,
      'requires': instance.requires.toList(),
      'batch_import_supported': instance.batchImportSupported,
      'blockers': instance.blockers.map((e) => e.toJson()).toList(),
      'limits': ?instance.limits?.toJson(),
    };
