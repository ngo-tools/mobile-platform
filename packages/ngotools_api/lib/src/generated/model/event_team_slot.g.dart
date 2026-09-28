// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'event_team_slot.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$EventTeamSlotCWProxy {
  EventTeamSlot service(EventServiceReference service);

  EventTeamSlot required_(int required_);

  EventTeamSlot open(int open);

  EventTeamSlot members(List<EventPerson> members);

  /// Creates a new instance with the provided field values.
  /// Passing `null` to a nullable field nullifies it, while `null` for a non-nullable field is ignored. To update a single field use `EventTeamSlot(...).copyWith.fieldName(value)`.
  ///
  /// Example:
  /// ```dart
  /// EventTeamSlot(...).copyWith(id: 12, name: "My name")
  /// ```
  EventTeamSlot call({
    EventServiceReference service,
    int required_,
    int open,
    List<EventPerson> members,
  });
}

/// Callable proxy for `copyWith` functionality.
/// Use as `instanceOfEventTeamSlot.copyWith(...)` or call `instanceOfEventTeamSlot.copyWith.fieldName(value)` for a single field.
class _$EventTeamSlotCWProxyImpl implements _$EventTeamSlotCWProxy {
  const _$EventTeamSlotCWProxyImpl(this._value);

  final EventTeamSlot _value;

  @override
  EventTeamSlot service(EventServiceReference service) =>
      call(service: service);

  @override
  EventTeamSlot required_(int required_) => call(required_: required_);

  @override
  EventTeamSlot open(int open) => call(open: open);

  @override
  EventTeamSlot members(List<EventPerson> members) => call(members: members);

  /// Creates a new instance with the provided field values.
  /// Passing `null` to a nullable field nullifies it, while `null` for a non-nullable field is ignored. To update a single field use `EventTeamSlot(...).copyWith.fieldName(value)`.
  ///
  /// Example:
  /// ```dart
  /// EventTeamSlot(...).copyWith(id: 12, name: "My name")
  /// ```
  @override
  EventTeamSlot call({
    Object? service = const $CopyWithPlaceholder(),
    Object? required_ = const $CopyWithPlaceholder(),
    Object? open = const $CopyWithPlaceholder(),
    Object? members = const $CopyWithPlaceholder(),
  }) {
    return EventTeamSlot(
      service: service == const $CopyWithPlaceholder() || service == null
          ? _value.service
          // ignore: cast_nullable_to_non_nullable
          : service as EventServiceReference,
      required_: required_ == const $CopyWithPlaceholder() || required_ == null
          ? _value.required_
          // ignore: cast_nullable_to_non_nullable
          : required_ as int,
      open: open == const $CopyWithPlaceholder() || open == null
          ? _value.open
          // ignore: cast_nullable_to_non_nullable
          : open as int,
      members: members == const $CopyWithPlaceholder() || members == null
          ? _value.members
          // ignore: cast_nullable_to_non_nullable
          : members as List<EventPerson>,
    );
  }
}

extension $EventTeamSlotCopyWith on EventTeamSlot {
  /// Returns a callable class used to build a new instance with modified fields.
  /// Example: `instanceOfEventTeamSlot.copyWith(...)` or `instanceOfEventTeamSlot.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$EventTeamSlotCWProxy get copyWith => _$EventTeamSlotCWProxyImpl(this);
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

EventTeamSlot _$EventTeamSlotFromJson(Map<String, dynamic> json) =>
    $checkedCreate('EventTeamSlot', json, ($checkedConvert) {
      $checkKeys(
        json,
        requiredKeys: const ['service', 'required', 'open', 'members'],
      );
      final val = EventTeamSlot(
        service: $checkedConvert(
          'service',
          (v) => EventServiceReference.fromJson(v as Map<String, dynamic>),
        ),
        required_: $checkedConvert('required', (v) => (v as num).toInt()),
        open: $checkedConvert('open', (v) => (v as num).toInt()),
        members: $checkedConvert(
          'members',
          (v) => (v as List<dynamic>)
              .map((e) => EventPerson.fromJson(e as Map<String, dynamic>))
              .toList(),
        ),
      );
      return val;
    }, fieldKeyMap: const {'required_': 'required'});

Map<String, dynamic> _$EventTeamSlotToJson(EventTeamSlot instance) =>
    <String, dynamic>{
      'service': instance.service.toJson(),
      'required': instance.required_,
      'open': instance.open,
      'members': instance.members.map((e) => e.toJson()).toList(),
    };
