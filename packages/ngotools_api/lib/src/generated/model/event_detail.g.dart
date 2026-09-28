// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'event_detail.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$EventDetailCWProxy {
  EventDetail id(int id);

  EventDetail name(String name);

  EventDetail type(EventTypeReference? type);

  EventDetail start(DateTime start);

  EventDetail end(DateTime end);

  EventDetail allDay(bool allDay);

  EventDetail planningCompleted(bool planningCompleted);

  EventDetail myServices(List<EventServiceReference> myServices);

  EventDetail availabilityOpen(bool availabilityOpen);

  EventDetail details(String? details);

  EventDetail agenda(EventAgenda? agenda);

  EventDetail team(List<EventTeamSlot> team);

  /// Creates a new instance with the provided field values.
  /// Passing `null` to a nullable field nullifies it, while `null` for a non-nullable field is ignored. To update a single field use `EventDetail(...).copyWith.fieldName(value)`.
  ///
  /// Example:
  /// ```dart
  /// EventDetail(...).copyWith(id: 12, name: "My name")
  /// ```
  EventDetail call({
    int id,
    String name,
    EventTypeReference? type,
    DateTime start,
    DateTime end,
    bool allDay,
    bool planningCompleted,
    List<EventServiceReference> myServices,
    bool availabilityOpen,
    String? details,
    EventAgenda? agenda,
    List<EventTeamSlot> team,
  });
}

/// Callable proxy for `copyWith` functionality.
/// Use as `instanceOfEventDetail.copyWith(...)` or call `instanceOfEventDetail.copyWith.fieldName(value)` for a single field.
class _$EventDetailCWProxyImpl implements _$EventDetailCWProxy {
  const _$EventDetailCWProxyImpl(this._value);

  final EventDetail _value;

  @override
  EventDetail id(int id) => call(id: id);

  @override
  EventDetail name(String name) => call(name: name);

  @override
  EventDetail type(EventTypeReference? type) => call(type: type);

  @override
  EventDetail start(DateTime start) => call(start: start);

  @override
  EventDetail end(DateTime end) => call(end: end);

  @override
  EventDetail allDay(bool allDay) => call(allDay: allDay);

  @override
  EventDetail planningCompleted(bool planningCompleted) =>
      call(planningCompleted: planningCompleted);

  @override
  EventDetail myServices(List<EventServiceReference> myServices) =>
      call(myServices: myServices);

  @override
  EventDetail availabilityOpen(bool availabilityOpen) =>
      call(availabilityOpen: availabilityOpen);

  @override
  EventDetail details(String? details) => call(details: details);

  @override
  EventDetail agenda(EventAgenda? agenda) => call(agenda: agenda);

  @override
  EventDetail team(List<EventTeamSlot> team) => call(team: team);

  /// Creates a new instance with the provided field values.
  /// Passing `null` to a nullable field nullifies it, while `null` for a non-nullable field is ignored. To update a single field use `EventDetail(...).copyWith.fieldName(value)`.
  ///
  /// Example:
  /// ```dart
  /// EventDetail(...).copyWith(id: 12, name: "My name")
  /// ```
  @override
  EventDetail call({
    Object? id = const $CopyWithPlaceholder(),
    Object? name = const $CopyWithPlaceholder(),
    Object? type = const $CopyWithPlaceholder(),
    Object? start = const $CopyWithPlaceholder(),
    Object? end = const $CopyWithPlaceholder(),
    Object? allDay = const $CopyWithPlaceholder(),
    Object? planningCompleted = const $CopyWithPlaceholder(),
    Object? myServices = const $CopyWithPlaceholder(),
    Object? availabilityOpen = const $CopyWithPlaceholder(),
    Object? details = const $CopyWithPlaceholder(),
    Object? agenda = const $CopyWithPlaceholder(),
    Object? team = const $CopyWithPlaceholder(),
  }) {
    return EventDetail(
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
      details: details == const $CopyWithPlaceholder()
          ? _value.details
          // ignore: cast_nullable_to_non_nullable
          : details as String?,
      agenda: agenda == const $CopyWithPlaceholder()
          ? _value.agenda
          // ignore: cast_nullable_to_non_nullable
          : agenda as EventAgenda?,
      team: team == const $CopyWithPlaceholder() || team == null
          ? _value.team
          // ignore: cast_nullable_to_non_nullable
          : team as List<EventTeamSlot>,
    );
  }
}

extension $EventDetailCopyWith on EventDetail {
  /// Returns a callable class used to build a new instance with modified fields.
  /// Example: `instanceOfEventDetail.copyWith(...)` or `instanceOfEventDetail.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$EventDetailCWProxy get copyWith => _$EventDetailCWProxyImpl(this);
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

EventDetail _$EventDetailFromJson(Map<String, dynamic> json) => $checkedCreate(
  'EventDetail',
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
        'team',
      ],
    );
    final val = EventDetail(
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
              (e) => EventServiceReference.fromJson(e as Map<String, dynamic>),
            )
            .toList(),
      ),
      availabilityOpen: $checkedConvert('availability_open', (v) => v as bool),
      details: $checkedConvert('details', (v) => v as String?),
      agenda: $checkedConvert(
        'agenda',
        (v) =>
            v == null ? null : EventAgenda.fromJson(v as Map<String, dynamic>),
      ),
      team: $checkedConvert(
        'team',
        (v) => (v as List<dynamic>)
            .map((e) => EventTeamSlot.fromJson(e as Map<String, dynamic>))
            .toList(),
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

Map<String, dynamic> _$EventDetailToJson(EventDetail instance) =>
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
      'details': ?instance.details,
      'agenda': ?instance.agenda?.toJson(),
      'team': instance.team.map((e) => e.toJson()).toList(),
    };
