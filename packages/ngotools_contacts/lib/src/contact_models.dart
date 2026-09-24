import 'package:freezed_annotation/freezed_annotation.dart';

part 'contact_models.freezed.dart';

/// Contact categories understood by the mobile presentation layer.
enum ContactKind { person, organization, couple, unknown }

/// Sort modes supported by the contact list.
enum ContactsSort { lastName, name, recentlyUpdated }

/// Origin of a contact result shown to the user.
enum ContactDataSource { remote, cache }

/// Contact kinds supported by the mobile editor.
enum ContactDraftKind { person, organization }

/// Persisted local state of a contact draft.
enum ContactDraftState { local, unsent, validationFailure, conflict }

/// Sanitized address fields displayed in contact details.
@freezed
abstract class ContactAddress with _$ContactAddress {
  /// Creates an immutable contact address.
  const factory ContactAddress({
    required int id,
    String? type,
    String? line1,
    String? line2,
    String? postalCode,
    String? city,
    String? state,
    String? country,
  }) = _ContactAddress;
}

/// Read-only contact projection owned by the contacts package.
@freezed
abstract class ContactRecord with _$ContactRecord {
  const ContactRecord._();

  /// Creates an immutable contact projection.
  const factory ContactRecord({
    required int id,
    required ContactKind kind,
    required String version,
    String? name,
    String? firstName,
    String? lastName,
    String? email,
    String? salutation,
    String? title,
    String? gender,
    DateTime? birthday,
    int? activeAddressId,
    DateTime? updatedAt,
    @Default(<ContactAddress>[]) List<ContactAddress> addresses,
  }) = _ContactRecord;

  /// Resolves the best available label without exposing an empty value.
  String displayName(String fallback) {
    final explicitName = name?.trim();

    if (explicitName != null && explicitName.isNotEmpty) {
      return explicitName;
    }

    final composedName = [
      firstName?.trim(),
      lastName?.trim(),
    ].whereType<String>().where((part) => part.isNotEmpty).join(' ');

    return composedName.isEmpty ? fallback : composedName;
  }
}

/// Encrypted, session-scoped contact draft awaiting explicit submission.
@freezed
abstract class ContactDraft with _$ContactDraft {
  /// Creates a local draft with one stable idempotency key.
  const factory ContactDraft({
    required String localId,
    required String idempotencyKey,
    required ContactDraftKind kind,
    required DateTime createdAt,
    required DateTime updatedAt,
    int? contactId,
    String? baseVersion,
    String? name,
    String? firstName,
    String? lastName,
    String? email,
    String? salutation,
    String? title,
    String? gender,
    DateTime? birthday,
    @Default(ContactDraftState.local) ContactDraftState state,
  }) = _ContactDraft;
}

/// Result of a manually confirmed draft submission.
sealed class ContactDraftSubmissionResult {
  const ContactDraftSubmissionResult();
}

/// Authoritative contact returned after the server accepted the draft.
final class ContactDraftSubmissionSuccess extends ContactDraftSubmissionResult {
  /// Creates a successful submission result.
  const ContactDraftSubmissionSuccess({
    required this.contact,
    required this.replayed,
  });

  final ContactRecord contact;
  final bool replayed;
}

/// A transport failure left the draft stored and explicitly unsent.
final class ContactDraftSubmissionUnsent extends ContactDraftSubmissionResult {
  /// Creates an unsent result.
  const ContactDraftSubmissionUnsent();
}

/// Server validation failed without discarding the local draft.
final class ContactDraftSubmissionValidationFailure
    extends ContactDraftSubmissionResult {
  /// Creates a validation failure result.
  const ContactDraftSubmissionValidationFailure();
}

/// The contact changed after the draft's base version was loaded.
final class ContactDraftSubmissionConflict
    extends ContactDraftSubmissionResult {
  /// Creates a conflict result.
  const ContactDraftSubmissionConflict();
}

/// One immutable page returned by a [ContactsRepository].
@freezed
abstract class ContactPage with _$ContactPage {
  const ContactPage._();

  /// Creates an immutable contact page.
  const factory ContactPage({
    required List<ContactRecord> items,
    required int page,
    required int perPage,
    required int total,
    required int lastPage,
    @Default(ContactDataSource.remote) ContactDataSource source,
    DateTime? cachedAt,
  }) = _ContactPage;

  /// Whether another page can be loaded.
  bool get hasNextPage => page < lastPage;
}

/// One contact together with its data provenance.
@freezed
abstract class ContactSnapshot with _$ContactSnapshot {
  /// Creates an immutable contact snapshot.
  const factory ContactSnapshot({
    required ContactRecord contact,
    @Default(ContactDataSource.remote) ContactDataSource source,
    DateTime? cachedAt,
  }) = _ContactSnapshot;
}

/// Parameters accepted by contact repositories.
@freezed
abstract class ContactSearch with _$ContactSearch {
  /// Creates a contact search request.
  const factory ContactSearch({
    @Default('') String query,
    @Default(1) int page,
    @Default(25) int perPage,
    @Default(ContactsSort.lastName) ContactsSort sort,
  }) = _ContactSearch;
}
