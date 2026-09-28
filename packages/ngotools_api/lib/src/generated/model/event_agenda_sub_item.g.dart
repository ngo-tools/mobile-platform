// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'event_agenda_sub_item.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$EventAgendaSubItemCWProxy {
  EventAgendaSubItem id(int id);

  EventAgendaSubItem type(String type);

  EventAgendaSubItem name(String? name);

  EventAgendaSubItem key(String? key);

  EventAgendaSubItem language(String? language);

  EventAgendaSubItem items(List<EventAgendaSubItem> items);

  /// Creates a new instance with the provided field values.
  /// Passing `null` to a nullable field nullifies it, while `null` for a non-nullable field is ignored. To update a single field use `EventAgendaSubItem(...).copyWith.fieldName(value)`.
  ///
  /// Example:
  /// ```dart
  /// EventAgendaSubItem(...).copyWith(id: 12, name: "My name")
  /// ```
  EventAgendaSubItem call({
    int id,
    String type,
    String? name,
    String? key,
    String? language,
    List<EventAgendaSubItem> items,
  });
}

/// Callable proxy for `copyWith` functionality.
/// Use as `instanceOfEventAgendaSubItem.copyWith(...)` or call `instanceOfEventAgendaSubItem.copyWith.fieldName(value)` for a single field.
class _$EventAgendaSubItemCWProxyImpl implements _$EventAgendaSubItemCWProxy {
  const _$EventAgendaSubItemCWProxyImpl(this._value);

  final EventAgendaSubItem _value;

  @override
  EventAgendaSubItem id(int id) => call(id: id);

  @override
  EventAgendaSubItem type(String type) => call(type: type);

  @override
  EventAgendaSubItem name(String? name) => call(name: name);

  @override
  EventAgendaSubItem key(String? key) => call(key: key);

  @override
  EventAgendaSubItem language(String? language) => call(language: language);

  @override
  EventAgendaSubItem items(List<EventAgendaSubItem> items) =>
      call(items: items);

  /// Creates a new instance with the provided field values.
  /// Passing `null` to a nullable field nullifies it, while `null` for a non-nullable field is ignored. To update a single field use `EventAgendaSubItem(...).copyWith.fieldName(value)`.
  ///
  /// Example:
  /// ```dart
  /// EventAgendaSubItem(...).copyWith(id: 12, name: "My name")
  /// ```
  @override
  EventAgendaSubItem call({
    Object? id = const $CopyWithPlaceholder(),
    Object? type = const $CopyWithPlaceholder(),
    Object? name = const $CopyWithPlaceholder(),
    Object? key = const $CopyWithPlaceholder(),
    Object? language = const $CopyWithPlaceholder(),
    Object? items = const $CopyWithPlaceholder(),
  }) {
    return EventAgendaSubItem(
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
    );
  }
}

extension $EventAgendaSubItemCopyWith on EventAgendaSubItem {
  /// Returns a callable class used to build a new instance with modified fields.
  /// Example: `instanceOfEventAgendaSubItem.copyWith(...)` or `instanceOfEventAgendaSubItem.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$EventAgendaSubItemCWProxy get copyWith =>
      _$EventAgendaSubItemCWProxyImpl(this);
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

EventAgendaSubItem _$EventAgendaSubItemFromJson(Map<String, dynamic> json) =>
    $checkedCreate('EventAgendaSubItem', json, ($checkedConvert) {
      $checkKeys(json, requiredKeys: const ['id', 'type', 'items']);
      final val = EventAgendaSubItem(
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
      );
      return val;
    });

Map<String, dynamic> _$EventAgendaSubItemToJson(EventAgendaSubItem instance) =>
    <String, dynamic>{
      'id': instance.id,
      'type': instance.type,
      'name': ?instance.name,
      'key': ?instance.key,
      'language': ?instance.language,
      'items': instance.items.map((e) => e.toJson()).toList(),
    };
