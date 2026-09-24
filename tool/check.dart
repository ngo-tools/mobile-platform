import 'dart:convert';
import 'dart:io';

import 'package:ngo_tools_mobile_platform/mobile_platform_tooling.dart';
import 'package:path/path.dart' as path;
import 'package:yaml/yaml.dart';

Future<void> main() async {
  final repository = Directory.current.absolute;
  final manifestSource = await _read(
    repository,
    'example/golden_app/ngo-tools.mobile.yaml',
  );
  final schemaSource = await _read(
    repository,
    'schemas/ngo-tools.mobile.schema.json',
  );
  final manifestResult = ManifestValidator.validate(
    manifestSource: manifestSource,
    schemaSource: schemaSource,
  );
  final errors = <String>[
    ...manifestResult.errors.map((error) => 'Manifest: $error'),
  ];

  errors.addAll(
    (await _validateArchitecture(
      repository,
    )).map((error) => 'Architecture: $error'),
  );
  errors.addAll(
    (await _validateModuleCatalog(
      repository,
      manifestResult.manifest,
    )).map((error) => 'Module catalog: $error'),
  );
  errors.addAll(
    (await GeneratedApiValidator.validate(
      repository,
    )).map((error) => 'Generated API: $error'),
  );
  errors.addAll(
    ReleaseWorkflowValidator.validate(
      await _read(
        repository,
        'example/golden_app/.github/workflows/release.yml',
      ),
    ).map((error) => 'Release workflow: $error'),
  );

  final manifest = manifestResult.manifest;

  if (manifest != null) {
    final expectedConfiguration =
        await OrganizationAppSetup.renderFormattedDartConfiguration(manifest);
    final committedConfiguration = await _read(
      repository,
      'example/golden_app/lib/generated/mobile_app_config.dart',
    );

    if (committedConfiguration != expectedConfiguration) {
      errors.add(
        'Generated app configuration: regenerate it from the manifest.',
      );
    }

    errors.addAll(
      NativeConfigurationValidator.validate(
        manifest: manifest,
        androidBuildFile: await _read(
          repository,
          'example/golden_app/android/app/build.gradle.kts',
        ),
        androidManifest: await _read(
          repository,
          'example/golden_app/android/app/src/main/AndroidManifest.xml',
        ),
        iosProjectFile: await _read(
          repository,
          'example/golden_app/ios/Runner.xcodeproj/project.pbxproj',
        ),
        iosInfoPlist: await _read(
          repository,
          'example/golden_app/ios/Runner/Info.plist',
        ),
        iosEntitlements: await _read(
          repository,
          'example/golden_app/ios/Runner/Runner.entitlements',
        ),
      ).map((error) => 'Native configuration: $error'),
    );
  }

  errors.addAll(
    SecretScanner.validate(
      await _repositoryTextFiles(repository),
    ).map((error) => 'Secret scan: $error'),
  );

  if (errors.isNotEmpty) {
    stderr.writeln('Platform preflight failed:');

    for (final error in errors) {
      stderr.writeln('- $error');
    }

    exitCode = 1;

    return;
  }

  await _run(repository, 'dart', [
    'format',
    '--output=none',
    '--set-exit-if-changed',
    '.',
  ]);
  await _run(repository, 'flutter', ['analyze']);

  final testFiles = await _testFiles(repository);

  if (testFiles.isNotEmpty) {
    await _run(repository, 'flutter', ['test', ...testFiles]);
  }

  stdout.writeln('Platform gate passed.');
}

