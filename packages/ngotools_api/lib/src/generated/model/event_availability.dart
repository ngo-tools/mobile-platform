//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:ngotools_api/src/generated/model/event_reference.dart';
import 'package:ngotools_api/src/generated/model/event_service_reference.dart';
import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:json_annotation/json_annotation.dart';

part 'event_availability.g.dart';

@CopyWith()
@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class EventAvailability {
  /// Returns a new [EventAvailability] instance.
  EventAvailability({
    required this.event,

    required this.service,

    required this.status,
  });

  @JsonKey(name: r'event', required: true, includeIfNull: false)
  final EventReference event;

  @JsonKey(name: r'service', required: true, includeIfNull: false)
  final EventServiceReference service;

  @JsonKey(
    name: r'status',
    required: true,
    includeIfNull: false,
    unknownEnumValue: EventAvailabilityStatusEnum.unknownDefaultOpenApi,
  )
  final EventAvailabilityStatusEnum status;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is EventAvailability &&
          other.event == event &&
          other.service == service &&
          other.status == status;

  @override
  int get hashCode => event.hashCode + service.hashCode + status.hashCode;

  factory EventAvailability.fromJson(Map<String, dynamic> json) =>
      _$EventAvailabilityFromJson(json);

  Map<String, dynamic> toJson() => _$EventAvailabilityToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }
}

enum EventAvailabilityStatusEnum {
  @JsonValue(r'available')
  available(r'available'),
  @JsonValue(r'not-available')
  notAvailable(r'not-available'),
  @JsonValue(r'if-needs-must')
  ifNeedsMust(r'if-needs-must'),
  @JsonValue(r'not-set')
  notSet(r'not-set'),
  @JsonValue(r'unknown_default_open_api')
  unknownDefaultOpenApi(r'unknown_default_open_api');

  const EventAvailabilityStatusEnum(this.value);

  final String value;

  @override
  String toString() => value;
}
