//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:json_annotation/json_annotation.dart';

part 'contact_address.g.dart';

@CopyWith()
@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class ContactAddress {
  /// Returns a new [ContactAddress] instance.
  ContactAddress({
    required this.id,

    this.type,

    this.line1,

    this.line2,

    this.postalCode,

    this.city,

    this.state,

    this.country,
  });

  @JsonKey(name: r'id', required: true, includeIfNull: false)
  final int id;

  @JsonKey(name: r'type', required: false, includeIfNull: false)
  final String? type;

  @JsonKey(name: r'line1', required: false, includeIfNull: false)
  final String? line1;

  @JsonKey(name: r'line2', required: false, includeIfNull: false)
  final String? line2;

  @JsonKey(name: r'postal_code', required: false, includeIfNull: false)
  final String? postalCode;

  @JsonKey(name: r'city', required: false, includeIfNull: false)
  final String? city;

  @JsonKey(name: r'state', required: false, includeIfNull: false)
  final String? state;

  @JsonKey(name: r'country', required: false, includeIfNull: false)
  final String? country;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ContactAddress &&
          other.id == id &&
          other.type == type &&
          other.line1 == line1 &&
          other.line2 == line2 &&
          other.postalCode == postalCode &&
          other.city == city &&
          other.state == state &&
          other.country == country;

  @override
  int get hashCode =>
      id.hashCode +
      (type == null ? 0 : type.hashCode) +
      (line1 == null ? 0 : line1.hashCode) +
      (line2 == null ? 0 : line2.hashCode) +
      (postalCode == null ? 0 : postalCode.hashCode) +
      (city == null ? 0 : city.hashCode) +
      (state == null ? 0 : state.hashCode) +
      (country == null ? 0 : country.hashCode);

  factory ContactAddress.fromJson(Map<String, dynamic> json) =>
      _$ContactAddressFromJson(json);

  Map<String, dynamic> toJson() => _$ContactAddressToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }
}
