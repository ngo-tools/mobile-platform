//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:json_annotation/json_annotation.dart';

part 'chat_account.g.dart';

@CopyWith()
@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class ChatAccount {
  /// Returns a new [ChatAccount] instance.
  ChatAccount({
    required this.status,

    required this.available,

    required this.matrixUserId,

    required this.serverName,

    required this.homeserverUrl,
  });

  @JsonKey(
    name: r'status',
    required: true,
    includeIfNull: false,
    unknownEnumValue: ChatAccountStatusEnum.unknownDefaultOpenApi,
  )
  final ChatAccountStatusEnum status;

  @JsonKey(name: r'available', required: true, includeIfNull: false)
  final bool available;

  @JsonKey(name: r'matrix_user_id', required: true, includeIfNull: true)
  final String? matrixUserId;

  @JsonKey(name: r'server_name', required: true, includeIfNull: true)
  final String? serverName;

  @JsonKey(name: r'homeserver_url', required: true, includeIfNull: true)
  final String? homeserverUrl;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ChatAccount &&
          other.status == status &&
          other.available == available &&
          other.matrixUserId == matrixUserId &&
          other.serverName == serverName &&
          other.homeserverUrl == homeserverUrl;

  @override
  int get hashCode =>
      status.hashCode +
      available.hashCode +
      (matrixUserId == null ? 0 : matrixUserId.hashCode) +
      (serverName == null ? 0 : serverName.hashCode) +
      (homeserverUrl == null ? 0 : homeserverUrl.hashCode);

  factory ChatAccount.fromJson(Map<String, dynamic> json) =>
      _$ChatAccountFromJson(json);

  Map<String, dynamic> toJson() => _$ChatAccountToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }
}

enum ChatAccountStatusEnum {
  @JsonValue(r'active')
  active(r'active'),
  @JsonValue(r'locked')
  locked(r'locked'),
  @JsonValue(r'deactivated')
  deactivated(r'deactivated'),
  @JsonValue(r'none')
  none(r'none'),
  @JsonValue(r'unknown_default_open_api')
  unknownDefaultOpenApi(r'unknown_default_open_api');

  const ChatAccountStatusEnum(this.value);

  final String value;

  @override
  String toString() => value;
}
