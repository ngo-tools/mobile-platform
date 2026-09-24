import 'dart:io';

import 'package:ngo_tools_mobile_platform/mobile_platform_tooling.dart';
import 'package:test/test.dart';

void main() {
  late String manifestSource;
  late String schemaSource;

  setUpAll(() async {
    manifestSource = await File(
      'example/golden_app/ngo-tools.mobile.yaml',
    ).readAsString();
    schemaSource = await File(
      'schemas/ngo-tools.mobile.schema.json',
    ).readAsString();
  });

  test('accepts the synthetic Golden App manifest', () {
    final result = ManifestValidator.validate(
      manifestSource: manifestSource,
      schemaSource: schemaSource,
    );

    expect(result.errors, isEmpty);
    expect(result.manifest?['kind'], 'OrganizationApp');
  });

  test('rejects unknown manifest properties', () {
    final result = ManifestValidator.validate(
      manifestSource: '$manifestSource\nsecret: should-not-exist\n',
      schemaSource: schemaSource,
    );

    expect(result.isValid, isFalse);
  });

  test('requires the default locale to be shipped', () {
    final result = ManifestValidator.validate(
      manifestSource: manifestSource.replaceFirst(
        'defaultLocale: de',
        'defaultLocale: fr',
      ),
      schemaSource: schemaSource,
    );

    expect(
      result.errors,
      contains('localization.defaultLocale must be included in locales.'),
    );
  });

  test('enforces the production attestation policy', () {
    final result = ManifestValidator.validate(
      manifestSource: manifestSource.replaceFirst(
        'attestationMode: enforced',
        'attestationMode: test',
      ),
      schemaSource: schemaSource,
    );

    expect(
      result.errors,
      contains(
        'backend.environments.production.attestationMode must be enforced.',
      ),
    );
  });

  test('rejects unapproved API scopes', () {
    final result = ManifestValidator.validate(
      manifestSource: manifestSource.replaceFirst(
        '- contacts:read',
        '- billing:admin',
      ),
      schemaSource: schemaSource,
    );

    expect(result.isValid, isFalse);
  });

  test('requires external-browser Authorization Code with PKCE', () {
    final result = ManifestValidator.validate(
      manifestSource: manifestSource.replaceFirst(
        'userAgent: external',
        'userAgent: embedded',
      ),
      schemaSource: schemaSource,
    );

    expect(result.isValid, isFalse);
  });

  test('requires the complete public OIDC scope set', () {
    final result = ManifestValidator.validate(
      manifestSource: manifestSource.replaceFirst(', offline_access', ''),
      schemaSource: schemaSource,
    );

    expect(result.isValid, isFalse);
  });

  test('reports malformed YAML instead of throwing', () {
    final result = ManifestValidator.validate(
      manifestSource: 'metadata: [',
      schemaSource: schemaSource,
    );

    expect(result.isValid, isFalse);
    expect(result.manifest, isNull);
  });
}
