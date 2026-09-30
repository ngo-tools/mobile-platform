// The only place that translates generated bindings into the public API.

import 'dart:convert';

import 'chat_exception.dart';
import 'chat_models.dart';
import 'rust/api/client.dart' as rust;
import 'rust/api/encryption.dart' as rust;
import 'rust/api/error.dart' as rust;
import 'rust/api/lifecycle.dart' as rust;
import 'rust/api/logging.dart' as rust;
import 'rust/api/notifications.dart' as rust;
import 'rust/api/room.dart' as rust;
import 'rust/api/rooms.dart' as rust;
import 'rust/api/threads.dart' as rust;
import 'rust/api/timeline.dart' as rust;

/// Runs a binding call and translates its errors into [ChatException].
Future<T> guard<T>(Future<T> Function() call) async {
  try {
    return await call();
  } on rust.ChatError catch (error) {
    throw chatException(error);
  }
}

ChatException chatException(rust.ChatError error) => switch (error) {
  rust.ChatError_Network() => const ChatException(ChatErrorKind.network),
  rust.ChatError_SessionExpired() => const ChatException(
    ChatErrorKind.sessionExpired,
  ),
  rust.ChatError_AccountLocked() => const ChatException(
    ChatErrorKind.accountLocked,
  ),
  rust.ChatError_Forbidden() => const ChatException(ChatErrorKind.forbidden),
  rust.ChatError_NotFound() => const ChatException(ChatErrorKind.notFound),
  rust.ChatError_RateLimited(:final retryAfterMs) => ChatException(
    ChatErrorKind.rateLimited,
    retryAfter: retryAfterMs == null
        ? null
        : Duration(milliseconds: retryAfterMs.toInt()),
  ),
  rust.ChatError_Crypto(:final message) => ChatException(
    ChatErrorKind.crypto,
    message: message,
  ),
  rust.ChatError_Storage(:final message) => ChatException(
    ChatErrorKind.storage,
    message: message,
  ),
  rust.ChatError_InvalidInput(:final message) => ChatException(
    ChatErrorKind.invalidInput,
    message: message,
  ),
  rust.ChatError_Internal(:final message) => ChatException(
    ChatErrorKind.internal,
    message: message,
  ),
};

ChatAccount account(rust.SessionInfo info) =>
    ChatAccount(userId: info.userId, deviceId: info.deviceId);

ChatSessionState sessionState(rust.SessionState state) => switch (state) {
  rust.SessionState.signedOut => ChatSessionState.signedOut,
  rust.SessionState.active => ChatSessionState.active,
  rust.SessionState.expired => ChatSessionState.expired,
  rust.SessionState.locked => ChatSessionState.locked,
};

ChatSyncStatus syncStatus(rust.SyncStatus status) => switch (status) {
  rust.SyncStatus.idle => ChatSyncStatus.idle,
  rust.SyncStatus.running => ChatSyncStatus.running,
  rust.SyncStatus.offline => ChatSyncStatus.offline,
  rust.SyncStatus.error => ChatSyncStatus.error,
  rust.SyncStatus.stopped => ChatSyncStatus.stopped,
};

rust.LogLevel logLevel(ChatLogLevel level) => switch (level) {
  ChatLogLevel.error => rust.LogLevel.error,
  ChatLogLevel.warn => rust.LogLevel.warn,
  ChatLogLevel.info => rust.LogLevel.info,
  ChatLogLevel.debug => rust.LogLevel.debug,
};

RecoveryStatus recoveryStatus(rust.RecoveryStatus status) => switch (status) {
  rust.RecoveryStatus.unknown => RecoveryStatus.unknown,
  rust.RecoveryStatus.enabled => RecoveryStatus.enabled,
  rust.RecoveryStatus.disabled => RecoveryStatus.disabled,
  rust.RecoveryStatus.incomplete => RecoveryStatus.incomplete,
};

EncryptionStatus encryptionStatus(rust.EncryptionStatus status) =>
    EncryptionStatus(
      recovery: recoveryStatus(status.recovery),
      deviceVerified: status.deviceVerified,
    );

