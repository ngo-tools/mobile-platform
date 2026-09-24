// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'pagination_links.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$PaginationLinksCWProxy {
  PaginationLinks first(String? first);

  PaginationLinks last(String? last);

  PaginationLinks prev(String? prev);

  PaginationLinks next(String? next);

  /// Creates a new instance with the provided field values.
  /// Passing `null` to a nullable field nullifies it, while `null` for a non-nullable field is ignored. To update a single field use `PaginationLinks(...).copyWith.fieldName(value)`.
  ///
  /// Example:
  /// ```dart
  /// PaginationLinks(...).copyWith(id: 12, name: "My name")
  /// ```
  PaginationLinks call({
    String? first,
    String? last,
    String? prev,
    String? next,
  });
}

/// Callable proxy for `copyWith` functionality.
/// Use as `instanceOfPaginationLinks.copyWith(...)` or call `instanceOfPaginationLinks.copyWith.fieldName(value)` for a single field.
class _$PaginationLinksCWProxyImpl implements _$PaginationLinksCWProxy {
  const _$PaginationLinksCWProxyImpl(this._value);

  final PaginationLinks _value;

  @override
  PaginationLinks first(String? first) => call(first: first);

  @override
  PaginationLinks last(String? last) => call(last: last);

  @override
  PaginationLinks prev(String? prev) => call(prev: prev);

  @override
  PaginationLinks next(String? next) => call(next: next);

  /// Creates a new instance with the provided field values.
  /// Passing `null` to a nullable field nullifies it, while `null` for a non-nullable field is ignored. To update a single field use `PaginationLinks(...).copyWith.fieldName(value)`.
  ///
  /// Example:
  /// ```dart
  /// PaginationLinks(...).copyWith(id: 12, name: "My name")
  /// ```
  @override
  PaginationLinks call({
    Object? first = const $CopyWithPlaceholder(),
    Object? last = const $CopyWithPlaceholder(),
    Object? prev = const $CopyWithPlaceholder(),
    Object? next = const $CopyWithPlaceholder(),
  }) {
    return PaginationLinks(
      first: first == const $CopyWithPlaceholder()
          ? _value.first
          // ignore: cast_nullable_to_non_nullable
          : first as String?,
      last: last == const $CopyWithPlaceholder()
          ? _value.last
          // ignore: cast_nullable_to_non_nullable
          : last as String?,
      prev: prev == const $CopyWithPlaceholder()
          ? _value.prev
          // ignore: cast_nullable_to_non_nullable
          : prev as String?,
      next: next == const $CopyWithPlaceholder()
          ? _value.next
          // ignore: cast_nullable_to_non_nullable
          : next as String?,
    );
  }
}

extension $PaginationLinksCopyWith on PaginationLinks {
  /// Returns a callable class used to build a new instance with modified fields.
  /// Example: `instanceOfPaginationLinks.copyWith(...)` or `instanceOfPaginationLinks.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$PaginationLinksCWProxy get copyWith => _$PaginationLinksCWProxyImpl(this);
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PaginationLinks _$PaginationLinksFromJson(Map<String, dynamic> json) =>
    $checkedCreate('PaginationLinks', json, ($checkedConvert) {
      final val = PaginationLinks(
        first: $checkedConvert('first', (v) => v as String?),
        last: $checkedConvert('last', (v) => v as String?),
        prev: $checkedConvert('prev', (v) => v as String?),
        next: $checkedConvert('next', (v) => v as String?),
      );
      return val;
    });

Map<String, dynamic> _$PaginationLinksToJson(PaginationLinks instance) =>
    <String, dynamic>{
      'first': ?instance.first,
      'last': ?instance.last,
      'prev': ?instance.prev,
      'next': ?instance.next,
    };
