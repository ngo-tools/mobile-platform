//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:ngotools_api/src/generated/model/event_assignment.dart';
import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:json_annotation/json_annotation.dart';

part 'event_assignment_collection_response.g.dart';

@CopyWith()
@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class EventAssignmentCollectionResponse {
  /// Returns a new [EventAssignmentCollectionResponse] instance.
  EventAssignmentCollectionResponse({required this.data});

  @JsonKey(name: r'data', required: true, includeIfNull: false)
  final List<EventAssignment> data;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is EventAssignmentCollectionResponse && other.data == data;

  @override
  int get hashCode => data.hashCode;

  factory EventAssignmentCollectionResponse.fromJson(
    Map<String, dynamic> json,
  ) => _$EventAssignmentCollectionResponseFromJson(json);

  Map<String, dynamic> toJson() =>
      _$EventAssignmentCollectionResponseToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }
}
