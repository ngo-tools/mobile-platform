import 'package:flutter/widgets.dart';
import 'package:golden_app/app.dart';
import 'package:ngotools_mobile_core/ngotools_mobile_core.dart';

/// Starts the Golden App in the selected environment.
void bootstrap(MobileEnvironment environment) {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(GoldenApp(environment: environment));
}
