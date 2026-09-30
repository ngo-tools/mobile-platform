//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:ngotools_api/src/generated/model/chat_person.dart';
import 'package:ngotools_api/src/generated/model/pagination_meta.dart';
import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:json_annotation/json_annotation.dart';

part 'chat_person_collection_response.g.dart';

@CopyWith()
@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class ChatPersonCollectionResponse {
  /// Returns a new [ChatPersonCollectionResponse] instance.
  ChatPersonCollectionResponse({required this.data, required this.meta});

  @JsonKey(name: r'data', required: true, includeIfNull: false)
  final List<ChatPerson> data;

  @JsonKey(name: r'meta', required: true, includeIfNull: false)
  final PaginationMeta meta;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ChatPersonCollectionResponse &&
          other.data == data &&
          other.meta == meta;

  @override
  int get hashCode => data.hashCode + meta.hashCode;

  factory ChatPersonCollectionResponse.fromJson(Map<String, dynamic> json) =>
      _$ChatPersonCollectionResponseFromJson(json);

  Map<String, dynamic> toJson() => _$ChatPersonCollectionResponseToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }
}
