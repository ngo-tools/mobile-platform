import 'package:ngotools_contacts/ngotools_contacts.dart';

/// Deterministic, secret-free contacts used by examples and widget tests.
final class SyntheticContactsRepository implements ContactsRepository {
  /// Creates the synthetic repository.
  const SyntheticContactsRepository();

  static const _contacts = [
    ContactRecord(
      id: 101,
      kind: ContactKind.person,
      firstName: 'Erika',
      lastName: 'Beispiel',
      email: 'erika@example.invalid',
      addresses: [
        ContactAddress(
          id: 1001,
          type: 'work',
          line1: 'Musterweg 1',
          postalCode: '10115',
          city: 'Berlin',
          country: 'DE',
        ),
      ],
    ),
    ContactRecord(
      id: 102,
      kind: ContactKind.organization,
      name: 'Beispielverein',
      email: 'verein@example.invalid',
      addresses: [
        ContactAddress(
          id: 1002,
          type: 'work',
          line1: 'Testallee 12',
          postalCode: '20095',
          city: 'Hamburg',
          country: 'DE',
        ),
      ],
    ),
    ContactRecord(
      id: 103,
      kind: ContactKind.couple,
      name: 'Alex und Kim Muster',
      email: 'muster@example.invalid',
    ),
  ];

  @override
  Future<ContactSnapshot> getById(int contactId) async => ContactSnapshot(
    contact: _contacts.singleWhere((contact) => contact.id == contactId),
  );

  @override
  Future<ContactPage> search(ContactSearch search) async {
    final query = search.query.trim().toLowerCase();
    final matches = _contacts
        .where((contact) {
          final values = [
            contact.displayName(''),
            contact.email,
            ...contact.addresses.map((address) => address.city),
          ].whereType<String>().map((value) => value.toLowerCase());

          return query.isEmpty || values.any((value) => value.contains(query));
        })
        .toList(growable: true);
    matches.sort(
      (left, right) => _sortValue(
        left,
        search.sort,
      ).compareTo(_sortValue(right, search.sort)),
    );

    if (search.sort == ContactsSort.recentlyUpdated) {
      final descending = matches.reversed.toList(growable: false);
      matches
        ..clear()
        ..addAll(descending);
    }

    final start = (search.page - 1) * search.perPage;
    final pageItems = start >= matches.length
        ? const <ContactRecord>[]
        : matches.skip(start).take(search.perPage).toList(growable: false);
    final lastPage = matches.isEmpty
        ? 1
        : (matches.length / search.perPage).ceil();

    return ContactPage(
      items: pageItems,
      page: search.page,
      perPage: search.perPage,
      total: matches.length,
      lastPage: lastPage,
    );
  }

  static String _sortValue(ContactRecord contact, ContactsSort sort) =>
      switch (sort) {
        ContactsSort.lastName =>
          contact.lastName ?? contact.name ?? contact.firstName ?? '',
        ContactsSort.name => contact.displayName(''),
        ContactsSort.recentlyUpdated =>
          contact.updatedAt?.toIso8601String() ?? '',
      };
}
