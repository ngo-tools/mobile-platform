import Flutter
import UIKit
import UserNotifications

@main
@objc class AppDelegate: FlutterAppDelegate, FlutterImplicitEngineDelegate {
  /// APNs token of this installation (hex), for the push device test.
  private var apnsToken: String?

  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }

  func didInitializeImplicitFlutterEngine(_ engineBridge: FlutterImplicitEngineBridge) {
    GeneratedPluginRegistrant.register(with: engineBridge.pluginRegistry)

    guard let registrar = engineBridge.pluginRegistry.registrar(forPlugin: "PushDeviceTest") else {
      return
    }
    let channel = FlutterMethodChannel(
      name: "tools.ngo.chat_example/push",
      binaryMessenger: registrar.messenger()
    )
    channel.setMethodCallHandler { [weak self] call, result in
      guard call.method == "apnsToken" else {
        result(FlutterMethodNotImplemented)
        return
      }
      if let token = self?.apnsToken {
        result(token)
        return
      }
      UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { granted, _ in
        DispatchQueue.main.async {
          guard granted else {
            result(FlutterError(code: "denied", message: "Notifications not allowed", details: nil))
            return
          }
          UIApplication.shared.registerForRemoteNotifications()
          // The token arrives in didRegisterForRemoteNotificationsWithDeviceToken.
          DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
            result(self?.apnsToken)
          }
        }
      }
    }
  }

  override func application(
    _ application: UIApplication,
    didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data
  ) {
    apnsToken = deviceToken.map { String(format: "%02x", $0) }.joined()
    super.application(application, didRegisterForRemoteNotificationsWithDeviceToken: deviceToken)
  }
}
