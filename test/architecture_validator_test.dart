import 'package:ngo_tools_mobile_platform/mobile_platform_tooling.dart';
import 'package:test/test.dart';

void main() {
  test('accepts the approved dependency direction', () {
    final errors = ArchitectureValidator.validate({
      'ngotools_mobile_core': {},
      'ngotools_auth': {'flutter', 'ngotools_mobile_core'},
      'ngotools_navigation': {'ngotools_auth', 'ngotools_mobile_core'},
    });

    expect(errors, isEmpty);
  });

  test('rejects dependencies from core into higher-level packages', () {
    final errors = ArchitectureValidator.validate({
      'ngotools_mobile_core': {'ngotools_api'},
    });

    expect(
      errors,
      contains('ngotools_mobile_core may not depend on ngotools_api.'),
    );
  });
}
