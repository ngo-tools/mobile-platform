import 'package:freezed_annotation/freezed_annotation.dart';

part 'contact_models.freezed.dart';

/// Contact categories understood by the mobile presentation layer.
enum ContactKind { person, organization, couple, unknown }

/// Sort modes supported by the contact list.
enum ContactsSort { lastName, name, recentlyUpdated }

/// Origin of a contact result shown to the user.
enum ContactDataSource { remote, cache }

/// Sanitized address fields displayed in contact details.
@freezed
abstract class ContactAddress with _$ContactAddress {
  /// Creates an immutable contact address.
  const factory ContactAddress({
    required int id,
    String? type,
    String? line1,
    String? line2,
    String? postalCode,
    String? city,
    String? state,
    String? country,
  }) = _ContactAddress;
}

/// Read-only contact projection owned by the contacts package.
@freezed
abstract class ContactRecord with _$ContactRecord {
  const ContactRecord._();

  /// Creates an immutable contact projection.
  const factory ContactRecord({
    required int id,
    required ContactKind kind,
    String? name,
    String? firstName,
    String? lastName,
    String? email,
    String? salutation,
    String? title,
    String? gender,
    DateTime? birthday,
    int? activeAddressId,
    DateTime? updatedAt,
    @Default(<ContactAddress>[]) List<ContactAddress> addresses,
  }) = _ContactRecord;

  /// Resolves the best available label without exposing an empty value.
  String displayName(String fallback) {
    final explicitName = name?.trim();

    if (explicitName != null && explicitName.isNotEmpty) {
      return explicitName;
    }

    final composedName = [
      firstName?.trim(),
      lastName?.trim(),
    ].whereType<String>().where((part) => part.isNotEmpty).join(' ');

    return composedName.isEmpty ? fallback : composedName;
  }
}

/// One immutable page returned by a [ContactsRepository].
@freezed
abstract class ContactPage with _$ContactPage {
  const ContactPage._();

  /// Creates an immutable contact page.
  const factory ContactPage({
    required List<ContactRecord> items,
    required int page,
    required int perPage,
    required int total,
    required int lastPage,
    @Default(ContactDataSource.remote) ContactDataSource source,
    DateTime? cachedAt,
  }) = _ContactPage;

  /// Whether another page can be loaded.
  bool get hasNextPage => page < lastPage;
}

/// One contact together with its data provenance.
@freezed
abstract class ContactSnapshot with _$ContactSnapshot {
  /// Creates an immutable contact snapshot.
  const factory ContactSnapshot({
    required ContactRecord contact,
    @Default(ContactDataSource.remote) ContactDataSource source,
    DateTime? cachedAt,
  }) = _ContactSnapshot;
}

/// Parameters accepted by contact repositories.
@freezed
abstract class ContactSearch with _$ContactSearch {
  /// Creates a contact search request.
  const factory ContactSearch({
    @Default('') String query,
    @Default(1) int page,
    @Default(25) int perPage,
    @Default(ContactsSort.lastName) ContactsSort sort,
  }) = _ContactSearch;
}
