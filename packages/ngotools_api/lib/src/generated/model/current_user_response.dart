//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:ngotools_api/src/generated/model/current_user.dart';
import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:json_annotation/json_annotation.dart';

part 'current_user_response.g.dart';

@CopyWith()
@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class CurrentUserResponse {
  /// Returns a new [CurrentUserResponse] instance.
  CurrentUserResponse({
    required this.user,

    required this.permissions,

    required this.features,
  });

  @JsonKey(name: r'user', required: true, includeIfNull: false)
  final CurrentUser user;

  @JsonKey(name: r'permissions', required: true, includeIfNull: false)
  final Set<String> permissions;

  @JsonKey(name: r'features', required: true, includeIfNull: false)
  final Set<String> features;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CurrentUserResponse &&
          other.user == user &&
          other.permissions == permissions &&
          other.features == features;

  @override
  int get hashCode => user.hashCode + permissions.hashCode + features.hashCode;

  factory CurrentUserResponse.fromJson(Map<String, dynamic> json) =>
      _$CurrentUserResponseFromJson(json);

  Map<String, dynamic> toJson() => _$CurrentUserResponseToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }
}
