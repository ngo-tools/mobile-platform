//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:ngotools_api/src/generated/model/contact_search_term.dart';
import 'package:ngotools_api/src/generated/model/contact_sort.dart';
import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:json_annotation/json_annotation.dart';

part 'contact_search_request.g.dart';

@CopyWith()
@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class ContactSearchRequest {
  /// Returns a new [ContactSearchRequest] instance.
  ContactSearchRequest({this.search, this.sort});

  @JsonKey(name: r'search', required: false, includeIfNull: false)
  final ContactSearchTerm? search;

  @JsonKey(name: r'sort', required: false, includeIfNull: false)
  final List<ContactSort>? sort;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ContactSearchRequest &&
          other.search == search &&
          other.sort == sort;

  @override
  int get hashCode => search.hashCode + sort.hashCode;

  factory ContactSearchRequest.fromJson(Map<String, dynamic> json) =>
      _$ContactSearchRequestFromJson(json);

  Map<String, dynamic> toJson() => _$ContactSearchRequestToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }
}
