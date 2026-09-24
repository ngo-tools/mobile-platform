// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'import_limits.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$ImportLimitsCWProxy {
  ImportLimits maxBatchSize(int maxBatchSize);

  /// Creates a new instance with the provided field values.
  /// Passing `null` to a nullable field nullifies it, while `null` for a non-nullable field is ignored. To update a single field use `ImportLimits(...).copyWith.fieldName(value)`.
  ///
  /// Example:
  /// ```dart
  /// ImportLimits(...).copyWith(id: 12, name: "My name")
  /// ```
  ImportLimits call({int maxBatchSize});
}

/// Callable proxy for `copyWith` functionality.
/// Use as `instanceOfImportLimits.copyWith(...)` or call `instanceOfImportLimits.copyWith.fieldName(value)` for a single field.
class _$ImportLimitsCWProxyImpl implements _$ImportLimitsCWProxy {
  const _$ImportLimitsCWProxyImpl(this._value);

  final ImportLimits _value;

  @override
  ImportLimits maxBatchSize(int maxBatchSize) =>
      call(maxBatchSize: maxBatchSize);

  /// Creates a new instance with the provided field values.
  /// Passing `null` to a nullable field nullifies it, while `null` for a non-nullable field is ignored. To update a single field use `ImportLimits(...).copyWith.fieldName(value)`.
  ///
  /// Example:
  /// ```dart
  /// ImportLimits(...).copyWith(id: 12, name: "My name")
  /// ```
  @override
  ImportLimits call({Object? maxBatchSize = const $CopyWithPlaceholder()}) {
    return ImportLimits(
      maxBatchSize:
          maxBatchSize == const $CopyWithPlaceholder() || maxBatchSize == null
          ? _value.maxBatchSize
          // ignore: cast_nullable_to_non_nullable
          : maxBatchSize as int,
    );
  }
}

extension $ImportLimitsCopyWith on ImportLimits {
  /// Returns a callable class used to build a new instance with modified fields.
  /// Example: `instanceOfImportLimits.copyWith(...)` or `instanceOfImportLimits.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$ImportLimitsCWProxy get copyWith => _$ImportLimitsCWProxyImpl(this);
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ImportLimits _$ImportLimitsFromJson(Map<String, dynamic> json) =>
    $checkedCreate('ImportLimits', json, ($checkedConvert) {
      $checkKeys(json, requiredKeys: const ['max_batch_size']);
      final val = ImportLimits(
        maxBatchSize: $checkedConvert(
          'max_batch_size',
          (v) => (v as num).toInt(),
        ),
      );
      return val;
    }, fieldKeyMap: const {'maxBatchSize': 'max_batch_size'});

Map<String, dynamic> _$ImportLimitsToJson(ImportLimits instance) =>
    <String, dynamic>{'max_batch_size': instance.maxBatchSize};
