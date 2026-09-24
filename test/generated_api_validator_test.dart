import 'dart:convert';
import 'dart:io';

import 'package:ngo_tools_mobile_platform/mobile_platform_tooling.dart';
import 'package:path/path.dart' as path;
import 'package:test/test.dart';

void main() {
  late Directory repository;

  setUp(() async {
    repository = await Directory.systemTemp.createTemp(
      'generated-api-validator-',
    );
    await _write(repository, 'openapi/mobile-runtime.yaml', 'openapi: 3.0.3');
    await _write(repository, 'openapi/dart-dio-config.yaml', 'pubName: api');
    await _write(
      repository,
      'packages/ngotools_api/lib/src/generated/api.dart',
      'final generated = true;',
    );
    final provenance = await GeneratedApiValidator.provenance(repository);
    await _write(
      repository,
      'openapi/generated-client.json',
      '${const JsonEncoder.withIndent('  ').convert(provenance)}\n',
    );
  });

  tearDown(() => repository.delete(recursive: true));

  test('accepts an unchanged generated client', () async {
    expect(await GeneratedApiValidator.validate(repository), isEmpty);
  });

  test('rejects contract drift', () async {
    await _write(repository, 'openapi/mobile-runtime.yaml', 'openapi: 3.1.0');

    expect(
      await GeneratedApiValidator.validate(repository),
      contains('spec_sha256 does not match the pinned generated API client.'),
    );
  });

  test('rejects generated source drift', () async {
    await _write(
      repository,
      'packages/ngotools_api/lib/src/generated/api.dart',
      'final generated = false;',
    );

    expect(
      await GeneratedApiValidator.validate(repository),
      contains('output_sha256 does not match the pinned generated API client.'),
    );
  });
}

Future<void> _write(
  Directory repository,
  String relativePath,
  String contents,
) async {
  final file = File(path.join(repository.path, relativePath));
  await file.parent.create(recursive: true);
  await file.writeAsString(contents);
}
