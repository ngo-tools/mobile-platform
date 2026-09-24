// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'contact_sort.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$ContactSortCWProxy {
  ContactSort field(ContactSortFieldEnum field);

  ContactSort direction(ContactSortDirectionEnum direction);

  /// Creates a new instance with the provided field values.
  /// Passing `null` to a nullable field nullifies it, while `null` for a non-nullable field is ignored. To update a single field use `ContactSort(...).copyWith.fieldName(value)`.
  ///
  /// Example:
  /// ```dart
  /// ContactSort(...).copyWith(id: 12, name: "My name")
  /// ```
  ContactSort call({
    ContactSortFieldEnum field,
    ContactSortDirectionEnum direction,
  });
}

/// Callable proxy for `copyWith` functionality.
/// Use as `instanceOfContactSort.copyWith(...)` or call `instanceOfContactSort.copyWith.fieldName(value)` for a single field.
class _$ContactSortCWProxyImpl implements _$ContactSortCWProxy {
  const _$ContactSortCWProxyImpl(this._value);

  final ContactSort _value;

  @override
  ContactSort field(ContactSortFieldEnum field) => call(field: field);

  @override
  ContactSort direction(ContactSortDirectionEnum direction) =>
      call(direction: direction);

  /// Creates a new instance with the provided field values.
  /// Passing `null` to a nullable field nullifies it, while `null` for a non-nullable field is ignored. To update a single field use `ContactSort(...).copyWith.fieldName(value)`.
  ///
  /// Example:
  /// ```dart
  /// ContactSort(...).copyWith(id: 12, name: "My name")
  /// ```
  @override
  ContactSort call({
    Object? field = const $CopyWithPlaceholder(),
    Object? direction = const $CopyWithPlaceholder(),
  }) {
    return ContactSort(
      field: field == const $CopyWithPlaceholder() || field == null
          ? _value.field
          // ignore: cast_nullable_to_non_nullable
          : field as ContactSortFieldEnum,
      direction: direction == const $CopyWithPlaceholder() || direction == null
          ? _value.direction
          // ignore: cast_nullable_to_non_nullable
          : direction as ContactSortDirectionEnum,
    );
  }
}

extension $ContactSortCopyWith on ContactSort {
  /// Returns a callable class used to build a new instance with modified fields.
  /// Example: `instanceOfContactSort.copyWith(...)` or `instanceOfContactSort.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$ContactSortCWProxy get copyWith => _$ContactSortCWProxyImpl(this);
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ContactSort _$ContactSortFromJson(Map<String, dynamic> json) =>
    $checkedCreate('ContactSort', json, ($checkedConvert) {
      $checkKeys(json, requiredKeys: const ['field', 'direction']);
      final val = ContactSort(
        field: $checkedConvert(
          'field',
          (v) => $enumDecode(
            _$ContactSortFieldEnumEnumMap,
            v,
            unknownValue: ContactSortFieldEnum.unknownDefaultOpenApi,
          ),
        ),
        direction: $checkedConvert(
          'direction',
          (v) => $enumDecode(
            _$ContactSortDirectionEnumEnumMap,
            v,
            unknownValue: ContactSortDirectionEnum.unknownDefaultOpenApi,
          ),
        ),
      );
      return val;
    });

Map<String, dynamic> _$ContactSortToJson(ContactSort instance) =>
    <String, dynamic>{
      'field': _$ContactSortFieldEnumEnumMap[instance.field]!,
      'direction': _$ContactSortDirectionEnumEnumMap[instance.direction]!,
    };

const _$ContactSortFieldEnumEnumMap = {
  ContactSortFieldEnum.name: 'name',
  ContactSortFieldEnum.firstName: 'first_name',
  ContactSortFieldEnum.lastName: 'last_name',
  ContactSortFieldEnum.updatedAt: 'updated_at',
  ContactSortFieldEnum.createdAt: 'created_at',
  ContactSortFieldEnum.id: 'id',
  ContactSortFieldEnum.unknownDefaultOpenApi: 'unknown_default_open_api',
};

const _$ContactSortDirectionEnumEnumMap = {
  ContactSortDirectionEnum.asc: 'asc',
  ContactSortDirectionEnum.desc: 'desc',
  ContactSortDirectionEnum.unknownDefaultOpenApi: 'unknown_default_open_api',
};
