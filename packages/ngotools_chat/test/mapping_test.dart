import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:ngotools_chat/src/chat_exception.dart';
import 'package:ngotools_chat/src/chat_models.dart';
import 'package:ngotools_chat/src/mapping.dart';
import 'package:ngotools_chat/src/rust/api/encryption.dart' as rust;
import 'package:ngotools_chat/src/rust/api/error.dart' as rust;
import 'package:ngotools_chat/src/rust/api/room.dart' as rust;
import 'package:ngotools_chat/src/rust/api/rooms.dart' as rust;
import 'package:ngotools_chat/src/rust/api/timeline.dart' as rust;

const alice = rust.Sender(
  id: '@alice:example.invalid',
  name: 'Alice',
  avatarUrl: 'mxc://example.invalid/avatar',
);

rust.EventItem rustEvent({
  rust.EventContent content = const rust.EventContent.text(body: 'Hallo'),
  rust.SendState sendState = const rust.SendState.sent(),
  rust.ReplyPreview? replyTo,
  rust.ThreadSummary? thread,
}) => rust.EventItem(
  key: const rust.EventKey.remote(eventId: r'$event'),
  eventId: r'$event',
  sender: alice,
  timestampMs: 1700000000000,
  isOwn: false,
  canEdit: false,
  canReply: true,
  sendState: sendState,
  content: content,
  replyTo: replyTo,
  reactions: const [rust.Reaction(key: '👍', count: 2, byMe: true)],
  isEdited: true,
  thread: thread,
);

