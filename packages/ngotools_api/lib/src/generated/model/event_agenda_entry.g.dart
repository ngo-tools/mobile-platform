// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'event_agenda_entry.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$EventAgendaEntryCWProxy {
  EventAgendaEntry id(int id);

  EventAgendaEntry type(String type);

  EventAgendaEntry name(String? name);

  EventAgendaEntry key(String? key);

  EventAgendaEntry language(String? language);

  EventAgendaEntry items(List<EventAgendaSubItem> items);

  EventAgendaEntry startsAt(DateTime startsAt);

  EventAgendaEntry durationMinutes(int? durationMinutes);

  EventAgendaEntry responsibleService(
    EventServiceReference? responsibleService,
  );

  EventAgendaEntry responsible(List<EventPerson> responsible);

  EventAgendaEntry isMine(bool isMine);

  /// Creates a new instance with the provided field values.
  /// Passing `null` to a nullable field nullifies it, while `null` for a non-nullable field is ignored. To update a single field use `EventAgendaEntry(...).copyWith.fieldName(value)`.
  ///
  /// Example:
  /// ```dart
  /// EventAgendaEntry(...).copyWith(id: 12, name: "My name")
  /// ```
  EventAgendaEntry call({
    int id,
    String type,
    String? name,
    String? key,
    String? language,
    List<EventAgendaSubItem> items,
    DateTime startsAt,
    int? durationMinutes,
    EventServiceReference? responsibleService,
    List<EventPerson> responsible,
    bool isMine,
  });
}

/// Callable proxy for `copyWith` functionality.
/// Use as `instanceOfEventAgendaEntry.copyWith(...)` or call `instanceOfEventAgendaEntry.copyWith.fieldName(value)` for a single field.
class _$EventAgendaEntryCWProxyImpl implements _$EventAgendaEntryCWProxy {
  const _$EventAgendaEntryCWProxyImpl(this._value);

  final EventAgendaEntry _value;

  @override
  EventAgendaEntry id(int id) => call(id: id);

  @override
  EventAgendaEntry type(String type) => call(type: type);

  @override
  EventAgendaEntry name(String? name) => call(name: name);

  @override
  EventAgendaEntry key(String? key) => call(key: key);

  @override
  EventAgendaEntry language(String? language) => call(language: language);

  @override
  EventAgendaEntry items(List<EventAgendaSubItem> items) => call(items: items);

  @override
  EventAgendaEntry startsAt(DateTime startsAt) => call(startsAt: startsAt);

  @override
  EventAgendaEntry durationMinutes(int? durationMinutes) =>
      call(durationMinutes: durationMinutes);

  @override
  EventAgendaEntry responsibleService(
    EventServiceReference? responsibleService,
  ) => call(responsibleService: responsibleService);

  @override
  EventAgendaEntry responsible(List<EventPerson> responsible) =>
      call(responsible: responsible);

  @override
  EventAgendaEntry isMine(bool isMine) => call(isMine: isMine);

