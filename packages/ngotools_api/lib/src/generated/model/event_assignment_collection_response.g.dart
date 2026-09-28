// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'event_assignment_collection_response.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$EventAssignmentCollectionResponseCWProxy {
  EventAssignmentCollectionResponse data(List<EventAssignment> data);

  /// Creates a new instance with the provided field values.
  /// Passing `null` to a nullable field nullifies it, while `null` for a non-nullable field is ignored. To update a single field use `EventAssignmentCollectionResponse(...).copyWith.fieldName(value)`.
  ///
  /// Example:
  /// ```dart
  /// EventAssignmentCollectionResponse(...).copyWith(id: 12, name: "My name")
  /// ```
  EventAssignmentCollectionResponse call({List<EventAssignment> data});
}

/// Callable proxy for `copyWith` functionality.
/// Use as `instanceOfEventAssignmentCollectionResponse.copyWith(...)` or call `instanceOfEventAssignmentCollectionResponse.copyWith.fieldName(value)` for a single field.
class _$EventAssignmentCollectionResponseCWProxyImpl
    implements _$EventAssignmentCollectionResponseCWProxy {
  const _$EventAssignmentCollectionResponseCWProxyImpl(this._value);

  final EventAssignmentCollectionResponse _value;

  @override
  EventAssignmentCollectionResponse data(List<EventAssignment> data) =>
      call(data: data);

  /// Creates a new instance with the provided field values.
  /// Passing `null` to a nullable field nullifies it, while `null` for a non-nullable field is ignored. To update a single field use `EventAssignmentCollectionResponse(...).copyWith.fieldName(value)`.
  ///
  /// Example:
  /// ```dart
  /// EventAssignmentCollectionResponse(...).copyWith(id: 12, name: "My name")
  /// ```
  @override
  EventAssignmentCollectionResponse call({
    Object? data = const $CopyWithPlaceholder(),
  }) {
    return EventAssignmentCollectionResponse(
      data: data == const $CopyWithPlaceholder() || data == null
          ? _value.data
          // ignore: cast_nullable_to_non_nullable
          : data as List<EventAssignment>,
    );
  }
}

extension $EventAssignmentCollectionResponseCopyWith
    on EventAssignmentCollectionResponse {
  /// Returns a callable class used to build a new instance with modified fields.
  /// Example: `instanceOfEventAssignmentCollectionResponse.copyWith(...)` or `instanceOfEventAssignmentCollectionResponse.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$EventAssignmentCollectionResponseCWProxy get copyWith =>
      _$EventAssignmentCollectionResponseCWProxyImpl(this);
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

EventAssignmentCollectionResponse _$EventAssignmentCollectionResponseFromJson(
  Map<String, dynamic> json,
) => $checkedCreate('EventAssignmentCollectionResponse', json, (
  $checkedConvert,
) {
  $checkKeys(json, requiredKeys: const ['data']);
  final val = EventAssignmentCollectionResponse(
    data: $checkedConvert(
      'data',
      (v) => (v as List<dynamic>)
          .map((e) => EventAssignment.fromJson(e as Map<String, dynamic>))
          .toList(),
    ),
  );
  return val;
});

Map<String, dynamic> _$EventAssignmentCollectionResponseToJson(
  EventAssignmentCollectionResponse instance,
) => <String, dynamic>{'data': instance.data.map((e) => e.toJson()).toList()};
