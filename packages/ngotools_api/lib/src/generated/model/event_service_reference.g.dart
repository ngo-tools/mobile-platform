// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'event_service_reference.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$EventServiceReferenceCWProxy {
  EventServiceReference id(int id);

  EventServiceReference name(String name);

  /// Creates a new instance with the provided field values.
  /// Passing `null` to a nullable field nullifies it, while `null` for a non-nullable field is ignored. To update a single field use `EventServiceReference(...).copyWith.fieldName(value)`.
  ///
  /// Example:
  /// ```dart
  /// EventServiceReference(...).copyWith(id: 12, name: "My name")
  /// ```
  EventServiceReference call({int id, String name});
}

/// Callable proxy for `copyWith` functionality.
/// Use as `instanceOfEventServiceReference.copyWith(...)` or call `instanceOfEventServiceReference.copyWith.fieldName(value)` for a single field.
class _$EventServiceReferenceCWProxyImpl
    implements _$EventServiceReferenceCWProxy {
  const _$EventServiceReferenceCWProxyImpl(this._value);

  final EventServiceReference _value;

  @override
  EventServiceReference id(int id) => call(id: id);

  @override
  EventServiceReference name(String name) => call(name: name);

  /// Creates a new instance with the provided field values.
  /// Passing `null` to a nullable field nullifies it, while `null` for a non-nullable field is ignored. To update a single field use `EventServiceReference(...).copyWith.fieldName(value)`.
  ///
  /// Example:
  /// ```dart
  /// EventServiceReference(...).copyWith(id: 12, name: "My name")
  /// ```
  @override
  EventServiceReference call({
    Object? id = const $CopyWithPlaceholder(),
    Object? name = const $CopyWithPlaceholder(),
  }) {
    return EventServiceReference(
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

extension $EventServiceReferenceCopyWith on EventServiceReference {
  /// Returns a callable class used to build a new instance with modified fields.
  /// Example: `instanceOfEventServiceReference.copyWith(...)` or `instanceOfEventServiceReference.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$EventServiceReferenceCWProxy get copyWith =>
      _$EventServiceReferenceCWProxyImpl(this);
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

EventServiceReference _$EventServiceReferenceFromJson(
  Map<String, dynamic> json,
) => $checkedCreate('EventServiceReference', json, ($checkedConvert) {
  $checkKeys(json, requiredKeys: const ['id', 'name']);
  final val = EventServiceReference(
    id: $checkedConvert('id', (v) => (v as num).toInt()),
    name: $checkedConvert('name', (v) => v as String),
  );
  return val;
});

Map<String, dynamic> _$EventServiceReferenceToJson(
  EventServiceReference instance,
) => <String, dynamic>{'id': instance.id, 'name': instance.name};
