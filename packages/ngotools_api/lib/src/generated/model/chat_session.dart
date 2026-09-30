//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:json_annotation/json_annotation.dart';

part 'chat_session.g.dart';

@CopyWith()
@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class ChatSession {
  /// Returns a new [ChatSession] instance.
  ChatSession({
    required this.matrixUserId,

    required this.deviceId,

    required this.accessToken,

    required this.expiresAt,

    required this.homeserverUrl,

    required this.serverName,
  });

  @JsonKey(name: r'matrix_user_id', required: true, includeIfNull: false)
  final String matrixUserId;

  @JsonKey(name: r'device_id', required: true, includeIfNull: false)
  final String deviceId;

  @JsonKey(name: r'access_token', required: true, includeIfNull: false)
  final String accessToken;

  @JsonKey(name: r'expires_at', required: true, includeIfNull: true)
  final DateTime? expiresAt;

  @JsonKey(name: r'homeserver_url', required: true, includeIfNull: false)
  final String homeserverUrl;

  @JsonKey(name: r'server_name', required: true, includeIfNull: false)
  final String serverName;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ChatSession &&
          other.matrixUserId == matrixUserId &&
          other.deviceId == deviceId &&
          other.accessToken == accessToken &&
          other.expiresAt == expiresAt &&
          other.homeserverUrl == homeserverUrl &&
          other.serverName == serverName;

  @override
  int get hashCode =>
      matrixUserId.hashCode +
      deviceId.hashCode +
      accessToken.hashCode +
      (expiresAt == null ? 0 : expiresAt.hashCode) +
      homeserverUrl.hashCode +
      serverName.hashCode;

  factory ChatSession.fromJson(Map<String, dynamic> json) =>
      _$ChatSessionFromJson(json);

  Map<String, dynamic> toJson() => _$ChatSessionToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }
}
