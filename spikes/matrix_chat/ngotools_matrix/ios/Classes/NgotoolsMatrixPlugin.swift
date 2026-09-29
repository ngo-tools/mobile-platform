import Flutter
import UIKit
import UserNotifications

/// Platform helpers the Rust facade cannot provide (App Group container).
public class NgotoolsMatrixPlugin: NSObject, FlutterPlugin {
    public static func register(with registrar: FlutterPluginRegistrar) {
        let channel = FlutterMethodChannel(name: "ngotools_matrix/platform", binaryMessenger: registrar.messenger())
        registrar.addMethodCallDelegate(NgotoolsMatrixPlugin(), channel: channel)
    }

    public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        switch call.method {
        case "appGroupDirectory":
            guard let group = call.arguments as? String else {
                result(FlutterError(code: "argument", message: "group id missing", details: nil))
                return
            }
            result(FileManager.default.containerURL(forSecurityApplicationGroupIdentifier: group)?.path)
        case "requestProvisionalNotifications":
            // Provisional authorization needs no prompt; enough for the spike's
            // Notification Service Extension check.
            UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound, .provisional]) { granted, _ in
                DispatchQueue.main.async { result(granted) }
            }
        default:
            result(FlutterMethodNotImplemented)
        }
    }
}