  /// Creates a new instance with the provided field values.
  /// Passing `null` to a nullable field nullifies it, while `null` for a non-nullable field is ignored. To update a single field use `EventAgendaEntry(...).copyWith.fieldName(value)`.
  ///
  /// Example:
  /// ```dart
  /// EventAgendaEntry(...).copyWith(id: 12, name: "My name")
  /// ```
  @override
  EventAgendaEntry call({
    Object? id = const $CopyWithPlaceholder(),
    Object? type = const $CopyWithPlaceholder(),
    Object? name = const $CopyWithPlaceholder(),
    Object? key = const $CopyWithPlaceholder(),
    Object? language = const $CopyWithPlaceholder(),
    Object? items = const $CopyWithPlaceholder(),
    Object? startsAt = const $CopyWithPlaceholder(),
    Object? durationMinutes = const $CopyWithPlaceholder(),
    Object? responsibleService = const $CopyWithPlaceholder(),
    Object? responsible = const $CopyWithPlaceholder(),
    Object? isMine = const $CopyWithPlaceholder(),
  }) {
    return EventAgendaEntry(
      id: id == const $CopyWithPlaceholder() || id == null
          ? _value.id
          // ignore: cast_nullable_to_non_nullable
          : id as int,
      type: type == const $CopyWithPlaceholder() || type == null
          ? _value.type
          // ignore: cast_nullable_to_non_nullable
          : type as String,
      name: name == const $CopyWithPlaceholder()
          ? _value.name
          // ignore: cast_nullable_to_non_nullable
          : name as String?,
      key: key == const $CopyWithPlaceholder()
          ? _value.key
          // ignore: cast_nullable_to_non_nullable
          : key as String?,
      language: language == const $CopyWithPlaceholder()
          ? _value.language
          // ignore: cast_nullable_to_non_nullable
          : language as String?,
      items: items == const $CopyWithPlaceholder() || items == null
          ? _value.items
          // ignore: cast_nullable_to_non_nullable
          : items as List<EventAgendaSubItem>,
      startsAt: startsAt == const $CopyWithPlaceholder() || startsAt == null
          ? _value.startsAt
          // ignore: cast_nullable_to_non_nullable
          : startsAt as DateTime,
      durationMinutes: durationMinutes == const $CopyWithPlaceholder()
          ? _value.durationMinutes
          // ignore: cast_nullable_to_non_nullable
          : durationMinutes as int?,
      responsibleService: responsibleService == const $CopyWithPlaceholder()
          ? _value.responsibleService
          // ignore: cast_nullable_to_non_nullable
          : responsibleService as EventServiceReference?,
      responsible:
          responsible == const $CopyWithPlaceholder() || responsible == null
          ? _value.responsible
          // ignore: cast_nullable_to_non_nullable
          : responsible as List<EventPerson>,
      isMine: isMine == const $CopyWithPlaceholder() || isMine == null
          ? _value.isMine
          // ignore: cast_nullable_to_non_nullable
          : isMine as bool,
    );
  }
}

extension $EventAgendaEntryCopyWith on EventAgendaEntry {
  /// Returns a callable class used to build a new instance with modified fields.
  /// Example: `instanceOfEventAgendaEntry.copyWith(...)` or `instanceOfEventAgendaEntry.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$EventAgendaEntryCWProxy get copyWith => _$EventAgendaEntryCWProxyImpl(this);
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

EventAgendaEntry _$EventAgendaEntryFromJson(Map<String, dynamic> json) =>
    $checkedCreate(
      'EventAgendaEntry',
      json,
      ($checkedConvert) {
        $checkKeys(
          json,
          requiredKeys: const [
            'id',
            'type',
            'items',
            'starts_at',
            'responsible',
            'is_mine',
          ],
        );
        final val = EventAgendaEntry(
          id: $checkedConvert('id', (v) => (v as num).toInt()),
          type: $checkedConvert('type', (v) => v as String),
          name: $checkedConvert('name', (v) => v as String?),
          key: $checkedConvert('key', (v) => v as String?),
          language: $checkedConvert('language', (v) => v as String?),
          items: $checkedConvert(
            'items',
            (v) => (v as List<dynamic>)
                .map(
                  (e) => EventAgendaSubItem.fromJson(e as Map<String, dynamic>),
                )
                .toList(),
          ),
          startsAt: $checkedConvert(
            'starts_at',
            (v) => DateTime.parse(v as String),
          ),
          durationMinutes: $checkedConvert(
            'duration_minutes',
            (v) => (v as num?)?.toInt(),
          ),
          responsibleService: $checkedConvert(
            'responsible_service',
            (v) => v == null
                ? null
                : EventServiceReference.fromJson(v as Map<String, dynamic>),
          ),
          responsible: $checkedConvert(
            'responsible',
            (v) => (v as List<dynamic>)
                .map((e) => EventPerson.fromJson(e as Map<String, dynamic>))
                .toList(),
          ),
          isMine: $checkedConvert('is_mine', (v) => v as bool),
        );
        return val;
      },
      fieldKeyMap: const {
        'startsAt': 'starts_at',
        'durationMinutes': 'duration_minutes',
        'responsibleService': 'responsible_service',
        'isMine': 'is_mine',
      },
    );

Map<String, dynamic> _$EventAgendaEntryToJson(EventAgendaEntry instance) =>
    <String, dynamic>{
      'id': instance.id,
      'type': instance.type,
      'name': ?instance.name,
      'key': ?instance.key,
      'language': ?instance.language,
      'items': instance.items.map((e) => e.toJson()).toList(),
      'starts_at': instance.startsAt.toIso8601String(),
      'duration_minutes': ?instance.durationMinutes,
      'responsible_service': ?instance.responsibleService?.toJson(),
      'responsible': instance.responsible.map((e) => e.toJson()).toList(),
      'is_mine': instance.isMine,
    };
