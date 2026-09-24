import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter_test/flutter_test.dart';
import 'package:ngotools_contacts/ngotools_contacts.dart';
import 'package:ngotools_contacts/src/internal/contact_cache_storage.dart';
import 'package:ngotools_mobile_core/ngotools_mobile_core.dart';

void main() {
  late DateTime now;
  late _MemoryKeyStore keyStore;
  late _MemoryBlobStore blobStore;
  late EncryptedContactCache cache;

  setUp(() {
    now = DateTime.utc(2026, 9, 24, 12);
    keyStore = _MemoryKeyStore(_key(1));
    blobStore = _MemoryBlobStore();
    cache = _cache(keyStore: keyStore, blobStore: blobStore, now: () => now);
  });

  test(
    'round-trips search and detail data as authenticated ciphertext',
    () async {
      const search = ContactSearch(query: 'Erika');
      final page = _page([_contact(101, 'Erika Beispiel')]);
      final detail = ContactSnapshot(
        contact: _contact(101, 'Erika Beispiel', withAddress: true),
      );

      await cache.writeSearch(search, page);
      final firstEnvelope = utf8.decode(blobStore.bytes!);
      await cache.writeContact(detail);
      final secondEnvelope = utf8.decode(blobStore.bytes!);

      final cachedPage = await cache.readSearch(search);
      final cachedDetail = await cache.readContact(101);
      expect(cachedPage?.items.single.name, 'Erika Beispiel');
      expect(cachedPage?.source, ContactDataSource.cache);
      expect(cachedPage?.cachedAt, now);
      expect(cachedDetail?.contact.addresses.single.city, 'Berlin');
      expect(cachedDetail?.source, ContactDataSource.cache);
      expect(firstEnvelope, isNot(contains('Erika')));
      expect(secondEnvelope, isNot(contains('Berlin')));
      expect(_nonce(firstEnvelope), isNot(_nonce(secondEnvelope)));
    },
  );

  test('derives an opaque scope from public app configuration', () {
    final app = MobileAppConfiguration(
      appId: 'mob_01J00000000000000000000000',
      tenant: 'synthetic-demo',
      defaultLocale: 'en',
      locales: const ['en'],
      environments: {MobileEnvironment.staging: _environment()},
    );
    final scope = ContactCacheScope.fromConfiguration(
      app: app,
      environment: app.forEnvironment(MobileEnvironment.staging),
      userId: 'synthetic-user',
    );

    expect(scope.id, hasLength(64));
    expect(scope.id, isNot(contains('synthetic')));
    expect(
      ContactCacheScope.fromConfiguration(
        app: app,
        environment: app.forEnvironment(MobileEnvironment.staging),
        userId: 'other-user',
      ).id,
      isNot(scope.id),
    );
  });

  test('rejects tampering and removes the unreadable blob', () async {
    await cache.writeSearch(
      const ContactSearch(),
      _page([_contact(101, 'Synthetic Contact')]),
    );
    final envelope =
        jsonDecode(utf8.decode(blobStore.bytes!)) as Map<String, Object?>;
    final cipherText = base64Decode(envelope['ciphertext']! as String);
    cipherText[0] ^= 0xff;
    envelope['ciphertext'] = base64Encode(cipherText);
    blobStore.bytes = Uint8List.fromList(utf8.encode(jsonEncode(envelope)));

    final cached = await cache.readSearch(const ContactSearch());

    expect(cached, isNull);
    expect(blobStore.bytes, isNull);
    expect(blobStore.deletes, 1);
  });

  test('fails closed for malformed or unknown envelopes', () async {
    blobStore.bytes = Uint8List.fromList(
      utf8.encode(jsonEncode({'version': 999, 'contact': 'Synthetic'})),
    );

    expect(await cache.readSearch(const ContactSearch()), isNull);
    expect(blobStore.bytes, isNull);
  });

  test('binds ciphertext to both its key and scope', () async {
    await cache.writeSearch(
      const ContactSearch(),
      _page([_contact(101, 'Synthetic Contact')]),
    );
    final encrypted = Uint8List.fromList(blobStore.bytes!);
    final wrongKeyBlob = _MemoryBlobStore()..bytes = encrypted;
    final wrongKeyCache = _cache(
      keyStore: _MemoryKeyStore(_key(2)),
      blobStore: wrongKeyBlob,
      now: () => now,
    );
    final otherScopeBlob = _MemoryBlobStore()..bytes = encrypted;
    final otherScopeCache = _cache(
      scope: _scope(userId: 'different-synthetic-user'),
      keyStore: _MemoryKeyStore(_key(1)),
      blobStore: otherScopeBlob,
      now: () => now,
    );

    expect(await wrongKeyCache.readSearch(const ContactSearch()), isNull);
    expect(await otherScopeCache.readSearch(const ContactSearch()), isNull);
    expect(wrongKeyBlob.bytes, isNull);
    expect(otherScopeBlob.bytes, isNull);
  });

  test('expires and removes stale snapshots', () async {
    await cache.writeSearch(
      const ContactSearch(),
      _page([_contact(101, 'Synthetic Contact')]),
    );
    now = now.add(const Duration(minutes: 16));

    expect(await cache.readSearch(const ContactSearch()), isNull);

    now = now.subtract(const Duration(minutes: 16));
    expect(await cache.readSearch(const ContactSearch()), isNull);
  });

  test('bounds retained searches and contact records', () async {
    cache = _cache(
      keyStore: keyStore,
      blobStore: blobStore,
      now: () => now,
      policy: ContactCachePolicy(maxSearches: 2, maxContacts: 2),
    );

    for (var id = 1; id <= 3; id += 1) {
      await cache.writeSearch(
        ContactSearch(query: 'query-$id'),
        _page([_contact(id, 'Contact $id')]),
      );
      now = now.add(const Duration(seconds: 1));
    }

    expect(
      await cache.readSearch(const ContactSearch(query: 'query-1')),
      isNull,
    );
    expect(
      await cache.readSearch(const ContactSearch(query: 'query-2')),
      isNotNull,
    );
    expect(
      await cache.readSearch(const ContactSearch(query: 'query-3')),
      isNotNull,
    );
  });

  test('serializes concurrent list and detail updates', () async {
    await Future.wait([
      cache.writeSearch(
        const ContactSearch(query: 'one'),
        _page([_contact(1, 'Contact One')]),
      ),
      cache.writeContact(
        ContactSnapshot(contact: _contact(2, 'Contact Two', withAddress: true)),
      ),
      cache.writeSearch(
        const ContactSearch(query: 'three'),
        _page([_contact(3, 'Contact Three')]),
      ),
    ]);

    expect(
      (await cache.readSearch(
        const ContactSearch(query: 'one'),
      ))?.items.single.id,
      1,
    );
    expect((await cache.readContact(2))?.contact.id, 2);
    expect(
      (await cache.readSearch(
        const ContactSearch(query: 'three'),
      ))?.items.single.id,
      3,
    );
  });

  test('purges both ciphertext and its protected key', () async {
    await cache.writeSearch(
      const ContactSearch(),
      _page([_contact(101, 'Synthetic Contact')]),
    );

    await cache.purgePrivateData();

    expect(blobStore.bytes, isNull);
    expect(blobStore.deletes, 1);
    expect(keyStore.key, isNull);
    expect(keyStore.deletes, 1);
  });

  test('cannot be recreated by a late write after session purge', () async {
    await cache.purgePrivateData();

    await expectLater(
      cache.writeSearch(
        const ContactSearch(),
        _page([_contact(101, 'Late Synthetic Contact')]),
      ),
      throwsStateError,
    );

    expect(await cache.readSearch(const ContactSearch()), isNull);
    expect(blobStore.bytes, isNull);
    expect(keyStore.key, isNull);
  });

  test('attempts key deletion even when blob deletion fails', () async {
    blobStore.deleteFails = true;

    await expectLater(cache.purgePrivateData(), throwsStateError);

    expect(blobStore.deletes, 1);
    expect(keyStore.deletes, 1);
    expect(keyStore.key, isNull);
  });

  test('atomically stores encrypted files in application support', () async {
    final directory = await Directory.systemTemp.createTemp(
      'ngotools-contact-cache-',
    );
    addTearDown(() => directory.delete(recursive: true));
    final fileStore = FileContactCacheBlobStore(
      scopeId: _scope().id,
      supportDirectory: () async => directory,
    );
    final bytes = Uint8List.fromList([1, 2, 3, 4]);

    await fileStore.write(bytes);

    expect(await fileStore.read(), bytes);
    expect(
      directory
          .listSync(recursive: true)
          .whereType<File>()
          .where((file) => file.path.endsWith('.tmp')),
      isEmpty,
    );

    await fileStore.delete();
    expect(await fileStore.read(), isNull);
  });
}

