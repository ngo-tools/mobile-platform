import 'dart:convert';
import 'dart:io';

import 'package:json_schema/json_schema.dart';
import 'package:path/path.dart' as path;
import 'package:yaml/yaml.dart';

/// Result of loading and validating the versioned mobile module catalog.
final class MobileModuleCatalogResult {
  /// Creates a catalog result.
  const MobileModuleCatalogResult({
    required this.catalog,
    required this.errors,
  });

  /// Validated catalog, or `null` when a descriptor could not be normalized.
  final MobileModuleCatalog? catalog;

  /// Stable, human-readable validation errors.
  final List<String> errors;

  /// Whether every descriptor and relationship is valid.
  bool get isValid => errors.isEmpty && catalog != null;
}

/// Localized, declarative metadata for one reusable mobile module.
final class MobileModuleDescriptor {
  /// Creates an immutable module descriptor.
  MobileModuleDescriptor({
    required this.id,
    required Map<String, String> names,
    required Map<String, String> summaries,
    required this.status,
    required this.deliveryType,
    required this.package,
    required Iterable<String> requiredModules,
    required Iterable<String> apiScopes,
    required Iterable<String> features,
    required Iterable<String> permissions,
    required Iterable<String> devicePermissions,
    required Iterable<String> deepLinks,
  }) : names = Map.unmodifiable(names),
       summaries = Map.unmodifiable(summaries),
       requiredModules = List.unmodifiable(requiredModules),
       apiScopes = List.unmodifiable(apiScopes),
       features = List.unmodifiable(features),
       permissions = List.unmodifiable(permissions),
       devicePermissions = List.unmodifiable(devicePermissions),
       deepLinks = List.unmodifiable(deepLinks);

  /// Stable manifest identifier.
  final String id;

  /// German and English display names.
  final Map<String, String> names;

  /// German and English short explanations.
  final Map<String, String> summaries;

  /// Delivery lifecycle: available, planned, or deprecated.
  final String status;

  /// Whether the module is built in or delivered as a package.
  final String deliveryType;

  /// Public package name for package-delivered modules.
  final String? package;

  /// Other modules that must be selected with this module.
  final List<String> requiredModules;

  /// OAuth abilities that must be declared by the app registration.
  final List<String> apiScopes;

  /// Server features required at runtime.
  final List<String> features;

  /// Server permissions required at runtime.
  final List<String> permissions;

  /// Native permissions required by this module.
  final List<String> devicePermissions;

  /// Supported application-relative deep-link patterns.
  final List<String> deepLinks;

  Map<String, Object?> toJson() => {
    'id': id,
    'name': names,
    'summary': summaries,
    'status': status,
    'delivery': {'type': deliveryType, if (package != null) 'package': package},
    'requires': {
      'modules': requiredModules,
      'api_scopes': apiScopes,
      'features': features,
      'permissions': permissions,
      'device_permissions': devicePermissions,
    },
    'deep_links': deepLinks,
  };
}

/// Validated, deterministic source of truth for reusable mobile modules.
final class MobileModuleCatalog {
  MobileModuleCatalog._(List<MobileModuleDescriptor> modules)
    : modules = List.unmodifiable(modules),
      _byId = Map.unmodifiable({
        for (final module in modules) module.id: module,
      });

  /// Modules ordered by stable identifier.
  final List<MobileModuleDescriptor> modules;

  final Map<String, MobileModuleDescriptor> _byId;

