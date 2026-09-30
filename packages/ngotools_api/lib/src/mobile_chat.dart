/// Status of the user's chat account in the organization.
enum MobileChatAccountStatus {
  /// The account may use the chat.
  active,

  /// Access was withdrawn; the account may come back.
  locked,

  /// The account was closed for good.
  deactivated,

  /// The user has no chat account.
  none,
}

/// Whether a chat person is a team member or a contact of the organization.
enum MobileChatPersonKind {
  /// A team member of the organization.
  teamMember,

  /// A contact with chat access, such as a volunteer.
  contact,
}

/// Chat access of the organization app, bound to its API token.
abstract interface class MobileChatApi {
  /// Loads the user's chat account and the organization's homeserver.
  Future<MobileChatAccount> fetchChatAccount();

  /// Lists the organization's chat address book without the user.
  Future<MobileChatPeoplePage> listChatPeople({
    String? search,
    int page = 1,
    int perPage = 50,
  });

  /// Signs the app into the chat in the background.
  ///
  /// Revokes an earlier chat session of the same API token. Throws a
  /// `MobileApiException` with code `chat_unavailable` or `no_chat_access`
  /// when the chat cannot be used.
  Future<MobileChatSession> createChatSession({String? deviceName});

  /// Renews the access token of the current chat session.
  ///
  /// Same session and device, also after the token expired. Code
  /// `no_chat_session` means the app has to sign in again, `no_chat_access`
  /// that access was withdrawn.
  Future<MobileChatSession> renewChatSession();

  /// Ends the chat session of the current API token.
  Future<void> deleteChatSession();
}

/// The user's chat account.
final class MobileChatAccount {
  /// Creates a chat account status.
  const MobileChatAccount({
    required this.status,
    required this.available,
    this.matrixUserId,
    this.serverName,
    this.homeserverUrl,
  });

  /// Account status.
  final MobileChatAccountStatus status;

  /// Whether the organization's homeserver runs.
  final bool available;

  /// Matrix user id, only for an active account on a running homeserver.
  final String? matrixUserId;

  /// Matrix server name while the homeserver runs.
  final String? serverName;

  /// Client API origin while the homeserver runs.
  final Uri? homeserverUrl;

  /// Whether the app can sign into the chat now.
  bool get isUsable =>
      available &&
      status == MobileChatAccountStatus.active &&
      matrixUserId != null &&
      homeserverUrl != null;
}

/// A person in the organization's chat address book.
final class MobileChatPerson {
  /// Creates an address book entry.
  const MobileChatPerson({
    required this.matrixUserId,
    required this.displayName,
    required this.kind,
  });

  /// Matrix user id to start a direct chat with.
  final String matrixUserId;

  /// Display name.
  final String displayName;

  /// Team member or contact.
  final MobileChatPersonKind kind;
}

/// One page of the chat address book.
final class MobileChatPeoplePage {
  /// Creates an address book page.
  MobileChatPeoplePage({
    required Iterable<MobileChatPerson> people,
    required this.page,
    required this.lastPage,
    required this.total,
  }) : people = List.unmodifiable(people);

  /// People on this page.
  final List<MobileChatPerson> people;

  /// One-based page number.
  final int page;

  /// Last available page.
  final int lastPage;

  /// Number of people across all pages.
  final int total;

  /// Whether a later page exists.
  bool get hasMore => page < lastPage;
}

/// A chat session NGO.Tools issued for this app installation.
final class MobileChatSession {
  /// Creates a chat session.
  const MobileChatSession({
    required this.matrixUserId,
    required this.deviceId,
    required this.accessToken,
    required this.homeserverUrl,
    required this.serverName,
    this.expiresAt,
  });

  /// Matrix user id of the account.
  final String matrixUserId;

  /// Matrix device of this app installation.
  final String deviceId;

  /// Matrix access token; hand it to the chat client only.
  final String accessToken;

  /// When the access token expires; renew it before.
  final DateTime? expiresAt;

  /// Client API origin of the homeserver.
  final Uri homeserverUrl;

  /// Matrix server name.
  final String serverName;

  @override
  String toString() =>
      'MobileChatSession(matrixUserId: $matrixUserId, deviceId: $deviceId, '
      'expiresAt: $expiresAt)';
}
