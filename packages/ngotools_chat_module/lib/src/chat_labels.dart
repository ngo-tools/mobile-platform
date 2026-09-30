import 'package:ngotools_chat/ngotools_chat.dart';

import 'chat_connection_state.dart';

/// Localized texts and date formats of the chat module.
final class ChatLabels {
  /// Creates labels.
  const ChatLabels({
    required this.title,
    required this.filterAll,
    required this.filterUnread,
    required this.filterPeople,
    required this.filterGroups,
    required this.searchHint,
    required this.invitesSection,
    required this.invitedBy,
    required this.accept,
    required this.decline,
    required this.actionFailed,
    required this.noRoomsTitle,
    required this.noRoomsMessage,
    required this.noMatchesMessage,
    required this.you,
    required this.unsent,
    required this.muted,
    required this.unread,
    required this.mentions,
    required this.imagePreview,
    required this.videoPreview,
    required this.audioPreview,
    required this.filePreview,
    required this.locationPreview,
    required this.pollPreview,
    required this.stickerPreview,
    required this.redactedPreview,
    required this.encryptedPreview,
    required this.otherPreview,
    required this.yesterday,
    required this.shortWeekdays,
    required this.connecting,
    required this.connectionFailed,
    required this.retry,
    required this.disconnected,
    required this.unavailableTitle,
    required this.homeserverUnavailable,
    required this.noAccount,
    required this.accessWithdrawn,
    required this.accountClosed,
  });

  /// Screen title.
  final String title;

  /// Filter chip for all chats.
  final String filterAll;

  /// Filter chip for chats with unread messages.
  final String filterUnread;

  /// Filter chip for direct chats.
  final String filterPeople;

  /// Filter chip for groups.
  final String filterGroups;

  /// Hint of the search field.
  final String searchHint;

  /// Heading above open invites.
  final String invitesSection;

  /// Subtitle of an invite.
  final String invitedBy;

  /// Accepts an invite.
  final String accept;

  /// Declines an invite.
  final String decline;

  /// Shown when an action failed.
  final String actionFailed;

  /// Empty state title.
  final String noRoomsTitle;

  /// Empty state message.
  final String noRoomsMessage;

  /// Shown when search or filter hide every chat.
  final String noMatchesMessage;

  /// Sender label of own messages.
  final String you;

  /// Latest message could not be sent (yet).
  final String unsent;

  /// Screen reader label of a muted chat.
  final String muted;

  /// Screen reader label of unread messages.
  final String Function(int count) unread;

  /// Screen reader label of unread mentions.
  final String Function(int count) mentions;

  /// Preview of an image.
  final String imagePreview;

  /// Preview of a video.
  final String videoPreview;

  /// Preview of an audio message.
  final String audioPreview;

  /// Preview of a file.
  final String filePreview;

  /// Preview of a location.
  final String locationPreview;

  /// Preview of a poll.
  final String pollPreview;

  /// Preview of a sticker.
  final String stickerPreview;

  /// Preview of a deleted message.
  final String redactedPreview;

  /// Preview of a message this device cannot decrypt (yet).
  final String encryptedPreview;

  /// Preview of anything else.
  final String otherPreview;

  /// Date label for yesterday.
  final String yesterday;

  /// Monday to Sunday, short.
  final List<String> shortWeekdays;

  /// Shown while connecting.
  final String connecting;

  /// Shown when connecting failed.
  final String connectionFailed;

  /// Retry action.
  final String retry;

  /// Shown while not connected.
  final String disconnected;

  /// Title when the chat cannot be used.
  final String unavailableTitle;

  /// Homeserver not running.
  final String homeserverUnavailable;

  /// User has no chat account.
  final String noAccount;

  /// Access was withdrawn.
  final String accessWithdrawn;

  /// Account closed.
  final String accountClosed;

  /// Text of a message preview.
  String preview(MessagePreview preview) => switch (preview) {
    TextPreview(:final body) => body,
    ImagePreview() => imagePreview,
    VideoPreview() => videoPreview,
    AudioPreview() => audioPreview,
    FilePreview() => filePreview,
    LocationPreview() => locationPreview,
    PollPreview() => pollPreview,
    StickerPreview() => stickerPreview,
    RedactedPreview() => redactedPreview,
    UnableToDecryptPreview() => encryptedPreview,
    OtherPreview() => otherPreview,
  };

  /// Why the chat cannot be used.
  String unavailable(ChatUnavailableReason reason) => switch (reason) {
    ChatUnavailableReason.homeserverUnavailable => homeserverUnavailable,
    ChatUnavailableReason.noAccount => noAccount,
    ChatUnavailableReason.accessWithdrawn => accessWithdrawn,
    ChatUnavailableReason.accountClosed => accountClosed,
  };

