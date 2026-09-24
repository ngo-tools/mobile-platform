import 'package:flutter_test/flutter_test.dart';
import 'package:ngotools_auth/ngotools_auth.dart';
import 'package:ngotools_navigation/ngotools_navigation.dart';

void main() {
  final requirement = MobileRouteRequirement(
    capabilities: const ['contacts.read'],
  );

  test('requires authentication before checking capabilities', () {
    expect(
      requirement.evaluate(
        authStatus: MobileAuthStatus.signedOut,
        effectiveCapabilities: const {},
      ),
      MobileRouteAccess.signInRequired,
    );
  });

  test('blocks a route when a capability is missing', () {
    expect(
      requirement.evaluate(
        authStatus: MobileAuthStatus.authenticated,
        effectiveCapabilities: const {},
      ),
      MobileRouteAccess.capabilityMissing,
    );
  });

  test('allows a route when all requirements are satisfied', () {
    expect(
      requirement.evaluate(
        authStatus: MobileAuthStatus.authenticated,
        effectiveCapabilities: const {'contacts.read'},
      ),
      MobileRouteAccess.allowed,
    );
  });
}
