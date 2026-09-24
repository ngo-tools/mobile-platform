/// Checks package dependencies against the approved workspace graph.
abstract final class ArchitectureValidator {
  static const _allowedDependencies = <String, Set<String>>{
    'ngotools_mobile_core': {},
    'ngotools_auth': {'ngotools_mobile_core'},
    'ngotools_api': {'ngotools_mobile_core'},
    'ngotools_contacts': {
      'ngotools_mobile_core',
      'ngotools_api',
      'ngotools_design_system',
    },
    'ngotools_design_system': {'ngotools_mobile_core'},
    'ngotools_navigation': {
      'ngotools_mobile_core',
      'ngotools_auth',
      'ngotools_api',
    },
    'ngotools_testing': {
      'ngotools_mobile_core',
      'ngotools_auth',
      'ngotools_api',
      'ngotools_contacts',
      'ngotools_design_system',
      'ngotools_navigation',
    },
  };

  /// Returns dependency violations for [packageDependencies].
  static List<String> validate(Map<String, Set<String>> packageDependencies) {
    final errors = <String>[];
    final platformPackages = _allowedDependencies.keys.toSet();

    for (final packageEntry in packageDependencies.entries) {
      final allowed = _allowedDependencies[packageEntry.key];

      if (allowed == null) {
        continue;
      }

      final internalDependencies = packageEntry.value.intersection(
        platformPackages,
      );
      final forbidden = internalDependencies.difference(allowed);

      for (final dependency in forbidden.toList()..sort()) {
        errors.add('${packageEntry.key} may not depend on $dependency.');
      }
    }

    return errors;
  }

  /// Returns imports that bypass token or HTTP ownership boundaries.
  static List<String> validateSourceBoundaries(Map<String, String> sources) {
    final errors = <String>[];

    for (final entry in sources.entries) {
      final isAuthSource = entry.key.startsWith('packages/ngotools_auth/lib/');
      final isApiSource = entry.key.startsWith('packages/ngotools_api/lib/');

      if (!isAuthSource && entry.value.contains("package:ngotools_auth/src/")) {
        errors.add('${entry.key} may not import ngotools_auth internals.');
      }

      if (!isApiSource &&
          entry.value.contains("package:ngotools_api/src/generated/")) {
        errors.add('${entry.key} may not import generated API internals.');
      }

      if (!isAuthSource &&
          !isApiSource &&
          entry.value.contains("package:dio/")) {
        errors.add('${entry.key} may not perform direct HTTP requests.');
      }
    }

    return errors;
  }
}
