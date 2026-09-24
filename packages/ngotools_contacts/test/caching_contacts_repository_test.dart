import 'package:flutter_test/flutter_test.dart';
import 'package:ngotools_api/ngotools_api.dart';
import 'package:ngotools_contacts/ngotools_contacts.dart';

void main() {
  late _RemoteRepository remote;
  late _ContactCache cache;
  late CachingContactsRepository repository;

  setUp(() {
    remote = _RemoteRepository();
    cache = _ContactCache();
    repository = CachingContactsRepository(remote: remote, cache: cache);
  });

  test('refreshes the cache after an authoritative response', () async {
    final page = _page(ContactDataSource.remote);
    remote.page = page;

    final result = await repository.search(const ContactSearch());

    expect(result, same(page));
    expect(cache.writtenPage, same(page));
    expect(cache.writtenSearch, const ContactSearch());
  });

  test('refreshes cached details after an authoritative response', () async {
    final snapshot = _snapshot(ContactDataSource.remote);
    remote.snapshot = snapshot;

    final result = await repository.getById(42);

    expect(result, same(snapshot));
    expect(cache.writtenSnapshot, same(snapshot));
  });

  test('falls back to a cached page only for a network failure', () async {
    remote.error = _problem('network_error', 0, retriable: true);
    cache.page = _page(ContactDataSource.cache);

    final result = await repository.search(const ContactSearch());

    expect(result.source, ContactDataSource.cache);
    expect(cache.searchReads, 1);
  });

  test('falls back to cached details only for a network failure', () async {
    remote.error = _problem('network_error', 0, retriable: true);
    cache.snapshot = _snapshot(ContactDataSource.cache);

    final result = await repository.getById(42);

    expect(result.source, ContactDataSource.cache);
    expect(cache.contactReads, 1);
  });

  test('never serves cache for authorization or invalid responses', () async {
    for (final error in [
      _problem('unauthenticated', 401),
      _problem('feature_disabled', 403),
      _problem('invalid_response', 0),
      _problem('network_error', 0),
    ]) {
      remote.error = error;
      cache.page = _page(ContactDataSource.cache);

      await expectLater(
        repository.search(const ContactSearch()),
        throwsA(same(error)),
      );
    }

    expect(cache.searchReads, 0);
  });

  test('rethrows network failure when no fresh cache exists', () async {
    final error = _problem('network_error', 0, retriable: true);
    remote.error = error;

    await expectLater(
      repository.search(const ContactSearch()),
      throwsA(same(error)),
    );
  });

  test('does not hide a remote result when cache persistence fails', () async {
    final page = _page(ContactDataSource.remote);
    remote.page = page;
    cache.writeFails = true;

    expect(await repository.search(const ContactSearch()), same(page));
  });
}

MobileApiException _problem(
  String code,
  int status, {
  bool retriable = false,
}) => MobileApiException(
  MobileApiProblem(
    code: code,
    title: 'Sanitized failure',
    status: status,
    retriable: retriable,
  ),
);

ContactPage _page(ContactDataSource source) => ContactPage(
  items: const [
    ContactRecord(id: 42, kind: ContactKind.person, name: 'Synthetic Contact'),
  ],
  page: 1,
  perPage: 25,
  total: 1,
  lastPage: 1,
  source: source,
  cachedAt: source == ContactDataSource.cache
      ? DateTime.utc(2026, 9, 24)
      : null,
);

ContactSnapshot _snapshot(ContactDataSource source) => ContactSnapshot(
  contact: const ContactRecord(
    id: 42,
    kind: ContactKind.person,
    name: 'Synthetic Contact',
  ),
  source: source,
  cachedAt: source == ContactDataSource.cache
      ? DateTime.utc(2026, 9, 24)
      : null,
);

final class _RemoteRepository implements ContactsRepository {
  ContactPage? page;
  ContactSnapshot? snapshot;
  MobileApiException? error;

  @override
  Future<ContactSnapshot> getById(int contactId) async {
    if (error case final failure?) {
      throw failure;
    }

    return snapshot ?? _snapshot(ContactDataSource.remote);
  }

  @override
  Future<ContactPage> search(ContactSearch search) async {
    if (error case final failure?) {
      throw failure;
    }

    return page ?? _page(ContactDataSource.remote);
  }
}

final class _ContactCache implements ContactReadCache {
  ContactPage? page;
  ContactSnapshot? snapshot;
  ContactSearch? writtenSearch;
  ContactPage? writtenPage;
  ContactSnapshot? writtenSnapshot;
  bool writeFails = false;
  int searchReads = 0;
  int contactReads = 0;

  @override
  Future<void> purgePrivateData() async {}

  @override
  Future<ContactSnapshot?> readContact(int contactId) async {
    contactReads += 1;

    return snapshot;
  }

  @override
  Future<ContactPage?> readSearch(ContactSearch search) async {
    searchReads += 1;

    return page;
  }

  @override
  Future<void> writeContact(ContactSnapshot snapshot) async {
    if (writeFails) {
      throw StateError('Synthetic cache write failure');
    }

    writtenSnapshot = snapshot;
  }

  @override
  Future<void> writeSearch(ContactSearch search, ContactPage page) async {
    if (writeFails) {
      throw StateError('Synthetic cache write failure');
    }

    writtenSearch = search;
    writtenPage = page;
  }
}