EncryptedContactCache _cache({
  ContactCacheScope? scope,
  required ContactCacheKeyStore keyStore,
  required ContactCacheBlobStore blobStore,
  required DateTime Function() now,
  ContactCachePolicy? policy,
}) => EncryptedContactCache.testing(
  scope: scope ?? _scope(),
  keyStore: keyStore,
  blobStore: blobStore,
  now: now,
  policy: policy,
);

ContactCacheScope _scope({String userId = 'synthetic-user'}) =>
    ContactCacheScope(
      appId: 'mob_01J00000000000000000000000',
      environmentId: 'env_01J00000000000000000000000',
      tenant: 'synthetic-demo',
      userId: userId,
    );

MobileEnvironmentConfiguration _environment() => MobileEnvironmentConfiguration(
  environment: MobileEnvironment.staging,
  id: 'env_01J00000000000000000000000',
  apiBaseUrl: Uri.https('staging.example.invalid'),
  configRevision: 'cfg_01J00000000000000000000000',
  attestationMode: MobileAttestationMode.test,
  oidc: MobileOidcConfiguration(
    issuer: Uri.https('identity.example.invalid', '/realms/synthetic'),
    clientId: 'mobile-synthetic',
    redirectUri: Uri.parse('ngotools-synthetic://oauth/callback'),
    scopes: const ['openid'],
  ),
);

