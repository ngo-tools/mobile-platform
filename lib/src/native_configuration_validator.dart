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

    for (final variable in const {
      'ANDROID_KEYSTORE_PATH',
      'ANDROID_STORE_PASSWORD',
      'ANDROID_KEY_ALIAS',
      'ANDROID_KEY_PASSWORD',
    }) {
      if (!androidBuildFile.contains('System.getenv("$variable")')) {
        errors.add('Android release signing must read $variable from CI.');
      }
    }

    final minimumSdkMatch = RegExp(
      r'minSdk\s*=\s*(\d+)',
    ).firstMatch(androidBuildFile);
    final minimumSdk = int.tryParse(minimumSdkMatch?.group(1) ?? '');

    if (minimumSdk == null || minimumSdk < 23) {
      errors.add(
        'Android minSdk must be at least 23 for protected session storage.',
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
    final productionRedirectScheme = _productionRedirectScheme(manifest);

    if (productionRedirectScheme != null &&
        !androidBuildFile.contains(
          'manifestPlaceholders["appAuthRedirectScheme"] =\n'
          '            "$productionRedirectScheme"',
        )) {
      errors.add(
        'Android AppAuth placeholder does not match the production redirect.',
      );
    }

    for (final scheme in redirectSchemes) {
      if (!androidManifest.contains('android:scheme="$scheme"')) {
        errors.add('Android is missing the $scheme auth redirect scheme.');
      }

      if (!iosInfoPlist.contains('<string>$scheme</string>')) {
        errors.add('iOS is missing the $scheme auth redirect scheme.');
      }
    }

    final deepLinkHosts = _deepLinkHosts(manifest);

    for (final host in deepLinkHosts) {
      if (!androidManifest.contains('android:host="$host"')) {
        errors.add('Android is missing the $host app-link host.');
      }

      if (!iosEntitlements.contains('<string>applinks:$host</string>')) {
        errors.add('iOS is missing the $host associated domain.');
      }
    }

    final androidHosts = RegExp(
      'android:host="([^"]+)"',
    ).allMatches(androidManifest).map((match) => match.group(1)!).toSet();
    final iosHosts = RegExp(
      r'<string>applinks:([^<]+)</string>',
    ).allMatches(iosEntitlements).map((match) => match.group(1)!).toSet();

    for (final host in androidHosts.difference(deepLinkHosts)) {
      errors.add('Android declares the unregistered $host app-link host.');
    }

    for (final host in iosHosts.difference(deepLinkHosts)) {
      errors.add('iOS declares the unregistered $host associated domain.');
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

  static Set<String> _deepLinkHosts(Map<String, Object?> manifest) {
    final deepLinks = manifest['deepLinks'];

    if (deepLinks is! Map<String, Object?>) {
      return const {};
    }

    final hosts = deepLinks['hosts'];

    if (hosts is! List<Object?>) {
      return const {};
    }

    return hosts.whereType<String>().toSet();
  }

  static String? _productionRedirectScheme(Map<String, Object?> manifest) {
    final backend = manifest['backend'];

    if (backend is! Map<String, Object?>) {
      return null;
    }

    final environments = backend['environments'];
    final production = environments is Map<String, Object?>
        ? environments['production']
        : null;
    final oidc = production is Map<String, Object?> ? production['oidc'] : null;
    final redirectUri = oidc is Map<String, Object?>
        ? oidc['redirectUri']
        : null;

    return redirectUri is String ? Uri.parse(redirectUri).scheme : null;
  }
}
