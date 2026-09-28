// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'event_response.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$EventResponseCWProxy {
  EventResponse data(EventDetail data);

  /// Creates a new instance with the provided field values.
  /// Passing `null` to a nullable field nullifies it, while `null` for a non-nullable field is ignored. To update a single field use `EventResponse(...).copyWith.fieldName(value)`.
  ///
  /// Example:
  /// ```dart
  /// EventResponse(...).copyWith(id: 12, name: "My name")
  /// ```
  EventResponse call({EventDetail data});
}

/// Callable proxy for `copyWith` functionality.
/// Use as `instanceOfEventResponse.copyWith(...)` or call `instanceOfEventResponse.copyWith.fieldName(value)` for a single field.
class _$EventResponseCWProxyImpl implements _$EventResponseCWProxy {
  const _$EventResponseCWProxyImpl(this._value);

  final EventResponse _value;

  @override
  EventResponse data(EventDetail data) => call(data: data);

  /// Creates a new instance with the provided field values.
  /// Passing `null` to a nullable field nullifies it, while `null` for a non-nullable field is ignored. To update a single field use `EventResponse(...).copyWith.fieldName(value)`.
  ///
  /// Example:
  /// ```dart
  /// EventResponse(...).copyWith(id: 12, name: "My name")
  /// ```
  @override
  EventResponse call({Object? data = const $CopyWithPlaceholder()}) {
    return EventResponse(
      data: data == const $CopyWithPlaceholder() || data == null
          ? _value.data
          // ignore: cast_nullable_to_non_nullable
          : data as EventDetail,
    );
  }
}

extension $EventResponseCopyWith on EventResponse {
  /// Returns a callable class used to build a new instance with modified fields.
  /// Example: `instanceOfEventResponse.copyWith(...)` or `instanceOfEventResponse.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$EventResponseCWProxy get copyWith => _$EventResponseCWProxyImpl(this);
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

EventResponse _$EventResponseFromJson(Map<String, dynamic> json) =>
    $checkedCreate('EventResponse', json, ($checkedConvert) {
      $checkKeys(json, requiredKeys: const ['data']);
      final val = EventResponse(
        data: $checkedConvert(
          'data',
          (v) => EventDetail.fromJson(v as Map<String, dynamic>),
        ),
      );
      return val;
    });

Map<String, dynamic> _$EventResponseToJson(EventResponse instance) =>
    <String, dynamic>{'data': instance.data.toJson()};
