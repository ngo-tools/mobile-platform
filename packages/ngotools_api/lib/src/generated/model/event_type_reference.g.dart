// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'event_type_reference.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$EventTypeReferenceCWProxy {
  EventTypeReference id(int id);

  EventTypeReference name(String name);

  /// Creates a new instance with the provided field values.
  /// Passing `null` to a nullable field nullifies it, while `null` for a non-nullable field is ignored. To update a single field use `EventTypeReference(...).copyWith.fieldName(value)`.
  ///
  /// Example:
  /// ```dart
  /// EventTypeReference(...).copyWith(id: 12, name: "My name")
  /// ```
  EventTypeReference call({int id, String name});
}

/// Callable proxy for `copyWith` functionality.
/// Use as `instanceOfEventTypeReference.copyWith(...)` or call `instanceOfEventTypeReference.copyWith.fieldName(value)` for a single field.
class _$EventTypeReferenceCWProxyImpl implements _$EventTypeReferenceCWProxy {
  const _$EventTypeReferenceCWProxyImpl(this._value);

  final EventTypeReference _value;

  @override
  EventTypeReference id(int id) => call(id: id);

  @override
  EventTypeReference name(String name) => call(name: name);

  /// Creates a new instance with the provided field values.
  /// Passing `null` to a nullable field nullifies it, while `null` for a non-nullable field is ignored. To update a single field use `EventTypeReference(...).copyWith.fieldName(value)`.
  ///
  /// Example:
  /// ```dart
  /// EventTypeReference(...).copyWith(id: 12, name: "My name")
  /// ```
  @override
  EventTypeReference call({
    Object? id = const $CopyWithPlaceholder(),
    Object? name = const $CopyWithPlaceholder(),
  }) {
    return EventTypeReference(
      id: id == const $CopyWithPlaceholder() || id == null
          ? _value.id
          // ignore: cast_nullable_to_non_nullable
          : id as int,
      name: name == const $CopyWithPlaceholder() || name == null
          ? _value.name
          // ignore: cast_nullable_to_non_nullable
          : name as String,
    );
  }
}

extension $EventTypeReferenceCopyWith on EventTypeReference {
  /// Returns a callable class used to build a new instance with modified fields.
  /// Example: `instanceOfEventTypeReference.copyWith(...)` or `instanceOfEventTypeReference.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$EventTypeReferenceCWProxy get copyWith =>
      _$EventTypeReferenceCWProxyImpl(this);
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

EventTypeReference _$EventTypeReferenceFromJson(Map<String, dynamic> json) =>
    $checkedCreate('EventTypeReference', json, ($checkedConvert) {
      $checkKeys(json, requiredKeys: const ['id', 'name']);
      final val = EventTypeReference(
        id: $checkedConvert('id', (v) => (v as num).toInt()),
        name: $checkedConvert('name', (v) => v as String),
      );
      return val;
    });

Map<String, dynamic> _$EventTypeReferenceToJson(EventTypeReference instance) =>
    <String, dynamic>{'id': instance.id, 'name': instance.name};
