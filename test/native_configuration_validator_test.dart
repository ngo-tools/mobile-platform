import 'package:ngo_tools_mobile_platform/mobile_platform_tooling.dart';
import 'package:test/test.dart';

void main() {
  final manifest = <String, Object?>{
    'identifiers': <String, Object?>{
      'android': <String, Object?>{'production': 'tools.ngo.mobile.golden'},
      'ios': <String, Object?>{'production': 'tools.ngo.mobile.golden'},
    },
    'permissions': <String, Object?>{'device': <Object?>[]},
    'backend': <String, Object?>{
      'environments': <String, Object?>{
        'production': <String, Object?>{
          'oidc': <String, Object?>{
            'redirectUri': 'ngotools-synthetic://oauth/callback',
          },
        },
      },
    },
  };

  const androidManifest =
      '<application android:allowBackup="false">'
      '<data android:scheme="ngotools-synthetic" />'
      '</application>';
  const iosProjectFile =
      'PRODUCT_BUNDLE_IDENTIFIER = tools.ngo.mobile.golden;\n'
      'CODE_SIGN_ENTITLEMENTS = Runner/Runner.entitlements;';
  const iosInfoPlist = '<string>ngotools-synthetic</string>';
  const iosEntitlements = '<key>keychain-access-groups</key>';
  const androidBuildFile =
      'defaultConfig { applicationId = "tools.ngo.mobile.golden"; '
      'minSdk = 23 }';

  test('accepts matching secret-free native configuration', () {
    final errors = NativeConfigurationValidator.validate(
      manifest: manifest,
      androidBuildFile: androidBuildFile,
      androidManifest: androidManifest,
      iosProjectFile: iosProjectFile,
      iosInfoPlist: iosInfoPlist,
      iosEntitlements: iosEntitlements,
    );

    expect(errors, isEmpty);
  });

  test('rejects identifiers and signing configuration drift', () {
    final errors = NativeConfigurationValidator.validate(
      manifest: manifest,
      androidBuildFile:
          'applicationId = "tools.ngo.mobile.other"\n'
          'minSdk = 23\n'
          'signingConfig = signingConfigs.getByName("debug")',
      androidManifest: androidManifest,
      iosProjectFile:
          'PRODUCT_BUNDLE_IDENTIFIER = tools.ngo.mobile.other;\n'
          'DEVELOPMENT_TEAM = ABC123;\n'
          'CODE_SIGN_ENTITLEMENTS = Runner/Runner.entitlements;',
      iosInfoPlist: iosInfoPlist,
      iosEntitlements: iosEntitlements,
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
      androidBuildFile: androidBuildFile,
      androidManifest: androidManifest,
      iosProjectFile: iosProjectFile,
      iosInfoPlist: iosInfoPlist,
      iosEntitlements: iosEntitlements,
    );

    expect(errors, hasLength(2));
  });

  test('requires app links on both native platforms', () {
    final deepLinkManifest = <String, Object?>{
      ...manifest,
      'deepLinks': <String, Object?>{
        'hosts': <Object?>['mobile.example.invalid'],
      },
    };
    final errors = NativeConfigurationValidator.validate(
      manifest: deepLinkManifest,
      androidBuildFile: androidBuildFile,
      androidManifest: androidManifest,
      iosProjectFile: iosProjectFile,
      iosInfoPlist: iosInfoPlist,
      iosEntitlements: iosEntitlements,
    );

    expect(errors, {
      'Android is missing the mobile.example.invalid app-link host.',
      'iOS is missing the mobile.example.invalid associated domain.',
    });
  });

  test('rejects missing redirect and protected-storage configuration', () {
    final errors = NativeConfigurationValidator.validate(
      manifest: manifest,
      androidBuildFile:
          'defaultConfig { applicationId = "tools.ngo.mobile.golden" }',
      androidManifest: '<application android:taskAffinity="" />',
      iosProjectFile: 'PRODUCT_BUNDLE_IDENTIFIER = tools.ngo.mobile.golden;',
      iosInfoPlist: '<plist />',
      iosEntitlements: '<plist />',
    );

    expect(errors, hasLength(6));
  });
}
