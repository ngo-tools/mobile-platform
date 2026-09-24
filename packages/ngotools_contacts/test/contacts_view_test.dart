import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ngotools_contacts/ngotools_contacts.dart';

void main() {
  testWidgets('renders and searches synthetic contacts', (tester) async {
    final repository = _SyntheticRepository();

    await tester.pumpWidget(_app(repository));
    await tester.pumpAndSettle();

    expect(find.text('Erika Beispiel'), findsOneWidget);
    expect(find.text('Beispielverein'), findsOneWidget);

    await tester.enterText(find.byType(SearchBar), 'Verein');
    await tester.testTextInput.receiveAction(TextInputAction.done);
    await tester.pumpAndSettle();

    expect(find.text('Erika Beispiel'), findsNothing);
    expect(find.text('Beispielverein'), findsOneWidget);
    expect(repository.searches.last.query, 'Verein');
  });

  testWidgets('opens read-only contact details', (tester) async {
    final repository = _SyntheticRepository();

    await tester.pumpWidget(_app(repository));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Erika Beispiel'));
    await tester.pumpAndSettle();

    expect(find.text('Contact details'), findsOneWidget);
    expect(find.text('erika@example.invalid'), findsOneWidget);
    expect(find.textContaining('Musterweg 1'), findsOneWidget);
  });

  testWidgets('uses a grid on wide layouts', (tester) async {
    await tester.binding.setSurfaceSize(const Size(1000, 800));
    addTearDown(() => tester.binding.setSurfaceSize(null));

    await tester.pumpWidget(_app(_SyntheticRepository()));
    await tester.pumpAndSettle();

    expect(find.byType(GridView), findsOneWidget);
  });

  testWidgets('shows a retry action for sanitized failures', (tester) async {
    final repository = _SyntheticRepository(failSearch: true);

    await tester.pumpWidget(_app(repository));
    await tester.pumpAndSettle();

    expect(find.text('Contacts could not be loaded.'), findsWidgets);
    expect(find.text('Try again'), findsOneWidget);
  });

  testWidgets('labels cached list and detail data as offline copies', (
    tester,
  ) async {
    final repository = _SyntheticRepository(source: ContactDataSource.cache);

    await tester.pumpWidget(_app(repository));
    await tester.pumpAndSettle();

    expect(find.text(ContactLabels.english.cachedMessage), findsOneWidget);

    await tester.tap(find.text('Erika Beispiel'));
    await tester.pumpAndSettle();

    expect(find.text(ContactLabels.english.cachedMessage), findsOneWidget);
  });
}

Widget _app(ContactsRepository repository) => MaterialApp(
  home: Scaffold(
    body: ContactsView(repository: repository, labels: ContactLabels.english),
  ),
);

final class _SyntheticRepository implements ContactsRepository {
  _SyntheticRepository({
    this.failSearch = false,
    this.source = ContactDataSource.remote,
  });

  final bool failSearch;
  final ContactDataSource source;
  final List<ContactSearch> searches = [];
  final List<ContactRecord> contacts = const [
    ContactRecord(
      id: 1,
      kind: ContactKind.person,
      firstName: 'Erika',
      lastName: 'Beispiel',
      email: 'erika@example.invalid',
      addresses: [
        ContactAddress(
          id: 10,
          line1: 'Musterweg 1',
          postalCode: '10115',
          city: 'Berlin',
          country: 'DE',
        ),
      ],
    ),
    ContactRecord(
      id: 2,
      kind: ContactKind.organization,
      name: 'Beispielverein',
      email: 'verein@example.invalid',
    ),
  ];

  @override
  Future<ContactSnapshot> getById(int contactId) async => ContactSnapshot(
    contact: contacts.singleWhere((contact) => contact.id == contactId),
    source: source,
    cachedAt: source == ContactDataSource.cache
        ? DateTime.utc(2026, 9, 24)
        : null,
  );

  @override
  Future<ContactPage> search(ContactSearch search) async {
    searches.add(search);

    if (failSearch) {
      throw StateError('Synthetic failure');
    }

    final query = search.query.toLowerCase();
    final matches = contacts
        .where(
          (contact) => contact.displayName('').toLowerCase().contains(query),
        )
        .toList(growable: false);

    return ContactPage(
      items: matches,
      page: 1,
      perPage: search.perPage,
      total: matches.length,
      lastPage: 1,
      source: source,
      cachedAt: source == ContactDataSource.cache
          ? DateTime.utc(2026, 9, 24)
          : null,
    );
  }
}
