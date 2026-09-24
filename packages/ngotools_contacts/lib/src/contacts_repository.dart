import 'package:ngotools_api/ngotools_api.dart';

import 'contact_models.dart';

/// Read-only boundary used by contact state and views.
abstract interface class ContactsRepository {
  /// Searches contacts visible to the authenticated user.
  Future<ContactPage> search(ContactSearch search);

  /// Loads one contact with its visible addresses.
  Future<ContactSnapshot> getById(int contactId);
}

/// Explicit online mutation boundary used only after draft confirmation.
abstract interface class ContactMutationRepository {
  /// Submits one retained draft with its stable idempotency key.
  Future<ContactDraftSubmissionResult> submitDraft(ContactDraft draft);
}

/// Contacts repository backed by the stable NGO.Tools mobile API boundary.
final class NgoToolsContactsRepository
    implements ContactsRepository, ContactMutationRepository {
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
  Future<ContactSnapshot> getById(int contactId) async =>
      ContactSnapshot(contact: _mapContact(await _api.fetchContact(contactId)));

  @override
  Future<ContactDraftSubmissionResult> submitDraft(ContactDraft draft) async {
    final mutation = MobileContactMutation(
      kind: switch (draft.kind) {
        ContactDraftKind.person => MobileWritableContactKind.person,
        ContactDraftKind.organization => MobileWritableContactKind.organization,
      },
      name: draft.name,
      firstName: draft.firstName,
      lastName: draft.lastName,
      email: draft.email,
      salutation: draft.salutation,
      title: draft.title,
      gender: draft.gender,
      birthday: draft.birthday,
    );
    final result = draft.contactId == null
        ? await _api.createContact(
            idempotencyKey: draft.idempotencyKey,
            contact: mutation,
          )
        : await _api.updateContact(
            contactId: draft.contactId!,
            idempotencyKey: draft.idempotencyKey,
            baseVersion: draft.baseVersion!,
            contact: mutation,
          );

    return switch (result) {
      MobileContactMutationSuccess(:final contact, :final replayed) =>
        ContactDraftSubmissionSuccess(
          contact: _mapContact(contact),
          replayed: replayed,
        ),
      MobileContactVersionConflict() => const ContactDraftSubmissionConflict(),
    };
  }

  static ContactRecord _mapContact(MobileContact contact) => ContactRecord(
    id: contact.id,
    kind: switch (contact.kind) {
      MobileContactKind.person => ContactKind.person,
      MobileContactKind.organization => ContactKind.organization,
      MobileContactKind.couple => ContactKind.couple,
      MobileContactKind.unknown => ContactKind.unknown,
    },
    version: contact.version,
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
