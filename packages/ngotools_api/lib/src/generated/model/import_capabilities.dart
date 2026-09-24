//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:ngotools_api/src/generated/model/import_capability.dart';
import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:json_annotation/json_annotation.dart';

part 'import_capabilities.g.dart';

@CopyWith()
@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class ImportCapabilities {
  /// Returns a new [ImportCapabilities] instance.
  ImportCapabilities({required this.enabled, required this.types});

  @JsonKey(name: r'enabled', required: true, includeIfNull: false)
  final bool enabled;

  @JsonKey(name: r'types', required: true, includeIfNull: false)
  final Map<String, ImportCapability> types;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ImportCapabilities &&
          other.enabled == enabled &&
          other.types == types;

  @override
  int get hashCode => enabled.hashCode + types.hashCode;

  factory ImportCapabilities.fromJson(Map<String, dynamic> json) =>
      _$ImportCapabilitiesFromJson(json);

  Map<String, dynamic> toJson() => _$ImportCapabilitiesToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }
}
