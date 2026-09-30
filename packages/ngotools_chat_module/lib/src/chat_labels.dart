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
    required this.timelineStart,
    required this.newMessages,
    required this.today,
    required this.weekdays,
    required this.months,
    required this.edited,
    required this.composerHint,
    required this.send,
    required this.replyingTo,
    required this.editing,
    required this.cancel,
    required this.reply,
    required this.replyInThread,
    required this.copy,
    required this.copied,
    required this.edit,
    required this.delete,
    required this.deleteTitle,
    required this.deleteMessage,
    required this.retrySend,
    required this.discard,
    required this.sending,
    required this.sent,
    required this.sendFailed,
    required this.typing,
    required this.threadReplies,
    required this.threads,
    required this.noThreads,
    required this.thread,
    required this.membership,
    required this.profileChanged,
    required this.roomChanged,
    required this.unsupportedMessage,
    required this.encryptedMessage,
    required this.replyLoading,
    required this.fullDate,
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

  /// Start of the conversation.
  final String timelineStart;

  /// Read marker.
  final String newMessages;

  /// Date label for today.
  final String today;

  /// Monday to Sunday.
  final List<String> weekdays;

  /// January to December.
  final List<String> months;

  /// Marks an edited message.
  final String edited;

  /// Hint of the message field.
  final String composerHint;

  /// Send button.
  final String send;

  /// Banner while replying.
  final String Function(String name) replyingTo;

  /// Banner while editing.
  final String editing;

  /// Cancel action.
  final String cancel;

  /// Reply action.
  final String reply;

  /// Opens the thread of a message.
  final String replyInThread;

  /// Copies the text.
  final String copy;

  /// Confirms copying.
  final String copied;

  /// Edit action.
  final String edit;

  /// Delete action.
  final String delete;

  /// Title of the delete confirmation.
  final String deleteTitle;

  /// Text of the delete confirmation.
  final String deleteMessage;

  /// Sends a failed message again.
  final String retrySend;

  /// Discards an unsent message.
  final String discard;

  /// Screen reader label while sending.
  final String sending;

  /// Screen reader label once sent.
  final String sent;

  /// A message could not be sent.
  final String sendFailed;

  /// Who is typing.
  final String Function(List<String> names) typing;

  /// Replies in a thread.
  final String Function(int count) threadReplies;

  /// Thread overview.
  final String threads;

  /// Empty thread overview.
  final String noThreads;

  /// Title of a thread.
  final String thread;

  /// Membership change.
  final String Function(String name, MembershipChange change) membership;

  /// Profile change.
  final String Function(String name) profileChanged;

  /// Room settings changed.
  final String roomChanged;

  /// Message the app cannot show.
  final String unsupportedMessage;

  /// Message this device cannot decrypt (yet).
  final String encryptedMessage;

  /// Replied-to message not loaded yet.
  final String replyLoading;

  /// Weekday, day and month of a date divider.
  final String Function(String weekday, int day, String month) fullDate;

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

  /// Label of a date divider: today, yesterday or the full date.
  String dayLabel(DateTime date, DateTime now) {
    final local = date.toLocal();
    final days = DateTime(
      now.year,
      now.month,
      now.day,
    ).difference(DateTime(local.year, local.month, local.day)).inDays;

    if (days == 0) {
      return today;
    }

    if (days == 1) {
      return yesterday;
    }

    final year = local.year == now.year ? '' : ' ${local.year}';

    return '${fullDate(weekdays[local.weekday - 1], local.day, months[local.month - 1])}$year';
  }

  /// Time of a message.
  String messageTime(DateTime timestamp) {
    final local = timestamp.toLocal();

    return '${_two(local.hour)}:${_two(local.minute)}';
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
    timelineStart: 'Beginn des Chats',
    newMessages: 'Neue Nachrichten',
    today: 'Heute',
    weekdays: const [
      'Montag',
      'Dienstag',
      'Mittwoch',
      'Donnerstag',
      'Freitag',
      'Samstag',
      'Sonntag',
    ],
    months: const [
      'Januar',
      'Februar',
      'März',
      'April',
      'Mai',
      'Juni',
      'Juli',
      'August',
      'September',
      'Oktober',
      'November',
      'Dezember',
    ],
    edited: 'bearbeitet',
    composerHint: 'Nachricht',
    send: 'Senden',
    replyingTo: (name) => 'Antwort an $name',
    editing: 'Nachricht bearbeiten',
    cancel: 'Abbrechen',
    reply: 'Antworten',
    replyInThread: 'Im Thread antworten',
    copy: 'Text kopieren',
    copied: 'Kopiert',
    edit: 'Bearbeiten',
    delete: 'Löschen',
    deleteTitle: 'Nachricht löschen?',
    deleteMessage: 'Die Nachricht wird für alle im Chat gelöscht.',
    retrySend: 'Erneut senden',
    discard: 'Verwerfen',
    sending: 'Wird gesendet',
    sent: 'Gesendet',
    sendFailed: 'Nicht gesendet',
    typing: (names) => switch (names.length) {
      1 => '${names.first} schreibt …',
      2 => '${names.first} und ${names.last} schreiben …',
      _ => 'Mehrere schreiben …',
    },
    threadReplies: (count) => count == 1 ? '1 Antwort' : '$count Antworten',
    threads: 'Threads',
    noThreads: 'In diesem Chat gibt es noch keine Threads.',
    thread: 'Thread',
    membership: (name, change) => switch (change) {
      MembershipChange.joined => '$name ist beigetreten',
      MembershipChange.left => '$name hat den Chat verlassen',
      MembershipChange.invited => '$name wurde eingeladen',
      MembershipChange.invitationAccepted =>
        '$name hat die Einladung angenommen',
      MembershipChange.invitationRejected =>
        '$name hat die Einladung abgelehnt',
      MembershipChange.kicked => '$name wurde entfernt',
      MembershipChange.banned => '$name wurde gesperrt',
      MembershipChange.other => 'Mitgliedschaft von $name geändert',
    },
    profileChanged: (name) => '$name hat das Profil geändert',
    roomChanged: 'Chat-Einstellungen geändert',
    unsupportedMessage: 'Diese Nachricht kann hier nicht angezeigt werden.',
    encryptedMessage:
        'Diese Nachricht kann auf diesem Gerät noch nicht entschlüsselt werden.',
    replyLoading: 'Nachricht wird geladen …',
    fullDate: (weekday, day, month) => '$weekday, $day. $month',
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
    timelineStart: 'Start of the chat',
    newMessages: 'New messages',
    today: 'Today',
    weekdays: const [
      'Monday',
      'Tuesday',
      'Wednesday',
      'Thursday',
      'Friday',
      'Saturday',
      'Sunday',
    ],
    months: const [
      'January',
      'February',
      'March',
      'April',
      'May',
      'June',
      'July',
      'August',
      'September',
      'October',
      'November',
      'December',
    ],
    edited: 'edited',
    composerHint: 'Message',
    send: 'Send',
    replyingTo: (name) => 'Replying to $name',
    editing: 'Editing message',
    cancel: 'Cancel',
    reply: 'Reply',
    replyInThread: 'Reply in thread',
    copy: 'Copy text',
    copied: 'Copied',
    edit: 'Edit',
    delete: 'Delete',
    deleteTitle: 'Delete message?',
    deleteMessage: 'The message will be deleted for everyone in the chat.',
    retrySend: 'Send again',
    discard: 'Discard',
    sending: 'Sending',
    sent: 'Sent',
    sendFailed: 'Not sent',
    typing: (names) => switch (names.length) {
      1 => '${names.first} is typing …',
      2 => '${names.first} and ${names.last} are typing …',
      _ => 'Several people are typing …',
    },
    threadReplies: (count) => count == 1 ? '1 reply' : '$count replies',
    threads: 'Threads',
    noThreads: 'There are no threads in this chat yet.',
    thread: 'Thread',
    membership: (name, change) => switch (change) {
      MembershipChange.joined => '$name joined',
      MembershipChange.left => '$name left the chat',
      MembershipChange.invited => '$name was invited',
      MembershipChange.invitationAccepted => '$name accepted the invite',
      MembershipChange.invitationRejected => '$name declined the invite',
      MembershipChange.kicked => '$name was removed',
      MembershipChange.banned => '$name was banned',
      MembershipChange.other => 'Membership of $name changed',
    },
    profileChanged: (name) => '$name changed their profile',
    roomChanged: 'Chat settings changed',
    unsupportedMessage: 'This message cannot be shown here.',
    encryptedMessage: 'This message cannot be decrypted on this device yet.',
    replyLoading: 'Loading message …',
    fullDate: (weekday, day, month) => '$weekday, $day $month',
  );
}
