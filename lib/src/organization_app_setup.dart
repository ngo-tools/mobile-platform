import 'dart:convert';
import 'dart:io';

import 'package:crypto/crypto.dart';
import 'package:path/path.dart' as path;
import 'package:yaml/yaml.dart';

import 'manifest_validator.dart';
import 'mobile_module_catalog.dart';
import 'native_configuration_validator.dart';
import 'secret_scanner.dart';

/// Creates a standalone organization app from a public registration manifest.
abstract final class OrganizationAppSetup {
  /// Generates an app without overwriting an existing target.
  static Future<void> generate({
    required Directory repository,
    required File registration,
    required Directory output,
    required String platformRef,
  }) async {
    if (!RegExp(r'^[0-9a-f]{40}$').hasMatch(platformRef)) {
      throw const FormatException(
        'platform-ref must be a full lowercase Git commit SHA.',
      );
    }

    if (await FileSystemEntity.type(output.path, followLinks: false) !=
        FileSystemEntityType.notFound) {
      throw FileSystemException(
        'The output directory already exists.',
        output.path,
      );
    }

    final registrationSource = await registration.readAsString();
    final secretErrors = SecretScanner.validate({
      'ngo-tools.mobile.yaml': registrationSource,
    });

    if (secretErrors.isNotEmpty) {
      throw const FormatException(
        'The registration contains possible credential material.',
      );
    }

    final schemaSource = await File(
      path.join(repository.path, 'schemas', 'ngo-tools.mobile.schema.json'),
    ).readAsString();
    final validation = ManifestValidator.validate(
      manifestSource: registrationSource,
      schemaSource: schemaSource,
    );

    if (!validation.isValid || validation.manifest == null) {
      throw FormatException(
        'Invalid registration:\n${validation.errors.join('\n')}',
      );
    }

    final manifest = validation.manifest!;
    final identifiers = _map(manifest, 'identifiers');
    final platformVersion = _platformVersion(
      await File(path.join(repository.path, 'pubspec.yaml')).readAsString(),
    );

    if (identifiers['android'] is! Map<String, Object?> ||
        identifiers['ios'] is! Map<String, Object?>) {
      throw const FormatException(
        'The Golden App template requires both Android and iOS identifiers.',
      );
    }

    final androidIdentifiers = identifiers['android']! as Map<String, Object?>;
    final androidIdentifierPattern = RegExp(
      r'^[A-Za-z][A-Za-z0-9_]*(?:\.[A-Za-z][A-Za-z0-9_]*)+$',
    );

    if (androidIdentifiers.values.whereType<String>().any(
      (identifier) => !androidIdentifierPattern.hasMatch(identifier),
    )) {
      throw const FormatException(
        'Android identifiers must also be valid Java package names.',
      );
    }

    final parent = output.parent;
    await parent.create(recursive: true);
    final temporary = await parent.createTemp('.ngotools-mobile-setup-');

    try {
      await _copyTemplate(
        Directory(path.join(repository.path, 'example', 'golden_app')),
        temporary,
      );
      await _configure(
        repository: repository,
        directory: temporary,
        manifest: manifest,
        registrationSource: registrationSource,
        platformRef: platformRef,
        platformVersion: platformVersion,
      );

      if (await FileSystemEntity.type(output.path, followLinks: false) !=
          FileSystemEntityType.notFound) {
        throw FileSystemException(
          'The output directory was created during setup.',
          output.path,
        );
      }

      await temporary.rename(output.path);
    } on Object {
      if (await temporary.exists()) {
        await temporary.delete(recursive: true);
      }

      rethrow;
    }
  }

