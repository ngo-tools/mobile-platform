//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:ngotools_api/src/generated/model/runtime_capabilities.dart';
import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:json_annotation/json_annotation.dart';

part 'capabilities_response.g.dart';

@CopyWith()
@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class CapabilitiesResponse {
  /// Returns a new [CapabilitiesResponse] instance.
  CapabilitiesResponse({required this.data});

  @JsonKey(name: r'data', required: true, includeIfNull: false)
  final RuntimeCapabilities data;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CapabilitiesResponse && other.data == data;

  @override
  int get hashCode => data.hashCode;

  factory CapabilitiesResponse.fromJson(Map<String, dynamic> json) =>
      _$CapabilitiesResponseFromJson(json);

  Map<String, dynamic> toJson() => _$CapabilitiesResponseToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }
}
