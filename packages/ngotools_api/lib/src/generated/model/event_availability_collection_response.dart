//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:ngotools_api/src/generated/model/event_availability.dart';
import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:json_annotation/json_annotation.dart';

part 'event_availability_collection_response.g.dart';

@CopyWith()
@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class EventAvailabilityCollectionResponse {
  /// Returns a new [EventAvailabilityCollectionResponse] instance.
  EventAvailabilityCollectionResponse({required this.data});

  @JsonKey(name: r'data', required: true, includeIfNull: false)
  final List<EventAvailability> data;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is EventAvailabilityCollectionResponse && other.data == data;

  @override
  int get hashCode => data.hashCode;

  factory EventAvailabilityCollectionResponse.fromJson(
    Map<String, dynamic> json,
  ) => _$EventAvailabilityCollectionResponseFromJson(json);

  Map<String, dynamic> toJson() =>
      _$EventAvailabilityCollectionResponseToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }
}
