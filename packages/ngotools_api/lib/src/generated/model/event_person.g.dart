// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'event_person.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$EventPersonCWProxy {
  EventPerson name(String name);

  EventPerson isMe(bool isMe);

  /// Creates a new instance with the provided field values.
  /// Passing `null` to a nullable field nullifies it, while `null` for a non-nullable field is ignored. To update a single field use `EventPerson(...).copyWith.fieldName(value)`.
  ///
  /// Example:
  /// ```dart
  /// EventPerson(...).copyWith(id: 12, name: "My name")
  /// ```
  EventPerson call({String name, bool isMe});
}

/// Callable proxy for `copyWith` functionality.
/// Use as `instanceOfEventPerson.copyWith(...)` or call `instanceOfEventPerson.copyWith.fieldName(value)` for a single field.
class _$EventPersonCWProxyImpl implements _$EventPersonCWProxy {
  const _$EventPersonCWProxyImpl(this._value);

  final EventPerson _value;

  @override
  EventPerson name(String name) => call(name: name);

  @override
  EventPerson isMe(bool isMe) => call(isMe: isMe);

  /// Creates a new instance with the provided field values.
  /// Passing `null` to a nullable field nullifies it, while `null` for a non-nullable field is ignored. To update a single field use `EventPerson(...).copyWith.fieldName(value)`.
  ///
  /// Example:
  /// ```dart
  /// EventPerson(...).copyWith(id: 12, name: "My name")
  /// ```
  @override
  EventPerson call({
    Object? name = const $CopyWithPlaceholder(),
    Object? isMe = const $CopyWithPlaceholder(),
  }) {
    return EventPerson(
      name: name == const $CopyWithPlaceholder() || name == null
          ? _value.name
          // ignore: cast_nullable_to_non_nullable
          : name as String,
      isMe: isMe == const $CopyWithPlaceholder() || isMe == null
          ? _value.isMe
          // ignore: cast_nullable_to_non_nullable
          : isMe as bool,
    );
  }
}

extension $EventPersonCopyWith on EventPerson {
  /// Returns a callable class used to build a new instance with modified fields.
  /// Example: `instanceOfEventPerson.copyWith(...)` or `instanceOfEventPerson.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$EventPersonCWProxy get copyWith => _$EventPersonCWProxyImpl(this);
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

EventPerson _$EventPersonFromJson(Map<String, dynamic> json) =>
    $checkedCreate('EventPerson', json, ($checkedConvert) {
      $checkKeys(json, requiredKeys: const ['name', 'is_me']);
      final val = EventPerson(
        name: $checkedConvert('name', (v) => v as String),
        isMe: $checkedConvert('is_me', (v) => v as bool),
      );
      return val;
    }, fieldKeyMap: const {'isMe': 'is_me'});

Map<String, dynamic> _$EventPersonToJson(EventPerson instance) =>
    <String, dynamic>{'name': instance.name, 'is_me': instance.isMe};