  /// Renders the immutable public Dart configuration for [manifest].
  static String renderDartConfiguration(Map<String, Object?> manifest) {
    final metadata = _map(manifest, 'metadata');
    final owner = _map(manifest, 'owner');
    final localization = _map(manifest, 'localization');
    final backend = _map(manifest, 'backend');
    final environments = _map(backend, 'environments');
    final locales = _strings(localization, 'locales');
    final buffer = StringBuffer()
      ..writeln('// GENERATED FILE. DO NOT EDIT.')
      ..writeln()
      ..writeln(
        "import 'package:ngotools_mobile_core/ngotools_mobile_core.dart';",
      )
      ..writeln()
      ..writeln('/// Public registration-bound application configuration.')
      ..writeln('final mobileAppConfiguration = MobileAppConfiguration(')
      ..writeln("  appId: ${_literal(_string(metadata, 'id'))},")
      ..writeln("  tenant: ${_literal(_string(owner, 'tenant'))},")
      ..writeln(
        "  defaultLocale: ${_literal(_string(localization, 'defaultLocale'))},",
      )
      ..writeln('  locales: [${locales.map(_literal).join(', ')}],')
      ..writeln('  environments: {');

    for (final name in const ['development', 'staging', 'production']) {
      final environment = _map(environments, name);
      final oidc = _map(environment, 'oidc');
      final scopes = _strings(oidc, 'scopes');
      buffer
        ..writeln(
          '    MobileEnvironment.$name: MobileEnvironmentConfiguration(',
        )
        ..writeln('      environment: MobileEnvironment.$name,')
        ..writeln("      id: ${_literal(_string(environment, 'id'))},")
        ..writeln(
          '      apiBaseUrl: Uri.parse('
          '${_literal(_string(environment, 'apiBaseUrl'))}),',
        )
        ..writeln(
          '      configRevision: '
          '${_literal(_string(environment, 'configRevision'))},',
        )
        ..writeln(
          '      attestationMode: MobileAttestationMode.'
          '${_string(environment, 'attestationMode')},',
        )
        ..writeln('      oidc: MobileOidcConfiguration(')
        ..writeln(
          '        issuer: Uri.parse(${_literal(_string(oidc, 'issuer'))}),',
        )
        ..writeln("        clientId: ${_literal(_string(oidc, 'clientId'))},")
        ..writeln(
          '        redirectUri: Uri.parse('
          '${_literal(_string(oidc, 'redirectUri'))}),',
        )
        ..writeln('        scopes: [${scopes.map(_literal).join(', ')}],')
        ..writeln('      ),')
        ..writeln('    ),');
    }

    buffer
      ..writeln('  },')
      ..writeln(');');

    return buffer.toString();
  }

  /// Renders and formats the generated Dart configuration deterministically.
  static Future<String> renderFormattedDartConfiguration(
    Map<String, Object?> manifest,
  ) async {
    final temporary = await Directory.systemTemp.createTemp(
      'ngotools-mobile-config-',
    );
    final file = File(path.join(temporary.path, 'mobile_app_config.dart'));

    try {
      await file.writeAsString(renderDartConfiguration(manifest));
      final result = await Process.run('dart', ['format', file.path]);

      if (result.exitCode != 0) {
        throw StateError(
          'Could not format generated Dart configuration: ${result.stderr}',
        );
      }

      return file.readAsString();
    } finally {
      await temporary.delete(recursive: true);
    }
  }