  /// Parses descriptors and validates their schema and dependency graph.
  static MobileModuleCatalogResult load({
    required String schemaSource,
    required Map<String, String> descriptorSources,
  }) {
    final errors = <String>[];
    JsonSchema schema;

    try {
      final decodedSchema = jsonDecode(schemaSource);

      if (decodedSchema is! Map<String, Object?>) {
        return const MobileModuleCatalogResult(
          catalog: null,
          errors: ['The module schema root must be an object.'],
        );
      }

      schema = JsonSchema.create(decodedSchema);
    } on Object catch (error) {
      return MobileModuleCatalogResult(
        catalog: null,
        errors: ['Unable to parse module schema: $error'],
      );
    }

    final modules = <MobileModuleDescriptor>[];
    final sourceEntries = descriptorSources.entries.toList()
      ..sort((left, right) => left.key.compareTo(right.key));

    for (final entry in sourceEntries) {
      try {
        final normalized = _normalizeYaml(loadYaml(entry.value));

        if (normalized is! Map<String, Object?>) {
          errors.add('${entry.key}: descriptor root must be an object.');
          continue;
        }

        final schemaErrors = schema
            .validate(normalized, validateFormats: true)
            .errors;

        if (schemaErrors.isNotEmpty) {
          errors.addAll(schemaErrors.map((error) => '${entry.key}: $error'));
          continue;
        }

        final descriptor = _descriptor(normalized);
        final directoryId = path.basename(path.dirname(entry.key));

        if (directoryId != descriptor.id) {
          errors.add(
            '${entry.key}: metadata.id must match its parent directory.',
          );
        }

        if (descriptor.deliveryType == 'package' &&
            descriptor.package == null) {
          errors.add(
            '${entry.key}: package delivery requires delivery.package.',
          );
        }

        if (descriptor.deliveryType == 'built_in' &&
            descriptor.package != null) {
          errors.add(
            '${entry.key}: built-in delivery must not declare a package.',
          );
        }

        _validateSortedLists(entry.key, descriptor, errors);
        modules.add(descriptor);
      } on Object catch (error) {
        errors.add('${entry.key}: unable to parse descriptor: $error');
      }
    }

    modules.sort((left, right) => left.id.compareTo(right.id));

    if (modules.isEmpty) {
      errors.add('The module catalog must contain at least one descriptor.');
    }

    final duplicateIds = <String>{};

    for (var index = 1; index < modules.length; index += 1) {
      if (modules[index - 1].id == modules[index].id) {
        duplicateIds.add(modules[index].id);
      }
    }

    for (final duplicateId in duplicateIds.toList()..sort()) {
      errors.add('Duplicate module id: $duplicateId.');
    }

    final ids = modules.map((module) => module.id).toSet();
    final modulesById = {for (final module in modules) module.id: module};

    for (final module in modules) {
      for (final dependency in module.requiredModules) {
        final dependencyModule = modulesById[dependency];

        if (!ids.contains(dependency) || dependencyModule == null) {
          errors.add(
            'Module ${module.id} requires unknown module $dependency.',
          );
        } else if (module.status == 'available' &&
            dependencyModule.status != 'available') {
          errors.add(
            'Available module ${module.id} requires unavailable module '
            '$dependency.',
          );
        }
      }
    }

    errors.addAll(_dependencyCycleErrors(modules));
    final catalog = MobileModuleCatalog._(modules);

    return MobileModuleCatalogResult(
      catalog: catalog,
      errors: List.unmodifiable(errors),
    );
  }

  /// Loads the authoritative schema and descriptors from [repository].
  static Future<MobileModuleCatalogResult> loadFromRepository(
    Directory repository,
  ) async {
    final schema = File(
      path.join(repository.path, 'schemas', 'mobile-module.schema.json'),
    );
    final modulesDirectory = Directory(path.join(repository.path, 'modules'));
    final descriptorSources = <String, String>{};

    if (!await schema.exists() || !await modulesDirectory.exists()) {
      return const MobileModuleCatalogResult(
        catalog: null,
        errors: ['The module schema or descriptor directory is missing.'],
      );
    }

    await for (final entity in modulesDirectory.list(recursive: true)) {
      if (entity is! File || path.basename(entity.path) != 'module.yaml') {
        continue;
      }

      descriptorSources[path.relative(entity.path, from: repository.path)] =
          await entity.readAsString();
    }

    return load(
      schemaSource: await schema.readAsString(),
      descriptorSources: descriptorSources,
    );
  }

  /// Finds a module by its stable manifest identifier.
  MobileModuleDescriptor? operator [](String id) => _byId[id];

