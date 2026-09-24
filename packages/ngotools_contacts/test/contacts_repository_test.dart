import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:ngotools_api/ngotools_api.dart';
import 'package:ngotools_contacts/ngotools_contacts.dart';

void main() {
  late _MockMobileApi api;
  late NgoToolsContactsRepository repository;

  setUp(() {
    api = _MockMobileApi();
    repository = NgoToolsContactsRepository(api);
  });

  test('maps stable API contacts into domain records', () async {
    when(
      () => api.searchContacts(
        query: any(named: 'query'),
        page: any(named: 'page'),
        perPage: any(named: 'perPage'),
        sort: any(named: 'sort'),
      ),
    ).thenAnswer(
      (_) async => MobileContactPage(
        items: [
          MobileContact(
            id: 42,
            kind: MobileContactKind.person,
            firstName: 'Erika',
            lastName: 'Beispiel',
            email: 'erika@example.invalid',
            addresses: const [
              MobileContactAddress(id: 8, city: 'Berlin', country: 'DE'),
            ],
          ),
        ],
        page: 1,
        perPage: 25,
        total: 1,
        lastPage: 1,
      ),
    );

    final result = await repository.search(const ContactSearch(query: 'Erika'));

    expect(result.items.single.kind, ContactKind.person);
    expect(result.items.single.displayName('Fallback'), 'Erika Beispiel');
    expect(result.items.single.addresses.single.city, 'Berlin');
    final invocation =
        verify(
              () => api.searchContacts(
                query: 'Erika',
                page: 1,
                perPage: 25,
                sort: captureAny(named: 'sort'),
              ),
            ).captured.single
            as List<MobileContactSort>;
    expect(invocation.map((sort) => sort.field), [
      MobileContactSortField.lastName,
      MobileContactSortField.id,
    ]);
  });

  test('uses deterministic descending sort for recent changes', () async {
    when(
      () => api.searchContacts(
        query: any(named: 'query'),
        page: any(named: 'page'),
        perPage: any(named: 'perPage'),
        sort: any(named: 'sort'),
      ),
    ).thenAnswer(
      (_) async => MobileContactPage(
        items: const [],
        page: 1,
        perPage: 25,
        total: 0,
        lastPage: 1,
      ),
    );

    await repository.search(
      const ContactSearch(sort: ContactsSort.recentlyUpdated),
    );

    final sorts =
        verify(
              () => api.searchContacts(
                query: '',
                page: 1,
                perPage: 25,
                sort: captureAny(named: 'sort'),
              ),
            ).captured.single
            as List<MobileContactSort>;
    expect(sorts.map((sort) => (sort.field, sort.direction)), [
      (MobileContactSortField.updatedAt, MobileContactSortDirection.descending),
      (MobileContactSortField.id, MobileContactSortDirection.descending),
    ]);
  });
}

final class _MockMobileApi extends Mock implements MobileContactsApi {}
