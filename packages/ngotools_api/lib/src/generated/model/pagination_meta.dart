//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:json_annotation/json_annotation.dart';

part 'pagination_meta.g.dart';

@CopyWith()
@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class PaginationMeta {
  /// Returns a new [PaginationMeta] instance.
  PaginationMeta({
    required this.currentPage,

    this.lastPage,

    required this.perPage,

    required this.total,
  });

  // minimum: 1
  @JsonKey(name: r'current_page', required: true, includeIfNull: false)
  final int currentPage;

  // minimum: 1
  @JsonKey(name: r'last_page', required: false, includeIfNull: false)
  final int? lastPage;

  // minimum: 1
  @JsonKey(name: r'per_page', required: true, includeIfNull: false)
  final int perPage;

  // minimum: 0
  @JsonKey(name: r'total', required: true, includeIfNull: false)
  final int total;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PaginationMeta &&
          other.currentPage == currentPage &&
          other.lastPage == lastPage &&
          other.perPage == perPage &&
          other.total == total;

  @override
  int get hashCode =>
      currentPage.hashCode +
      lastPage.hashCode +
      perPage.hashCode +
      total.hashCode;

  factory PaginationMeta.fromJson(Map<String, dynamic> json) =>
      _$PaginationMetaFromJson(json);

  Map<String, dynamic> toJson() => _$PaginationMetaToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }
}