  static Future<void> _configure({
    required Directory repository,
    required Directory directory,
    required Map<String, Object?> manifest,
    required String registrationSource,
    required String platformRef,
    required String platformVersion,
  }) async {
    final metadata = _map(manifest, 'metadata');
    final owner = _map(manifest, 'owner');
    final identifiers = _map(manifest, 'identifiers');
    final androidIdentifiers = _map(identifiers, 'android');
    final iosIdentifiers = _map(identifiers, 'ios');
    final backend = _map(manifest, 'backend');
    final environments = _map(backend, 'environments');
    final deepLinks = _strings(_map(manifest, 'deepLinks'), 'hosts');
    final devicePermissions = _strings(_map(manifest, 'permissions'), 'device');
    final appName = _string(metadata, 'name');
    final tenant = _string(owner, 'tenant');
    final packageName = 'ngo_tools_${tenant.replaceAll('-', '_')}';
    final androidId = _string(androidIdentifiers, 'production');
    final iosId = _string(iosIdentifiers, 'production');
    final schemes = [
      for (final name in const ['development', 'staging', 'production'])
        Uri.parse(
          _string(_map(_map(environments, name), 'oidc'), 'redirectUri'),
        ).scheme,
    ];

    await File(
      path.join(directory.path, 'ngo-tools.mobile.yaml'),
    ).writeAsString(registrationSource);
    await _writeModuleCatalog(
      repository: repository,
      directory: directory,
      manifest: manifest,
    );
    await File(
      path.join(directory.path, 'analysis_options.yaml'),
    ).writeAsString('include: package:flutter_lints/flutter.yaml\n');
    final generatedConfiguration = File(
      path.join(directory.path, 'lib', 'generated', 'mobile_app_config.dart'),
    );
    await generatedConfiguration.writeAsString(
      await renderFormattedDartConfiguration(manifest),
    );

    await _rewritePubspec(
      directory,
      packageName: packageName,
      version: _string(metadata, 'version'),
      platformRef: platformRef,
    );
    await _rewritePackageImports(directory, packageName);
    await _rewriteAndroid(
      directory,
      appName: appName,
      applicationId: androidId,
      schemes: schemes,
      deepLinks: deepLinks,
      permissions: devicePermissions,
    );
    await _rewriteIos(
      directory,
      appName: appName,
      bundleId: iosId,
      schemes: schemes,
      deepLinks: deepLinks,
      permissions: devicePermissions,
    );

    final errors = NativeConfigurationValidator.validate(
      manifest: manifest,
      androidBuildFile: await _read(directory, 'android/app/build.gradle.kts'),
      androidManifest: await _read(
        directory,
        'android/app/src/main/AndroidManifest.xml',
      ),
      iosProjectFile: await _read(
        directory,
        'ios/Runner.xcodeproj/project.pbxproj',
      ),
      iosInfoPlist: await _read(directory, 'ios/Runner/Info.plist'),
      iosEntitlements: await _read(directory, 'ios/Runner/Runner.entitlements'),
    );

    if (errors.isNotEmpty) {
      throw StateError(
        'Generated native configuration is invalid:\n${errors.join('\n')}',
      );
    }

    final provenance = {
      'app_id': _string(metadata, 'id'),
      'app_version': _string(metadata, 'version'),
      'contract_version': _string(backend, 'minimumContractVersion'),
      'platform_sdk_version': platformVersion,
      'platform_ref': platformRef,
      'registration_sha256': sha256
          .convert(utf8.encode(registrationSource))
          .toString(),
      'identifiers': {
        'android': _string(androidIdentifiers, 'production'),
        'ios': _string(iosIdentifiers, 'production'),
      },
      'distribution': Map<String, Object?>.from(_map(manifest, 'distribution')),
    };
    await File(path.join(directory.path, '.ngotools-setup.json')).writeAsString(
      '${const JsonEncoder.withIndent('  ').convert(provenance)}\n',
    );
  }

  static Future<void> _writeModuleCatalog({
    required Directory repository,
    required Directory directory,
    required Map<String, Object?> manifest,
  }) async {
    final result = await MobileModuleCatalog.loadFromRepository(repository);

    if (!result.isValid || result.catalog == null) {
      throw StateError(
        'The platform module catalog is invalid:\n${result.errors.join('\n')}',
      );
    }

    final catalog = result.catalog!;
    final errors = catalog.validateManifest(manifest);

    if (errors.isNotEmpty) {
      throw FormatException(
        'Invalid registration modules:\n${errors.join('\n')}',
      );
    }

    final snapshot = File(
      path.join(directory.path, '.ngotools', 'modules.json'),
    );
    final documentation = File(path.join(directory.path, 'docs', 'MODULES.md'));
    await snapshot.parent.create(recursive: true);
    await documentation.parent.create(recursive: true);
    await snapshot.writeAsString(catalog.renderSnapshot());
    await documentation.writeAsString(catalog.renderMarkdown());
  }

  static Future<void> _rewritePubspec(
    Directory directory, {
    required String packageName,
    required String version,
    required String platformRef,
  }) async {
    final file = File(path.join(directory.path, 'pubspec.yaml'));
    var source = await file.readAsString();
    source = source
        .replaceFirst('name: golden_app', 'name: $packageName')
        .replaceFirst('version: 0.1.0+1', 'version: $version+1')
        .replaceFirst('\nresolution: workspace\n', '');

    const packages = [
      'ngotools_api',
      'ngotools_auth',
      'ngotools_contacts',
      'ngotools_design_system',
      'ngotools_mobile_core',
      'ngotools_navigation',
      'ngotools_testing',
    ];
    final overrides = packages
        .map(
          (package) =>
              '  $package:\n'
              '    git:\n'
              '      url: https://github.com/ngo-tools/mobile-platform.git\n'
              '      ref: $platformRef\n'
              '      path: packages/$package',
        )
        .join('\n');
    source = '$source\ndependency_overrides:\n$overrides\n';

    await file.writeAsString(source);
  }

  static Future<void> _rewritePackageImports(
    Directory directory,
    String packageName,
  ) async {
    for (final sourceRoot in const ['lib', 'test', 'tool']) {
      final sourceDirectory = Directory(path.join(directory.path, sourceRoot));

      await for (final entity in sourceDirectory.list(recursive: true)) {
        if (entity is! File || !entity.path.endsWith('.dart')) {
          continue;
        }

        final source = await entity.readAsString();
        await entity.writeAsString(
          source.replaceAll('package:golden_app/', 'package:$packageName/'),
        );
      }
    }
  }

