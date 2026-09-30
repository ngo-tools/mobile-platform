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

  test('keeps the chat package free of internal platform dependencies', () {
    final errors = ArchitectureValidator.validate({
      'ngotools_chat': {'flutter', 'flutter_rust_bridge', 'ngotools_auth'},
    });

    expect(errors, ['ngotools_chat may not depend on ngotools_auth.']);
  });

  test('keeps the Rust bridge internals inside the chat package', () {
    final errors = ArchitectureValidator.validateSourceBoundaries({
      'example/golden_app/lib/chat.dart':
          "import 'package:ngotools_chat/src/rust/frb_generated.dart';",
      'packages/ngotools_chat/lib/ngotools_chat.dart':
          "export 'package:ngotools_chat/src/rust/frb_generated.dart';",
    });

    expect(errors, [
      'example/golden_app/lib/chat.dart may not import ngotools_chat internals.',
      'packages/ngotools_chat/lib/ngotools_chat.dart may not export the '
          'generated chat bindings.',
    ]);
  });

  test('keeps the chat example on the public API', () {
    final errors = ArchitectureValidator.validateSourceBoundaries({
      'packages/ngotools_chat/example/lib/main.dart':
          "import 'package:ngotools_chat/src/rust/api/client.dart';",
      'packages/ngotools_chat/lib/src/chat_session.dart':
          "import 'rust/api/client.dart';",
      'packages/ngotools_chat/lib/ngotools_chat.dart':
          "export 'src/chat_session.dart';",
    });

    expect(errors, [
      'packages/ngotools_chat/example/lib/main.dart may not import '
          'ngotools_chat internals.',
    ]);
  });
}
