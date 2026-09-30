import 'dart:typed_data';

import 'package:freezed_annotation/freezed_annotation.dart';

part 'chat_models.freezed.dart';

/// State of the signed-in session.
enum ChatSessionState {
  signedOut,
  active,

  /// Tokens were revoked or rejected (with MAS also for locked accounts);
  /// sign in again.
  expired,

  /// The homeserver reported the account as locked or deactivated.
  locked,
}

/// State of the background sync.
enum ChatSyncStatus {
  idle,
  running,

  /// No connection; the sync resumes on its own.
  offline,

  /// Failed; restarted with a backoff unless the session ended.
  error,
  stopped,
}

enum ChatLogLevel { error, warn, info, debug }

/// Key backup / recovery state of the account.
enum RecoveryStatus { unknown, enabled, disabled, incomplete }

/// Whether this device is verified (cross-signed).
enum VerificationState { unknown, verified, unverified }

/// Opaque reference to media (image, file, avatar). Pass it to
/// `ChatSession.fetchMedia`; do not parse it.
@immutable
class ChatMedia {
  const ChatMedia(this.reference);

  final String reference;

  @override
  bool operator ==(Object other) =>
      other is ChatMedia && other.reference == reference;

  @override
  int get hashCode => reference.hashCode;

  @override
  String toString() => 'ChatMedia';
}

/// The signed-in account.
@freezed
abstract class ChatAccount with _$ChatAccount {
  const factory ChatAccount({
    required String userId,
    required String deviceId,
  }) = _ChatAccount;
}

/// A Matrix user as shown in the chat (sender, member, typing user).
@freezed
abstract class ChatUser with _$ChatUser {
  const factory ChatUser({
    required String id,
    String? displayName,
    ChatMedia? avatar,
  }) = _ChatUser;
}

/// Short, localizable description of a message (room list, notifications,
/// reply and thread previews).
@freezed
sealed class MessagePreview with _$MessagePreview {
  const factory MessagePreview.text(String body) = TextPreview;
  const factory MessagePreview.image() = ImagePreview;
  const factory MessagePreview.video() = VideoPreview;
  const factory MessagePreview.audio() = AudioPreview;
  const factory MessagePreview.file() = FilePreview;
  const factory MessagePreview.location() = LocationPreview;
  const factory MessagePreview.poll() = PollPreview;
  const factory MessagePreview.sticker() = StickerPreview;
  const factory MessagePreview.redacted() = RedactedPreview;
  const factory MessagePreview.unableToDecrypt() = UnableToDecryptPreview;
  const factory MessagePreview.other() = OtherPreview;
}

enum RoomKind { direct, group }

enum Membership { joined, invited }

enum RoomFilter {
  /// Joined rooms and invites.
  all,

  /// Direct chats.
  people,
  groups,
  invites,

  /// Rooms with unread messages.
  unread,
}

enum NotificationMode { allMessages, mentionsOnly, mute }

/// Latest message of a room for the room list.
@freezed
abstract class LatestEvent with _$LatestEvent {
  const factory LatestEvent({
    required ChatUser sender,
    required bool isOwn,
    required DateTime timestamp,
    required MessagePreview preview,

    /// Still being sent or failed to send.
    required bool isUnsent,
  }) = _LatestEvent;
}

@freezed
abstract class RoomSummary with _$RoomSummary {
  const factory RoomSummary({
    required String id,
    required String name,
    ChatMedia? avatar,
    required RoomKind kind,
    required Membership membership,
    required bool isEncrypted,
    required int unreadMessages,
    required int unreadMentions,
    LatestEvent? latest,

    /// Mode chosen for this room; `null` follows the account default.
    NotificationMode? notificationMode,
  }) = _RoomSummary;
}

enum MemberRole { admin, moderator, user }

enum MemberState { joined, invited }

@freezed
abstract class ChatMember with _$ChatMember {
  const factory ChatMember({
    required ChatUser user,
    required MemberState state,
    required MemberRole role,
    required bool isOwn,
  }) = _ChatMember;
}

@freezed
abstract class RoomNotificationSettings with _$RoomNotificationSettings {
  const factory RoomNotificationSettings({
    required NotificationMode mode,

    /// True when the room follows the account default for its kind.
    required bool isDefault,
  }) = _RoomNotificationSettings;
}

/// Stable identity of a message: the transaction id of a local echo or the
/// event id once the server confirmed it.
@freezed
sealed class EventKey with _$EventKey {
  const factory EventKey.local(String transactionId) = LocalEventKey;
  const factory EventKey.remote(String eventId) = RemoteEventKey;
}

@freezed
abstract class UploadProgress with _$UploadProgress {
  const factory UploadProgress({
    required int currentBytes,
    required int totalBytes,
  }) = _UploadProgress;
}

@freezed
sealed class SendState with _$SendState {
  /// Queued or uploading; [progress] is set while media is uploaded.
  const factory SendState.sending({UploadProgress? progress}) = Sending;
  const factory SendState.sent() = Sent;

