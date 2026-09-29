import Foundation
import UserNotifications

/// Resolves `event_id_only` pushes through the shared Rust facade: opens the
/// app's encrypted store in the App Group, decrypts the event and replaces the
/// placeholder text.
final class NotificationService: UNNotificationServiceExtension {
    private var contentHandler: ((UNNotificationContent) -> Void)?
    private var content: UNMutableNotificationContent?

    override func didReceive(
        _ request: UNNotificationRequest,
        withContentHandler contentHandler: @escaping (UNNotificationContent) -> Void
    ) {
        self.contentHandler = contentHandler
        let content = (request.content.mutableCopy() as? UNMutableNotificationContent) ?? UNMutableNotificationContent()
        self.content = content

        guard
            let roomId = request.content.userInfo["room_id"] as? String,
            let eventId = request.content.userInfo["event_id"] as? String,
            let group = FileManager.default.containerURL(forSecurityApplicationGroupIdentifier: NseResolver.appGroup)
        else {
            contentHandler(content)
            return
        }

        let result = NseResolver.resolve(groupDirectory: group, roomId: roomId, eventId: eventId)

        if result["ok"] as? Bool == true {
            content.title = (result["sender_name"] as? String) ?? (result["room_name"] as? String) ?? content.title
            content.body = (result["body"] as? String) ?? content.body
        }

        contentHandler(content)
    }

    override func serviceExtensionTimeWillExpire() {
        if let contentHandler, let content {
            contentHandler(content)
        }
    }
}
