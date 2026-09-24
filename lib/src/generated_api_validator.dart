import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:crypto/crypto.dart';
import 'package:path/path.dart' as path;

/// Verifies that the committed API client matches its pinned contract.
abstract final class GeneratedApiValidator {
  /// Pinned OpenAPI Generator CLI version.
  static const generatorVersion = '7.25.0';

  /// SHA-256 of the pinned OpenAPI Generator CLI JAR.
  static const generatorSha256 =
      '41ce4f6b07f196676439d710759fa1ced7a08066d06ff1bf314681470289efae';

  /// Returns provenance for the contract, config, and generated source tree.
  static Future<Map<String, String>> provenance(Directory repository) async => {
    'generator': 'openapi-generator-cli',
    'generator_version': generatorVersion,
    'generator_sha256': generatorSha256,
    'spec_sha256': await _fileDigest(
      File(path.join(repository.path, 'openapi', 'mobile-runtime.yaml')),
    ),
    'config_sha256': await _fileDigest(
      File(path.join(repository.path, 'openapi', 'dart-dio-config.yaml')),
    ),
    'output_sha256': await _directoryDigest(
      repository,
      Directory(
        path.join(
          repository.path,
          'packages',
          'ngotools_api',
          'lib',
          'src',
          'generated',
        ),
      ),
    ),
  };

  /// Returns provenance mismatches that must fail the platform gate.
  static Future<List<String>> validate(Directory repository) async {
    final manifestFile = File(
      path.join(repository.path, 'openapi', 'generated-client.json'),
    );

    if (!await manifestFile.exists()) {
      return ['Missing openapi/generated-client.json.'];
    }

    final Object? decoded;

    try {
      decoded = jsonDecode(await manifestFile.readAsString());
    } on FormatException {
      return ['openapi/generated-client.json is not valid JSON.'];
    }

    if (decoded is! Map<String, dynamic>) {
      return ['openapi/generated-client.json must contain a JSON object.'];
    }

    final actual = await provenance(repository);
    final errors = <String>[];

    for (final entry in actual.entries) {
      if (decoded[entry.key] != entry.value) {
        errors.add(
          '${entry.key} does not match the pinned generated API client.',
        );
      }
    }

    return errors;
  }

  static Future<String> _fileDigest(File file) async =>
      sha256.convert(await file.readAsBytes()).toString();

  static Future<String> _directoryDigest(
    Directory repository,
    Directory directory,
  ) async {
    final files = await directory
        .list(recursive: true)
        .where((entity) => entity is File)
        .cast<File>()
        .toList();
    files.sort((left, right) => left.path.compareTo(right.path));
    final bytes = BytesBuilder(copy: false);

    for (final file in files) {
      final relativePath = path
          .relative(file.path, from: repository.path)
          .replaceAll(path.separator, '/');
      bytes
        ..add(utf8.encode(relativePath))
        ..addByte(0)
        ..add(await file.readAsBytes())
        ..addByte(0);
    }

    return sha256.convert(bytes.takeBytes()).toString();
  }
}