  /// Searches identifiers and localized names and summaries.
  List<MobileModuleDescriptor> search(String query) {
    final normalizedQuery = query.trim().toLowerCase();

    if (normalizedQuery.isEmpty) {
      return modules;
    }

    return List.unmodifiable(
      modules.where((module) {
        final searchable = [
          module.id,
          ...module.names.values,
          ...module.summaries.values,
        ].join('\n').toLowerCase();

        return searchable.contains(normalizedQuery);
      }),
    );
  }

  /// Validates selected modules and their declared app permissions.
  List<String> validateManifest(Map<String, Object?> manifest) {
    final errors = <String>[];
    final features = manifest['features'];
    final permissions = manifest['permissions'];

    if (features is! Map<String, Object?> ||
        permissions is! Map<String, Object?>) {
      return const ['Manifest module declarations are unavailable.'];
    }

    final selected = _stringList(features['modules']).toSet();
    final apiScopes = _stringList(permissions['apiScopes']).toSet();
    final devicePermissions = _stringList(permissions['device']).toSet();

    for (final moduleId in selected.toList()..sort()) {
      final module = _byId[moduleId];

      if (module == null) {
        errors.add('Manifest selects unknown module $moduleId.');
        continue;
      }

      for (final dependency in module.requiredModules) {
        if (!selected.contains(dependency)) {
          errors.add('Module $moduleId requires selected module $dependency.');
        }
      }

      for (final scope in module.apiScopes) {
        if (!apiScopes.contains(scope)) {
          errors.add('Module $moduleId requires API scope $scope.');
        }
      }

      for (final permission in module.devicePermissions) {
        if (!devicePermissions.contains(permission)) {
          errors.add(
            'Module $moduleId requires device permission $permission.',
          );
        }
      }
    }

    return List.unmodifiable(errors);
  }

  /// Renders a stable public JSON snapshot for all or selected modules.
  String renderSnapshot({Iterable<String>? moduleIds}) {
    final selected = _selected(moduleIds);
    final value = {
      'schema_version': 1,
      'modules': selected.map((module) => module.toJson()).toList(),
    };

    return '${const JsonEncoder.withIndent('  ').convert(value)}\n';
  }

  /// Renders deterministic human-readable documentation.
  String renderMarkdown({Iterable<String>? moduleIds}) {
    final selected = _selected(moduleIds);
    final buffer = StringBuffer()
      ..writeln('# NGO.Tools mobile modules')
      ..writeln()
      ..writeln('<!-- GENERATED FILE. DO NOT EDIT. -->')
      ..writeln()
      ..writeln(
        'This catalog describes client integration requirements. '
        'Server capabilities and policies remain authoritative.',
      );

    for (final module in selected) {
      buffer
        ..writeln()
        ..writeln('## ${module.names['en']} (`${module.id}`)')
        ..writeln()
        ..writeln('- German: ${module.names['de']}')
        ..writeln('- Status: `${module.status}`')
        ..writeln(
          '- Delivery: `${module.deliveryType}`'
          '${module.package == null ? '' : ' (`${module.package}`)'}',
        )
        ..writeln(
          '- Required modules: ${_markdownValues(module.requiredModules)}',
        )
        ..writeln('- API scopes: ${_markdownValues(module.apiScopes)}')
        ..writeln('- Features: ${_markdownValues(module.features)}')
        ..writeln('- Permissions: ${_markdownValues(module.permissions)}')
        ..writeln(
          '- Device permissions: '
          '${_markdownValues(module.devicePermissions)}',
        )
        ..writeln('- Deep links: ${_markdownValues(module.deepLinks)}')
        ..writeln()
        ..writeln(module.summaries['en'])
        ..writeln()
        ..writeln(module.summaries['de']);
    }

    return buffer.toString();
  }

