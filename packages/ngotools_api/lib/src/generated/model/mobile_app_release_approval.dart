//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:json_annotation/json_annotation.dart';

part 'mobile_app_release_approval.g.dart';

@CopyWith()
@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class MobileAppReleaseApproval {
  /// Returns a new [MobileAppReleaseApproval] instance.
  MobileAppReleaseApproval({
    required this.releaseRequestId,

    required this.pollToken,

    required this.userCode,

    required this.authorizationUrl,

    required this.expiresIn,

    required this.pollInterval,
  });

  @JsonKey(name: r'release_request_id', required: true, includeIfNull: false)
  final String releaseRequestId;

  @JsonKey(name: r'poll_token', required: true, includeIfNull: false)
  final String pollToken;

  @JsonKey(name: r'user_code', required: true, includeIfNull: false)
  final String userCode;

  @JsonKey(name: r'authorization_url', required: true, includeIfNull: false)
  final String authorizationUrl;

  // minimum: 1
  @JsonKey(name: r'expires_in', required: true, includeIfNull: false)
  final int expiresIn;

  // minimum: 1
  @JsonKey(name: r'poll_interval', required: true, includeIfNull: false)
  final int pollInterval;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is MobileAppReleaseApproval &&
          other.releaseRequestId == releaseRequestId &&
          other.pollToken == pollToken &&
          other.userCode == userCode &&
          other.authorizationUrl == authorizationUrl &&
          other.expiresIn == expiresIn &&
          other.pollInterval == pollInterval;

  @override
  int get hashCode =>
      releaseRequestId.hashCode +
      pollToken.hashCode +
      userCode.hashCode +
      authorizationUrl.hashCode +
      expiresIn.hashCode +
      pollInterval.hashCode;

  factory MobileAppReleaseApproval.fromJson(Map<String, dynamic> json) =>
      _$MobileAppReleaseApprovalFromJson(json);

  Map<String, dynamic> toJson() => _$MobileAppReleaseApprovalToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }
}
