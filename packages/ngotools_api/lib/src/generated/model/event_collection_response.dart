//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:ngotools_api/src/generated/model/event_summary.dart';
import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:json_annotation/json_annotation.dart';

part 'event_collection_response.g.dart';

@CopyWith()
@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class EventCollectionResponse {
  /// Returns a new [EventCollectionResponse] instance.
  EventCollectionResponse({required this.data});

  @JsonKey(name: r'data', required: true, includeIfNull: false)
  final List<EventSummary> data;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is EventCollectionResponse && other.data == data;

  @override
  int get hashCode => data.hashCode;

  factory EventCollectionResponse.fromJson(Map<String, dynamic> json) =>
      _$EventCollectionResponseFromJson(json);

  Map<String, dynamic> toJson() => _$EventCollectionResponseToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }
}
