/// Checks package dependencies against the approved workspace graph.
abstract final class ArchitectureValidator {
  static const _allowedDependencies = <String, Set<String>>{
    'ngotools_mobile_core': {},
    'ngotools_auth': {'ngotools_mobile_core'},
    'ngotools_api': {'ngotools_mobile_core'},
    'ngotools_design_system': {'ngotools_mobile_core'},
    'ngotools_navigation': {'ngotools_mobile_core', 'ngotools_auth'},
    'ngotools_testing': {
      'ngotools_mobile_core',
      'ngotools_auth',
      'ngotools_api',
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
}
