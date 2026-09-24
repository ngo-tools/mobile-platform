import 'dart:convert';
import 'dart:io';

Future<void> main(List<String> arguments) async {
  try {
    final command = _Command.parse(arguments);

    if (command == null) {
      _usage();
      exitCode = 64;
      return;
    }

    final snapshot = await _CatalogSnapshot.load(
      File('.ngotools/modules.json'),
    );

    switch (command.name) {
      case 'list':
        for (final module in snapshot.modules) {
          stdout.writeln(
            '${module.id}\t${module.status}\t${module.name['en']}',
          );
        }
      case 'search':
        final matches = snapshot.search(command.value!);

        for (final module in matches) {
          stdout.writeln(
            '${module.id}\t${module.status}\t${module.name['en']}',
          );
        }
      case 'explain':
        final module = snapshot[command.value!];

        if (module == null) {
          throw FormatException('Unknown module: ${command.value}.');
        }

        stdout.write(module.explanation);
      case 'add':
        final module = snapshot[command.value!];

        if (module == null) {
          throw FormatException('Unknown module: ${command.value}.');
        }

        if (module.status != 'available') {
          throw StateError(
            'Module ${module.id} is ${module.status} and cannot be added.',
          );
        }

        final manifest = File(command.manifest ?? 'ngo-tools.mobile.yaml');
        final selected = snapshot.dependenciesFor(module.id);
        final modules = [for (final id in selected) snapshot[id]!];
        final editor = _ManifestModuleEditor(await manifest.readAsString());
        final updated = editor.add(
          modules: modules.map((item) => item.id),
          apiScopes: modules.expand((item) => item.apiScopes),
          devicePermissions: modules.expand((item) => item.devicePermissions),
        );

        if (updated == editor.source) {
          stdout.writeln('Module ${module.id} is already configured.');
          return;
        }

        await _writeAtomically(manifest, updated);
        stdout.writeln('Added module ${module.id} to ${manifest.path}.');
    }
  } on Object catch (error) {
    stderr.writeln('Module command failed: $error');
    exitCode = 1;
  }
}

void _usage() {
  stderr.writeln('Usage:');
  stderr.writeln('  dart run tool/modules.dart list');
  stderr.writeln('  dart run tool/modules.dart search <query>');
  stderr.writeln('  dart run tool/modules.dart explain <module>');
  stderr.writeln(
    '  dart run tool/modules.dart add <module> '
    '[--manifest=ngo-tools.mobile.yaml]',
  );
}

final class _Command {
  const _Command({required this.name, this.value, this.manifest});

  final String name;
  final String? value;
  final String? manifest;

  static _Command? parse(List<String> arguments) {
    if (arguments.length == 1 && arguments.first == 'list') {
      return const _Command(name: 'list');
    }

    if (arguments.length == 2 &&
        const {'search', 'explain'}.contains(arguments.first) &&
        arguments[1].trim().isNotEmpty) {
      return _Command(name: arguments.first, value: arguments[1]);
    }

    if (arguments.length >= 2 && arguments.first == 'add') {
      String? manifest;

      for (final option in arguments.skip(2)) {
        if (!option.startsWith('--manifest=') || manifest != null) {
          return null;
        }

        manifest = option.substring('--manifest='.length);

        if (manifest.isEmpty) {
          return null;
        }
      }

      return _Command(name: 'add', value: arguments[1], manifest: manifest);
    }

    return null;
  }
}

final class _CatalogSnapshot {
  _CatalogSnapshot(List<_Module> modules)
    : modules = List.unmodifiable(modules),
      _byId = Map.unmodifiable({
        for (final module in modules) module.id: module,
      });

  final List<_Module> modules;
  final Map<String, _Module> _byId;

  _Module? operator [](String id) => _byId[id];

  static Future<_CatalogSnapshot> load(File file) async {
    final decoded = jsonDecode(await file.readAsString());

    if (decoded is! Map<String, Object?> || decoded['schema_version'] != 1) {
      throw const FormatException('Unsupported module catalog snapshot.');
    }

    final values = decoded['modules'];

    if (values is! List<Object?>) {
      throw const FormatException('Module catalog has no modules.');
    }

    final modules = values.map(_Module.fromJson).toList(growable: false)
      ..sort((left, right) => left.id.compareTo(right.id));

    if (modules.map((module) => module.id).toSet().length != modules.length) {
      throw const FormatException('Module catalog contains duplicate IDs.');
    }

    return _CatalogSnapshot(modules);
  }

  List<_Module> search(String query) {
    final normalized = query.trim().toLowerCase();

    return modules
        .where((module) => module.searchable.contains(normalized))
        .toList(growable: false);
  }

  List<String> dependenciesFor(String moduleId) {
    final result = <String>[];
    final visiting = <String>{};
    final visited = <String>{};

    void visit(String id) {
      if (!visiting.add(id)) {
        throw StateError('Module dependency cycle includes $id.');
      }

      if (visited.contains(id)) {
        visiting.remove(id);
        return;
      }

      final module = _byId[id];

      if (module == null) {
        throw FormatException('Unknown module dependency: $id.');
      }

      for (final dependency in module.requiredModules) {
        visit(dependency);
      }

      visiting.remove(id);
      visited.add(id);
      result.add(id);
    }

    visit(moduleId);
    return result;
  }
}

final class _Module {
  _Module({
    required this.id,
    required this.name,
    required this.summary,
    required this.status,
    required this.delivery,
    required this.requiredModules,
    required this.apiScopes,
    required this.features,
    required this.permissions,
    required this.devicePermissions,
    required this.deepLinks,
  });

