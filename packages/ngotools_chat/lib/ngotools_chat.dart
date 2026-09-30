/// Matrix chat for NGO.Tools apps on matrix-rust-sdk.
///
/// Start with [ChatSession.initialize] and [ChatSession.open]. The native
/// bindings stay internal; this library is the whole public API.
library;

export 'src/chat_exception.dart';
export 'src/chat_lifecycle.dart';
export 'src/chat_models.dart';
export 'src/chat_session.dart';
export 'src/image_attachment.dart';
export 'src/platform.dart';
export 'src/room_list_controller.dart' show RoomListController;
export 'src/thread_list_controller.dart' show ThreadListController;
export 'src/timeline_controller.dart' show TimelineController;
