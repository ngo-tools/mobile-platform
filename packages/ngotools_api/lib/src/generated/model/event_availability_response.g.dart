// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'event_availability_response.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$EventAvailabilityResponseCWProxy {
  EventAvailabilityResponse data(EventAvailability data);

  /// Creates a new instance with the provided field values.
  /// Passing `null` to a nullable field nullifies it, while `null` for a non-nullable field is ignored. To update a single field use `EventAvailabilityResponse(...).copyWith.fieldName(value)`.
  ///
  /// Example:
  /// ```dart
  /// EventAvailabilityResponse(...).copyWith(id: 12, name: "My name")
  /// ```
  EventAvailabilityResponse call({EventAvailability data});
}

/// Callable proxy for `copyWith` functionality.
/// Use as `instanceOfEventAvailabilityResponse.copyWith(...)` or call `instanceOfEventAvailabilityResponse.copyWith.fieldName(value)` for a single field.
class _$EventAvailabilityResponseCWProxyImpl
    implements _$EventAvailabilityResponseCWProxy {
  const _$EventAvailabilityResponseCWProxyImpl(this._value);

  final EventAvailabilityResponse _value;

  @override
  EventAvailabilityResponse data(EventAvailability data) => call(data: data);

  /// Creates a new instance with the provided field values.
  /// Passing `null` to a nullable field nullifies it, while `null` for a non-nullable field is ignored. To update a single field use `EventAvailabilityResponse(...).copyWith.fieldName(value)`.
  ///
  /// Example:
  /// ```dart
  /// EventAvailabilityResponse(...).copyWith(id: 12, name: "My name")
  /// ```
  @override
  EventAvailabilityResponse call({
    Object? data = const $CopyWithPlaceholder(),
  }) {
    return EventAvailabilityResponse(
      data: data == const $CopyWithPlaceholder() || data == null
          ? _value.data
          // ignore: cast_nullable_to_non_nullable
          : data as EventAvailability,
    );
  }
}

extension $EventAvailabilityResponseCopyWith on EventAvailabilityResponse {
  /// Returns a callable class used to build a new instance with modified fields.
  /// Example: `instanceOfEventAvailabilityResponse.copyWith(...)` or `instanceOfEventAvailabilityResponse.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$EventAvailabilityResponseCWProxy get copyWith =>
      _$EventAvailabilityResponseCWProxyImpl(this);
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

EventAvailabilityResponse _$EventAvailabilityResponseFromJson(
  Map<String, dynamic> json,
) => $checkedCreate('EventAvailabilityResponse', json, ($checkedConvert) {
  $checkKeys(json, requiredKeys: const ['data']);
  final val = EventAvailabilityResponse(
    data: $checkedConvert(
      'data',
      (v) => EventAvailability.fromJson(v as Map<String, dynamic>),
    ),
  );
  return val;
});

Map<String, dynamic> _$EventAvailabilityResponseToJson(
  EventAvailabilityResponse instance,
) => <String, dynamic>{'data': instance.data.toJson()};
