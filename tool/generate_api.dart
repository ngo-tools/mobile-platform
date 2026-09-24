import 'dart:convert';
import 'dart:io';

import 'package:crypto/crypto.dart';
import 'package:ngo_tools_mobile_platform/mobile_platform_tooling.dart';
import 'package:path/path.dart' as path;

Future<void> main() async {
  final repository = Directory.current.absolute;
  final generator = await _generatorJar();
  final temporaryOutput = await Directory.systemTemp.createTemp(
    'ngotools-openapi-',
  );

  try {
    await _run(repository, 'java', [
      '-jar',
      generator.path,
      'generate',
      '-g',
      'dart-dio',
      '-i',
      path.join(repository.path, 'openapi', 'mobile-runtime.yaml'),
      '-c',
      path.join(repository.path, 'openapi', 'dart-dio-config.yaml'),
      '-o',
      temporaryOutput.path,
      '--global-property',
      'apiDocs=false,modelDocs=false,apiTests=false,modelTests=false',
    ]);

    final generatedSource = Directory(
      path.join(temporaryOutput.path, 'lib', 'src', 'generated'),
    );
    final committedSource = Directory(
      path.join(
        repository.path,
        'packages',
        'ngotools_api',
        'lib',
        'src',
        'generated',
      ),
    );

    if (await committedSource.exists()) {
      await committedSource.delete(recursive: true);
    }

    await _copyDirectory(generatedSource, committedSource);
    await _run(repository, 'dart', ['format', committedSource.path]);
    await _run(
      Directory(path.join(repository.path, 'packages', 'ngotools_api')),
      'dart',
      ['run', 'build_runner', 'build'],
    );

    final provenance = await GeneratedApiValidator.provenance(repository);
    final manifest = File(
      path.join(repository.path, 'openapi', 'generated-client.json'),
    );
    await manifest.writeAsString(
      '${const JsonEncoder.withIndent('  ').convert(provenance)}\n',
    );
  } finally {
    await temporaryOutput.delete(recursive: true);
  }

  stdout.writeln('Generated API client and provenance updated.');
}

Future<File> _generatorJar() async {
  final version = GeneratedApiValidator.generatorVersion;
  final jar = File(
    path.join(Directory.systemTemp.path, 'openapi-generator-cli-$version.jar'),
  );

  if (!await jar.exists()) {
    final request = await HttpClient().getUrl(
      Uri.https(
        'repo1.maven.org',
        '/maven2/org/openapitools/openapi-generator-cli/$version/'
            'openapi-generator-cli-$version.jar',
      ),
    );
    final response = await request.close();

    if (response.statusCode != HttpStatus.ok) {
      throw HttpException(
        'Could not download the pinned OpenAPI Generator.',
        uri: request.uri,
      );
    }

    await response.pipe(jar.openWrite());
  }

  final digest = sha256.convert(await jar.readAsBytes()).toString();

  if (digest != GeneratedApiValidator.generatorSha256) {
    throw StateError('The OpenAPI Generator checksum does not match.');
  }

  return jar;
}

Future<void> _copyDirectory(Directory source, Directory destination) async {
  await destination.create(recursive: true);

  await for (final entity in source.list(recursive: true)) {
    final relativePath = path.relative(entity.path, from: source.path);
    final targetPath = path.join(destination.path, relativePath);

    if (entity is Directory) {
      await Directory(targetPath).create(recursive: true);
    } else if (entity is File) {
      await File(targetPath).parent.create(recursive: true);
      await entity.copy(targetPath);
    }
  }
}

Future<void> _run(
  Directory workingDirectory,
  String executable,
  List<String> arguments,
) async {
  final result = await Process.run(
    executable,
    arguments,
    workingDirectory: workingDirectory.path,
  );

  if (result.exitCode != 0) {
    stderr.write(result.stdout);
    stderr.write(result.stderr);
    throw ProcessException(
      executable,
      arguments,
      'Command failed.',
      result.exitCode,
    );
  }
}
