import 'package:flutter_test/flutter_test.dart';
import 'package:ngotools_api/ngotools_api.dart';
import 'package:ngotools_contacts/ngotools_contacts.dart';

void main() {
  late DateTime now;
  late _MemoryContactStore store;
  late _MutationRepository mutations;
  late ContactDraftManager manager;
  late List<String> uuids;

  setUp(() {
    now = DateTime.utc(2026, 9, 24, 18);
    store = _MemoryContactStore();
    mutations = _MutationRepository();
    uuids = [
      '018e9cf8-7aa1-7cc8-8e6b-6f1deacb4101',
      '018e9cf8-7aa1-7cc8-8e6b-6f1deacb4201',
    ];
    manager = ContactDraftManager(
      mutations: mutations,
      store: store,
      cache: store,
      now: () => now,
      uuid: () => uuids.removeAt(0),
    );
  });

  test('manual retry reuses the draft idempotency key', () async {
    var attempt = 0;
    mutations.onSubmit = (draft) async {
      attempt += 1;

      if (attempt == 1) {
        throw MobileApiException(
          MobileApiProblem(
            code: 'network_error',
            title: 'Network unavailable',
            status: 0,
            retriable: true,
          ),
        );
      }

      return ContactDraftSubmissionSuccess(
        contact: _contact(firstName: 'Erika'),
        replayed: false,
      );
    };
    final draft = await manager.createDraft();
    final saved = await manager.saveDraft(
      draft.copyWith(
        firstName: 'Erika',
        lastName: 'Beispiel',
        email: 'erika@example.invalid',
      ),
    );

    final firstResult = await manager.submitDraft(saved);
    final retained = (await manager.listDrafts()).single;
    final secondResult = await manager.submitDraft(retained);

    expect(firstResult, isA<ContactDraftSubmissionUnsent>());
    expect(secondResult, isA<ContactDraftSubmissionSuccess>());
    expect(
      mutations.submissions.map((draft) => draft.idempotencyKey),
      everyElement(saved.idempotencyKey),
    );
    expect(store.drafts, isEmpty);
    expect(store.writtenContact?.contact.firstName, 'Erika');
    expect(store.searchInvalidations, 1);
  });

  test('keeps an edit draft when the opaque version conflicts', () async {
    mutations.onSubmit = (_) async => const ContactDraftSubmissionConflict();
    final draft = await manager.createEditDraft(
      _contact(firstName: 'Original'),
    );
    final saved = await manager.saveDraft(
      draft.copyWith(firstName: 'Local edit'),
    );

    final result = await manager.submitDraft(saved);
    final retained = (await manager.listDrafts()).single;

    expect(result, isA<ContactDraftSubmissionConflict>());
    expect(retained.state, ContactDraftState.conflict);
    expect(retained.firstName, 'Local edit');
    expect(retained.baseVersion, _version);
    expect(store.writtenContact, isNull);
  });

  test('does not recreate private data after logout seals the store', () async {
    final draft = await manager.createDraft();
    await store.purgePrivateData();

    await expectLater(manager.saveDraft(draft), throwsStateError);
    expect(await manager.listDrafts(), isEmpty);
  });
}

const _version =
    'aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa';

ContactRecord _contact({required String firstName}) => ContactRecord(
  id: 42,
  kind: ContactKind.person,
  version: _version,
  firstName: firstName,
  lastName: 'Beispiel',
  email: 'erika@example.invalid',
);

final class _MutationRepository implements ContactMutationRepository {
  Future<ContactDraftSubmissionResult> Function(ContactDraft draft)? onSubmit;
  final List<ContactDraft> submissions = [];

  @override
  Future<ContactDraftSubmissionResult> submitDraft(ContactDraft draft) {
    submissions.add(draft);

    return onSubmit!(draft);
  }
}

final class _MemoryContactStore implements ContactDraftStore, ContactReadCache {
  final Map<String, ContactDraft> drafts = {};
  ContactSnapshot? writtenContact;
  int searchInvalidations = 0;
  bool purged = false;

  @override
  Future<void> deleteDraft(String localId) async {
    _ensureActive();
    drafts.remove(localId);
  }

  @override
  Future<void> invalidateSearches() async {
    _ensureActive();
    searchInvalidations += 1;
  }

  @override
  Future<void> purgePrivateData() async {
    purged = true;
    drafts.clear();
    writtenContact = null;
  }

  @override
  Future<ContactSnapshot?> readContact(int contactId) async => null;

  @override
  Future<List<ContactDraft>> readDrafts() async =>
      purged ? const [] : List<ContactDraft>.unmodifiable(drafts.values);

  @override
  Future<ContactPage?> readSearch(ContactSearch search) async => null;

  @override
  Future<void> writeContact(ContactSnapshot snapshot) async {
    _ensureActive();
    writtenContact = snapshot;
  }

  @override
  Future<void> writeDraft(ContactDraft draft) async {
    _ensureActive();
    drafts[draft.localId] = draft;
  }

  @override
  Future<void> writeSearch(ContactSearch search, ContactPage page) async {}

  void _ensureActive() {
    if (purged) {
      throw StateError('Synthetic store has been purged.');
    }
  }
}
