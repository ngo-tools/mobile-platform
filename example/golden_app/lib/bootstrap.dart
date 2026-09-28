import 'package:flutter/widgets.dart';
import 'package:golden_app/runtime.dart';
import 'package:ngotools_mobile_core/ngotools_mobile_core.dart';

/// Starts the Golden App with sign-in and API access in [environment].
void bootstrap(MobileEnvironment environment) {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(GoldenRuntime(environment: environment));
}
