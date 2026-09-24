// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'pagination_meta.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$PaginationMetaCWProxy {
  PaginationMeta currentPage(int currentPage);

  PaginationMeta lastPage(int? lastPage);

  PaginationMeta perPage(int perPage);

  PaginationMeta total(int total);

  /// Creates a new instance with the provided field values.
  /// Passing `null` to a nullable field nullifies it, while `null` for a non-nullable field is ignored. To update a single field use `PaginationMeta(...).copyWith.fieldName(value)`.
  ///
  /// Example:
  /// ```dart
  /// PaginationMeta(...).copyWith(id: 12, name: "My name")
  /// ```
  PaginationMeta call({int currentPage, int? lastPage, int perPage, int total});
}

/// Callable proxy for `copyWith` functionality.
/// Use as `instanceOfPaginationMeta.copyWith(...)` or call `instanceOfPaginationMeta.copyWith.fieldName(value)` for a single field.
class _$PaginationMetaCWProxyImpl implements _$PaginationMetaCWProxy {
  const _$PaginationMetaCWProxyImpl(this._value);

  final PaginationMeta _value;

  @override
  PaginationMeta currentPage(int currentPage) => call(currentPage: currentPage);

  @override
  PaginationMeta lastPage(int? lastPage) => call(lastPage: lastPage);

  @override
  PaginationMeta perPage(int perPage) => call(perPage: perPage);

  @override
  PaginationMeta total(int total) => call(total: total);

  /// Creates a new instance with the provided field values.
  /// Passing `null` to a nullable field nullifies it, while `null` for a non-nullable field is ignored. To update a single field use `PaginationMeta(...).copyWith.fieldName(value)`.
  ///
  /// Example:
  /// ```dart
  /// PaginationMeta(...).copyWith(id: 12, name: "My name")
  /// ```
  @override
  PaginationMeta call({
    Object? currentPage = const $CopyWithPlaceholder(),
    Object? lastPage = const $CopyWithPlaceholder(),
    Object? perPage = const $CopyWithPlaceholder(),
    Object? total = const $CopyWithPlaceholder(),
  }) {
    return PaginationMeta(
      currentPage:
          currentPage == const $CopyWithPlaceholder() || currentPage == null
          ? _value.currentPage
          // ignore: cast_nullable_to_non_nullable
          : currentPage as int,
      lastPage: lastPage == const $CopyWithPlaceholder()
          ? _value.lastPage
          // ignore: cast_nullable_to_non_nullable
          : lastPage as int?,
      perPage: perPage == const $CopyWithPlaceholder() || perPage == null
          ? _value.perPage
          // ignore: cast_nullable_to_non_nullable
          : perPage as int,
      total: total == const $CopyWithPlaceholder() || total == null
          ? _value.total
          // ignore: cast_nullable_to_non_nullable
          : total as int,
    );
  }
}

extension $PaginationMetaCopyWith on PaginationMeta {
  /// Returns a callable class used to build a new instance with modified fields.
  /// Example: `instanceOfPaginationMeta.copyWith(...)` or `instanceOfPaginationMeta.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$PaginationMetaCWProxy get copyWith => _$PaginationMetaCWProxyImpl(this);
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PaginationMeta _$PaginationMetaFromJson(
  Map<String, dynamic> json,
) => $checkedCreate(
  'PaginationMeta',
  json,
  ($checkedConvert) {
    $checkKeys(json, requiredKeys: const ['current_page', 'per_page', 'total']);
    final val = PaginationMeta(
      currentPage: $checkedConvert('current_page', (v) => (v as num).toInt()),
      lastPage: $checkedConvert('last_page', (v) => (v as num?)?.toInt()),
      perPage: $checkedConvert('per_page', (v) => (v as num).toInt()),
      total: $checkedConvert('total', (v) => (v as num).toInt()),
    );
    return val;
  },
  fieldKeyMap: const {
    'currentPage': 'current_page',
    'lastPage': 'last_page',
    'perPage': 'per_page',
  },
);

Map<String, dynamic> _$PaginationMetaToJson(PaginationMeta instance) =>
    <String, dynamic>{
      'current_page': instance.currentPage,
      'last_page': ?instance.lastPage,
      'per_page': instance.perPage,
      'total': instance.total,
    };
