import 'dart:io';

import 'package:flutter/services.dart';

/// Native helpers of the plugin (iOS App Group container for the store that
/// the Notification Service Extension shares).
class NgotoolsMatrixPlatform {
  static const _channel = MethodChannel('ngotools_matrix/platform');

  static Future<String?> appGroupDirectory(String groupId) async {
    if (!Platform.isIOS) {
      return null;
    }
    return _channel.invokeMethod<String>('appGroupDirectory', groupId);
  }

  static Future<bool> requestProvisionalNotifications() async {
    if (!Platform.isIOS) {
      return false;
    }
    return await _channel.invokeMethod<bool>('requestProvisionalNotifications') ?? false;
  }
}