DecryptionFailure decryptionFailure(
  rust.DecryptionFailure reason,
) => switch (reason) {
  rust.DecryptionFailure.unknown => DecryptionFailure.unknown,
  rust.DecryptionFailure.sentBeforeJoined => DecryptionFailure.sentBeforeJoined,
  rust.DecryptionFailure.historicalNoBackup =>
    DecryptionFailure.historicalNoBackup,
  rust.DecryptionFailure.historicalUnverifiedDevice =>
    DecryptionFailure.historicalUnverifiedDevice,
  rust.DecryptionFailure.withheld => DecryptionFailure.withheld,
  rust.DecryptionFailure.untrustedSender => DecryptionFailure.untrustedSender,
};

VerificationState verificationState(String state) => switch (state) {
  'verified' => VerificationState.verified,
  'unverified' => VerificationState.unverified,
  _ => VerificationState.unknown,
};

/// Avatars arrive as `mxc://` URIs; the media API expects a serialized
/// media source, which for plain media is the JSON string of the URI.
ChatMedia? avatar(String? mxcUri) =>
    mxcUri == null ? null : ChatMedia(jsonEncode(mxcUri));

ChatUser user(rust.Sender sender) => ChatUser(
  id: sender.id,
  displayName: sender.name,
  avatar: avatar(sender.avatarUrl),
);

DateTime timestamp(int milliseconds) =>
    DateTime.fromMillisecondsSinceEpoch(milliseconds);

MessagePreview messagePreview(rust.MessagePreview preview) => switch (preview) {
  rust.MessagePreview_Text(:final body) => MessagePreview.text(body),
  rust.MessagePreview_Image() => const MessagePreview.image(),
  rust.MessagePreview_Video() => const MessagePreview.video(),
  rust.MessagePreview_Audio() => const MessagePreview.audio(),
  rust.MessagePreview_File() => const MessagePreview.file(),
  rust.MessagePreview_Location() => const MessagePreview.location(),
  rust.MessagePreview_Poll() => const MessagePreview.poll(),
  rust.MessagePreview_Sticker() => const MessagePreview.sticker(),
  rust.MessagePreview_Redacted() => const MessagePreview.redacted(),
  rust.MessagePreview_UnableToDecrypt() =>
    const MessagePreview.unableToDecrypt(),
  rust.MessagePreview_Other() => const MessagePreview.other(),
};

RoomSummary roomSummary(rust.RoomSummary room) => RoomSummary(
  id: room.id,
  name: room.name,
  avatar: avatar(room.avatarUrl),
  kind: switch (room.kind) {
    rust.RoomKind.direct => RoomKind.direct,
    rust.RoomKind.group => RoomKind.group,
  },
  membership: switch (room.membership) {
    rust.Membership.joined => Membership.joined,
    rust.Membership.invited => Membership.invited,
  },
  isEncrypted: room.isEncrypted,
  unreadMessages: room.unreadMessages,
  unreadMentions: room.unreadMentions,
  latest: room.latest == null ? null : latestEvent(room.latest!),
  notificationMode: room.notificationMode == null
      ? null
      : notificationMode(room.notificationMode!),
);

LatestEvent latestEvent(rust.LatestEvent event) => LatestEvent(
  sender: ChatUser(id: event.senderId, displayName: event.senderName),
  isOwn: event.isOwn,
  timestamp: timestamp(event.timestampMs),
  preview: messagePreview(event.preview),
  isUnsent: event.isUnsent,
);

rust.RoomFilter roomFilter(RoomFilter filter) => switch (filter) {
  RoomFilter.all => rust.RoomFilter.all,
  RoomFilter.people => rust.RoomFilter.people,
  RoomFilter.groups => rust.RoomFilter.groups,
  RoomFilter.invites => rust.RoomFilter.invites,
  RoomFilter.unread => rust.RoomFilter.unread,
};

