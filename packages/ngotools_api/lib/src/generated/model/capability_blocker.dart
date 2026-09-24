//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:json_annotation/json_annotation.dart';

part 'capability_blocker.g.dart';

@CopyWith()
@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class CapabilityBlocker {
  /// Returns a new [CapabilityBlocker] instance.
  CapabilityBlocker({required this.code, required this.message});

  @JsonKey(name: r'code', required: true, includeIfNull: false)
  final String code;

  @JsonKey(name: r'message', required: true, includeIfNull: false)
  final String message;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CapabilityBlocker &&
          other.code == code &&
          other.message == message;

  @override
  int get hashCode => code.hashCode + message.hashCode;

  factory CapabilityBlocker.fromJson(Map<String, dynamic> json) =>
      _$CapabilityBlockerFromJson(json);

  Map<String, dynamic> toJson() => _$CapabilityBlockerToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }
}
