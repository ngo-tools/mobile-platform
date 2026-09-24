import 'package:ngotools_api/ngotools_api.dart';

import 'contact_cache.dart';
import 'contact_models.dart';
import 'contacts_repository.dart';

/// Adds network-only fallback to a bounded encrypted read cache.
final class CachingContactsRepository implements ContactsRepository {
  /// Creates a cache decorator around the authoritative [remote] repository.
  const CachingContactsRepository({
    required ContactsRepository remote,
    required ContactReadCache cache,
  }) : _remote = remote,
       _cache = cache;

  final ContactsRepository _remote;
  final ContactReadCache _cache;

  @override
  Future<ContactPage> search(ContactSearch search) async {
    try {
      final page = await _remote.search(search);

      if (page.source == ContactDataSource.remote) {
        await _bestEffort(() => _cache.writeSearch(search, page));
      }

      return page;
    } on MobileApiException catch (error) {
      if (!_isNetworkFailure(error)) {
        rethrow;
      }

      final cached = await _bestEffortRead(() => _cache.readSearch(search));

      if (cached != null) {
        return cached;
      }

      rethrow;
    }
  }

  @override
  Future<ContactSnapshot> getById(int contactId) async {
    try {
      final snapshot = await _remote.getById(contactId);

      if (snapshot.source == ContactDataSource.remote) {
        await _bestEffort(() => _cache.writeContact(snapshot));
      }

      return snapshot;
    } on MobileApiException catch (error) {
      if (!_isNetworkFailure(error)) {
        rethrow;
      }

      final cached = await _bestEffortRead(() => _cache.readContact(contactId));

      if (cached != null) {
        return cached;
      }

      rethrow;
    }
  }

  static bool _isNetworkFailure(MobileApiException error) =>
      error.problem.code == 'network_error' &&
      error.problem.status == 0 &&
      error.problem.retriable;

  static Future<void> _bestEffort(Future<void> Function() operation) async {
    try {
      await operation();
    } on Object {
      // A cache failure must never hide a successful authoritative response.
    }
  }

  static Future<T?> _bestEffortRead<T>(Future<T?> Function() operation) async {
    try {
      return await operation();
    } on Object {
      return null;
    }
  }
}
