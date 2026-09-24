//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:ngotools_api/src/generated/model/pagination_links.dart';
import 'package:ngotools_api/src/generated/model/pagination_meta.dart';
import 'package:ngotools_api/src/generated/model/contact.dart';
import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:json_annotation/json_annotation.dart';

part 'contact_collection_response.g.dart';

@CopyWith()
@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class ContactCollectionResponse {
  /// Returns a new [ContactCollectionResponse] instance.
  ContactCollectionResponse({required this.data, this.links, this.meta});

  @JsonKey(name: r'data', required: true, includeIfNull: false)
  final List<Contact> data;

  @JsonKey(name: r'links', required: false, includeIfNull: false)
  final PaginationLinks? links;

  @JsonKey(name: r'meta', required: false, includeIfNull: false)
  final PaginationMeta? meta;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ContactCollectionResponse &&
          other.data == data &&
          other.links == links &&
          other.meta == meta;

  @override
  int get hashCode => data.hashCode + links.hashCode + meta.hashCode;

  factory ContactCollectionResponse.fromJson(Map<String, dynamic> json) =>
      _$ContactCollectionResponseFromJson(json);

  Map<String, dynamic> toJson() => _$ContactCollectionResponseToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }
}
