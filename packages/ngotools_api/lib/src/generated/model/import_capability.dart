//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:ngotools_api/src/generated/model/capability_blocker.dart';
import 'package:ngotools_api/src/generated/model/import_limits.dart';
import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:json_annotation/json_annotation.dart';

part 'import_capability.g.dart';

@CopyWith()
@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class ImportCapability {
  /// Returns a new [ImportCapability] instance.
  ImportCapability({
    this.label,

    required this.supported,

    required this.requiredFeature,

    required this.featureEnabled,

    required this.permissionGranted,

    required this.available,

    required this.requires,

    required this.batchImportSupported,

    required this.blockers,

    this.limits,
  });

  @JsonKey(name: r'label', required: false, includeIfNull: false)
  final String? label;

  @JsonKey(name: r'supported', required: true, includeIfNull: false)
  final bool supported;

  @JsonKey(name: r'required_feature', required: true, includeIfNull: false)
  final String requiredFeature;

  @JsonKey(name: r'feature_enabled', required: true, includeIfNull: false)
  final bool featureEnabled;

  @JsonKey(name: r'permission_granted', required: true, includeIfNull: false)
  final bool permissionGranted;

  @JsonKey(name: r'available', required: true, includeIfNull: false)
  final bool available;

  @JsonKey(name: r'requires', required: true, includeIfNull: false)
  final Set<String> requires;

  @JsonKey(
    name: r'batch_import_supported',
    required: true,
    includeIfNull: false,
  )
  final bool batchImportSupported;

  @JsonKey(name: r'blockers', required: true, includeIfNull: false)
  final List<CapabilityBlocker> blockers;

  @JsonKey(name: r'limits', required: false, includeIfNull: false)
  final ImportLimits? limits;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ImportCapability &&
          other.label == label &&
          other.supported == supported &&
          other.requiredFeature == requiredFeature &&
          other.featureEnabled == featureEnabled &&
          other.permissionGranted == permissionGranted &&
          other.available == available &&
          other.requires == requires &&
          other.batchImportSupported == batchImportSupported &&
          other.blockers == blockers &&
          other.limits == limits;

  @override
  int get hashCode =>
      (label == null ? 0 : label.hashCode) +
      supported.hashCode +
      requiredFeature.hashCode +
      featureEnabled.hashCode +
      permissionGranted.hashCode +
      available.hashCode +
      requires.hashCode +
      batchImportSupported.hashCode +
      blockers.hashCode +
      (limits == null ? 0 : limits.hashCode);

  factory ImportCapability.fromJson(Map<String, dynamic> json) =>
      _$ImportCapabilityFromJson(json);

  Map<String, dynamic> toJson() => _$ImportCapabilityToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }
}
