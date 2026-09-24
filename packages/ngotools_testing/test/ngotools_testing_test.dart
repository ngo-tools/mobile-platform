import 'package:flutter_test/flutter_test.dart';
import 'package:ngotools_mobile_core/ngotools_mobile_core.dart';
import 'package:ngotools_testing/ngotools_testing.dart';

void main() {
  test('uses only reserved invalid hosts', () {
    final hosts = MobileEnvironment.values.map(
      (environment) => SyntheticMobileFixture.configuration
          .forEnvironment(environment)
          .apiBaseUrl
          .host,
    );

    expect(hosts, everyElement(endsWith('.invalid')));
  });

  test('exposes only synthetic runtime capabilities', () {
    expect(SyntheticMobileFixture.capabilities.hasFeature('contacts'), isTrue);
    expect(SyntheticMobileFixture.capabilities.canImport('contacts'), isTrue);
  });
}
