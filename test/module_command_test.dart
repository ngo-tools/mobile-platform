import 'dart:convert';
import 'dart:io';

import 'package:path/path.dart' as path;
import 'package:test/test.dart';

void main() {
  late Directory temporary;
  late String command;

  setUp(() async {
    temporary = await Directory.systemTemp.createTemp('module-command-');
    command = path.join(
      Directory.current.absolute.path,
      'tool',
      'modules.dart',
    );
    await Directory(
      path.join(temporary.path, '.ngotools'),
    ).create(recursive: true);
    await File(
      path.join(temporary.path, '.ngotools', 'modules.json'),
    ).writeAsString(
      await File(
        path.join(Directory.current.absolute.path, '.ngotools', 'modules.json'),
      ).readAsString(),
    );
  });

  tearDown(() => temporary.delete(recursive: true));

  test('lists, searches, and explains local catalog modules', () async {
    final list = await _run(temporary, command, ['list']);
    final search = await _run(temporary, command, ['search', 'Kontakte']);
    final explain = await _run(temporary, command, ['explain', 'profile']);

    expect(list.exitCode, 0);
    expect(list.stdout, contains('contacts\tavailable\tContacts'));
    expect(search.exitCode, 0);
    expect(search.stdout, 'contacts\tavailable\tContacts\n');
    expect(explain.exitCode, 0);
    expect(explain.stdout, contains('API scopes: profile:read'));
  });

  test('adds available modules and scopes idempotently', () async {
    final manifest = File(path.join(temporary.path, 'ngo-tools.mobile.yaml'));
    await manifest.writeAsString('''
permissions:
  apiScopes: []
  device: []
features:
  modules: []
''');

    final first = await _run(temporary, command, ['add', 'profile']);
    final afterFirst = await manifest.readAsString();
    final second = await _run(temporary, command, ['add', 'profile']);

    expect(first.exitCode, 0);
    expect(afterFirst, contains('    - profile:read'));
    expect(afterFirst, contains('    - profile'));
    expect(second.exitCode, 0);
    expect(second.stdout, contains('already configured'));
    expect(await manifest.readAsString(), afterFirst);
  });

  test('adds the available contacts module with both scopes', () async {
    final manifest = File(path.join(temporary.path, 'ngo-tools.mobile.yaml'));
    const source = '''
permissions:
  apiScopes:
    - profile:read
  device: []
features:
  modules:
    - profile
''';
    await manifest.writeAsString(source);

    final result = await _run(temporary, command, ['add', 'contacts']);
    final generated = await manifest.readAsString();

    expect(result.exitCode, 0);
    expect(generated, contains('    - contacts:read'));
    expect(generated, contains('    - contacts:write'));
    expect(generated, contains('    - contacts'));
  });

  test('rejects malformed snapshots', () async {
    await File(
      path.join(temporary.path, '.ngotools', 'modules.json'),
    ).writeAsString(jsonEncode({'schema_version': 2, 'modules': <Object?>[]}));

    final result = await _run(temporary, command, ['list']);

    expect(result.exitCode, 1);
    expect(result.stderr, contains('Unsupported module catalog snapshot'));
  });
}

Future<ProcessResult> _run(
  Directory directory,
  String command,
  List<String> arguments,
) => Process.run('dart', [
  'run',
  command,
  ...arguments,
], workingDirectory: directory.path);