  /// Compact time of the latest activity: time today, "yesterday", weekday
  /// within a week, date otherwise.
  String activityTime(DateTime timestamp, DateTime now) {
    final local = timestamp.toLocal();
    final today = DateTime(now.year, now.month, now.day);
    final day = DateTime(local.year, local.month, local.day);
    final days = today.difference(day).inDays;

    if (days <= 0) {
      return '${_two(local.hour)}:${_two(local.minute)}';
    }

    if (days == 1) {
      return yesterday;
    }

    if (days < 7) {
      return shortWeekdays[local.weekday - 1];
    }

    return '${_two(local.day)}.${_two(local.month)}.${now.year == local.year ? '' : '${local.year % 100}'}';
  }

  static String _two(int value) => value.toString().padLeft(2, '0');

  /// German texts.
  static final german = ChatLabels(
    title: 'Chats',
    filterAll: 'Alle',
    filterUnread: 'Ungelesen',
    filterPeople: 'Personen',
    filterGroups: 'Gruppen',
    searchHint: 'Chats durchsuchen',
    invitesSection: 'Einladungen',
    invitedBy: 'Du wurdest eingeladen',
    accept: 'Annehmen',
    decline: 'Ablehnen',
    actionFailed: 'Das hat nicht geklappt. Bitte versuche es erneut.',
    noRoomsTitle: 'Noch keine Chats',
    noRoomsMessage:
        'Hier erscheinen Deine Gruppen und Direktnachrichten, sobald es sie gibt.',
    noMatchesMessage: 'Keine Chats gefunden.',
    you: 'Du',
    unsent: 'Nicht gesendet',
    muted: 'Stummgeschaltet',
    unread: (count) =>
        count == 1 ? '1 ungelesene Nachricht' : '$count ungelesene Nachrichten',
    mentions: (count) => count == 1 ? '1 Erwähnung' : '$count Erwähnungen',
    imagePreview: 'Bild',
    videoPreview: 'Video',
    audioPreview: 'Sprachnachricht',
    filePreview: 'Datei',
    locationPreview: 'Standort',
    pollPreview: 'Umfrage',
    stickerPreview: 'Sticker',
    redactedPreview: 'Nachricht gelöscht',
    encryptedPreview: 'Verschlüsselte Nachricht',
    otherPreview: 'Nachricht',
    yesterday: 'Gestern',
    shortWeekdays: const ['Mo', 'Di', 'Mi', 'Do', 'Fr', 'Sa', 'So'],
    connecting: 'Chat wird verbunden …',
    connectionFailed: 'Keine Verbindung zum Chat.',
    retry: 'Erneut versuchen',
    disconnected: 'Der Chat ist nicht verbunden.',
    unavailableTitle: 'Chat nicht verfügbar',
    homeserverUnavailable:
        'Der Chat Deiner Organisation ist gerade nicht verfügbar.',
    noAccount: 'Für Dich ist der Chat nicht freigeschaltet.',
    accessWithdrawn:
        'Deine Organisation hat Deinen Chat-Zugang beendet. Bei Fragen wende Dich an Deine Ansprechperson.',
    accountClosed: 'Dein Chat-Konto wurde geschlossen.',
  );

  /// English texts.
  static final english = ChatLabels(
    title: 'Chats',
    filterAll: 'All',
    filterUnread: 'Unread',
    filterPeople: 'People',
    filterGroups: 'Groups',
    searchHint: 'Search chats',
    invitesSection: 'Invites',
    invitedBy: 'You were invited',
    accept: 'Accept',
    decline: 'Decline',
    actionFailed: 'That did not work. Please try again.',
    noRoomsTitle: 'No chats yet',
    noRoomsMessage:
        'Your groups and direct messages will appear here once there are any.',
    noMatchesMessage: 'No chats found.',
    you: 'You',
    unsent: 'Not sent',
    muted: 'Muted',
    unread: (count) =>
        count == 1 ? '1 unread message' : '$count unread messages',
    mentions: (count) => count == 1 ? '1 mention' : '$count mentions',
    imagePreview: 'Photo',
    videoPreview: 'Video',
    audioPreview: 'Voice message',
    filePreview: 'File',
    locationPreview: 'Location',
    pollPreview: 'Poll',
    stickerPreview: 'Sticker',
    redactedPreview: 'Message deleted',
    encryptedPreview: 'Encrypted message',
    otherPreview: 'Message',
    yesterday: 'Yesterday',
    shortWeekdays: const ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'],
    connecting: 'Connecting to chat …',
    connectionFailed: 'No connection to the chat.',
    retry: 'Try again',
    disconnected: 'The chat is not connected.',
    unavailableTitle: 'Chat unavailable',
    homeserverUnavailable: "Your organization's chat is currently unavailable.",
    noAccount: 'The chat is not enabled for you.',
    accessWithdrawn:
        'Your organization ended your chat access. Please contact your organization with any questions.',
    accountClosed: 'Your chat account was closed.',
  );
}
