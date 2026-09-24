import 'package:ngotools_api/ngotools_api.dart';

import 'contact_models.dart';

/// Read-only boundary used by contact state and views.
abstract interface class ContactsRepository {
  /// Searches contacts visible to the authenticated user.
  Future<ContactPage> search(ContactSearch search);

  /// Loads one contact with its visible addresses.
  Future<ContactRecord> getById(int contactId);
}

/// Contacts repository backed by the stable NGO.Tools mobile API boundary.
final class NgoToolsContactsRepository implements ContactsRepository {
  /// Creates an API-backed repository.
  const NgoToolsContactsRepository(this._api);

  final MobileContactsApi _api;

  @override
  Future<ContactPage> search(ContactSearch search) async {
    final result = await _api.searchContacts(
      query: search.query,
      page: search.page,
      perPage: search.perPage,
      sort: switch (search.sort) {
        ContactsSort.lastName => const [
          MobileContactSort(field: MobileContactSortField.lastName),
          MobileContactSort(field: MobileContactSortField.id),
        ],
        ContactsSort.name => const [
          MobileContactSort(field: MobileContactSortField.name),
          MobileContactSort(field: MobileContactSortField.id),
        ],
        ContactsSort.recentlyUpdated => const [
          MobileContactSort(
            field: MobileContactSortField.updatedAt,
            direction: MobileContactSortDirection.descending,
          ),
          MobileContactSort(
            field: MobileContactSortField.id,
            direction: MobileContactSortDirection.descending,
          ),
        ],
      },
    );

    return ContactPage(
      items: result.items.map(_mapContact).toList(growable: false),
      page: result.page,
      perPage: result.perPage,
      total: result.total,
      lastPage: result.lastPage,
    );
  }

  @override
  Future<ContactRecord> getById(int contactId) async =>
      _mapContact(await _api.fetchContact(contactId));

  static ContactRecord _mapContact(MobileContact contact) => ContactRecord(
    id: contact.id,
    kind: switch (contact.kind) {
      MobileContactKind.person => ContactKind.person,
      MobileContactKind.organization => ContactKind.organization,
      MobileContactKind.couple => ContactKind.couple,
      MobileContactKind.unknown => ContactKind.unknown,
    },
    name: contact.name,
    firstName: contact.firstName,
    lastName: contact.lastName,
    email: contact.email,
    salutation: contact.salutation,
    title: contact.title,
    gender: contact.gender,
    birthday: contact.birthday,
    activeAddressId: contact.activeAddressId,
    updatedAt: contact.updatedAt,
    addresses: contact.addresses
        .map(
          (address) => ContactAddress(
            id: address.id,
            type: address.type,
            line1: address.line1,
            line2: address.line2,
            postalCode: address.postalCode,
            city: address.city,
            state: address.state,
            country: address.country,
          ),
        )
        .toList(growable: false),
  );
}
