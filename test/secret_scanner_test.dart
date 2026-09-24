import 'package:ngo_tools_mobile_platform/mobile_platform_tooling.dart';
import 'package:test/test.dart';

void main() {
  test('accepts public configuration', () {
    final errors = SecretScanner.validate({
      'config.json': '{"apiBaseUrl":"https://example.invalid"}',
    });

    expect(errors, isEmpty);
  });

  test('rejects credential file extensions', () {
    final errors = SecretScanner.validate({'android/release.jks': ''});

    expect(
      errors,
      contains('android/release.jks: forbidden credential file type.'),
    );
  });

  test('rejects token and service-account material', () {
    final token = 'ghp_${List.filled(24, 'a').join()}';
    final serviceAccount = <String, String>{
      'type':
          'service'
          '_account',
      'private'
              '_key':
          'redacted',
    };
    final errors = SecretScanner.validate({
      'token.txt': token,
      'service-account.json': serviceAccount.entries
          .map((entry) => '"${entry.key}": "${entry.value}"')
          .join(', '),
    });

    expect(errors, hasLength(2));
  });

  test('rejects private key material', () {
    final marker =
        '-----BEGIN RSA PRIVATE'
        ' KEY-----';
    final errors = SecretScanner.validate({'key.txt': marker});

    expect(errors, hasLength(1));
  });
}
