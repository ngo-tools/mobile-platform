import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:ngotools_api/ngotools_api.dart';
import 'package:ngotools_contacts/ngotools_contacts.dart';

void main() {
  test('loads the first contact page', () async {
    final repository = _CallbackRepository(
      onSearch: (search) async =>
          _page(items: [_contact(1, 'Erika Beispiel')], page: search.page),
    );
    final cubit = ContactsCubit(repository: repository);

    await cubit.load();

    expect(cubit.state.status, ContactsStatus.ready);
    expect(cubit.state.contacts.single.name, 'Erika Beispiel');
    expect(repository.searches.single.page, 1);

    await cubit.close();
  });

  test('keeps only the newest search response', () async {
    final oldRequest = Completer<ContactPage>();
    final newRequest = Completer<ContactPage>();
    final repository = _CallbackRepository(
      onSearch: (search) => switch (search.query) {
        'old' => oldRequest.future,
        'new' => newRequest.future,
        _ => throw StateError('Unexpected query'),
      },
    );
    final cubit = ContactsCubit(repository: repository);

    final oldFuture = cubit.search('old');
    final newFuture = cubit.search('new');
    newRequest.complete(itemsPage([_contact(2, 'New Result')]));
    await newFuture;
    oldRequest.complete(itemsPage([_contact(1, 'Old Result')]));
    await oldFuture;

    expect(cubit.state.query, 'new');
    expect(cubit.state.contacts.single.name, 'New Result');

    await cubit.close();
  });

  test('appends the next page without replacing prior contacts', () async {
    final repository = _CallbackRepository(
      onSearch: (search) async => ContactPage(
        items: [_contact(search.page, 'Contact ${search.page}')],
        page: search.page,
        perPage: search.perPage,
        total: 2,
        lastPage: 2,
      ),
    );
    final cubit = ContactsCubit(repository: repository);

    await cubit.load();
    await cubit.loadMore();

    expect(cubit.state.contacts.map((contact) => contact.id), [1, 2]);
    expect(cubit.state.hasNextPage, isFalse);
    expect(repository.searches.map((search) => search.page), [1, 2]);

    await cubit.close();
  });

  test('maps API failures to sanitized UI categories', () async {
    final repository = _CallbackRepository(
      onSearch: (_) async => throw MobileApiException(
        MobileApiProblem(
          code: 'feature_disabled',
          title: 'Internal detail',
          status: 403,
        ),
      ),
    );
    final cubit = ContactsCubit(repository: repository);

    await cubit.load();

    expect(cubit.state.status, ContactsStatus.failure);
    expect(cubit.state.failure, ContactsFailureCode.forbidden);

    await cubit.close();
  });

  test(
    'retries a failed next page without discarding loaded contacts',
    () async {
      var secondPageAttempts = 0;
      final repository = _CallbackRepository(
        onSearch: (search) async {
          if (search.page == 2 && secondPageAttempts++ == 0) {
            throw StateError('Synthetic page failure');
          }

          return ContactPage(
            items: [_contact(search.page, 'Contact ${search.page}')],
            page: search.page,
            perPage: search.perPage,
            total: 2,
            lastPage: 2,
          );
        },
      );
      final cubit = ContactsCubit(repository: repository);

      await cubit.load();
      await cubit.loadMore();
      expect(cubit.state.status, ContactsStatus.failure);
      expect(cubit.state.contacts.single.id, 1);

      await cubit.retry();

      expect(cubit.state.status, ContactsStatus.ready);
      expect(cubit.state.contacts.map((contact) => contact.id), [1, 2]);

      await cubit.close();
    },
  );
}

ContactPage itemsPage(List<ContactRecord> contacts) => ContactPage(
  items: contacts,
  page: 1,
  perPage: 25,
  total: contacts.length,
  lastPage: 1,
);

ContactPage _page({required List<ContactRecord> items, required int page}) =>
    ContactPage(
      items: items,
      page: page,
      perPage: 25,
      total: items.length,
      lastPage: 1,
    );

ContactRecord _contact(int id, String name) =>
    ContactRecord(id: id, kind: ContactKind.person, name: name);

final class _CallbackRepository implements ContactsRepository {
  _CallbackRepository({required this.onSearch});

  final Future<ContactPage> Function(ContactSearch search) onSearch;
  final List<ContactSearch> searches = [];

  @override
  Future<ContactRecord> getById(int contactId) =>
      Future<ContactRecord>.error(StateError('No detail callback.'));

  @override
  Future<ContactPage> search(ContactSearch search) {
    searches.add(search);

    return onSearch(search);
  }
}
