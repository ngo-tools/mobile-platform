// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'update_event_availability_request.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$UpdateEventAvailabilityRequestCWProxy {
  UpdateEventAvailabilityRequest status(
    UpdateEventAvailabilityRequestStatusEnum status,
  );

  /// Creates a new instance with the provided field values.
  /// Passing `null` to a nullable field nullifies it, while `null` for a non-nullable field is ignored. To update a single field use `UpdateEventAvailabilityRequest(...).copyWith.fieldName(value)`.
  ///
  /// Example:
  /// ```dart
  /// UpdateEventAvailabilityRequest(...).copyWith(id: 12, name: "My name")
  /// ```
  UpdateEventAvailabilityRequest call({
    UpdateEventAvailabilityRequestStatusEnum status,
  });
}

/// Callable proxy for `copyWith` functionality.
/// Use as `instanceOfUpdateEventAvailabilityRequest.copyWith(...)` or call `instanceOfUpdateEventAvailabilityRequest.copyWith.fieldName(value)` for a single field.
class _$UpdateEventAvailabilityRequestCWProxyImpl
    implements _$UpdateEventAvailabilityRequestCWProxy {
  const _$UpdateEventAvailabilityRequestCWProxyImpl(this._value);

  final UpdateEventAvailabilityRequest _value;

  @override
  UpdateEventAvailabilityRequest status(
    UpdateEventAvailabilityRequestStatusEnum status,
  ) => call(status: status);

  /// Creates a new instance with the provided field values.
  /// Passing `null` to a nullable field nullifies it, while `null` for a non-nullable field is ignored. To update a single field use `UpdateEventAvailabilityRequest(...).copyWith.fieldName(value)`.
  ///
  /// Example:
  /// ```dart
  /// UpdateEventAvailabilityRequest(...).copyWith(id: 12, name: "My name")
  /// ```
  @override
  UpdateEventAvailabilityRequest call({
    Object? status = const $CopyWithPlaceholder(),
  }) {
    return UpdateEventAvailabilityRequest(
      status: status == const $CopyWithPlaceholder() || status == null
          ? _value.status
          // ignore: cast_nullable_to_non_nullable
          : status as UpdateEventAvailabilityRequestStatusEnum,
    );
  }
}

extension $UpdateEventAvailabilityRequestCopyWith
    on UpdateEventAvailabilityRequest {
  /// Returns a callable class used to build a new instance with modified fields.
  /// Example: `instanceOfUpdateEventAvailabilityRequest.copyWith(...)` or `instanceOfUpdateEventAvailabilityRequest.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$UpdateEventAvailabilityRequestCWProxy get copyWith =>
      _$UpdateEventAvailabilityRequestCWProxyImpl(this);
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UpdateEventAvailabilityRequest _$UpdateEventAvailabilityRequestFromJson(
  Map<String, dynamic> json,
) => $checkedCreate('UpdateEventAvailabilityRequest', json, ($checkedConvert) {
  $checkKeys(json, requiredKeys: const ['status']);
  final val = UpdateEventAvailabilityRequest(
    status: $checkedConvert(
      'status',
      (v) => $enumDecode(
        _$UpdateEventAvailabilityRequestStatusEnumEnumMap,
        v,
        unknownValue:
            UpdateEventAvailabilityRequestStatusEnum.unknownDefaultOpenApi,
      ),
    ),
  );
  return val;
});

Map<String, dynamic> _$UpdateEventAvailabilityRequestToJson(
  UpdateEventAvailabilityRequest instance,
) => <String, dynamic>{
  'status': _$UpdateEventAvailabilityRequestStatusEnumEnumMap[instance.status]!,
};

const _$UpdateEventAvailabilityRequestStatusEnumEnumMap = {
  UpdateEventAvailabilityRequestStatusEnum.available: 'available',
  UpdateEventAvailabilityRequestStatusEnum.notAvailable: 'not-available',
  UpdateEventAvailabilityRequestStatusEnum.ifNeedsMust: 'if-needs-must',
  UpdateEventAvailabilityRequestStatusEnum.unknownDefaultOpenApi:
      'unknown_default_open_api',
};
