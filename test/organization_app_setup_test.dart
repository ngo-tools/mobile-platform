import 'dart:convert';
import 'dart:io';

import 'package:ngo_tools_mobile_platform/mobile_platform_tooling.dart';
import 'package:path/path.dart' as path;
import 'package:test/test.dart';

void main() {
  late Directory temporary;
  late Directory repository;
  late File registration;

  setUp(() async {
    repository = Directory.current.absolute;
    registration = File(
      path.join(
        repository.path,
        'example',
        'golden_app',
        'ngo-tools.mobile.yaml',
      ),
    );
    temporary = await Directory.systemTemp.createTemp(
      'organization-app-setup-',
    );
  });

  tearDown(() => temporary.delete(recursive: true));

  test('creates a standalone app from a valid registration', () async {
    final output = Directory(path.join(temporary.path, 'synthetic-app'));
    const platformRef = 'aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa';

    await OrganizationAppSetup.generate(
      repository: repository,
      registration: registration,
      output: output,
      platformRef: platformRef,
    );

    final pubspec = await _read(output, 'pubspec.yaml');
    final dartConfiguration = await _read(
      output,
      'lib/generated/mobile_app_config.dart',
    );
    final androidBuild = await _read(output, 'android/app/build.gradle.kts');
    final androidManifest = await _read(
      output,
      'android/app/src/main/AndroidManifest.xml',
    );
    final iosProject = await _read(
      output,
      'ios/Runner.xcodeproj/project.pbxproj',
    );
    final iosPodfile = await _read(output, 'ios/Podfile');
    final iosEntitlements = await _read(
      output,
      'ios/Runner/Runner.entitlements',
    );
    final bootstrap = await _read(output, 'lib/bootstrap.dart');
    final main = await _read(output, 'lib/main.dart');
    final releaseTool = await _read(output, 'tool/request_release.dart');
    final releaseWorkflow = await _read(
      output,
      '.github/workflows/release.yml',
    );
    final moduleSnapshot = await _read(output, '.ngotools/modules.json');
    final moduleDocumentation = await _read(output, 'docs/MODULES.md');
    final moduleCommand = await _read(output, 'tool/modules.dart');
    final agentInstructions = await _read(output, 'AGENTS.md');
    final provenance =
        jsonDecode(await _read(output, '.ngotools-setup.json'))
            as Map<String, dynamic>;

    expect(pubspec, contains('name: ngo_tools_synthetic_demo'));
    expect(pubspec, isNot(contains('resolution: workspace')));
    expect(pubspec, contains('ref: $platformRef'));
    expect(
      pubspec,
      contains('url: https://github.com/ngo-tools/mobile-platform.git'),
    );
    expect(bootstrap, contains("package:ngo_tools_synthetic_demo/app.dart"));
    expect(main, contains("package:ngo_tools_synthetic_demo/bootstrap.dart"));
    expect(
      releaseTool,
      contains(
        "package:ngo_tools_synthetic_demo/generated/mobile_app_config.dart",
      ),
    );
    expect(
      releaseWorkflow,
      contains('actions/checkout@11d5960a326750d5838078e36cf38b85af677262'),
    );
    expect(ReleaseWorkflowValidator.validate(releaseWorkflow), isEmpty);
    expect(moduleSnapshot, contains('"id": "contacts"'));
    expect(moduleSnapshot, contains('"id": "profile"'));
    expect(moduleDocumentation, contains('## Contacts (`contacts`)'));
    expect(moduleCommand, contains("case 'search':"));
    expect(agentInstructions, contains('tool/modules.dart search'));
    expect(
      dartConfiguration,
      contains("appId: 'mob_01J00000000000000000000000'"),
    );
    expect(dartConfiguration, isNot(contains('SyntheticMobileFixture')));
    expect(
      dartConfiguration,
      await OrganizationAppSetup.renderFormattedDartConfiguration(
        ManifestValidator.validate(
          manifestSource: await registration.readAsString(),
          schemaSource: await File(
            path.join(
              repository.path,
              'schemas',
              'ngo-tools.mobile.schema.json',
            ),
          ).readAsString(),
        ).manifest!,
      ),
    );
    expect(androidBuild, contains('applicationId = "tools.ngo.mobile.golden"'));
    expect(
      androidBuild,
      contains(
        'manifestPlaceholders["appAuthRedirectScheme"] =\n'
        '            "ngotools-01j00000000000000000000002"',
      ),
    );
    expect(androidManifest, contains('android:host="mobile.example.invalid"'));
    expect(
      iosProject,
      contains('PRODUCT_BUNDLE_IDENTIFIER = tools.ngo.mobile.golden;'),
    );
    expect(iosPodfile, contains("platform :ios, '13.0'"));
    expect(
      iosEntitlements,
      contains('<string>applinks:mobile.example.invalid</string>'),
    );
    expect(provenance['platform_ref'], platformRef);
    expect(provenance['app_id'], 'mob_01J00000000000000000000000');
    expect(provenance['app_version'], '0.1.0');
    expect(provenance['contract_version'], '2.0.0');
    expect(provenance['platform_sdk_version'], '0.1.0-dev.1');
    expect(provenance['identifiers'], {
      'android': 'tools.ngo.mobile.golden',
      'ios': 'tools.ngo.mobile.golden',
    });
    expect(provenance['distribution'], {
      'android': 'closed_testing',
      'ios': 'testflight',
    });
    expect(
      provenance['registration_sha256'],
      matches(RegExp(r'^[0-9a-f]{64}$')),
    );
  });

  test('rejects invalid refs before creating output', () async {
    final output = Directory(path.join(temporary.path, 'invalid-ref'));

    await expectLater(
      OrganizationAppSetup.generate(
        repository: repository,
        registration: registration,
        output: output,
        platformRef: 'main',
      ),
      throwsA(isA<FormatException>()),
    );
    expect(await output.exists(), isFalse);
  });

  test('keeps unselected modules discoverable in generated apps', () async {
    final source = (await registration.readAsString())
        .replaceFirst('    - contacts:read\n', '')
        .replaceFirst('    - contacts\n', '');
    final profileRegistration = File(
      path.join(temporary.path, 'profile-only.yaml'),
    );
    await profileRegistration.writeAsString(source);
    final output = Directory(path.join(temporary.path, 'profile-only'));

    await OrganizationAppSetup.generate(
      repository: repository,
      registration: profileRegistration,
      output: output,
      platformRef: 'aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa',
    );

    final snapshot = await _read(output, '.ngotools/modules.json');
    final documentation = await _read(output, 'docs/MODULES.md');
    final generatedManifest = await _read(output, 'ngo-tools.mobile.yaml');

    expect(snapshot, contains('"id": "profile"'));
    expect(snapshot, contains('"id": "contacts"'));
    expect(documentation, contains('## Profile (`profile`)'));
    expect(documentation, contains('## Contacts (`contacts`)'));
    expect(generatedManifest, isNot(contains('    - contacts\n')));
  });

  test('never overwrites an existing output directory', () async {
    final output = Directory(path.join(temporary.path, 'existing'));
    await output.create();
    final sentinel = File(path.join(output.path, 'keep.txt'));
    await sentinel.writeAsString('keep');

    await expectLater(
      OrganizationAppSetup.generate(
        repository: repository,
        registration: registration,
        output: output,
        platformRef: 'aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa',
      ),
      throwsA(isA<FileSystemException>()),
    );
    expect(await sentinel.readAsString(), 'keep');
  });

  test('rejects an invalid registration without partial output', () async {
    final invalidRegistration = File(
      path.join(temporary.path, 'invalid-registration.yaml'),
    );
    await invalidRegistration.writeAsString('kind: Unknown');
    final output = Directory(path.join(temporary.path, 'invalid-registration'));

    await expectLater(
      OrganizationAppSetup.generate(
        repository: repository,
        registration: invalidRegistration,
        output: output,
        platformRef: 'aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa',
      ),
      throwsA(isA<FormatException>()),
    );
    expect(await output.exists(), isFalse);
  });

  test('rejects credential material before creating output', () async {
    final sensitiveRegistration = File(
      path.join(temporary.path, 'sensitive-registration.yaml'),
    );
    final token = ['ghp', 'abcdefghijklmnopqrstuvwxyz123456'].join('_');
    await sensitiveRegistration.writeAsString(
      '${await registration.readAsString()}\n# $token',
    );
    final output = Directory(path.join(temporary.path, 'sensitive-output'));

    await expectLater(
      OrganizationAppSetup.generate(
        repository: repository,
        registration: sensitiveRegistration,
        output: output,
        platformRef: 'aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa',
      ),
      throwsA(isA<FormatException>()),
    );
    expect(await output.exists(), isFalse);
  });
}

Future<String> _read(Directory directory, String relativePath) =>
    File(path.join(directory.path, relativePath)).readAsString();
