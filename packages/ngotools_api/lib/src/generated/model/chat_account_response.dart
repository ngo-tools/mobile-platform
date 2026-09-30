//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:ngotools_api/src/generated/model/chat_account.dart';
import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:json_annotation/json_annotation.dart';

part 'chat_account_response.g.dart';

@CopyWith()
@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class ChatAccountResponse {
  /// Returns a new [ChatAccountResponse] instance.
  ChatAccountResponse({required this.data});

  @JsonKey(name: r'data', required: true, includeIfNull: false)
  final ChatAccount data;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ChatAccountResponse && other.data == data;

  @override
  int get hashCode => data.hashCode;

  factory ChatAccountResponse.fromJson(Map<String, dynamic> json) =>
      _$ChatAccountResponseFromJson(json);

  Map<String, dynamic> toJson() => _$ChatAccountResponseToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }
}