  List<MobileModuleDescriptor> _selected(Iterable<String>? moduleIds) {
    if (moduleIds == null) {
      return modules;
    }

    final ids = moduleIds.toSet();
    final missing = ids.difference(_byId.keys.toSet());

    if (missing.isNotEmpty) {
      throw ArgumentError(
        'Unknown modules: ${(missing.toList()..sort()).join(', ')}',
      );
    }

    return List.unmodifiable(
      modules.where((module) => ids.contains(module.id)),
    );
  }

  static MobileModuleDescriptor _descriptor(Map<String, Object?> value) {
    final metadata = value['metadata']! as Map<String, Object?>;
    final names = metadata['name']! as Map<String, Object?>;
    final summaries = metadata['summary']! as Map<String, Object?>;
    final delivery = value['delivery']! as Map<String, Object?>;
    final requires = value['requires']! as Map<String, Object?>;

    return MobileModuleDescriptor(
      id: metadata['id']! as String,
      names: names.map((key, value) => MapEntry(key, value! as String)),
      summaries: summaries.map((key, value) => MapEntry(key, value! as String)),
      status: value['status']! as String,
      deliveryType: delivery['type']! as String,
      package: delivery['package'] as String?,
      requiredModules: _stringList(requires['modules']),
      apiScopes: _stringList(requires['apiScopes']),
      features: _stringList(requires['features']),
      permissions: _stringList(requires['permissions']),
      devicePermissions: _stringList(requires['devicePermissions']),
      deepLinks: _stringList(value['deepLinks']),
    );
  }

  static void _validateSortedLists(
    String source,
    MobileModuleDescriptor descriptor,
    List<String> errors,
  ) {
    final lists = {
      'requires.modules': descriptor.requiredModules,
      'requires.apiScopes': descriptor.apiScopes,
      'requires.features': descriptor.features,
      'requires.permissions': descriptor.permissions,
      'requires.devicePermissions': descriptor.devicePermissions,
      'deepLinks': descriptor.deepLinks,
    };

    for (final entry in lists.entries) {
      final sorted = entry.value.toList()..sort();

      if (!_listEquals(entry.value, sorted)) {
        errors.add('$source: ${entry.key} must be sorted.');
      }
    }
  }

  static List<String> _dependencyCycleErrors(
    List<MobileModuleDescriptor> modules,
  ) {
    final dependencies = {
      for (final module in modules) module.id: module.requiredModules,
    };
    final visiting = <String>{};
    final visited = <String>{};
    final errors = <String>{};

    void visit(String moduleId, List<String> trail) {
      if (visiting.contains(moduleId)) {
        final cycleStart = trail.indexOf(moduleId);
        final cycle = [...trail.sublist(cycleStart), moduleId];
        errors.add('Module dependency cycle: ${cycle.join(' -> ')}.');
        return;
      }

      if (visited.contains(moduleId)) {
        return;
      }

      visiting.add(moduleId);

      for (final dependency in dependencies[moduleId] ?? const <String>[]) {
        if (dependencies.containsKey(dependency)) {
          visit(dependency, [...trail, moduleId]);
        }
      }

      visiting.remove(moduleId);
      visited.add(moduleId);
    }

    for (final moduleId in dependencies.keys.toList()..sort()) {
      visit(moduleId, const []);
    }

    return errors.toList()..sort();
  }

  static bool _listEquals(List<String> left, List<String> right) {
    if (left.length != right.length) {
      return false;
    }

    for (var index = 0; index < left.length; index += 1) {
      if (left[index] != right[index]) {
        return false;
      }
    }

    return true;
  }

  static List<String> _stringList(Object? value) =>
      (value! as List<Object?>).cast<String>();

  static String _markdownValues(List<String> values) =>
      values.isEmpty ? 'none' : values.map((value) => '`$value`').join(', ');

  static Object? _normalizeYaml(Object? value) {
    if (value is YamlMap) {
      return <String, Object?>{
        for (final entry in value.entries)
          entry.key.toString(): _normalizeYaml(entry.value),
      };
    }

    if (value is YamlList) {
      return <Object?>[for (final item in value) _normalizeYaml(item)];
    }

    return value;
  }
}
