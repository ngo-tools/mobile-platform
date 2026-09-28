// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'event_availability_collection_response.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$EventAvailabilityCollectionResponseCWProxy {
  EventAvailabilityCollectionResponse data(List<EventAvailability> data);

  /// Creates a new instance with the provided field values.
  /// Passing `null` to a nullable field nullifies it, while `null` for a non-nullable field is ignored. To update a single field use `EventAvailabilityCollectionResponse(...).copyWith.fieldName(value)`.
  ///
  /// Example:
  /// ```dart
  /// EventAvailabilityCollectionResponse(...).copyWith(id: 12, name: "My name")
  /// ```
  EventAvailabilityCollectionResponse call({List<EventAvailability> data});
}

/// Callable proxy for `copyWith` functionality.
/// Use as `instanceOfEventAvailabilityCollectionResponse.copyWith(...)` or call `instanceOfEventAvailabilityCollectionResponse.copyWith.fieldName(value)` for a single field.
class _$EventAvailabilityCollectionResponseCWProxyImpl
    implements _$EventAvailabilityCollectionResponseCWProxy {
  const _$EventAvailabilityCollectionResponseCWProxyImpl(this._value);

  final EventAvailabilityCollectionResponse _value;

  @override
  EventAvailabilityCollectionResponse data(List<EventAvailability> data) =>
      call(data: data);

  /// Creates a new instance with the provided field values.
  /// Passing `null` to a nullable field nullifies it, while `null` for a non-nullable field is ignored. To update a single field use `EventAvailabilityCollectionResponse(...).copyWith.fieldName(value)`.
  ///
  /// Example:
  /// ```dart
  /// EventAvailabilityCollectionResponse(...).copyWith(id: 12, name: "My name")
  /// ```
  @override
  EventAvailabilityCollectionResponse call({
    Object? data = const $CopyWithPlaceholder(),
  }) {
    return EventAvailabilityCollectionResponse(
      data: data == const $CopyWithPlaceholder() || data == null
          ? _value.data
          // ignore: cast_nullable_to_non_nullable
          : data as List<EventAvailability>,
    );
  }
}

extension $EventAvailabilityCollectionResponseCopyWith
    on EventAvailabilityCollectionResponse {
  /// Returns a callable class used to build a new instance with modified fields.
  /// Example: `instanceOfEventAvailabilityCollectionResponse.copyWith(...)` or `instanceOfEventAvailabilityCollectionResponse.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$EventAvailabilityCollectionResponseCWProxy get copyWith =>
      _$EventAvailabilityCollectionResponseCWProxyImpl(this);
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

EventAvailabilityCollectionResponse
_$EventAvailabilityCollectionResponseFromJson(Map<String, dynamic> json) =>
    $checkedCreate('EventAvailabilityCollectionResponse', json, (
      $checkedConvert,
    ) {
      $checkKeys(json, requiredKeys: const ['data']);
      final val = EventAvailabilityCollectionResponse(
        data: $checkedConvert(
          'data',
          (v) => (v as List<dynamic>)
              .map((e) => EventAvailability.fromJson(e as Map<String, dynamic>))
              .toList(),
        ),
      );
      return val;
    });

Map<String, dynamic> _$EventAvailabilityCollectionResponseToJson(
  EventAvailabilityCollectionResponse instance,
) => <String, dynamic>{'data': instance.data.map((e) => e.toJson()).toList()};
