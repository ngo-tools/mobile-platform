import 'package:ngotools_chat/ngotools_chat.dart';

/// Texts about end-to-end encryption: messages this device cannot read and
/// the recovery key.
final class ChatEncryptionLabels {
  /// Creates the texts.
  const ChatEncryptionLabels({
    required this.undecryptable,
    required this.undecryptableTitle,
    required this.undecryptableExplanation,
    required this.showExplanation,
    required this.enterRecoveryKey,
  });

  /// Short line in place of a message this device cannot read.
  final String Function(DecryptionFailure reason) undecryptable;

  /// Title of the explanation.
  final String undecryptableTitle;

  /// Why the message cannot be read and what helps.
  final String Function(DecryptionFailure reason) undecryptableExplanation;

  /// Accessibility hint of an unreadable message.
  final String showExplanation;

  /// Opens the recovery key entry.
  final String enterRecoveryKey;

  /// German texts.
  static final german = ChatEncryptionLabels(
    undecryptable: (reason) => switch (reason) {
      DecryptionFailure.unknown =>
        'Diese Nachricht kann noch nicht entschlüsselt werden.',
      DecryptionFailure.sentBeforeJoined =>
        'Vor Deinem Beitritt gesendet – nicht lesbar.',
      DecryptionFailure.historicalNoBackup => 'Auf diesem Gerät nicht lesbar.',
      DecryptionFailure.historicalUnverifiedDevice =>
        'Zum Lesen ist Dein Wiederherstellungsschlüssel nötig.',
      DecryptionFailure.withheld => 'Nicht für dieses Gerät freigegeben.',
      DecryptionFailure.untrustedSender =>
        'Von einem nicht bestätigten Gerät gesendet.',
    },
    undecryptableTitle: 'Warum ist diese Nachricht nicht lesbar?',
    undecryptableExplanation: (reason) => switch (reason) {
      DecryptionFailure.unknown =>
        'Die Schlüssel für diese Nachricht sind noch nicht auf diesem Gerät. '
            'Oft kommen sie nach wenigen Sekunden an. Wenn nicht, hilft Dein '
            'Wiederherstellungsschlüssel.',
      DecryptionFailure.sentBeforeJoined =>
        'Die Nachricht wurde geschrieben, bevor Du dem Chat beigetreten bist. '
            'Verschlüsselte Nachrichten aus dieser Zeit kannst Du nicht lesen.',
      DecryptionFailure.historicalNoBackup =>
        'Die Nachricht wurde geschrieben, bevor Du Dich auf diesem Gerät '
            'angemeldet hast. Für Dein Konto war keine Wiederherstellung '
            'eingerichtet, deshalb gibt es keine Sicherung der Schlüssel. '
            'Neue Nachrichten kannst Du lesen.',
      DecryptionFailure.historicalUnverifiedDevice =>
        'Die Nachricht wurde geschrieben, bevor Du Dich auf diesem Gerät '
            'angemeldet hast. Mit Deinem Wiederherstellungsschlüssel holst Du '
            'die Schlüssel aus der Sicherung und kannst sie wieder lesen.',
      DecryptionFailure.withheld =>
        'Das Gerät, von dem die Nachricht kam, hat die Schlüssel nicht mit '
            'diesem Gerät geteilt, zum Beispiel weil dieses Gerät noch nicht '
            'bestätigt ist. Mit Deinem Wiederherstellungsschlüssel bestätigst '
            'Du es.',
      DecryptionFailure.untrustedSender =>
        'Die Nachricht kam von einem Gerät, das der Absender nicht bestätigt '
            'hat. Zu Deiner Sicherheit wird sie nicht angezeigt.',
    },
    showExplanation: 'Erklärung anzeigen',
    enterRecoveryKey: 'Wiederherstellungsschlüssel eingeben',
  );

  /// English texts.
  static final english = ChatEncryptionLabels(
    undecryptable: (reason) => switch (reason) {
      DecryptionFailure.unknown => 'This message cannot be decrypted yet.',
      DecryptionFailure.sentBeforeJoined =>
        'Sent before you joined – not readable.',
      DecryptionFailure.historicalNoBackup => 'Not readable on this device.',
      DecryptionFailure.historicalUnverifiedDevice =>
        'Your recovery key is needed to read this.',
      DecryptionFailure.withheld => 'Not shared with this device.',
      DecryptionFailure.untrustedSender => 'Sent from an unverified device.',
    },
    undecryptableTitle: 'Why can’t I read this message?',
    undecryptableExplanation: (reason) => switch (reason) {
      DecryptionFailure.unknown =>
        'The keys for this message are not on this device yet. They often '
            'arrive within a few seconds. If not, your recovery key helps.',
      DecryptionFailure.sentBeforeJoined =>
        'The message was written before you joined the chat. You cannot read '
            'encrypted messages from that time.',
      DecryptionFailure.historicalNoBackup =>
        'The message was written before you signed in on this device. '
            'Recovery was not set up for your account, so there is no backup '
            'of the keys. You can read new messages.',
      DecryptionFailure.historicalUnverifiedDevice =>
        'The message was written before you signed in on this device. With '
            'your recovery key you restore the keys from the backup and can '
            'read it again.',
      DecryptionFailure.withheld =>
        'The device that sent the message did not share the keys with this '
            'device, for example because this device is not verified yet. '
            'Your recovery key verifies it.',
      DecryptionFailure.untrustedSender =>
        'The message came from a device the sender has not verified. For '
            'your safety it is not shown.',
    },
    showExplanation: 'Show explanation',
    enterRecoveryKey: 'Enter recovery key',
  );

  /// Whether the recovery key can make a message with [reason] readable.
  static bool recoveryKeyHelps(DecryptionFailure reason) => switch (reason) {
    DecryptionFailure.unknown ||
    DecryptionFailure.historicalUnverifiedDevice ||
    DecryptionFailure.withheld => true,
    _ => false,
  };
}
