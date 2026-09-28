// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'event_collection_response.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$EventCollectionResponseCWProxy {
  EventCollectionResponse data(List<EventSummary> data);

  /// Creates a new instance with the provided field values.
  /// Passing `null` to a nullable field nullifies it, while `null` for a non-nullable field is ignored. To update a single field use `EventCollectionResponse(...).copyWith.fieldName(value)`.
  ///
  /// Example:
  /// ```dart
  /// EventCollectionResponse(...).copyWith(id: 12, name: "My name")
  /// ```
  EventCollectionResponse call({List<EventSummary> data});
}

/// Callable proxy for `copyWith` functionality.
/// Use as `instanceOfEventCollectionResponse.copyWith(...)` or call `instanceOfEventCollectionResponse.copyWith.fieldName(value)` for a single field.
class _$EventCollectionResponseCWProxyImpl
    implements _$EventCollectionResponseCWProxy {
  const _$EventCollectionResponseCWProxyImpl(this._value);

  final EventCollectionResponse _value;

  @override
  EventCollectionResponse data(List<EventSummary> data) => call(data: data);

  /// Creates a new instance with the provided field values.
  /// Passing `null` to a nullable field nullifies it, while `null` for a non-nullable field is ignored. To update a single field use `EventCollectionResponse(...).copyWith.fieldName(value)`.
  ///
  /// Example:
  /// ```dart
  /// EventCollectionResponse(...).copyWith(id: 12, name: "My name")
  /// ```
  @override
  EventCollectionResponse call({Object? data = const $CopyWithPlaceholder()}) {
    return EventCollectionResponse(
      data: data == const $CopyWithPlaceholder() || data == null
          ? _value.data
          // ignore: cast_nullable_to_non_nullable
          : data as List<EventSummary>,
    );
  }
}

extension $EventCollectionResponseCopyWith on EventCollectionResponse {
  /// Returns a callable class used to build a new instance with modified fields.
  /// Example: `instanceOfEventCollectionResponse.copyWith(...)` or `instanceOfEventCollectionResponse.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$EventCollectionResponseCWProxy get copyWith =>
      _$EventCollectionResponseCWProxyImpl(this);
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

EventCollectionResponse _$EventCollectionResponseFromJson(
  Map<String, dynamic> json,
) => $checkedCreate('EventCollectionResponse', json, ($checkedConvert) {
  $checkKeys(json, requiredKeys: const ['data']);
  final val = EventCollectionResponse(
    data: $checkedConvert(
      'data',
      (v) => (v as List<dynamic>)
          .map((e) => EventSummary.fromJson(e as Map<String, dynamic>))
          .toList(),
    ),
  );
  return val;
});

Map<String, dynamic> _$EventCollectionResponseToJson(
  EventCollectionResponse instance,
) => <String, dynamic>{'data': instance.data.map((e) => e.toJson()).toList()};