void main() {
  test('translates every error kind and keeps the retry delay', () {
    expect(
      chatException(const rust.ChatError.rateLimited()).kind,
      ChatErrorKind.rateLimited,
    );
    expect(
      chatException(
        rust.ChatError.rateLimited(retryAfterMs: BigInt.from(1500)),
      ).retryAfter,
      const Duration(milliseconds: 1500),
    );

    final errors = {
      const rust.ChatError.network(): ChatErrorKind.network,
      const rust.ChatError.sessionExpired(): ChatErrorKind.sessionExpired,
      const rust.ChatError.accountLocked(): ChatErrorKind.accountLocked,
      const rust.ChatError.forbidden(): ChatErrorKind.forbidden,
      const rust.ChatError.notFound(): ChatErrorKind.notFound,
      const rust.ChatError.crypto(message: 'x'): ChatErrorKind.crypto,
      const rust.ChatError.storage(message: 'x'): ChatErrorKind.storage,
      const rust.ChatError.invalidInput(message: 'x'):
          ChatErrorKind.invalidInput,
      const rust.ChatError.internal(message: 'x'): ChatErrorKind.internal,
    };
    for (final MapEntry(key: error, value: kind) in errors.entries) {
      expect(chatException(error).kind, kind, reason: '$error');
    }
  });

  test('guard rethrows binding errors as ChatException', () async {
    await expectLater(
      guard<void>(() async => throw const rust.ChatError.notFound()),
      throwsA(
        isA<ChatException>().having(
          (error) => error.kind,
          'kind',
          ChatErrorKind.notFound,
        ),
      ),
    );
  });

  test('maps a timeline event with reply, reactions and thread', () {
    final item = timelineItem(
      rust.TimelineItem(
        id: 'item-1',
        kind: rust.TimelineItemKind.event(
          event: rustEvent(
            replyTo: const rust.ReplyPreview(
              eventId: r'$parent',
              sender: alice,
              preview: rust.MessagePreview.image(),
            ),
            thread: const rust.ThreadSummary(
              replyCount: 3,
              latestPreview: rust.MessagePreview.text(body: 'Zuletzt'),
            ),
          ),
        ),
      ),
    );

    expect(item.id, 'item-1');
    final event = (item as EventTimelineItem).event;
    expect(event.key, const EventKey.remote(r'$event'));
    expect(
      event.sender,
      ChatUser(
        id: '@alice:example.invalid',
        displayName: 'Alice',
        avatar: ChatMedia(jsonEncode('mxc://example.invalid/avatar')),
      ),
    );
    expect(event.timestamp, DateTime.fromMillisecondsSinceEpoch(1700000000000));
    expect(event.content, const EventContent.text('Hallo'));
    expect(event.replyTo?.preview, const MessagePreview.image());
    expect(event.reactions, [const Reaction(key: '👍', count: 2, byMe: true)]);
    expect(event.thread?.replyCount, 3);
    expect(event.thread?.latestPreview, const MessagePreview.text('Zuletzt'));
    expect(event.isEdited, isTrue);
  });

  test('maps images and upload progress', () {
    final event = eventItem(
      rustEvent(
        content: const rust.EventContent.image(
          filename: 'bild.png',
          media: '{"file":1}',
          thumbnail: '{"file":2}',
          width: 800,
          height: 600,
        ),
        sendState: rust.SendState.sending(
          progress: rust.UploadProgress(
            currentBytes: BigInt.from(10),
            totalBytes: BigInt.from(40),
          ),
        ),
      ),
    );

    expect(
      event.content,
      const EventContent.image(
        filename: 'bild.png',
        media: ChatMedia('{"file":1}'),
        thumbnail: ChatMedia('{"file":2}'),
        width: 800,
        height: 600,
      ),
    );
    expect(
      event.sendState,
      const SendState.sending(
        progress: UploadProgress(currentBytes: 10, totalBytes: 40),
      ),
    );
  });

  test('maps the other timeline item kinds', () {
    expect(
      timelineItem(
        const rust.TimelineItem(
          id: 'd',
          kind: rust.TimelineItemKind.dateDivider(timestampMs: 0),
        ),
      ),
      TimelineItem.dateDivider(
        id: 'd',
        date: DateTime.fromMillisecondsSinceEpoch(0),
      ),
    );
    expect(
      timelineItem(
        const rust.TimelineItem(
          id: 's',
          kind: rust.TimelineItemKind.timelineStart(),
        ),
      ),
      const TimelineItem.timelineStart(id: 's'),
    );
  });

  test('maps room summaries with latest message and mode', () {
    final summary = roomSummary(
      const rust.RoomSummary(
        id: '!room',
        name: 'Vorstand',
        kind: rust.RoomKind.group,
        membership: rust.Membership.invited,
        isEncrypted: false,
        unreadMessages: 4,
        unreadMentions: 1,
        latest: rust.LatestEvent(
          senderId: '@bob:example.invalid',
          senderName: 'Bob',
          isOwn: false,
          timestampMs: 0,
          preview: rust.MessagePreview.text(body: 'Hi'),
          isUnsent: false,
        ),
        notificationMode: rust.NotificationMode.mute,
      ),
    );

    expect(summary.kind, RoomKind.group);
    expect(summary.membership, Membership.invited);
    expect(summary.avatar, isNull);
    expect(summary.latest?.sender.displayName, 'Bob');
    expect(summary.latest?.preview, const MessagePreview.text('Hi'));
    expect(summary.notificationMode, NotificationMode.mute);
  });

  test('round-trips event keys and notification modes', () {
    for (final key in const [
      EventKey.local('txn'),
      EventKey.remote(r'$event'),
    ]) {
      expect(eventKey(rustEventKey(key)), key);
    }
    for (final mode in NotificationMode.values) {
      expect(notificationMode(rustNotificationMode(mode)), mode);
    }
    expect(verificationState('verified'), VerificationState.verified);
    expect(verificationState('something-new'), VerificationState.unknown);
  });

  test('maps why a message cannot be decrypted', () {
    for (final reason in rust.DecryptionFailure.values) {
      final content = eventItem(
        rustEvent(content: rust.EventContent.unableToDecrypt(reason: reason)),
      ).content;

      expect(
        content,
        EventContent.unableToDecrypt(
          reason: DecryptionFailure.values.byName(reason.name),
        ),
      );
    }
  });

  test('maps the encryption status', () {
    expect(
      encryptionStatus(
        const rust.EncryptionStatus(
          recovery: rust.RecoveryStatus.incomplete,
          deviceVerified: false,
        ),
      ),
      const EncryptionStatus(
        recovery: RecoveryStatus.incomplete,
        deviceVerified: false,
      ),
    );
  });
}
