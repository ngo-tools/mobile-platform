//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:ngotools_api/src/generated/model/import_capabilities.dart';
import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:json_annotation/json_annotation.dart';

part 'runtime_capabilities.g.dart';

@CopyWith()
@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class RuntimeCapabilities {
  /// Returns a new [RuntimeCapabilities] instance.
  RuntimeCapabilities({
    required this.schemaVersion,

    required this.features,

    required this.imports,
  });

  // minimum: 1
  @JsonKey(name: r'schema_version', required: true, includeIfNull: false)
  final int schemaVersion;

  @JsonKey(name: r'features', required: true, includeIfNull: false)
  final Set<String> features;

  @JsonKey(name: r'imports', required: true, includeIfNull: false)
  final ImportCapabilities imports;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is RuntimeCapabilities &&
          other.schemaVersion == schemaVersion &&
          other.features == features &&
          other.imports == imports;

  @override
  int get hashCode =>
      schemaVersion.hashCode + features.hashCode + imports.hashCode;

  factory RuntimeCapabilities.fromJson(Map<String, dynamic> json) =>
      _$RuntimeCapabilitiesFromJson(json);

  Map<String, dynamic> toJson() => _$RuntimeCapabilitiesToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }
}