NotificationMode notificationMode(rust.NotificationMode mode) => switch (mode) {
  rust.NotificationMode.allMessages => NotificationMode.allMessages,
  rust.NotificationMode.mentionsOnly => NotificationMode.mentionsOnly,
  rust.NotificationMode.mute => NotificationMode.mute,
};

rust.NotificationMode rustNotificationMode(NotificationMode mode) =>
    switch (mode) {
      NotificationMode.allMessages => rust.NotificationMode.allMessages,
      NotificationMode.mentionsOnly => rust.NotificationMode.mentionsOnly,
      NotificationMode.mute => rust.NotificationMode.mute,
    };

RoomNotificationSettings notificationSettings(
  rust.RoomNotificationSettings settings,
) => RoomNotificationSettings(
  mode: notificationMode(settings.mode),
  isDefault: settings.isDefault,
);

ChatMember member(rust.Member member) => ChatMember(
  user: ChatUser(
    id: member.userId,
    displayName: member.displayName,
    avatar: avatar(member.avatarUrl),
  ),
  state: switch (member.state) {
    rust.MemberState.joined => MemberState.joined,
    rust.MemberState.invited => MemberState.invited,
  },
  role: switch (member.role) {
    rust.MemberRole.admin => MemberRole.admin,
    rust.MemberRole.moderator => MemberRole.moderator,
    rust.MemberRole.user => MemberRole.user,
  },
  isOwn: member.isOwn,
);

EventKey eventKey(rust.EventKey key) => switch (key) {
  rust.EventKey_Local(:final transactionId) => EventKey.local(transactionId),
  rust.EventKey_Remote(:final eventId) => EventKey.remote(eventId),
};

rust.EventKey rustEventKey(EventKey key) => switch (key) {
  LocalEventKey(:final transactionId) => rust.EventKey.local(
    transactionId: transactionId,
  ),
  RemoteEventKey(:final eventId) => rust.EventKey.remote(eventId: eventId),
};

SendState sendState(rust.SendState state) => switch (state) {
  rust.SendState_Sending(:final progress) => SendState.sending(
    progress: progress == null
        ? null
        : UploadProgress(
            currentBytes: progress.currentBytes.toInt(),
            totalBytes: progress.totalBytes.toInt(),
          ),
  ),
  rust.SendState_Sent() => const SendState.sent(),
  rust.SendState_Failed(:final recoverable) => SendState.failed(
    recoverable: recoverable,
  ),
};

ChatMedia media(String reference) => ChatMedia(reference);

EventContent eventContent(rust.EventContent content) => switch (content) {
  rust.EventContent_Text(:final body) => EventContent.text(body),
  rust.EventContent_Image(
    :final caption,
    :final filename,
    media: final reference,
    :final thumbnail,
    :final width,
    :final height,
    :final blurhash,
  ) =>
    EventContent.image(
      caption: caption,
      filename: filename,
      media: media(reference),
      thumbnail: thumbnail == null ? null : media(thumbnail),
      width: width,
      height: height,
      blurhash: blurhash,
    ),
  rust.EventContent_Video(:final caption, :final filename, :final media) =>
    EventContent.video(
      caption: caption,
      filename: filename,
      media: ChatMedia(media),
    ),
  rust.EventContent_Audio(:final filename, :final media) => EventContent.audio(
    filename: filename,
    media: ChatMedia(media),
  ),
  rust.EventContent_File(
    :final caption,
    :final filename,
    :final media,
    :final size,
  ) =>
    EventContent.file(
      caption: caption,
      filename: filename,
      media: ChatMedia(media),
      size: size?.toInt(),
    ),
  rust.EventContent_Redacted() => const EventContent.redacted(),
  rust.EventContent_UnableToDecrypt(:final reason) =>
    EventContent.unableToDecrypt(reason: decryptionFailure(reason)),
  rust.EventContent_Membership(:final userId, :final change) =>
    EventContent.membership(userId: userId, change: membershipChange(change)),
  rust.EventContent_ProfileChange(:final userId) => EventContent.profileChange(
    userId,
  ),
  rust.EventContent_RoomState(:final eventType) => EventContent.roomState(
    eventType,
  ),
  rust.EventContent_Unsupported() => const EventContent.unsupported(),
};