  final String id;
  final Map<String, String> name;
  final Map<String, String> summary;
  final String status;
  final String delivery;
  final List<String> requiredModules;
  final List<String> apiScopes;
  final List<String> features;
  final List<String> permissions;
  final List<String> devicePermissions;
  final List<String> deepLinks;

  String get searchable =>
      [id, ...name.values, ...summary.values].join('\n').toLowerCase();

  String get explanation {
    final buffer = StringBuffer()
      ..writeln('${name['en']} ($id)')
      ..writeln('Status: $status')
      ..writeln('Delivery: $delivery')
      ..writeln('Required modules: ${_values(requiredModules)}')
      ..writeln('API scopes: ${_values(apiScopes)}')
      ..writeln('Features: ${_values(features)}')
      ..writeln('Permissions: ${_values(permissions)}')
      ..writeln('Device permissions: ${_values(devicePermissions)}')
      ..writeln('Deep links: ${_values(deepLinks)}')
      ..writeln()
      ..writeln(summary['en'])
      ..writeln(summary['de']);

    return buffer.toString();
  }

  static _Module fromJson(Object? value) {
    if (value is! Map<String, Object?>) {
      throw const FormatException('Invalid module catalog entry.');
    }

    final delivery = _map(value, 'delivery');
    final requires = _map(value, 'requires');

    return _Module(
      id: _string(value, 'id'),
      name: _localized(value, 'name'),
      summary: _localized(value, 'summary'),
      status: _string(value, 'status'),
      delivery: delivery['package'] == null
          ? _string(delivery, 'type')
          : '${_string(delivery, 'type')} (${_string(delivery, 'package')})',
      requiredModules: _strings(requires, 'modules'),
      apiScopes: _strings(requires, 'api_scopes'),
      features: _strings(requires, 'features'),
      permissions: _strings(requires, 'permissions'),
      devicePermissions: _strings(requires, 'device_permissions'),
      deepLinks: _strings(value, 'deep_links'),
    );
  }

  static Map<String, Object?> _map(Map<String, Object?> value, String key) {
    final result = value[key];

    if (result is! Map<String, Object?>) {
      throw FormatException('Module field $key must be an object.');
    }

    return result;
  }

  static Map<String, String> _localized(
    Map<String, Object?> value,
    String key,
  ) {
    final result = _map(value, key);

    return {'de': _string(result, 'de'), 'en': _string(result, 'en')};
  }

  static String _string(Map<String, Object?> value, String key) {
    final result = value[key];

    if (result is! String || result.isEmpty) {
      throw FormatException('Module field $key must be a string.');
    }

    return result;
  }

  static List<String> _strings(Map<String, Object?> value, String key) {
    final result = value[key];

    if (result is! List<Object?> || !result.every((item) => item is String)) {
      throw FormatException('Module field $key must be a string list.');
    }

    return result.cast<String>();
  }

  static String _values(List<String> values) =>
      values.isEmpty ? 'none' : values.join(', ');
}

final class _ManifestModuleEditor {
  _ManifestModuleEditor(this.source);

  final String source;

  String add({
    required Iterable<String> modules,
    required Iterable<String> apiScopes,
    required Iterable<String> devicePermissions,
  }) {
    var lines = source.split('\n');
    lines = _mergeList(lines, 'features', 'modules', modules);
    lines = _mergeList(lines, 'permissions', 'apiScopes', apiScopes);
    lines = _mergeList(lines, 'permissions', 'device', devicePermissions);

    final result = lines.join('\n');
    return source.endsWith('\n') && !result.endsWith('\n')
        ? '$result\n'
        : result;
  }

  static List<String> _mergeList(
    List<String> lines,
    String parent,
    String key,
    Iterable<String> additions,
  ) {
    final parentIndex = lines.indexOf('$parent:');

    if (parentIndex < 0) {
      throw FormatException('Manifest has no $parent section.');
    }

    var childIndex = -1;

    for (var index = parentIndex + 1; index < lines.length; index += 1) {
      final line = lines[index];

      if (line.isNotEmpty && !line.startsWith(' ')) {
        break;
      }

      if (line == '  $key:' || line == '  $key: []') {
        childIndex = index;
        break;
      }
    }

    if (childIndex < 0) {
      throw FormatException('Manifest has no $parent.$key field.');
    }

    var endIndex = childIndex + 1;
    final existing = <String>{};

    while (endIndex < lines.length &&
        (lines[endIndex].isEmpty || lines[endIndex].startsWith('    '))) {
      final line = lines[endIndex];

      if (line.startsWith('    - ')) {
        existing.add(line.substring('    - '.length));
      } else if (line.isNotEmpty) {
        throw FormatException(
          'Manifest field $parent.$key must be a scalar list.',
        );
      }

      endIndex += 1;
    }

    existing.addAll(additions);
    final values = existing.toList()..sort();
    final replacement = values.isEmpty
        ? ['  $key: []']
        : ['  $key:', ...values.map((value) => '    - $value')];

    return [...lines.take(childIndex), ...replacement, ...lines.skip(endIndex)];
  }
}

Future<void> _writeAtomically(File target, String contents) async {
  final temporary = File(
    '${target.path}.ngotools-$pid-${DateTime.now().microsecondsSinceEpoch}',
  );

  try {
    await temporary.writeAsString(contents, flush: true);
    await temporary.rename(target.path);
  } finally {
    if (await temporary.exists()) {
      await temporary.delete();
    }
  }
}
