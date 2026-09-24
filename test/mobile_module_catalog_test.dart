import 'dart:io';

import 'package:ngo_tools_mobile_platform/mobile_platform_tooling.dart';
import 'package:path/path.dart' as path;
import 'package:test/test.dart';

void main() {
  late Directory repository;
  late MobileModuleCatalog catalog;

  setUpAll(() async {
    repository = Directory.current.absolute;
    final result = await MobileModuleCatalog.loadFromRepository(repository);

    expect(result.errors, isEmpty);
    catalog = result.catalog!;
  });

  test('loads descriptors in deterministic identifier order', () {
    expect(catalog.modules.map((module) => module.id), ['contacts', 'profile']);
    expect(catalog['contacts']?.status, 'planned');
    expect(catalog['profile']?.status, 'available');
  });

  test('rejects an empty catalog', () {
    final schema = File(
      path.join(repository.path, 'schemas', 'mobile-module.schema.json'),
    ).readAsStringSync();
    final result = MobileModuleCatalog.load(
      schemaSource: schema,
      descriptorSources: const {},
    );

    expect(
      result.errors,
      contains('The module catalog must contain at least one descriptor.'),
    );
  });

  test('searches identifiers and both localized texts', () {
    expect(catalog.search('kontakte').single.id, 'contacts');
    expect(catalog.search('sanitized').single.id, 'profile');
    expect(catalog.search('CONTACT').single.id, 'contacts');
  });

  test('validates dependencies and required API scopes in manifests', () {
    final errors = catalog.validateManifest({
      'features': {
        'modules': ['contacts'],
      },
      'permissions': {
        'apiScopes': ['profile:read'],
        'device': <Object?>[],
      },
    });

    expect(errors, [
      'Module contacts requires selected module profile.',
      'Module contacts requires API scope contacts:read.',
    ]);
  });

  test('rejects directory mismatches, missing dependencies, and cycles', () {
    final schema = File(
      path.join(repository.path, 'schemas', 'mobile-module.schema.json'),
    ).readAsStringSync();
    final profile = File(
      path.join(repository.path, 'modules', 'profile', 'module.yaml'),
    ).readAsStringSync();
    final cyclic = profile
        .replaceFirst('id: profile', 'id: cycle')
        .replaceFirst('  modules: []', '  modules:\n    - cycle');
    final result = MobileModuleCatalog.load(
      schemaSource: schema,
      descriptorSources: {'modules/wrong/module.yaml': cyclic},
    );

    expect(
      result.errors,
      containsAll([
        'modules/wrong/module.yaml: metadata.id must match its parent directory.',
        'Module dependency cycle: cycle -> cycle.',
      ]),
    );
  });

  test('available modules cannot depend on unavailable modules', () {
    final schema = File(
      path.join(repository.path, 'schemas', 'mobile-module.schema.json'),
    ).readAsStringSync();
    final contacts = File(
      path.join(repository.path, 'modules', 'contacts', 'module.yaml'),
    ).readAsStringSync().replaceFirst('status: planned', 'status: available');
    final profile = File(
      path.join(repository.path, 'modules', 'profile', 'module.yaml'),
    ).readAsStringSync().replaceFirst('status: available', 'status: planned');
    final result = MobileModuleCatalog.load(
      schemaSource: schema,
      descriptorSources: {
        'modules/contacts/module.yaml': contacts,
        'modules/profile/module.yaml': profile,
      },
    );

    expect(
      result.errors,
      contains(
        'Available module contacts requires unavailable module profile.',
      ),
    );
  });

  test('renders stable snapshots independently of source order', () async {
    final schema = await File(
      path.join(repository.path, 'schemas', 'mobile-module.schema.json'),
    ).readAsString();
    final contacts = await File(
      path.join(repository.path, 'modules', 'contacts', 'module.yaml'),
    ).readAsString();
    final profile = await File(
      path.join(repository.path, 'modules', 'profile', 'module.yaml'),
    ).readAsString();
    final reversed = MobileModuleCatalog.load(
      schemaSource: schema,
      descriptorSources: {
        'modules/profile/module.yaml': profile,
        'modules/contacts/module.yaml': contacts,
      },
    ).catalog!;

    expect(reversed.renderSnapshot(), catalog.renderSnapshot());
    expect(
      catalog.renderMarkdown(moduleIds: const ['profile']),
      contains('## Profile (`profile`)'),
    );
    expect(
      catalog.renderMarkdown(moduleIds: const ['profile']),
      isNot(contains('## Contacts')),
    );
  });
}