Future<List<String>> _validateArchitecture(Directory repository) async {
  final packageDependencies = <String, Set<String>>{};
  final packageDirectory = Directory(path.join(repository.path, 'packages'));
  final packages = await packageDirectory
      .list()
      .where((entity) => entity is Directory)
      .cast<Directory>()
      .toList();

  packages.sort((left, right) => left.path.compareTo(right.path));

  for (final package in packages) {
    final pubspec = loadYaml(
      await File(path.join(package.path, 'pubspec.yaml')).readAsString(),
    );

    if (pubspec is! YamlMap) {
      return ['${path.basename(package.path)} has an invalid pubspec.'];
    }

    final name = pubspec['name'];
    final dependencies = pubspec['dependencies'];

    if (name is! String) {
      return ['${path.basename(package.path)} has no package name.'];
    }

    packageDependencies[name] = dependencies is YamlMap
        ? dependencies.keys.map((dependency) => dependency.toString()).toSet()
        : <String>{};
  }

  final errors = ArchitectureValidator.validate(packageDependencies);
  final sources = <String, String>{};

  for (final sourceRoot in [
    Directory(path.join(repository.path, 'packages')),
    Directory(path.join(repository.path, 'example', 'golden_app', 'lib')),
  ]) {
    await for (final entity in sourceRoot.list(recursive: true)) {
      if (entity is! File ||
          !entity.path.endsWith('.dart') ||
          entity.path.split(path.separator).contains('test')) {
        continue;
      }

      final relativePath = path.relative(entity.path, from: repository.path);
      sources[relativePath] = await entity.readAsString();
    }
  }

  errors.addAll(ArchitectureValidator.validateSourceBoundaries(sources));

  return errors;
}

Future<List<String>> _validateModuleCatalog(
  Directory repository,
  Map<String, Object?>? manifest,
) async {
  final result = await MobileModuleCatalog.loadFromRepository(repository);
  final errors = result.errors.toList(growable: true);
  final catalog = result.catalog;

  if (catalog == null || manifest == null) {
    return errors;
  }

  final manifestErrors = catalog.validateManifest(manifest);
  errors.addAll(manifestErrors);

  if (manifestErrors.isNotEmpty) {
    return errors;
  }

  final expectedFiles = <String, String>{
    '.ngotools/modules.json': catalog.renderSnapshot(),
    'docs/MODULES.md': catalog.renderMarkdown(),
    'example/golden_app/.ngotools/modules.json': catalog.renderSnapshot(),
    'example/golden_app/docs/MODULES.md': catalog.renderMarkdown(),
  };

  for (final entry in expectedFiles.entries) {
    final file = File(path.join(repository.path, entry.key));

    if (!await file.exists() || await file.readAsString() != entry.value) {
      errors.add('${entry.key} must be regenerated.');
    }
  }

  final command = await _read(repository, 'tool/modules.dart');
  final generatedCommand = await _read(
    repository,
    'example/golden_app/tool/modules.dart',
  );

  if (command != generatedCommand) {
    errors.add('The generated app module command must be regenerated.');
  }

  return errors;
}

Future<Map<String, String>> _repositoryTextFiles(Directory repository) async {
  final result = await Process.run('git', [
    'ls-files',
    '--cached',
    '--others',
    '--exclude-standard',
    '-z',
  ], workingDirectory: repository.path);

  if (result.exitCode != 0) {
    throw ProcessException(
      'git',
      ['ls-files'],
      result.stderr.toString(),
      result.exitCode,
    );
  }

  final files = <String, String>{};
  final relativePaths = result.stdout
      .toString()
      .split('\u0000')
      .where((filePath) => filePath.isNotEmpty);

  for (final relativePath in relativePaths) {
    final file = File(path.join(repository.path, relativePath));

    if (!await file.exists()) {
      continue;
    }

    final bytes = await file.readAsBytes();
    files[relativePath] = bytes.length <= 1024 * 1024
        ? utf8.decode(bytes, allowMalformed: true)
        : '';
  }

  return files;
}

Future<List<String>> _testFiles(Directory repository) async {
  final files = <String>[];

  await for (final entity in repository.list(recursive: true)) {
    if (entity is! File || !entity.path.endsWith('_test.dart')) {
      continue;
    }

    final relativePath = path.relative(entity.path, from: repository.path);

    if (path
        .split(relativePath)
        .any((segment) => segment == '.dart_tool' || segment == 'build')) {
      continue;
    }

    files.add(relativePath);
  }

  files.sort();

  return files;
}

Future<String> _read(Directory repository, String relativePath) =>
    File(path.join(repository.path, relativePath)).readAsString();

Future<void> _run(
  Directory repository,
  String executable,
  List<String> arguments,
) async {
  stdout.writeln('> $executable ${arguments.join(' ')}');
  final process = await Process.start(
    executable,
    arguments,
    workingDirectory: repository.path,
    mode: ProcessStartMode.inheritStdio,
  );
  final processExitCode = await process.exitCode;

  if (processExitCode != 0) {
    exitCode = processExitCode;
    exit(processExitCode);
  }
}
