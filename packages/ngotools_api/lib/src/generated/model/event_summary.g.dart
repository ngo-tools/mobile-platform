// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'event_summary.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$EventSummaryCWProxy {
  EventSummary id(int id);

  EventSummary name(String name);

  EventSummary type(EventTypeReference? type);

  EventSummary start(DateTime start);

  EventSummary end(DateTime end);

  EventSummary allDay(bool allDay);

  EventSummary planningCompleted(bool planningCompleted);

  EventSummary myServices(List<EventServiceReference> myServices);

  EventSummary availabilityOpen(bool availabilityOpen);

  /// Creates a new instance with the provided field values.
  /// Passing `null` to a nullable field nullifies it, while `null` for a non-nullable field is ignored. To update a single field use `EventSummary(...).copyWith.fieldName(value)`.
  ///
  /// Example:
  /// ```dart
  /// EventSummary(...).copyWith(id: 12, name: "My name")
  /// ```
  EventSummary call({
    int id,
    String name,
    EventTypeReference? type,
    DateTime start,
    DateTime end,
    bool allDay,
    bool planningCompleted,
    List<EventServiceReference> myServices,
    bool availabilityOpen,
  });
}

/// Callable proxy for `copyWith` functionality.
/// Use as `instanceOfEventSummary.copyWith(...)` or call `instanceOfEventSummary.copyWith.fieldName(value)` for a single field.
class _$EventSummaryCWProxyImpl implements _$EventSummaryCWProxy {
  const _$EventSummaryCWProxyImpl(this._value);

  final EventSummary _value;

  @override
  EventSummary id(int id) => call(id: id);

  @override
  EventSummary name(String name) => call(name: name);

  @override
  EventSummary type(EventTypeReference? type) => call(type: type);

  @override
  EventSummary start(DateTime start) => call(start: start);

  @override
  EventSummary end(DateTime end) => call(end: end);

  @override
  EventSummary allDay(bool allDay) => call(allDay: allDay);

  @override
  EventSummary planningCompleted(bool planningCompleted) =>
      call(planningCompleted: planningCompleted);

  @override
  EventSummary myServices(List<EventServiceReference> myServices) =>
      call(myServices: myServices);

  @override
  EventSummary availabilityOpen(bool availabilityOpen) =>
      call(availabilityOpen: availabilityOpen);

  /// Creates a new instance with the provided field values.
  /// Passing `null` to a nullable field nullifies it, while `null` for a non-nullable field is ignored. To update a single field use `EventSummary(...).copyWith.fieldName(value)`.
  ///
  /// Example:
  /// ```dart
  /// EventSummary(...).copyWith(id: 12, name: "My name")
  /// ```
  @override
  EventSummary call({
    Object? id = const $CopyWithPlaceholder(),
    Object? name = const $CopyWithPlaceholder(),
    Object? type = const $CopyWithPlaceholder(),
    Object? start = const $CopyWithPlaceholder(),
    Object? end = const $CopyWithPlaceholder(),
    Object? allDay = const $CopyWithPlaceholder(),
    Object? planningCompleted = const $CopyWithPlaceholder(),
    Object? myServices = const $CopyWithPlaceholder(),
    Object? availabilityOpen = const $CopyWithPlaceholder(),
  }) {
    return EventSummary(
      id: id == const $CopyWithPlaceholder() || id == null
          ? _value.id
          // ignore: cast_nullable_to_non_nullable
          : id as int,
      name: name == const $CopyWithPlaceholder() || name == null
          ? _value.name
          // ignore: cast_nullable_to_non_nullable
          : name as String,
      type: type == const $CopyWithPlaceholder()
          ? _value.type
          // ignore: cast_nullable_to_non_nullable
          : type as EventTypeReference?,
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
      planningCompleted:
          planningCompleted == const $CopyWithPlaceholder() ||
              planningCompleted == null
          ? _value.planningCompleted
          // ignore: cast_nullable_to_non_nullable
          : planningCompleted as bool,
      myServices:
          myServices == const $CopyWithPlaceholder() || myServices == null
          ? _value.myServices
          // ignore: cast_nullable_to_non_nullable
          : myServices as List<EventServiceReference>,
      availabilityOpen:
          availabilityOpen == const $CopyWithPlaceholder() ||
              availabilityOpen == null
          ? _value.availabilityOpen
          // ignore: cast_nullable_to_non_nullable
          : availabilityOpen as bool,
    );
  }
}

extension $EventSummaryCopyWith on EventSummary {
  /// Returns a callable class used to build a new instance with modified fields.
  /// Example: `instanceOfEventSummary.copyWith(...)` or `instanceOfEventSummary.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$EventSummaryCWProxy get copyWith => _$EventSummaryCWProxyImpl(this);
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

EventSummary _$EventSummaryFromJson(Map<String, dynamic> json) =>
    $checkedCreate(
      'EventSummary',
      json,
      ($checkedConvert) {
        $checkKeys(
          json,
          requiredKeys: const [
            'id',
            'name',
            'start',
            'end',
            'all_day',
            'planning_completed',
            'my_services',
            'availability_open',
          ],
        );
        final val = EventSummary(
          id: $checkedConvert('id', (v) => (v as num).toInt()),
          name: $checkedConvert('name', (v) => v as String),
          type: $checkedConvert(
            'type',
            (v) => v == null
                ? null
                : EventTypeReference.fromJson(v as Map<String, dynamic>),
          ),
          start: $checkedConvert('start', (v) => DateTime.parse(v as String)),
          end: $checkedConvert('end', (v) => DateTime.parse(v as String)),
          allDay: $checkedConvert('all_day', (v) => v as bool),
          planningCompleted: $checkedConvert(
            'planning_completed',
            (v) => v as bool,
          ),
          myServices: $checkedConvert(
            'my_services',
            (v) => (v as List<dynamic>)
                .map(
                  (e) =>
                      EventServiceReference.fromJson(e as Map<String, dynamic>),
                )
                .toList(),
          ),
          availabilityOpen: $checkedConvert(
            'availability_open',
            (v) => v as bool,
          ),
        );
        return val;
      },
      fieldKeyMap: const {
        'allDay': 'all_day',
        'planningCompleted': 'planning_completed',
        'myServices': 'my_services',
        'availabilityOpen': 'availability_open',
      },
    );

Map<String, dynamic> _$EventSummaryToJson(EventSummary instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'type': ?instance.type?.toJson(),
      'start': instance.start.toIso8601String(),
      'end': instance.end.toIso8601String(),
      'all_day': instance.allDay,
      'planning_completed': instance.planningCompleted,
      'my_services': instance.myServices.map((e) => e.toJson()).toList(),
      'availability_open': instance.availabilityOpen,
    };