List<int> _key(int seed) => List<int>.generate(32, (index) => seed + index);

String _nonce(String envelope) =>
    (jsonDecode(envelope) as Map<String, Object?>)['nonce']! as String;

ContactPage _page(List<ContactRecord> contacts) => ContactPage(
  items: contacts,
  page: 1,
  perPage: 25,
  total: contacts.length,
  lastPage: 1,
);

ContactRecord _contact(int id, String name, {bool withAddress = false}) =>
    ContactRecord(
      id: id,
      kind: ContactKind.person,
      name: name,
      email: 'contact-$id@example.invalid',
      addresses: withAddress
          ? [
              ContactAddress(
                id: id * 10,
                line1: 'Musterweg $id',
                city: 'Berlin',
                country: 'DE',
              ),
            ]
          : const [],
    );

final class _MemoryKeyStore implements ContactCacheKeyStore {
  _MemoryKeyStore(this.key);

  List<int>? key;
  int deletes = 0;

  @override
  Future<void> delete() async {
    deletes += 1;
    key = null;
  }

  @override
  Future<List<int>> readOrCreate() async =>
      key ??= List<int>.generate(32, (index) => 200 + index);
}

final class _MemoryBlobStore implements ContactCacheBlobStore {
  Uint8List? bytes;
  int deletes = 0;
  bool deleteFails = false;

  @override
  Future<void> delete() async {
    deletes += 1;

    if (deleteFails) {
      throw StateError('Synthetic blob delete failure.');
    }

    bytes = null;
  }

  @override
  Future<Uint8List?> read() async =>
      bytes == null ? null : Uint8List.fromList(bytes!);

  @override
  Future<void> write(Uint8List bytes) async {
    this.bytes = Uint8List.fromList(bytes);
  }
}
