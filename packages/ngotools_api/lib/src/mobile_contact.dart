/// Stable contact kinds exposed by the mobile API boundary.
enum MobileContactKind { person, organization, couple, unknown }

/// Contact kinds accepted by the narrow mobile mutation boundary.
enum MobileWritableContactKind { person, organization }

/// Server-supported contact sort fields.
enum MobileContactSortField {
  name,
  firstName,
  lastName,
  updatedAt,
  createdAt,
  id,
}

/// Server-supported sort direction.
enum MobileContactSortDirection { ascending, descending }

/// Minimal read-only contact API consumed by feature packages.
abstract interface class MobileContactsApi {
  /// Searches the server-authorized contact projection.
  Future<MobileContactPage> searchContacts({
    String? query,
    int page = 1,
    int perPage = 25,
    List<MobileContactSort> sort = const [
      MobileContactSort(field: MobileContactSortField.lastName),
      MobileContactSort(field: MobileContactSortField.id),
    ],
  });

  /// Loads one contact with its server-visible addresses.
  Future<MobileContact> fetchContact(int contactId);

  /// Creates one contact and safely replays a retried submission.
  Future<MobileContactMutationResult> createContact({
    required String idempotencyKey,
    required MobileContactMutation contact,
  });

  /// Updates one contact only when [baseVersion] is still current.
  Future<MobileContactMutationResult> updateContact({
    required int contactId,
    required String idempotencyKey,
    required String baseVersion,
    required MobileContactMutation contact,
  });
}

/// Full writable contact projection sent by an explicitly confirmed draft.
final class MobileContactMutation {
  /// Creates a narrow person or organization mutation.
  const MobileContactMutation({
    required this.kind,
    this.name,
    this.firstName,
    this.lastName,
    this.email,
    this.salutation,
    this.title,
    this.gender,
    this.birthday,
  });

  final MobileWritableContactKind kind;
  final String? name;
  final String? firstName;
  final String? lastName;
  final String? email;
  final String? salutation;
  final String? title;
  final String? gender;
  final DateTime? birthday;
}

/// Result of a confirmed contact mutation.
sealed class MobileContactMutationResult {
  const MobileContactMutationResult();
}

/// Authoritative contact returned after a successful mutation.
final class MobileContactMutationSuccess extends MobileContactMutationResult {
  /// Creates a successful mutation result.
  const MobileContactMutationSuccess({
    required this.contact,
    required this.replayed,
  });

  final MobileContact contact;
  final bool replayed;
}

/// A safe signal that the edited base version is no longer current.
final class MobileContactVersionConflict extends MobileContactMutationResult {
  /// Creates the conflict result without exposing server contact contents.
  const MobileContactVersionConflict();
}

/// One server-side contact sort directive.
final class MobileContactSort {
  /// Creates a stable sort directive.
  const MobileContactSort({
    required this.field,
    this.direction = MobileContactSortDirection.ascending,
  });

  final MobileContactSortField field;
  final MobileContactSortDirection direction;
}

/// Sanitized address fields exposed by the contact API.
final class MobileContactAddress {
  /// Creates an immutable address.
  const MobileContactAddress({
    required this.id,
    this.type,
    this.line1,
    this.line2,
    this.postalCode,
    this.city,
    this.state,
    this.country,
  });

  final int id;
  final String? type;
  final String? line1;
  final String? line2;
  final String? postalCode;
  final String? city;
  final String? state;
  final String? country;
}

/// Sanitized contact projection independent of generated transport models.
final class MobileContact {
  /// Creates an immutable contact projection.
  MobileContact({
    required this.id,
    required this.kind,
    required this.version,
    this.name,
    this.firstName,
    this.lastName,
    this.email,
    this.salutation,
    this.title,
    this.gender,
    this.birthday,
    this.activeAddressId,
    this.updatedAt,
    Iterable<MobileContactAddress> addresses = const [],
  }) : addresses = List.unmodifiable(addresses);

  final int id;
  final MobileContactKind kind;
  final String version;
  final String? name;
  final String? firstName;
  final String? lastName;
  final String? email;
  final String? salutation;
  final String? title;
  final String? gender;
  final DateTime? birthday;
  final int? activeAddressId;
  final DateTime? updatedAt;
  final List<MobileContactAddress> addresses;
}

/// One page of contacts with stable pagination metadata.
final class MobileContactPage {
  /// Creates an immutable contact page.
  MobileContactPage({
    required Iterable<MobileContact> items,
    required this.page,
    required this.perPage,
    required this.total,
    required this.lastPage,
  }) : items = List.unmodifiable(items);

  final List<MobileContact> items;
  final int page;
  final int perPage;
  final int total;
  final int lastPage;

  /// Whether a subsequent page is available.
  bool get hasNextPage => page < lastPage;
}