  static Future<void> _rewriteAndroid(
    Directory directory, {
    required String appName,
    required String applicationId,
    required List<String> schemes,
    required List<String> deepLinks,
    required List<String> permissions,
  }) async {
    final buildFile = File(
      path.join(directory.path, 'android', 'app', 'build.gradle.kts'),
    );
    var buildSource = await buildFile.readAsString();
    buildSource = buildSource
        .replaceFirst(
          'namespace = "tools.ngo.mobile.golden_app"',
          'namespace = "$applicationId"',
        )
        .replaceFirst(
          'applicationId = "tools.ngo.mobile.golden"',
          'applicationId = "$applicationId"',
        )
        .replaceFirst(
          '"ngotools-01j00000000000000000000002"',
          '"${schemes[2]}"',
        );
    await buildFile.writeAsString(buildSource);

    final activity = File(
      path.join(
        directory.path,
        'android',
        'app',
        'src',
        'main',
        'kotlin',
        'tools',
        'ngo',
        'mobile',
        'golden_app',
        'MainActivity.kt',
      ),
    );
    await activity.writeAsString(
      (await activity.readAsString()).replaceFirst(
        'package tools.ngo.mobile.golden_app',
        'package $applicationId',
      ),
    );

    final manifestFile = File(
      path.join(
        directory.path,
        'android',
        'app',
        'src',
        'main',
        'AndroidManifest.xml',
      ),
    );
    var manifest = await manifestFile.readAsString();
    manifest = manifest.replaceFirst(
      'android:label="golden_app"',
      'android:label="${_xml(appName)}"',
    );
    final originalSchemes = const [
      'ngotools-01j00000000000000000000000',
      'ngotools-01j00000000000000000000001',
      'ngotools-01j00000000000000000000002',
    ];

    for (var index = 0; index < schemes.length; index += 1) {
      manifest = manifest.replaceFirst(originalSchemes[index], schemes[index]);
    }

    final androidPermissions = {
      'notifications': 'android.permission.POST_NOTIFICATIONS',
      'camera': 'android.permission.CAMERA',
      'photos': 'android.permission.READ_MEDIA_IMAGES',
      'location': 'android.permission.ACCESS_FINE_LOCATION',
    };
    final permissionXml = permissions
        .map((permission) => androidPermissions[permission])
        .whereType<String>()
        .map(
          (permission) => '    <uses-permission android:name="$permission" />',
        )
        .join('\n');
    manifest = manifest.replaceFirst(
      '<manifest xmlns:android="http://schemas.android.com/apk/res/android">',
      '<manifest xmlns:android="http://schemas.android.com/apk/res/android">'
          '${permissionXml.isEmpty ? '' : '\n$permissionXml'}',
    );
    final appLinks = deepLinks
        .map(
          (host) =>
              '            <intent-filter android:autoVerify="true">\n'
              '                <action android:name="android.intent.action.VIEW" />\n'
              '                <category android:name="android.intent.category.DEFAULT" />\n'
              '                <category android:name="android.intent.category.BROWSABLE" />\n'
              '                <data android:scheme="https" android:host="${_xml(host)}" />\n'
              '            </intent-filter>',
        )
        .join('\n');
    const goldenAppLink =
        '            <intent-filter android:autoVerify="true">\n'
        '                <action android:name="android.intent.action.VIEW" />\n'
        '                <category android:name="android.intent.category.DEFAULT" />\n'
        '                <category android:name="android.intent.category.BROWSABLE" />\n'
        '                <data android:scheme="https" android:host="mobile.example.invalid" />\n'
        '            </intent-filter>';
    manifest = manifest.replaceFirst(goldenAppLink, appLinks);
    await manifestFile.writeAsString(manifest);
  }

