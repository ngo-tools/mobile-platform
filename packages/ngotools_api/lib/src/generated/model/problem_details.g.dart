// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'problem_details.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$ProblemDetailsCWProxy {
  ProblemDetails type(String? type);

  ProblemDetails title(String? title);

  ProblemDetails status(int? status);

  ProblemDetails detail(String? detail);

  ProblemDetails instance(String? instance);

  ProblemDetails code(String? code);

  ProblemDetails errorCode(String? errorCode);

  ProblemDetails message(String? message);

  ProblemDetails requestId(String? requestId);

  ProblemDetails errors(Map<String, List<String>>? errors);

  /// Creates a new instance with the provided field values.
  /// Passing `null` to a nullable field nullifies it, while `null` for a non-nullable field is ignored. To update a single field use `ProblemDetails(...).copyWith.fieldName(value)`.
  ///
  /// Example:
  /// ```dart
  /// ProblemDetails(...).copyWith(id: 12, name: "My name")
  /// ```
  ProblemDetails call({
    String? type,
    String? title,
    int? status,
    String? detail,
    String? instance,
    String? code,
    String? errorCode,
    String? message,
    String? requestId,
    Map<String, List<String>>? errors,
  });
}

/// Callable proxy for `copyWith` functionality.
/// Use as `instanceOfProblemDetails.copyWith(...)` or call `instanceOfProblemDetails.copyWith.fieldName(value)` for a single field.
class _$ProblemDetailsCWProxyImpl implements _$ProblemDetailsCWProxy {
  const _$ProblemDetailsCWProxyImpl(this._value);

  final ProblemDetails _value;

  @override
  ProblemDetails type(String? type) => call(type: type);

  @override
  ProblemDetails title(String? title) => call(title: title);

  @override
  ProblemDetails status(int? status) => call(status: status);

  @override
  ProblemDetails detail(String? detail) => call(detail: detail);

  @override
  ProblemDetails instance(String? instance) => call(instance: instance);

  @override
  ProblemDetails code(String? code) => call(code: code);

  @override
  ProblemDetails errorCode(String? errorCode) => call(errorCode: errorCode);

  @override
  ProblemDetails message(String? message) => call(message: message);

  @override
  ProblemDetails requestId(String? requestId) => call(requestId: requestId);

  @override
  ProblemDetails errors(Map<String, List<String>>? errors) =>
      call(errors: errors);

  /// Creates a new instance with the provided field values.
  /// Passing `null` to a nullable field nullifies it, while `null` for a non-nullable field is ignored. To update a single field use `ProblemDetails(...).copyWith.fieldName(value)`.
  ///
  /// Example:
  /// ```dart
  /// ProblemDetails(...).copyWith(id: 12, name: "My name")
  /// ```
  @override
  ProblemDetails call({
    Object? type = const $CopyWithPlaceholder(),
    Object? title = const $CopyWithPlaceholder(),
    Object? status = const $CopyWithPlaceholder(),
    Object? detail = const $CopyWithPlaceholder(),
    Object? instance = const $CopyWithPlaceholder(),
    Object? code = const $CopyWithPlaceholder(),
    Object? errorCode = const $CopyWithPlaceholder(),
    Object? message = const $CopyWithPlaceholder(),
    Object? requestId = const $CopyWithPlaceholder(),
    Object? errors = const $CopyWithPlaceholder(),
  }) {
    return ProblemDetails(
      type: type == const $CopyWithPlaceholder()
          ? _value.type
          // ignore: cast_nullable_to_non_nullable
          : type as String?,
      title: title == const $CopyWithPlaceholder()
          ? _value.title
          // ignore: cast_nullable_to_non_nullable
          : title as String?,
      status: status == const $CopyWithPlaceholder()
          ? _value.status
          // ignore: cast_nullable_to_non_nullable
          : status as int?,
      detail: detail == const $CopyWithPlaceholder()
          ? _value.detail
          // ignore: cast_nullable_to_non_nullable
          : detail as String?,
      instance: instance == const $CopyWithPlaceholder()
          ? _value.instance
          // ignore: cast_nullable_to_non_nullable
          : instance as String?,
      code: code == const $CopyWithPlaceholder()
          ? _value.code
          // ignore: cast_nullable_to_non_nullable
          : code as String?,
      errorCode: errorCode == const $CopyWithPlaceholder()
          ? _value.errorCode
          // ignore: cast_nullable_to_non_nullable
          : errorCode as String?,
      message: message == const $CopyWithPlaceholder()
          ? _value.message
          // ignore: cast_nullable_to_non_nullable
          : message as String?,
      requestId: requestId == const $CopyWithPlaceholder()
          ? _value.requestId
          // ignore: cast_nullable_to_non_nullable
          : requestId as String?,
      errors: errors == const $CopyWithPlaceholder()
          ? _value.errors
          // ignore: cast_nullable_to_non_nullable
          : errors as Map<String, List<String>>?,
    );
  }
}

extension $ProblemDetailsCopyWith on ProblemDetails {
  /// Returns a callable class used to build a new instance with modified fields.
  /// Example: `instanceOfProblemDetails.copyWith(...)` or `instanceOfProblemDetails.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$ProblemDetailsCWProxy get copyWith => _$ProblemDetailsCWProxyImpl(this);
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ProblemDetails _$ProblemDetailsFromJson(Map<String, dynamic> json) =>
    $checkedCreate(
      'ProblemDetails',
      json,
      ($checkedConvert) {
        final val = ProblemDetails(
          type: $checkedConvert('type', (v) => v as String?),
          title: $checkedConvert('title', (v) => v as String?),
          status: $checkedConvert('status', (v) => (v as num?)?.toInt()),
          detail: $checkedConvert('detail', (v) => v as String?),
          instance: $checkedConvert('instance', (v) => v as String?),
          code: $checkedConvert('code', (v) => v as String?),
          errorCode: $checkedConvert('error_code', (v) => v as String?),
          message: $checkedConvert('message', (v) => v as String?),
          requestId: $checkedConvert('request_id', (v) => v as String?),
          errors: $checkedConvert(
            'errors',
            (v) => (v as Map<String, dynamic>?)?.map(
              (k, e) => MapEntry(
                k,
                (e as List<dynamic>).map((e) => e as String).toList(),
              ),
            ),
          ),
        );
        return val;
      },
      fieldKeyMap: const {'errorCode': 'error_code', 'requestId': 'request_id'},
    );

Map<String, dynamic> _$ProblemDetailsToJson(ProblemDetails instance) =>
    <String, dynamic>{
      'type': ?instance.type,
      'title': ?instance.title,
      'status': ?instance.status,
      'detail': ?instance.detail,
      'instance': ?instance.instance,
      'code': ?instance.code,
      'error_code': ?instance.errorCode,
      'message': ?instance.message,
      'request_id': ?instance.requestId,
      'errors': ?instance.errors,
    };
