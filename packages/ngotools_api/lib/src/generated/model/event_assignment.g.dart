// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'event_assignment.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$EventAssignmentCWProxy {
  EventAssignment id(int id);

  EventAssignment event(EventReference event);

  EventAssignment service(EventServiceReference service);

  /// Creates a new instance with the provided field values.
  /// Passing `null` to a nullable field nullifies it, while `null` for a non-nullable field is ignored. To update a single field use `EventAssignment(...).copyWith.fieldName(value)`.
  ///
  /// Example:
  /// ```dart
  /// EventAssignment(...).copyWith(id: 12, name: "My name")
  /// ```
  EventAssignment call({
    int id,
    EventReference event,
    EventServiceReference service,
  });
}

/// Callable proxy for `copyWith` functionality.
/// Use as `instanceOfEventAssignment.copyWith(...)` or call `instanceOfEventAssignment.copyWith.fieldName(value)` for a single field.
class _$EventAssignmentCWProxyImpl implements _$EventAssignmentCWProxy {
  const _$EventAssignmentCWProxyImpl(this._value);

  final EventAssignment _value;

  @override
  EventAssignment id(int id) => call(id: id);

  @override
  EventAssignment event(EventReference event) => call(event: event);

  @override
  EventAssignment service(EventServiceReference service) =>
      call(service: service);

  /// Creates a new instance with the provided field values.
  /// Passing `null` to a nullable field nullifies it, while `null` for a non-nullable field is ignored. To update a single field use `EventAssignment(...).copyWith.fieldName(value)`.
  ///
  /// Example:
  /// ```dart
  /// EventAssignment(...).copyWith(id: 12, name: "My name")
  /// ```
  @override
  EventAssignment call({
    Object? id = const $CopyWithPlaceholder(),
    Object? event = const $CopyWithPlaceholder(),
    Object? service = const $CopyWithPlaceholder(),
  }) {
    return EventAssignment(
      id: id == const $CopyWithPlaceholder() || id == null
          ? _value.id
          // ignore: cast_nullable_to_non_nullable
          : id as int,
      event: event == const $CopyWithPlaceholder() || event == null
          ? _value.event
          // ignore: cast_nullable_to_non_nullable
          : event as EventReference,
      service: service == const $CopyWithPlaceholder() || service == null
          ? _value.service
          // ignore: cast_nullable_to_non_nullable
          : service as EventServiceReference,
    );
  }
}

extension $EventAssignmentCopyWith on EventAssignment {
  /// Returns a callable class used to build a new instance with modified fields.
  /// Example: `instanceOfEventAssignment.copyWith(...)` or `instanceOfEventAssignment.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$EventAssignmentCWProxy get copyWith => _$EventAssignmentCWProxyImpl(this);
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

EventAssignment _$EventAssignmentFromJson(Map<String, dynamic> json) =>
    $checkedCreate('EventAssignment', json, ($checkedConvert) {
      $checkKeys(json, requiredKeys: const ['id', 'event', 'service']);
      final val = EventAssignment(
        id: $checkedConvert('id', (v) => (v as num).toInt()),
        event: $checkedConvert(
          'event',
          (v) => EventReference.fromJson(v as Map<String, dynamic>),
        ),
        service: $checkedConvert(
          'service',
          (v) => EventServiceReference.fromJson(v as Map<String, dynamic>),
        ),
      );
      return val;
    });

Map<String, dynamic> _$EventAssignmentToJson(EventAssignment instance) =>
    <String, dynamic>{
      'id': instance.id,
      'event': instance.event.toJson(),
      'service': instance.service.toJson(),
    };
