/// Compares the public manifest with native application configuration.
abstract final class NativeConfigurationValidator {
  static const _androidPermissions = <String, String>{
    'notifications': 'android.permission.POST_NOTIFICATIONS',
    'camera': 'android.permission.CAMERA',
    'photos': 'android.permission.READ_MEDIA_IMAGES',
    'location': 'android.permission.ACCESS_FINE_LOCATION',
  };

  static const _iosPermissions = <String, String>{
    'camera': 'NSCameraUsageDescription',
    'photos': 'NSPhotoLibraryUsageDescription',
    'location': 'NSLocationWhenInUseUsageDescription',
  };

  /// Returns mismatches between [manifest] and native files.
  static List<String> validate({
    required Map<String, Object?> manifest,
    required String androidBuildFile,
    required String androidManifest,
    required String iosProjectFile,
    required String iosInfoPlist,
    required String iosEntitlements,
  }) {
    final errors = <String>[];
    final identifiers = manifest['identifiers'];

    if (identifiers is Map<String, Object?>) {
      final android = identifiers['android'];
      final ios = identifiers['ios'];

      if (android is Map<String, Object?>) {
        final productionId = android['production'];

        if (productionId is String &&
            !androidBuildFile.contains('applicationId = "$productionId"')) {
          errors.add('Android applicationId does not match the manifest.');
        }
      }

      if (ios is Map<String, Object?>) {
        final productionId = ios['production'];

        if (productionId is String &&
            !iosProjectFile.contains(
              'PRODUCT_BUNDLE_IDENTIFIER = $productionId;',
            )) {
          errors.add('iOS bundle identifier does not match the manifest.');
        }
      }
    }

    if (iosProjectFile.contains('DEVELOPMENT_TEAM =')) {
      errors.add('The repository must not pin an Apple development team.');
    }

    if (androidBuildFile.contains(
      'signingConfig = signingConfigs.getByName("debug")',
    )) {
      errors.add('Release builds must not use the Android debug signing key.');
    }

    if (!androidBuildFile.contains('minSdk = 23')) {
      errors.add(
        'Android minSdk must support hardware-backed session storage.',
      );
    }

    if (!androidManifest.contains('android:allowBackup="false"')) {
      errors.add('Android backups must be disabled for protected sessions.');
    }

    if (androidManifest.contains('android:taskAffinity=""')) {
      errors.add('Android taskAffinity must not block AppAuth redirects.');
    }

    if (!iosProjectFile.contains(
          'CODE_SIGN_ENTITLEMENTS = Runner/Runner.entitlements;',
        ) ||
        !iosEntitlements.contains('<key>keychain-access-groups</key>')) {
      errors.add('iOS Keychain entitlements must protect auth sessions.');
    }

    final redirectSchemes = _redirectSchemes(manifest);

    for (final scheme in redirectSchemes) {
      if (!androidManifest.contains('android:scheme="$scheme"')) {
        errors.add('Android is missing the $scheme auth redirect scheme.');
      }

      if (!iosInfoPlist.contains('<string>$scheme</string>')) {
        errors.add('iOS is missing the $scheme auth redirect scheme.');
      }
    }

    final permissions = manifest['permissions'];
    final declaredPermissions = <String>{};

    if (permissions is Map<String, Object?>) {
      final devicePermissions = permissions['device'];

      if (devicePermissions is List<Object?>) {
        declaredPermissions.addAll(devicePermissions.whereType<String>());
      }
    }

    for (final entry in _androidPermissions.entries) {
      final isConfigured = androidManifest.contains(entry.value);

      if (isConfigured != declaredPermissions.contains(entry.key)) {
        errors.add(
          'Android permission ${entry.key} does not match the manifest.',
        );
      }
    }

    for (final entry in _iosPermissions.entries) {
      final isConfigured = iosInfoPlist.contains(entry.value);

      if (isConfigured != declaredPermissions.contains(entry.key)) {
        errors.add('iOS permission ${entry.key} does not match the manifest.');
      }
    }

    return errors;
  }

  static Set<String> _redirectSchemes(Map<String, Object?> manifest) {
    final backend = manifest['backend'];

    if (backend is! Map<String, Object?>) {
      return const {};
    }

    final environments = backend['environments'];

    if (environments is! Map<String, Object?>) {
      return const {};
    }

    return {
      for (final environment in environments.values)
        if (environment is Map<String, Object?> &&
            environment['oidc'] is Map<String, Object?>)
          if ((environment['oidc']! as Map<String, Object?>)['redirectUri']
              case final String redirectUri)
            Uri.parse(redirectUri).scheme,
    };
  }
}
