import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';

import 'package:crypto/crypto.dart' as crypto;
import 'package:cryptography/cryptography.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:ngotools_mobile_core/ngotools_mobile_core.dart';

import 'contact_models.dart';
import 'internal/contact_cache_document.dart';
import 'internal/contact_cache_storage.dart';

/// Fixed identity boundary for one encrypted contact cache.
final class ContactCacheScope {
  /// Creates a scope bound to one app, environment, tenant and user.
  ContactCacheScope({
    required String appId,
    required String environmentId,
    required String tenant,
    required String userId,
  }) : appId = _notEmpty(appId, 'appId'),
       environmentId = _notEmpty(environmentId, 'environmentId'),
       tenant = _notEmpty(tenant, 'tenant'),
       userId = _notEmpty(userId, 'userId');

  /// Creates a correctly bound scope from public app configuration.
  factory ContactCacheScope.fromConfiguration({
    required MobileAppConfiguration app,
    required MobileEnvironmentConfiguration environment,
    required String userId,
  }) => ContactCacheScope(
    appId: app.appId,
    environmentId: environment.id,
    tenant: app.tenant,
    userId: userId,
  );

  final String appId;
  final String environmentId;
  final String tenant;
  final String userId;

  /// Irreversible identifier used in filenames and protected-storage keys.
  String get id => crypto.sha256
      .convert(utf8.encode(jsonEncode([appId, environmentId, tenant, userId])))
      .toString();

  static String _notEmpty(String value, String name) {
    final normalized = value.trim();

    if (normalized.isEmpty) {
      throw ArgumentError.value(value, name, 'Must not be empty.');
    }

    return normalized;
  }
}

/// Retention and freshness rules for encrypted contact data.
final class ContactCachePolicy {
  /// Creates bounded cache rules.
  ContactCachePolicy({
    Duration maxAge = const Duration(minutes: 15),
    int maxSearches = 20,
    int maxContacts = 200,
    int maxDrafts = 50,
  }) : maxAge = _positiveDuration(maxAge),
       maxSearches = _positiveInt(maxSearches, 'maxSearches'),
       maxContacts = _positiveInt(maxContacts, 'maxContacts'),
       maxDrafts = _positiveInt(maxDrafts, 'maxDrafts');

  final Duration maxAge;
  final int maxSearches;
  final int maxContacts;
  final int maxDrafts;

  static Duration _positiveDuration(Duration value) {
    if (value <= Duration.zero) {
      throw ArgumentError.value(value, 'maxAge', 'Must be positive.');
    }

    return value;
  }

  static int _positiveInt(int value, String name) {
    if (value < 1) {
      throw ArgumentError.value(value, name, 'Must be at least one.');
    }

    return value;
  }
}

/// Read/write boundary for cached contact projections.
abstract interface class ContactReadCache implements MobilePrivateDataPurger {
  /// Returns a fresh cached search page or `null`.
  Future<ContactPage?> readSearch(ContactSearch search);

  /// Returns a fresh cached detail snapshot or `null`.
  Future<ContactSnapshot?> readContact(int contactId);

  /// Stores a successful remote search result.
  Future<void> writeSearch(ContactSearch search, ContactPage page);

  /// Stores a successful remote contact detail result.
  Future<void> writeContact(ContactSnapshot snapshot);

  /// Invalidates search pages after a successful mutation.
  Future<void> invalidateSearches();
}

/// Session-scoped encrypted persistence for explicitly saved drafts.
abstract interface class ContactDraftStore implements MobilePrivateDataPurger {
  /// Lists all retained drafts, newest first.
  Future<List<ContactDraft>> readDrafts();

  /// Stores a new or existing draft without silently evicting another draft.
  Future<void> writeDraft(ContactDraft draft);

  /// Removes one draft after an explicit discard or successful submission.
  Future<void> deleteDraft(String localId);
}

/// Raised when a scope already contains the configured draft maximum.
final class ContactDraftLimitExceeded implements Exception {
  /// Creates a bounded-storage error.
  const ContactDraftLimitExceeded(this.maximum);

  final int maximum;
}

