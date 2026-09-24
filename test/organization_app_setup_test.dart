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
    final iosEntitlements = await _read(
      output,
      'ios/Runner/Runner.entitlements',
    );
    final bootstrap = await _read(output, 'lib/bootstrap.dart');
    final main = await _read(output, 'lib/main.dart');
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
    expect(androidManifest, contains('android:host="mobile.example.invalid"'));
    expect(
      iosProject,
      contains('PRODUCT_BUNDLE_IDENTIFIER = tools.ngo.mobile.golden;'),
    );
    expect(
      iosEntitlements,
      contains('<string>applinks:mobile.example.invalid</string>'),
    );
    expect(provenance['platform_ref'], platformRef);
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
