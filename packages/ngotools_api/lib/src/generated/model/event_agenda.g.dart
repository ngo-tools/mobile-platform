// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'event_agenda.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$EventAgendaCWProxy {
  EventAgenda completed(bool completed);

  EventAgenda items(List<EventAgendaEntry> items);

  /// Creates a new instance with the provided field values.
  /// Passing `null` to a nullable field nullifies it, while `null` for a non-nullable field is ignored. To update a single field use `EventAgenda(...).copyWith.fieldName(value)`.
  ///
  /// Example:
  /// ```dart
  /// EventAgenda(...).copyWith(id: 12, name: "My name")
  /// ```
  EventAgenda call({bool completed, List<EventAgendaEntry> items});
}

/// Callable proxy for `copyWith` functionality.
/// Use as `instanceOfEventAgenda.copyWith(...)` or call `instanceOfEventAgenda.copyWith.fieldName(value)` for a single field.
class _$EventAgendaCWProxyImpl implements _$EventAgendaCWProxy {
  const _$EventAgendaCWProxyImpl(this._value);

  final EventAgenda _value;

  @override
  EventAgenda completed(bool completed) => call(completed: completed);

  @override
  EventAgenda items(List<EventAgendaEntry> items) => call(items: items);

  /// Creates a new instance with the provided field values.
  /// Passing `null` to a nullable field nullifies it, while `null` for a non-nullable field is ignored. To update a single field use `EventAgenda(...).copyWith.fieldName(value)`.
  ///
  /// Example:
  /// ```dart
  /// EventAgenda(...).copyWith(id: 12, name: "My name")
  /// ```
  @override
  EventAgenda call({
    Object? completed = const $CopyWithPlaceholder(),
    Object? items = const $CopyWithPlaceholder(),
  }) {
    return EventAgenda(
      completed: completed == const $CopyWithPlaceholder() || completed == null
          ? _value.completed
          // ignore: cast_nullable_to_non_nullable
          : completed as bool,
      items: items == const $CopyWithPlaceholder() || items == null
          ? _value.items
          // ignore: cast_nullable_to_non_nullable
          : items as List<EventAgendaEntry>,
    );
  }
}

extension $EventAgendaCopyWith on EventAgenda {
  /// Returns a callable class used to build a new instance with modified fields.
  /// Example: `instanceOfEventAgenda.copyWith(...)` or `instanceOfEventAgenda.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$EventAgendaCWProxy get copyWith => _$EventAgendaCWProxyImpl(this);
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

EventAgenda _$EventAgendaFromJson(Map<String, dynamic> json) =>
    $checkedCreate('EventAgenda', json, ($checkedConvert) {
      $checkKeys(json, requiredKeys: const ['completed', 'items']);
      final val = EventAgenda(
        completed: $checkedConvert('completed', (v) => v as bool),
        items: $checkedConvert(
          'items',
          (v) => (v as List<dynamic>)
              .map((e) => EventAgendaEntry.fromJson(e as Map<String, dynamic>))
              .toList(),
        ),
      );
      return val;
    });

Map<String, dynamic> _$EventAgendaToJson(EventAgenda instance) =>
    <String, dynamic>{
      'completed': instance.completed,
      'items': instance.items.map((e) => e.toJson()).toList(),
    };