  /// Recoverable failures can be retried, others only cancelled.
  const factory SendState.failed({required bool recoverable}) = SendFailed;
}

enum MembershipChange {
  joined,
  left,
  invited,
  invitationAccepted,
  invitationRejected,
  kicked,
  banned,
  other,
}

@freezed
sealed class EventContent with _$EventContent {
  /// Plain text; links are detected by the UI.
  const factory EventContent.text(String body) = TextContent;
  const factory EventContent.image({
    String? caption,
    required String filename,
    required ChatMedia media,

    /// Small preview; prefer it for display when set.
    ChatMedia? thumbnail,
    int? width,
    int? height,
    String? blurhash,
  }) = ImageContent;
  const factory EventContent.video({
    String? caption,
    required String filename,
    required ChatMedia media,
  }) = VideoContent;
  const factory EventContent.audio({
    required String filename,
    required ChatMedia media,
  }) = AudioContent;
  const factory EventContent.file({
    String? caption,
    required String filename,
    required ChatMedia media,
    int? size,
  }) = FileContent;
  const factory EventContent.redacted() = RedactedContent;
  const factory EventContent.unableToDecrypt() = UnableToDecryptContent;
  const factory EventContent.membership({
    required String userId,
    required MembershipChange change,
  }) = MembershipContent;
  const factory EventContent.profileChange(String userId) =
      ProfileChangeContent;
  const factory EventContent.roomState(String eventType) = RoomStateContent;
  const factory EventContent.unsupported() = UnsupportedContent;
}

@freezed
abstract class ReplyPreview with _$ReplyPreview {
  const factory ReplyPreview({
    required String eventId,

    /// `null` until loaded (`TimelineController.loadReplyDetails`).
    ChatUser? sender,
    MessagePreview? preview,
  }) = _ReplyPreview;
}

@freezed
abstract class Reaction with _$Reaction {
  const factory Reaction({
    required String key,
    required int count,
    required bool byMe,
  }) = _Reaction;
}

@freezed
abstract class ThreadSummary with _$ThreadSummary {
  const factory ThreadSummary({
    required int replyCount,
    ChatUser? latestSender,
    MessagePreview? latestPreview,
  }) = _ThreadSummary;
}

@freezed
abstract class EventItem with _$EventItem {
  const factory EventItem({
    required EventKey key,

    /// Not unique across items: the SDK may keep a local echo next to its
    /// remote echo for a while. Key widgets by `TimelineItem.id`.
    String? eventId,
    required ChatUser sender,
    required DateTime timestamp,
    required bool isOwn,
    required bool canEdit,
    required bool canReply,
    required SendState sendState,
    required EventContent content,
    ReplyPreview? replyTo,
    @Default(<Reaction>[]) List<Reaction> reactions,
    required bool isEdited,

    /// Root event id when this message belongs to a thread.
    String? threadRoot,

    /// Set on thread roots.
    ThreadSummary? thread,
  }) = _EventItem;
}

/// An entry of a timeline; [id] is stable for the lifetime of the item.
@freezed
sealed class TimelineItem with _$TimelineItem {
  const factory TimelineItem.event({
    required String id,
    required EventItem event,
  }) = EventTimelineItem;
  const factory TimelineItem.dateDivider({
    required String id,
    required DateTime date,
  }) = DateDividerItem;
  const factory TimelineItem.readMarker({required String id}) = ReadMarkerItem;
  const factory TimelineItem.timelineStart({required String id}) =
      TimelineStartItem;
}

@freezed
abstract class ThreadEvent with _$ThreadEvent {
  const factory ThreadEvent({
    required String eventId,
    required ChatUser sender,
    required DateTime timestamp,
    required bool isOwn,

    /// `null` while the content is unknown (e.g. not yet decrypted).
    MessagePreview? preview,
  }) = _ThreadEvent;
}

@freezed
abstract class ThreadInfo with _$ThreadInfo {
  const factory ThreadInfo({
    required ThreadEvent root,
    ThreadEvent? latest,
    required int replyCount,
  }) = _ThreadInfo;
}

/// Encoded preview image for [ImageAttachment].
@freezed
abstract class ImageThumbnail with _$ImageThumbnail {
  const factory ImageThumbnail({
    required Uint8List data,
    required String mimeType,
    required int width,
    required int height,
  }) = _ImageThumbnail;
}

/// An image to send; create it with `prepareImageAttachment`.
@freezed
abstract class ImageAttachment with _$ImageAttachment {
  const factory ImageAttachment({
    required String filePath,
    required String mimeType,
    String? caption,
    int? width,
    int? height,
    String? blurhash,
    ImageThumbnail? thumbnail,
  }) = _ImageAttachment;
}

/// A resolved push notification.
@freezed
abstract class ChatNotification with _$ChatNotification {
  const factory ChatNotification({
    required String roomName,
    String? senderName,
    required String body,
    required bool isDirect,
    bool? isEncrypted,
  }) = _ChatNotification;
}
