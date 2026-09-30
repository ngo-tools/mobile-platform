// GENERATED FILE. DO NOT EDIT.
// The app generator writes this file from the selected modules.

import 'package:ngotools_api/ngotools_api.dart';
import 'package:ngotools_mobile_core/ngotools_mobile_core.dart';

import '../modules/app_chat.dart';
import '../modules/chat_module.dart';

/// Creates the chat of the app; `null` when the app has no chat.
Future<AppChat?> createAppChat({
  required NgoToolsMobileApi api,
  required MobileAppConfiguration app,
  required MobileEnvironmentConfiguration environment,
}) => GoldenChat.create(api: api, app: app, environment: environment);
