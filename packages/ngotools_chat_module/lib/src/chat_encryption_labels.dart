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
    required this.setupTitle,
    required this.setupIntro,
    required this.setupKeyInfo,
    required this.setUp,
    required this.later,
    required this.settingUp,
    required this.setupFailed,
    required this.tryAgain,
    required this.keyTitle,
    required this.keyInfo,
    required this.copyKey,
    required this.copied,
    required this.next,
    required this.confirmTitle,
    required this.confirmInfo,
    required this.confirmHint,
    required this.confirmMismatch,
    required this.showKeyAgain,
    required this.done,
    required this.setupDone,
    required this.setupReminder,
    required this.security,
    required this.recoveryEnabled,
    required this.recoveryDisabled,
    required this.recoveryIncomplete,
    required this.recoveryChecking,
    required this.deviceVerified,
    required this.deviceNotVerified,
    required this.newKey,
    required this.newKeyTitle,
    required this.newKeyMessage,
    required this.cancel,
    required this.recoverTitle,
    required this.recoverInfo,
    required this.recoveryKeyField,
    required this.recover,
    required this.recovering,
    required this.wrongKey,
    required this.recoverFailed,
    required this.recovered,
    required this.lostKey,
    required this.lostKeyTitle,
    required this.lostKeyMessage,
    required this.recoverReminder,
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

  /// Title of the recovery setup.
  final String setupTitle;

  /// Why recovery matters.
  final String setupIntro;

  /// What the recovery key is and who can restore it.
  final String setupKeyInfo;

  /// Starts the setup.
  final String setUp;

  /// Skips the setup for now.
  final String later;

  /// Setup in progress.
  final String settingUp;

  /// The setup failed.
  final String setupFailed;

  /// Retries.
  final String tryAgain;

  /// Title above the recovery key.
  final String keyTitle;

  /// Asks to save the key now.
  final String keyInfo;

  /// Copies the key.
  final String copyKey;

  /// Confirms the copy.
  final String copied;

  /// Next step.
  final String next;

  /// Title of the key confirmation.
  final String confirmTitle;

  /// Asks for the last characters of the key.
  final String confirmInfo;

  /// Label of the confirmation field.
  final String confirmHint;

  /// The characters do not match.
  final String confirmMismatch;

  /// Goes back to the key.
  final String showKeyAgain;

  /// Finishes the setup.
  final String done;

  /// Recovery is set up.
  final String setupDone;

  /// Reminder above the room list.
  final String setupReminder;

  /// Security settings of the chat.
  final String security;

  /// Recovery is set up.
  final String recoveryEnabled;

  /// Recovery is not set up.
  final String recoveryDisabled;

  /// This device lacks the key.
  final String recoveryIncomplete;

  /// State not known yet.
  final String recoveryChecking;

  /// This device is verified.
  final String deviceVerified;

  /// This device is not verified.
  final String deviceNotVerified;

  /// Creates a new recovery key.
  final String newKey;

  /// Title of the new key confirmation.
  final String newKeyTitle;

  /// What happens with the old key.
  final String newKeyMessage;

  /// Cancels.
  final String cancel;

  /// Title of the recovery key entry.
  final String recoverTitle;

  /// Why and where to find the key.
  final String recoverInfo;

  /// Label of the key field.
  final String recoveryKeyField;

  /// Restores with the key.
  final String recover;

  /// Restore in progress.
  final String recovering;

  /// The key does not match.
  final String wrongKey;

  /// The restore failed.
  final String recoverFailed;

  /// The restore succeeded.
  final String recovered;

  /// Help when the key is lost.
  final String lostKey;

  /// Title of the lost key help.
  final String lostKeyTitle;

  /// How to reset in the web chat.
  final String lostKeyMessage;

  /// Reminder above the room list on a new device.
  final String recoverReminder;

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
    setupTitle: 'Nachrichten sichern',
    setupIntro:
        'Deine Direktnachrichten sind Ende-zu-Ende-verschlüsselt. Damit Du sie auch auf einem neuen Gerät oder nach einer neuen Anmeldung lesen kannst, richte jetzt die Wiederherstellung ein.',
    setupKeyInfo:
        'Du bekommst dafür einen Wiederherstellungsschlüssel. Bewahre ihn sicher auf, zum Beispiel in einem Passwortmanager. Weder Deine Organisation noch NGO.Tools können ihn wiederherstellen.',
    setUp: 'Einrichten',
    later: 'Später',
    settingUp: 'Wird eingerichtet …',
    setupFailed:
        'Die Wiederherstellung konnte nicht eingerichtet werden. Bitte versuche es erneut.',
    tryAgain: 'Erneut versuchen',
    keyTitle: 'Dein Wiederherstellungsschlüssel',
    keyInfo:
        'Speichere den Schlüssel jetzt, zum Beispiel in Deinem Passwortmanager. Er wird nur dieses eine Mal angezeigt.',
    copyKey: 'Schlüssel kopieren',
    copied: 'Kopiert',
    next: 'Weiter',
    confirmTitle: 'Schlüssel bestätigen',
    confirmInfo:
        'Gib zur Kontrolle die letzten vier Zeichen Deines gespeicherten Schlüssels ein.',
    confirmHint: 'Letzte vier Zeichen',
    confirmMismatch:
        'Die Zeichen passen nicht. Sieh noch einmal in Deinem gespeicherten Schlüssel nach.',
    showKeyAgain: 'Schlüssel noch einmal zeigen',
    done: 'Fertig',
    setupDone: 'Die Wiederherstellung ist eingerichtet.',
    setupReminder:
        'Richte die Wiederherstellung ein, damit Du Deine Direktnachrichten auch auf neuen Geräten lesen kannst.',
    security: 'Sicherheit',
    recoveryEnabled: 'Wiederherstellung eingerichtet',
    recoveryDisabled: 'Wiederherstellung nicht eingerichtet',
    recoveryIncomplete:
        'Auf diesem Gerät fehlt der Wiederherstellungsschlüssel',
    recoveryChecking: 'Wird geprüft …',
    deviceVerified: 'Dieses Gerät ist bestätigt.',
    deviceNotVerified: 'Dieses Gerät ist noch nicht bestätigt.',
    newKey: 'Neuen Schlüssel erzeugen',
    newKeyTitle: 'Neuen Schlüssel erzeugen?',
    newKeyMessage:
        'Dein bisheriger Wiederherstellungsschlüssel funktioniert danach nicht mehr, auch nicht im Web-Chat. Speichere den neuen Schlüssel sicher.',
    cancel: 'Abbrechen',
    recoverTitle: 'Nachrichten wiederherstellen',
    recoverInfo:
        'Gib Deinen Wiederherstellungsschlüssel ein, um ältere verschlüsselte Nachrichten auf diesem Gerät zu lesen. Du hast ihn beim Einrichten der Wiederherstellung gespeichert, zum Beispiel in Deinem Passwortmanager.',
    recoveryKeyField: 'Wiederherstellungsschlüssel',
    recover: 'Wiederherstellen',
    recovering: 'Wird wiederhergestellt …',
    wrongKey:
        'Dieser Schlüssel passt nicht. Prüfe die Eingabe oder nimm den zuletzt erzeugten Schlüssel.',
    recoverFailed: 'Das hat nicht geklappt. Bitte versuche es erneut.',
    recovered:
        'Wiederhergestellt. Ältere Nachrichten werden jetzt entschlüsselt.',
    lostKey: 'Schlüssel verloren?',
    lostKeyTitle: 'Schlüssel verloren',
    lostKeyMessage:
        'Ohne Wiederherstellungsschlüssel lässt sich die Verschlüsselung nur zurücksetzen. Das geht im Web-Chat von NGO.Tools: Einstellungen → Verschlüsselung → „Wiederherstellungsschlüssel vergessen?“ → „Digitale Identität zurücksetzen“.\n\nÄltere verschlüsselte Nachrichten kannst Du danach auf neuen Geräten nicht mehr lesen. Richte anschließend hier die Wiederherstellung neu ein.',
    recoverReminder:
        'Auf diesem Gerät fehlt Dein Wiederherstellungsschlüssel. Gib ihn ein, um ältere verschlüsselte Nachrichten zu lesen.',
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
    setupTitle: 'Back up your messages',
    setupIntro:
        'Your direct messages are end-to-end encrypted. To read them on a new device or after signing in again, set up recovery now.',
    setupKeyInfo:
        'You get a recovery key for this. Keep it safe, for example in a password manager. Neither your organization nor NGO.Tools can restore it.',
    setUp: 'Set up',
    later: 'Later',
    settingUp: 'Setting up …',
    setupFailed: 'Recovery could not be set up. Please try again.',
    tryAgain: 'Try again',
    keyTitle: 'Your recovery key',
    keyInfo:
        'Save the key now, for example in your password manager. It is shown only this once.',
    copyKey: 'Copy key',
    copied: 'Copied',
    next: 'Next',
    confirmTitle: 'Confirm your key',
    confirmInfo:
        'To check, enter the last four characters of the key you saved.',
    confirmHint: 'Last four characters',
    confirmMismatch:
        'The characters do not match. Please check the key you saved.',
    showKeyAgain: 'Show the key again',
    done: 'Done',
    setupDone: 'Recovery is set up.',
    setupReminder:
        'Set up recovery so you can read your direct messages on new devices too.',
    security: 'Security',
    recoveryEnabled: 'Recovery set up',
    recoveryDisabled: 'Recovery not set up',
    recoveryIncomplete: 'The recovery key is missing on this device',
    recoveryChecking: 'Checking …',
    deviceVerified: 'This device is verified.',
    deviceNotVerified: 'This device is not verified yet.',
    newKey: 'Create a new key',
    newKeyTitle: 'Create a new key?',
    newKeyMessage:
        'Your previous recovery key stops working, also in the web chat. Keep the new key safe.',
    cancel: 'Cancel',
    recoverTitle: 'Restore your messages',
    recoverInfo:
        'Enter your recovery key to read older encrypted messages on this device. You saved it when you set up recovery, for example in your password manager.',
    recoveryKeyField: 'Recovery key',
    recover: 'Restore',
    recovering: 'Restoring …',
    wrongKey:
        'This key does not match. Check what you entered or use the most recently created key.',
    recoverFailed: 'That did not work. Please try again.',
    recovered: 'Restored. Older messages are being decrypted now.',
    lostKey: 'Lost your key?',
    lostKeyTitle: 'Lost key',
    lostKeyMessage:
        'Without the recovery key, encryption can only be reset. You do this in the NGO.Tools web chat: Settings → Encryption → “Forgot recovery key?” → “Reset cryptographic identity”.\n\nAfterwards you cannot read older encrypted messages on new devices. Then set up recovery here again.',
    recoverReminder:
        'Your recovery key is missing on this device. Enter it to read older encrypted messages.',
  );

  /// Whether the recovery key can make a message with [reason] readable.
  static bool recoveryKeyHelps(DecryptionFailure reason) => switch (reason) {
    DecryptionFailure.unknown ||
    DecryptionFailure.historicalUnverifiedDevice ||
    DecryptionFailure.withheld => true,
    _ => false,
  };
}
