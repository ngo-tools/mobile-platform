import 'package:golden_app/bootstrap.dart';
import 'package:ngotools_mobile_core/ngotools_mobile_core.dart';

void main() {
  const environmentName = String.fromEnvironment(
    'MOBILE_ENVIRONMENT',
    defaultValue: 'development',
  );
  final environment = MobileEnvironment.values.byName(environmentName);

  bootstrap(environment);
}
