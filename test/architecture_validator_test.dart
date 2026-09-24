import 'package:ngo_tools_mobile_platform/mobile_platform_tooling.dart';
import 'package:test/test.dart';

void main() {
  test('accepts the approved dependency direction', () {
    final errors = ArchitectureValidator.validate({
      'ngotools_mobile_core': {},
      'ngotools_auth': {'flutter', 'ngotools_mobile_core'},
      'ngotools_navigation': {
        'ngotools_api',
        'ngotools_auth',
        'ngotools_mobile_core',
      },
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

  test('keeps raw auth state and HTTP behind package boundaries', () {
    final errors = ArchitectureValidator.validateSourceBoundaries({
      'example/golden_app/lib/profile.dart':
          "import 'package:ngotools_auth/src/internal/auth_session.dart';\n"
          "import 'package:ngotools_api/src/generated/api.dart';\n"
          "import 'package:dio/dio.dart';",
      'packages/ngotools_auth/lib/src/client.dart':
          "import 'package:dio/dio.dart';",
      'packages/ngotools_api/lib/src/client.dart':
          "import 'package:dio/dio.dart';",
    });

    expect(errors, {
      'example/golden_app/lib/profile.dart may not import ngotools_auth internals.',
      'example/golden_app/lib/profile.dart may not import generated API internals.',
      'example/golden_app/lib/profile.dart may not perform direct HTTP requests.',
    });
  });
}
