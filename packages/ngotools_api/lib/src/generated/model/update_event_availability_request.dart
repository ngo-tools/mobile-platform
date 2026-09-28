//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:json_annotation/json_annotation.dart';

part 'update_event_availability_request.g.dart';

@CopyWith()
@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class UpdateEventAvailabilityRequest {
  /// Returns a new [UpdateEventAvailabilityRequest] instance.
  UpdateEventAvailabilityRequest({required this.status});

  @JsonKey(
    name: r'status',
    required: true,
    includeIfNull: false,
    unknownEnumValue:
        UpdateEventAvailabilityRequestStatusEnum.unknownDefaultOpenApi,
  )
  final UpdateEventAvailabilityRequestStatusEnum status;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is UpdateEventAvailabilityRequest && other.status == status;

  @override
  int get hashCode => status.hashCode;

  factory UpdateEventAvailabilityRequest.fromJson(Map<String, dynamic> json) =>
      _$UpdateEventAvailabilityRequestFromJson(json);

  Map<String, dynamic> toJson() => _$UpdateEventAvailabilityRequestToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }
}

enum UpdateEventAvailabilityRequestStatusEnum {
  @JsonValue(r'available')
  available(r'available'),
  @JsonValue(r'not-available')
  notAvailable(r'not-available'),
  @JsonValue(r'if-needs-must')
  ifNeedsMust(r'if-needs-must'),
  @JsonValue(r'unknown_default_open_api')
  unknownDefaultOpenApi(r'unknown_default_open_api');

  const UpdateEventAvailabilityRequestStatusEnum(this.value);

  final String value;

  @override
  String toString() => value;
}
