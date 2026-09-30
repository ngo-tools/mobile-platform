// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'create_chat_session_request.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$CreateChatSessionRequestCWProxy {
  CreateChatSessionRequest deviceName(String? deviceName);

  /// Creates a new instance with the provided field values.
  /// Passing `null` to a nullable field nullifies it, while `null` for a non-nullable field is ignored. To update a single field use `CreateChatSessionRequest(...).copyWith.fieldName(value)`.
  ///
  /// Example:
  /// ```dart
  /// CreateChatSessionRequest(...).copyWith(id: 12, name: "My name")
  /// ```
  CreateChatSessionRequest call({String? deviceName});
}

/// Callable proxy for `copyWith` functionality.
/// Use as `instanceOfCreateChatSessionRequest.copyWith(...)` or call `instanceOfCreateChatSessionRequest.copyWith.fieldName(value)` for a single field.
class _$CreateChatSessionRequestCWProxyImpl
    implements _$CreateChatSessionRequestCWProxy {
  const _$CreateChatSessionRequestCWProxyImpl(this._value);

  final CreateChatSessionRequest _value;

  @override
  CreateChatSessionRequest deviceName(String? deviceName) =>
      call(deviceName: deviceName);

  /// Creates a new instance with the provided field values.
  /// Passing `null` to a nullable field nullifies it, while `null` for a non-nullable field is ignored. To update a single field use `CreateChatSessionRequest(...).copyWith.fieldName(value)`.
  ///
  /// Example:
  /// ```dart
  /// CreateChatSessionRequest(...).copyWith(id: 12, name: "My name")
  /// ```
  @override
  CreateChatSessionRequest call({
    Object? deviceName = const $CopyWithPlaceholder(),
  }) {
    return CreateChatSessionRequest(
      deviceName: deviceName == const $CopyWithPlaceholder()
          ? _value.deviceName
          // ignore: cast_nullable_to_non_nullable
          : deviceName as String?,
    );
  }
}

extension $CreateChatSessionRequestCopyWith on CreateChatSessionRequest {
  /// Returns a callable class used to build a new instance with modified fields.
  /// Example: `instanceOfCreateChatSessionRequest.copyWith(...)` or `instanceOfCreateChatSessionRequest.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$CreateChatSessionRequestCWProxy get copyWith =>
      _$CreateChatSessionRequestCWProxyImpl(this);
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CreateChatSessionRequest _$CreateChatSessionRequestFromJson(
  Map<String, dynamic> json,
) => $checkedCreate('CreateChatSessionRequest', json, ($checkedConvert) {
  final val = CreateChatSessionRequest(
    deviceName: $checkedConvert('device_name', (v) => v as String?),
  );
  return val;
}, fieldKeyMap: const {'deviceName': 'device_name'});

Map<String, dynamic> _$CreateChatSessionRequestToJson(
  CreateChatSessionRequest instance,
) => <String, dynamic>{'device_name': ?instance.deviceName};