  static Future<void> _rewriteIos(
    Directory directory, {
    required String appName,
    required String bundleId,
    required List<String> schemes,
    required List<String> deepLinks,
    required List<String> permissions,
  }) async {
    final projectFile = File(
      path.join(directory.path, 'ios', 'Runner.xcodeproj', 'project.pbxproj'),
    );
    var project = await projectFile.readAsString();
    project = project
        .replaceAll(
          'tools.ngo.mobile.goldenApp.RunnerTests',
          '$bundleId.RunnerTests',
        )
        .replaceAll('tools.ngo.mobile.golden', bundleId);
    await projectFile.writeAsString(project);

    final infoFile = File(
      path.join(directory.path, 'ios', 'Runner', 'Info.plist'),
    );
    var info = await infoFile.readAsString();
    info = info
        .replaceFirst(
          '<string>Golden App</string>',
          '<string>${_xml(appName)}</string>',
        )
        .replaceFirst(
          '<string>golden_app</string>',
          '<string>${_xml(appName)}</string>',
        );
    final originalSchemes = const [
      'ngotools-01j00000000000000000000000',
      'ngotools-01j00000000000000000000001',
      'ngotools-01j00000000000000000000002',
    ];

    for (var index = 0; index < schemes.length; index += 1) {
      info = info.replaceFirst(originalSchemes[index], schemes[index]);
    }

    final descriptions = {
      'camera': (
        'NSCameraUsageDescription',
        '$appName uses the camera only when you choose to capture an attachment.',
      ),
      'photos': (
        'NSPhotoLibraryUsageDescription',
        '$appName accesses photos only when you choose an attachment.',
      ),
      'location': (
        'NSLocationWhenInUseUsageDescription',
        '$appName uses location only when you choose to add it.',
      ),
    };
    final usageXml = permissions
        .map((permission) => descriptions[permission])
        .whereType<(String, String)>()
        .map(
          (description) =>
              '\t<key>${description.$1}</key>\n'
              '\t<string>${_xml(description.$2)}</string>',
        )
        .join('\n');
    info = info.replaceFirst(
      '</dict>\n</plist>',
      '${usageXml.isEmpty ? '' : '$usageXml\n'}</dict>\n</plist>',
    );
    await infoFile.writeAsString(info);

    final entitlementsFile = File(
      path.join(directory.path, 'ios', 'Runner', 'Runner.entitlements'),
    );
    var entitlements = await entitlementsFile.readAsString();
    final domains = deepLinks
        .map((host) => '\t\t<string>applinks:${_xml(host)}</string>')
        .join('\n');
    const goldenDomains =
        '\t<key>com.apple.developer.associated-domains</key>\n'
        '\t<array>\n'
        '\t\t<string>applinks:mobile.example.invalid</string>\n'
        '\t</array>';
    entitlements = entitlements.replaceFirst(
      goldenDomains,
      '\t<key>com.apple.developer.associated-domains</key>\n'
      '\t<array>\n$domains\n\t</array>',
    );
    await entitlementsFile.writeAsString(entitlements);
  }

  static Future<void> _copyTemplate(
    Directory source,
    Directory destination,
  ) async {
    await destination.create(recursive: true);

    await for (final entity in source.list(followLinks: false)) {
      final name = path.basename(entity.path);

      if (const {'.dart_tool', 'build'}.contains(name)) {
        continue;
      }

      final targetPath = path.join(destination.path, name);

      if (entity is Directory) {
        await _copyTemplate(entity, Directory(targetPath));
      } else if (entity is File) {
        await entity.copy(targetPath);
      }
    }
  }

  static Future<String> _read(Directory directory, String relativePath) =>
      File(path.join(directory.path, relativePath)).readAsString();

  static Map<String, Object?> _map(Map<String, Object?> value, String key) =>
      value[key]! as Map<String, Object?>;

  static String _string(Map<String, Object?> value, String key) =>
      value[key]! as String;

  static List<String> _strings(Map<String, Object?> value, String key) =>
      (value[key]! as List<Object?>).cast<String>();

  static String _platformVersion(String pubspecSource) {
    final pubspec = loadYaml(pubspecSource);
    final version = pubspec is YamlMap ? pubspec['version'] : null;

    if (version is! String ||
        !RegExp(r'^\d+\.\d+\.\d+(?:-[0-9A-Za-z.-]+)?$').hasMatch(version)) {
      throw const FormatException(
        'The Mobile Platform pubspec has no semantic version.',
      );
    }

    return version;
  }

  static String _literal(String value) =>
      "'${value.replaceAll(r'\', r'\\').replaceAll("'", r"\'").replaceAll(r'$', r'\$').replaceAll('\n', r'\n').replaceAll('\r', r'\r').replaceAll('\t', r'\t')}'";

  static String _xml(String value) =>
      const HtmlEscape(HtmlEscapeMode.attribute).convert(value);
}
