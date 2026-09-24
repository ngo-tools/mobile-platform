//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:json_annotation/json_annotation.dart';

part 'import_limits.g.dart';

@CopyWith()
@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class ImportLimits {
  /// Returns a new [ImportLimits] instance.
  ImportLimits({required this.maxBatchSize});

  // minimum: 1
  @JsonKey(name: r'max_batch_size', required: true, includeIfNull: false)
  final int maxBatchSize;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ImportLimits && other.maxBatchSize == maxBatchSize;

  @override
  int get hashCode => maxBatchSize.hashCode;

  factory ImportLimits.fromJson(Map<String, dynamic> json) =>
      _$ImportLimitsFromJson(json);

  Map<String, dynamic> toJson() => _$ImportLimitsToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }
}
