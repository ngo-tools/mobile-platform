//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:ngotools_api/src/generated/model/event_availability.dart';
import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:json_annotation/json_annotation.dart';

part 'event_availability_response.g.dart';

@CopyWith()
@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class EventAvailabilityResponse {
  /// Returns a new [EventAvailabilityResponse] instance.
  EventAvailabilityResponse({required this.data});

  @JsonKey(name: r'data', required: true, includeIfNull: false)
  final EventAvailability data;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is EventAvailabilityResponse && other.data == data;

  @override
  int get hashCode => data.hashCode;

  factory EventAvailabilityResponse.fromJson(Map<String, dynamic> json) =>
      _$EventAvailabilityResponseFromJson(json);

  Map<String, dynamic> toJson() => _$EventAvailabilityResponseToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }
}
