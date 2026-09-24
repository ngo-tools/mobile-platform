import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:ngotools_api/ngotools_api.dart';
import 'package:ngotools_contacts/ngotools_contacts.dart';

void main() {
  late _MockMobileApi api;
  late NgoToolsContactsRepository repository;

  setUpAll(() {
    registerFallbackValue(
      const MobileContactMutation(kind: MobileWritableContactKind.person),
    );
  });

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
            version:
                'aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa',
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

  test('maps confirmed drafts into the stable mutation API', () async {
    when(
      () => api.createContact(
        idempotencyKey: any(named: 'idempotencyKey'),
        contact: any(named: 'contact'),
      ),
    ).thenAnswer(
      (_) async => MobileContactMutationSuccess(
        contact: MobileContact(
          id: 43,
          kind: MobileContactKind.person,
          version:
              'bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb',
          firstName: 'Erika',
          lastName: 'Beispiel',
        ),
        replayed: false,
      ),
    );
    final draft = ContactDraft(
      localId: '018e9cf8-7aa1-7cc8-8e6b-6f1deacb4101',
      idempotencyKey: '018e9cf8-7aa1-7cc8-8e6b-6f1deacb4201',
      kind: ContactDraftKind.person,
      createdAt: DateTime.utc(2026, 9, 24),
      updatedAt: DateTime.utc(2026, 9, 24),
      firstName: 'Erika',
      lastName: 'Beispiel',
    );

    final result = await repository.submitDraft(draft);

    expect(result, isA<ContactDraftSubmissionSuccess>());
    final mutation =
        verify(
              () => api.createContact(
                idempotencyKey: draft.idempotencyKey,
                contact: captureAny(named: 'contact'),
              ),
            ).captured.single
            as MobileContactMutation;
    expect(mutation.kind, MobileWritableContactKind.person);
    expect(mutation.firstName, 'Erika');
  });
}

final class _MockMobileApi extends Mock implements MobileContactsApi {}
