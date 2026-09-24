//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:json_annotation/json_annotation.dart';

part 'problem_details.g.dart';

@CopyWith()
@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class ProblemDetails {
  /// Returns a new [ProblemDetails] instance.
  ProblemDetails({
    this.type,

    this.title,

    this.status,

    this.detail,

    this.instance,

    this.code,

    this.errorCode,

    this.message,

    this.requestId,

    this.errors,
  });

  @JsonKey(name: r'type', required: false, includeIfNull: false)
  final String? type;

  @JsonKey(name: r'title', required: false, includeIfNull: false)
  final String? title;

  // minimum: 100
  // maximum: 599
  @JsonKey(name: r'status', required: false, includeIfNull: false)
  final int? status;

  @JsonKey(name: r'detail', required: false, includeIfNull: false)
  final String? detail;

  @JsonKey(name: r'instance', required: false, includeIfNull: false)
  final String? instance;

  @JsonKey(name: r'code', required: false, includeIfNull: false)
  final String? code;

  @JsonKey(name: r'error_code', required: false, includeIfNull: false)
  final String? errorCode;

  @JsonKey(name: r'message', required: false, includeIfNull: false)
  final String? message;

  @JsonKey(name: r'request_id', required: false, includeIfNull: false)
  final String? requestId;

  @JsonKey(name: r'errors', required: false, includeIfNull: false)
  final Map<String, List<String>>? errors;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ProblemDetails &&
          other.type == type &&
          other.title == title &&
          other.status == status &&
          other.detail == detail &&
          other.instance == instance &&
          other.code == code &&
          other.errorCode == errorCode &&
          other.message == message &&
          other.requestId == requestId &&
          other.errors == errors;

  @override
  int get hashCode =>
      type.hashCode +
      title.hashCode +
      status.hashCode +
      detail.hashCode +
      instance.hashCode +
      code.hashCode +
      errorCode.hashCode +
      message.hashCode +
      requestId.hashCode +
      errors.hashCode;

  factory ProblemDetails.fromJson(Map<String, dynamic> json) =>
      _$ProblemDetailsFromJson(json);

  Map<String, dynamic> toJson() => _$ProblemDetailsToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }
}
