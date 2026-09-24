import 'package:ngotools_api/ngotools_api.dart';
import 'package:uuid/uuid.dart';

import 'contact_cache.dart';
import 'contact_models.dart';
import 'contacts_repository.dart';

/// Coordinates encrypted local drafts and explicitly confirmed submissions.
final class ContactDraftManager {
  /// Creates a draft manager for one authenticated cache scope.
  ContactDraftManager({
    required ContactMutationRepository mutations,
    required ContactDraftStore store,
    required ContactReadCache cache,
    DateTime Function()? now,
    String Function()? uuid,
  }) : _mutations = mutations,
       _store = store,
       _cache = cache,
       _now = now ?? DateTime.now,
       _uuid = uuid ?? const Uuid().v4;

  final ContactMutationRepository _mutations;
  final ContactDraftStore _store;
  final ContactReadCache _cache;
  final DateTime Function() _now;
  final String Function() _uuid;

  /// Lists retained local drafts, newest first.
  Future<List<ContactDraft>> listDrafts() => _store.readDrafts();

  /// Creates an empty local draft without contacting the server.
  Future<ContactDraft> createDraft({
    ContactDraftKind kind = ContactDraftKind.person,
  }) async {
    final timestamp = _now().toUtc();
    final draft = ContactDraft(
      localId: _uuid(),
      idempotencyKey: _uuid(),
      kind: kind,
      createdAt: timestamp,
      updatedAt: timestamp,
    );
    return draft;
  }

  /// Creates an edit draft from an authoritative contact version.
  Future<ContactDraft> createEditDraft(ContactRecord contact) async {
    final kind = switch (contact.kind) {
      ContactKind.person => ContactDraftKind.person,
      ContactKind.organization => ContactDraftKind.organization,
      ContactKind.couple || ContactKind.unknown => throw ArgumentError.value(
        contact.kind,
        'contact.kind',
        'Only people and organizations can be edited.',
      ),
    };
    final timestamp = _now().toUtc();
    final draft = ContactDraft(
      localId: _uuid(),
      idempotencyKey: _uuid(),
      kind: kind,
      createdAt: timestamp,
      updatedAt: timestamp,
      contactId: contact.id,
      baseVersion: contact.version,
      name: contact.name,
      firstName: contact.firstName,
      lastName: contact.lastName,
      email: contact.email,
      salutation: contact.salutation,
      title: contact.title,
      gender: contact.gender,
      birthday: contact.birthday,
    );
    return draft;
  }

  /// Persists user edits locally without contacting the server.
  Future<ContactDraft> saveDraft(ContactDraft draft) async {
    final saved = draft.copyWith(
      updatedAt: _now().toUtc(),
      state: ContactDraftState.local,
    );
    await _store.writeDraft(saved);

    return saved;
  }

  /// Discards one local draft explicitly.
  Future<void> discardDraft(String localId) => _store.deleteDraft(localId);

  /// Submits once. Failures are retained and are never retried automatically.
  Future<ContactDraftSubmissionResult> submitDraft(ContactDraft draft) async {
    final submitting = draft.copyWith(updatedAt: _now().toUtc());
    await _store.writeDraft(submitting);

    try {
      final result = await _mutations.submitDraft(submitting);

      return switch (result) {
        ContactDraftSubmissionSuccess(:final contact) => await _complete(
          submitting,
          result,
          contact,
        ),
        ContactDraftSubmissionConflict() => await _retain(
          submitting,
          ContactDraftState.conflict,
          const ContactDraftSubmissionConflict(),
        ),
        ContactDraftSubmissionUnsent() => await _retain(
          submitting,
          ContactDraftState.unsent,
          const ContactDraftSubmissionUnsent(),
        ),
        ContactDraftSubmissionValidationFailure() => await _retain(
          submitting,
          ContactDraftState.validationFailure,
          const ContactDraftSubmissionValidationFailure(),
        ),
      };
    } on MobileApiException catch (error) {
      if (error.problem.status == 0 && error.problem.code == 'network_error') {
        return _retain(
          submitting,
          ContactDraftState.unsent,
          const ContactDraftSubmissionUnsent(),
        );
      }

      if (error.problem.status == 422) {
        return _retain(
          submitting,
          ContactDraftState.validationFailure,
          const ContactDraftSubmissionValidationFailure(),
        );
      }

      rethrow;
    }
  }

  Future<ContactDraftSubmissionSuccess> _complete(
    ContactDraft draft,
    ContactDraftSubmissionSuccess result,
    ContactRecord contact,
  ) async {
    await _cache.writeContact(ContactSnapshot(contact: contact));
    await _cache.invalidateSearches();
    await _store.deleteDraft(draft.localId);

    return result;
  }

  Future<ContactDraftSubmissionResult> _retain(
    ContactDraft draft,
    ContactDraftState state,
    ContactDraftSubmissionResult result,
  ) async {
    await _store.writeDraft(
      draft.copyWith(updatedAt: _now().toUtc(), state: state),
    );

    return result;
  }
}
