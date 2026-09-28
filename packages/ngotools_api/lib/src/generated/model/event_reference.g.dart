// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'event_reference.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$EventReferenceCWProxy {
  EventReference id(int id);

  EventReference name(String name);

  EventReference start(DateTime start);

  EventReference end(DateTime end);

  EventReference allDay(bool allDay);

  /// Creates a new instance with the provided field values.
  /// Passing `null` to a nullable field nullifies it, while `null` for a non-nullable field is ignored. To update a single field use `EventReference(...).copyWith.fieldName(value)`.
  ///
  /// Example:
  /// ```dart
  /// EventReference(...).copyWith(id: 12, name: "My name")
  /// ```
  EventReference call({
    int id,
    String name,
    DateTime start,
    DateTime end,
    bool allDay,
  });
}

/// Callable proxy for `copyWith` functionality.
/// Use as `instanceOfEventReference.copyWith(...)` or call `instanceOfEventReference.copyWith.fieldName(value)` for a single field.
class _$EventReferenceCWProxyImpl implements _$EventReferenceCWProxy {
  const _$EventReferenceCWProxyImpl(this._value);

  final EventReference _value;

  @override
  EventReference id(int id) => call(id: id);

  @override
  EventReference name(String name) => call(name: name);

  @override
  EventReference start(DateTime start) => call(start: start);

  @override
  EventReference end(DateTime end) => call(end: end);

  @override
  EventReference allDay(bool allDay) => call(allDay: allDay);

  /// Creates a new instance with the provided field values.
  /// Passing `null` to a nullable field nullifies it, while `null` for a non-nullable field is ignored. To update a single field use `EventReference(...).copyWith.fieldName(value)`.
  ///
  /// Example:
  /// ```dart
  /// EventReference(...).copyWith(id: 12, name: "My name")
  /// ```
  @override
  EventReference call({
    Object? id = const $CopyWithPlaceholder(),
    Object? name = const $CopyWithPlaceholder(),
    Object? start = const $CopyWithPlaceholder(),
    Object? end = const $CopyWithPlaceholder(),
    Object? allDay = const $CopyWithPlaceholder(),
  }) {
    return EventReference(
      id: id == const $CopyWithPlaceholder() || id == null
          ? _value.id
          // ignore: cast_nullable_to_non_nullable
          : id as int,
      name: name == const $CopyWithPlaceholder() || name == null
          ? _value.name
          // ignore: cast_nullable_to_non_nullable
          : name as String,
      start: start == const $CopyWithPlaceholder() || start == null
          ? _value.start
          // ignore: cast_nullable_to_non_nullable
          : start as DateTime,
      end: end == const $CopyWithPlaceholder() || end == null
          ? _value.end
          // ignore: cast_nullable_to_non_nullable
          : end as DateTime,
      allDay: allDay == const $CopyWithPlaceholder() || allDay == null
          ? _value.allDay
          // ignore: cast_nullable_to_non_nullable
          : allDay as bool,
    );
  }
}

extension $EventReferenceCopyWith on EventReference {
  /// Returns a callable class used to build a new instance with modified fields.
  /// Example: `instanceOfEventReference.copyWith(...)` or `instanceOfEventReference.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$EventReferenceCWProxy get copyWith => _$EventReferenceCWProxyImpl(this);
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

EventReference _$EventReferenceFromJson(Map<String, dynamic> json) =>
    $checkedCreate('EventReference', json, ($checkedConvert) {
      $checkKeys(
        json,
        requiredKeys: const ['id', 'name', 'start', 'end', 'all_day'],
      );
      final val = EventReference(
        id: $checkedConvert('id', (v) => (v as num).toInt()),
        name: $checkedConvert('name', (v) => v as String),
        start: $checkedConvert('start', (v) => DateTime.parse(v as String)),
        end: $checkedConvert('end', (v) => DateTime.parse(v as String)),
        allDay: $checkedConvert('all_day', (v) => v as bool),
      );
      return val;
    }, fieldKeyMap: const {'allDay': 'all_day'});

Map<String, dynamic> _$EventReferenceToJson(EventReference instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'start': instance.start.toIso8601String(),
      'end': instance.end.toIso8601String(),
      'all_day': instance.allDay,
    };