/// AES-256-GCM cache with its key held in platform-protected storage.
final class EncryptedContactCache
    implements ContactReadCache, ContactDraftStore {
  /// Creates the production file and protected-key cache.
  factory EncryptedContactCache({
    required ContactCacheScope scope,
    ContactCachePolicy? policy,
    FlutterSecureStorage? secureStorage,
  }) => EncryptedContactCache.testing(
    scope: scope,
    policy: policy,
    keyStore: SecureContactCacheKeyStore(
      scopeId: scope.id,
      storage: secureStorage,
    ),
    blobStore: FileContactCacheBlobStore(scopeId: scope.id),
  );

  /// Creates a cache around controlled storage boundaries.
  EncryptedContactCache.testing({
    required ContactCacheScope scope,
    required ContactCacheKeyStore keyStore,
    required ContactCacheBlobStore blobStore,
    ContactCachePolicy? policy,
    DateTime Function()? now,
  }) : _scope = scope,
       _keyStore = keyStore,
       _blobStore = blobStore,
       _policy = policy ?? ContactCachePolicy(),
       _now = now ?? DateTime.now,
       _cipher = AesGcm.with256bits();

  static const _envelopeVersion = 1;

  final ContactCacheScope _scope;
  final ContactCacheKeyStore _keyStore;
  final ContactCacheBlobStore _blobStore;
  final ContactCachePolicy _policy;
  final DateTime Function() _now;
  final AesGcm _cipher;
  Future<void> _pending = Future<void>.value();
  bool _purged = false;

  @override
  Future<ContactPage?> readSearch(ContactSearch search) =>
      _serialized(() async {
        _validateSearch(search);

        if (_purged) {
          return null;
        }

        final document = await _loadDocument();
        final key = _searchKey(search);
        final cached = document.searches[key];

        if (cached == null) {
          return null;
        }

        if (!_isFresh(cached.storedAt)) {
          document.searches.remove(key);
          await _writeDocument(document);

          return null;
        }

        final contacts = <ContactRecord>[];

        for (final contactId in cached.contactIds) {
          final value = document.contacts[contactId];

          if (value == null || !_isFresh(value.storedAt)) {
            if (value != null) {
              document.contacts.remove(contactId);
            }
            document.searches.remove(key);
            await _writeDocument(document);

            return null;
          }

          contacts.add(value.contact);
        }

        return ContactPage(
          items: contacts,
          page: cached.page,
          perPage: cached.perPage,
          total: cached.total,
          lastPage: cached.lastPage,
          source: ContactDataSource.cache,
          cachedAt: cached.storedAt,
        );
      });

  @override
  Future<ContactSnapshot?> readContact(int contactId) => _serialized(() async {
    if (contactId < 1) {
      throw ArgumentError.value(
        contactId,
        'contactId',
        'Must be at least one.',
      );
    }

    if (_purged) {
      return null;
    }

    final document = await _loadDocument();
    final cached = document.details[contactId];

    if (cached == null) {
      return null;
    }

    if (!_isFresh(cached.storedAt)) {
      document.details.remove(contactId);
      await _writeDocument(document);

      return null;
    }

    return ContactSnapshot(
      contact: cached.contact,
      source: ContactDataSource.cache,
      cachedAt: cached.storedAt,
    );
  });

  @override
  Future<void> writeSearch(ContactSearch search, ContactPage page) =>
      _serialized(() async {
        _validateSearch(search);
        _ensureActive();

        if (page.page < 1 ||
            page.perPage < 1 ||
            page.total < 0 ||
            page.lastPage < 1 ||
            page.items.any((contact) => contact.id < 1)) {
          throw ArgumentError.value(page, 'page', 'Contains invalid metadata.');
        }

        final document = await _loadDocument();
        final storedAt = _now().toUtc();

        for (final contact in page.items) {
          document.contacts[contact.id] = CachedContactValue(
            contact: contact,
            storedAt: storedAt,
          );
        }

        document.searches[_searchKey(search)] = CachedSearchValue(
          contactIds: List<int>.unmodifiable(
            page.items.map((contact) => contact.id),
          ),
          page: page.page,
          perPage: page.perPage,
          total: page.total,
          lastPage: page.lastPage,
          storedAt: storedAt,
        );
        _prune(document);
        await _writeDocument(document);
      });

  @override
  Future<void> writeContact(ContactSnapshot snapshot) => _serialized(() async {
    _ensureActive();

    if (snapshot.contact.id < 1 ||
        snapshot.contact.addresses.any((address) => address.id < 1)) {
      throw ArgumentError.value(
        snapshot,
        'snapshot',
        'Contains invalid contact identifiers.',
      );
    }

    final document = await _loadDocument();
    final storedAt = _now().toUtc();
    final cached = CachedContactValue(
      contact: snapshot.contact,
      storedAt: storedAt,
    );
    document.contacts[snapshot.contact.id] = cached;
    document.details[snapshot.contact.id] = cached;
    _prune(document);
    await _writeDocument(document);
  });

  @override
  Future<void> invalidateSearches() => _serialized(() async {
    _ensureActive();
    final document = await _loadDocument();
    document.searches.clear();
    await _writeDocument(document);
  });

  @override
  Future<List<ContactDraft>> readDrafts() => _serialized(() async {
    if (_purged) {
      return const [];
    }

    final drafts = (await _loadDocument()).drafts.values.toList(growable: false)
      ..sort((left, right) => right.updatedAt.compareTo(left.updatedAt));

    return List<ContactDraft>.unmodifiable(drafts);
  });

  @override
  Future<void> writeDraft(ContactDraft draft) => _serialized(() async {
    _ensureActive();
    _validateDraft(draft);
    final document = await _loadDocument();

    if (!document.drafts.containsKey(draft.localId) &&
        document.drafts.length >= _policy.maxDrafts) {
      throw ContactDraftLimitExceeded(_policy.maxDrafts);
    }

    document.drafts[draft.localId] = draft;
    await _writeDocument(document);
  });

  @override
  Future<void> deleteDraft(String localId) => _serialized(() async {
    _ensureActive();

    if (!_isUuid(localId)) {
      throw ArgumentError.value(localId, 'localId', 'Must be a UUID.');
    }

    final document = await _loadDocument();

    if (document.drafts.remove(localId) != null) {
      await _writeDocument(document);
    }
  });

  @override
  Future<void> purgePrivateData() => _serialized(() async {
    _purged = true;
    var failed = false;

    try {
      await _blobStore.delete();
    } on Object {
      failed = true;
    }

    try {
      await _keyStore.delete();
    } on Object {
      failed = true;
    }

    if (failed) {
      throw StateError('Encrypted contact data could not be cleared.');
    }
  });

  Future<ContactCacheDocument> _loadDocument() async {
    final bytes = await _blobStore.read();

    if (bytes == null) {
      return ContactCacheDocument();
    }

    final keyBytes = await _keyStore.readOrCreate();

    try {
      final Object? envelopeValue = jsonDecode(utf8.decode(bytes));

      if (envelopeValue is! Map<String, Object?> ||
          envelopeValue['version'] != _envelopeVersion ||
          envelopeValue['nonce'] is! String ||
          envelopeValue['ciphertext'] is! String ||
          envelopeValue['mac'] is! String) {
        throw const FormatException('Invalid encrypted cache envelope.');
      }

      final clearText = await _cipher.decrypt(
        SecretBox(
          base64Decode(envelopeValue['ciphertext']! as String),
          nonce: base64Decode(envelopeValue['nonce']! as String),
          mac: Mac(base64Decode(envelopeValue['mac']! as String)),
        ),
        secretKey: SecretKey(keyBytes),
        aad: utf8.encode(_scope.id),
      );
      final Object? documentValue = jsonDecode(utf8.decode(clearText));

      if (documentValue is! Map<String, Object?>) {
        throw const FormatException('Invalid decrypted contact cache.');
      }

      return ContactCacheDocument.fromJson(documentValue);
    } on Object {
      await _blobStore.delete();

      return ContactCacheDocument();
    }
  }

  Future<void> _writeDocument(ContactCacheDocument document) async {
    final keyBytes = await _keyStore.readOrCreate();
    final clearText = utf8.encode(jsonEncode(document.toJson()));
    final secretBox = await _cipher.encrypt(
      clearText,
      secretKey: SecretKey(keyBytes),
      nonce: _cipher.newNonce(),
      aad: utf8.encode(_scope.id),
    );
    final envelope = <String, Object?>{
      'version': _envelopeVersion,
      'nonce': base64Encode(secretBox.nonce),
      'ciphertext': base64Encode(secretBox.cipherText),
      'mac': base64Encode(secretBox.mac.bytes),
    };
    await _blobStore.write(
      Uint8List.fromList(utf8.encode(jsonEncode(envelope))),
    );
  }

  void _prune(ContactCacheDocument document) {
    document.contacts.removeWhere((_, value) => !_isFresh(value.storedAt));
    document.details.removeWhere((_, value) => !_isFresh(value.storedAt));
    document.searches.removeWhere(
      (_, value) =>
          !_isFresh(value.storedAt) ||
          value.contactIds.any((id) => !document.contacts.containsKey(id)),
    );

    final searches = document.searches.entries.toList()
      ..sort(
        (left, right) => right.value.storedAt.compareTo(left.value.storedAt),
      );

    for (final entry in searches.skip(_policy.maxSearches)) {
      document.searches.remove(entry.key);
    }

    final allContactIds = {...document.contacts.keys, ...document.details.keys};
    final contactIdsByRecency = allContactIds.toList()
      ..sort((left, right) {
        final leftTime = _latestStoredAt(document, left);
        final rightTime = _latestStoredAt(document, right);

        return rightTime.compareTo(leftTime);
      });
    final retainedIds = contactIdsByRecency.take(_policy.maxContacts).toSet();

    document.contacts.removeWhere((id, _) => !retainedIds.contains(id));
    document.details.removeWhere((id, _) => !retainedIds.contains(id));
    document.searches.removeWhere(
      (_, search) => search.contactIds.any((id) => !retainedIds.contains(id)),
    );
  }

  DateTime _latestStoredAt(ContactCacheDocument document, int contactId) {
    final contactTime = document.contacts[contactId]?.storedAt;
    final detailTime = document.details[contactId]?.storedAt;

    if (contactTime == null) {
      return detailTime!;
    }

    if (detailTime == null) {
      return contactTime;
    }

    return contactTime.isAfter(detailTime) ? contactTime : detailTime;
  }

  bool _isFresh(DateTime storedAt) {
    final now = _now().toUtc();

    return !storedAt.isAfter(now) && now.difference(storedAt) <= _policy.maxAge;
  }

  String _searchKey(ContactSearch search) => crypto.sha256
      .convert(
        utf8.encode(
          jsonEncode([
            search.query.trim().toLowerCase(),
            search.page,
            search.perPage,
            search.sort.name,
          ]),
        ),
      )
      .toString();

  static void _validateSearch(ContactSearch search) {
    if (search.page < 1 || search.perPage < 1 || search.perPage > 100) {
      throw ArgumentError.value(
        search,
        'search',
        'Page and per-page values must be within API bounds.',
      );
    }
  }

  static void _validateDraft(ContactDraft draft) {
    if (!_isUuid(draft.localId) ||
        !_isUuid(draft.idempotencyKey) ||
        (draft.contactId == null) != (draft.baseVersion == null) ||
        (draft.contactId != null && draft.contactId! < 1) ||
        (draft.baseVersion != null &&
            !RegExp(r'^[a-f0-9]{64}$').hasMatch(draft.baseVersion!)) ||
        draft.createdAt.isAfter(draft.updatedAt)) {
      throw ArgumentError.value(draft, 'draft', 'Contains invalid metadata.');
    }
  }

  static bool _isUuid(String value) => RegExp(
    r'^[0-9a-f]{8}-[0-9a-f]{4}-[1-8][0-9a-f]{3}-[89ab][0-9a-f]{3}-[0-9a-f]{12}$',
    caseSensitive: false,
  ).hasMatch(value);

  void _ensureActive() {
    if (_purged) {
      throw StateError('The contact cache belongs to an ended session.');
    }
  }

  Future<T> _serialized<T>(Future<T> Function() operation) {
    final completer = Completer<T>();
    _pending = _pending.then((_) async {
      try {
        completer.complete(await operation());
      } on Object catch (error, stackTrace) {
        completer.completeError(error, stackTrace);
      }
    });

    return completer.future;
  }
}
