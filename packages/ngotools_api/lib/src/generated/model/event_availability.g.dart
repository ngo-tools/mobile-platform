// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'event_availability.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$EventAvailabilityCWProxy {
  EventAvailability event(EventReference event);

  EventAvailability service(EventServiceReference service);

  EventAvailability status(EventAvailabilityStatusEnum status);

  /// Creates a new instance with the provided field values.
  /// Passing `null` to a nullable field nullifies it, while `null` for a non-nullable field is ignored. To update a single field use `EventAvailability(...).copyWith.fieldName(value)`.
  ///
  /// Example:
  /// ```dart
  /// EventAvailability(...).copyWith(id: 12, name: "My name")
  /// ```
  EventAvailability call({
    EventReference event,
    EventServiceReference service,
    EventAvailabilityStatusEnum status,
  });
}

/// Callable proxy for `copyWith` functionality.
/// Use as `instanceOfEventAvailability.copyWith(...)` or call `instanceOfEventAvailability.copyWith.fieldName(value)` for a single field.
class _$EventAvailabilityCWProxyImpl implements _$EventAvailabilityCWProxy {
  const _$EventAvailabilityCWProxyImpl(this._value);

  final EventAvailability _value;

  @override
  EventAvailability event(EventReference event) => call(event: event);

  @override
  EventAvailability service(EventServiceReference service) =>
      call(service: service);

  @override
  EventAvailability status(EventAvailabilityStatusEnum status) =>
      call(status: status);

  /// Creates a new instance with the provided field values.
  /// Passing `null` to a nullable field nullifies it, while `null` for a non-nullable field is ignored. To update a single field use `EventAvailability(...).copyWith.fieldName(value)`.
  ///
  /// Example:
  /// ```dart
  /// EventAvailability(...).copyWith(id: 12, name: "My name")
  /// ```
  @override
  EventAvailability call({
    Object? event = const $CopyWithPlaceholder(),
    Object? service = const $CopyWithPlaceholder(),
    Object? status = const $CopyWithPlaceholder(),
  }) {
    return EventAvailability(
      event: event == const $CopyWithPlaceholder() || event == null
          ? _value.event
          // ignore: cast_nullable_to_non_nullable
          : event as EventReference,
      service: service == const $CopyWithPlaceholder() || service == null
          ? _value.service
          // ignore: cast_nullable_to_non_nullable
          : service as EventServiceReference,
      status: status == const $CopyWithPlaceholder() || status == null
          ? _value.status
          // ignore: cast_nullable_to_non_nullable
          : status as EventAvailabilityStatusEnum,
    );
  }
}

extension $EventAvailabilityCopyWith on EventAvailability {
  /// Returns a callable class used to build a new instance with modified fields.
  /// Example: `instanceOfEventAvailability.copyWith(...)` or `instanceOfEventAvailability.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$EventAvailabilityCWProxy get copyWith =>
      _$EventAvailabilityCWProxyImpl(this);
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

EventAvailability _$EventAvailabilityFromJson(Map<String, dynamic> json) =>
    $checkedCreate('EventAvailability', json, ($checkedConvert) {
      $checkKeys(json, requiredKeys: const ['event', 'service', 'status']);
      final val = EventAvailability(
        event: $checkedConvert(
          'event',
          (v) => EventReference.fromJson(v as Map<String, dynamic>),
        ),
        service: $checkedConvert(
          'service',
          (v) => EventServiceReference.fromJson(v as Map<String, dynamic>),
        ),
        status: $checkedConvert(
          'status',
          (v) => $enumDecode(
            _$EventAvailabilityStatusEnumEnumMap,
            v,
            unknownValue: EventAvailabilityStatusEnum.unknownDefaultOpenApi,
          ),
        ),
      );
      return val;
    });

Map<String, dynamic> _$EventAvailabilityToJson(EventAvailability instance) =>
    <String, dynamic>{
      'event': instance.event.toJson(),
      'service': instance.service.toJson(),
      'status': _$EventAvailabilityStatusEnumEnumMap[instance.status]!,
    };

const _$EventAvailabilityStatusEnumEnumMap = {
  EventAvailabilityStatusEnum.available: 'available',
  EventAvailabilityStatusEnum.notAvailable: 'not-available',
  EventAvailabilityStatusEnum.ifNeedsMust: 'if-needs-must',
  EventAvailabilityStatusEnum.notSet: 'not-set',
  EventAvailabilityStatusEnum.unknownDefaultOpenApi: 'unknown_default_open_api',
};
