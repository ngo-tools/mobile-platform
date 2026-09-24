import 'dart:io';

import 'package:ngo_tools_mobile_platform/mobile_platform_tooling.dart';
import 'package:path/path.dart' as path;

Future<void> main() async {
  final repository = Directory.current.absolute;
  final result = await MobileModuleCatalog.loadFromRepository(repository);

  if (!result.isValid) {
    stderr.writeln('Module catalog generation failed:');

    for (final error in result.errors) {
      stderr.writeln('- $error');
    }

    exitCode = 1;
    return;
  }

  final catalog = result.catalog!;
  await _write(repository, '.ngotools/modules.json', catalog.renderSnapshot());
  await _write(repository, 'docs/MODULES.md', catalog.renderMarkdown());
  await _write(
    repository,
    'example/golden_app/.ngotools/modules.json',
    catalog.renderSnapshot(),
  );
  await _write(
    repository,
    'example/golden_app/docs/MODULES.md',
    catalog.renderMarkdown(),
  );

  final commandSource = await File(
    path.join(repository.path, 'tool', 'modules.dart'),
  ).readAsString();
  await _write(
    repository,
    'example/golden_app/tool/modules.dart',
    commandSource,
  );
  stdout.writeln('Module catalog generated.');
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
