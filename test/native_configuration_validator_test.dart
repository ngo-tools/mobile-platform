import 'package:ngo_tools_mobile_platform/mobile_platform_tooling.dart';
import 'package:test/test.dart';

void main() {
  final manifest = <String, Object?>{
    'identifiers': <String, Object?>{
      'android': <String, Object?>{'production': 'tools.ngo.mobile.golden'},
      'ios': <String, Object?>{'production': 'tools.ngo.mobile.golden'},
    },
    'permissions': <String, Object?>{'device': <Object?>[]},
  };

  test('accepts matching secret-free native configuration', () {
    final errors = NativeConfigurationValidator.validate(
      manifest: manifest,
      androidBuildFile:
          'defaultConfig { applicationId = "tools.ngo.mobile.golden" }',
      androidManifest: '<manifest />',
      iosProjectFile: 'PRODUCT_BUNDLE_IDENTIFIER = tools.ngo.mobile.golden;',
      iosInfoPlist: '<plist />',
    );

    expect(errors, isEmpty);
  });

  test('rejects identifiers and signing configuration drift', () {
    final errors = NativeConfigurationValidator.validate(
      manifest: manifest,
      androidBuildFile:
          'applicationId = "tools.ngo.mobile.other"\n'
          'signingConfig = signingConfigs.getByName("debug")',
      androidManifest: '<manifest />',
      iosProjectFile:
          'PRODUCT_BUNDLE_IDENTIFIER = tools.ngo.mobile.other;\n'
          'DEVELOPMENT_TEAM = ABC123;',
      iosInfoPlist: '<plist />',
    );

    expect(errors, hasLength(4));
  });

  test('requires native declarations for requested permissions', () {
    final permissionManifest = <String, Object?>{
      ...manifest,
      'permissions': <String, Object?>{
        'device': <Object?>['camera'],
      },
    };
    final errors = NativeConfigurationValidator.validate(
      manifest: permissionManifest,
      androidBuildFile:
          'defaultConfig { applicationId = "tools.ngo.mobile.golden" }',
      androidManifest: '<manifest />',
      iosProjectFile: 'PRODUCT_BUNDLE_IDENTIFIER = tools.ngo.mobile.golden;',
      iosInfoPlist: '<plist />',
    );

    expect(errors, hasLength(2));
  });
}