MembershipChange membershipChange(rust.MembershipKind kind) => switch (kind) {
  rust.MembershipKind.joined => MembershipChange.joined,
  rust.MembershipKind.left => MembershipChange.left,
  rust.MembershipKind.invited => MembershipChange.invited,
  rust.MembershipKind.invitationAccepted => MembershipChange.invitationAccepted,
  rust.MembershipKind.invitationRejected => MembershipChange.invitationRejected,
  rust.MembershipKind.kicked => MembershipChange.kicked,
  rust.MembershipKind.banned => MembershipChange.banned,
  rust.MembershipKind.other => MembershipChange.other,
};

EventItem eventItem(rust.EventItem event) => EventItem(
  key: eventKey(event.key),
  eventId: event.eventId,
  sender: user(event.sender),
  timestamp: timestamp(event.timestampMs),
  isOwn: event.isOwn,
  canEdit: event.canEdit,
  canReply: event.canReply,
  sendState: sendState(event.sendState),
  content: eventContent(event.content),
  replyTo: event.replyTo == null
      ? null
      : ReplyPreview(
          eventId: event.replyTo!.eventId,
          sender: event.replyTo!.sender == null
              ? null
              : user(event.replyTo!.sender!),
          preview: event.replyTo!.preview == null
              ? null
              : messagePreview(event.replyTo!.preview!),
        ),
  reactions: [
    for (final reaction in event.reactions)
      Reaction(key: reaction.key, count: reaction.count, byMe: reaction.byMe),
  ],
  isEdited: event.isEdited,
  threadRoot: event.threadRoot,
  thread: event.thread == null
      ? null
      : ThreadSummary(
          replyCount: event.thread!.replyCount,
          latestSender: event.thread!.latestSender == null
              ? null
              : user(event.thread!.latestSender!),
          latestPreview: event.thread!.latestPreview == null
              ? null
              : messagePreview(event.thread!.latestPreview!),
        ),
);

TimelineItem timelineItem(rust.TimelineItem item) => switch (item.kind) {
  rust.TimelineItemKind_Event(:final event) => TimelineItem.event(
    id: item.id,
    event: eventItem(event),
  ),
  rust.TimelineItemKind_DateDivider(:final timestampMs) =>
    TimelineItem.dateDivider(id: item.id, date: timestamp(timestampMs)),
  rust.TimelineItemKind_ReadMarker() => TimelineItem.readMarker(id: item.id),
  rust.TimelineItemKind_TimelineStart() => TimelineItem.timelineStart(
    id: item.id,
  ),
};

ThreadEvent threadEvent(rust.ThreadEvent event) => ThreadEvent(
  eventId: event.eventId,
  sender: user(event.sender),
  timestamp: timestamp(event.timestampMs),
  isOwn: event.isOwn,
  preview: event.preview == null ? null : messagePreview(event.preview!),
);

ThreadInfo threadInfo(rust.ThreadInfo thread) => ThreadInfo(
  root: threadEvent(thread.root),
  latest: thread.latest == null ? null : threadEvent(thread.latest!),
  replyCount: thread.replyCount,
);

rust.ImageAttachment rustImageAttachment(ImageAttachment image) =>
    rust.ImageAttachment(
      filePath: image.filePath,
      mimeType: image.mimeType,
      caption: image.caption,
      width: image.width,
      height: image.height,
      blurhash: image.blurhash,
      thumbnail: image.thumbnail == null
          ? null
          : rust.ImageThumbnail(
              data: image.thumbnail!.data,
              mimeType: image.thumbnail!.mimeType,
              width: image.thumbnail!.width,
              height: image.thumbnail!.height,
            ),
    );

ChatNotification notification(rust.NotificationContent content) =>
    ChatNotification(
      roomName: content.roomName,
      senderName: content.senderName,
      body: content.body,
      isDirect: content.isDirect,
      isEncrypted: content.isEncrypted,
    );
