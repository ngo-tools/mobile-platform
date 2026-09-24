import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ngotools_api/ngotools_api.dart';
import 'package:ngotools_contacts/ngotools_contacts.dart';

void main() {
  testWidgets('submits only after confirmation and retries manually', (
    tester,
  ) async {
    final store = _MemoryContactStore();
    final mutations = _MutationRepository();
    final uuids = [
      '018e9cf8-7aa1-7cc8-8e6b-6f1deacb4101',
      '018e9cf8-7aa1-7cc8-8e6b-6f1deacb4201',
    ];
    final manager = ContactDraftManager(
      mutations: mutations,
      store: store,
      cache: store,
      now: () => DateTime.utc(2026, 9, 24, 18),
      uuid: () => uuids.removeAt(0),
    );
    final draft = await manager.createDraft();

    await tester.pumpWidget(
      MaterialApp(
        home: ContactEditorPage(
          manager: manager,
          draft: draft,
          labels: ContactLabels.english,
        ),
      ),
    );
    await tester.enterText(
      find.byKey(const ValueKey('contact-first-name')),
      'Erika',
    );
    await tester.enterText(
      find.byKey(const ValueKey('contact-last-name')),
      'Example',
    );
    await tester.enterText(
      find.byKey(const ValueKey('contact-email')),
      'erika@example.invalid',
    );

    await tester.drag(find.byType(ListView), const Offset(0, -700));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Submit draft'));
    await tester.pumpAndSettle();

    expect(find.text('Submit this contact?'), findsOneWidget);
    expect(mutations.submissions, isEmpty);

    await tester.tap(find.text('Confirm and submit'));
    await tester.pumpAndSettle();
    await tester.drag(find.byType(ListView), const Offset(0, 700));
    await tester.pumpAndSettle();

    expect(find.textContaining('Not sent.'), findsOneWidget);
    expect(mutations.submissions, hasLength(1));

    await tester.drag(find.byType(ListView), const Offset(0, -700));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Submit draft'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Confirm and submit'));
    await tester.pumpAndSettle();

    expect(find.text('The contact was saved on the server.'), findsOneWidget);
    expect(mutations.submissions, hasLength(2));
    expect(mutations.submissions.map((item) => item.idempotencyKey).toSet(), {
      draft.idempotencyKey,
    });
    expect(store.drafts, isEmpty);
  });
}

final class _MutationRepository implements ContactMutationRepository {
  final List<ContactDraft> submissions = [];

  @override
  Future<ContactDraftSubmissionResult> submitDraft(ContactDraft draft) async {
    submissions.add(draft);

    if (submissions.length == 1) {
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
      contact: ContactRecord(
        id: 42,
        kind: ContactKind.person,
        version:
            'aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa',
        firstName: draft.firstName,
        lastName: draft.lastName,
        email: draft.email,
      ),
      replayed: false,
    );
  }
}

final class _MemoryContactStore implements ContactDraftStore, ContactReadCache {
  final Map<String, ContactDraft> drafts = {};

  @override
  Future<void> deleteDraft(String localId) async {
    drafts.remove(localId);
  }

  @override
  Future<void> invalidateSearches() async {}

  @override
  Future<void> purgePrivateData() async {
    drafts.clear();
  }

  @override
  Future<ContactSnapshot?> readContact(int contactId) async => null;

  @override
  Future<List<ContactDraft>> readDrafts() async =>
      List<ContactDraft>.unmodifiable(drafts.values);

  @override
  Future<ContactPage?> readSearch(ContactSearch search) async => null;

  @override
  Future<void> writeContact(ContactSnapshot snapshot) async {}

  @override
  Future<void> writeDraft(ContactDraft draft) async {
    drafts[draft.localId] = draft;
  }

  @override
  Future<void> writeSearch(ContactSearch search, ContactPage page) async {}
}
