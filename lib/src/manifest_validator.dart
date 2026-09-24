import 'dart:convert';

import 'package:json_schema/json_schema.dart';
import 'package:yaml/yaml.dart';

/// The result of validating an NGO.Tools mobile manifest.
class ManifestValidationResult {
  /// Creates a manifest validation result.
  const ManifestValidationResult({
    required this.manifest,
    required this.errors,
  });

  /// The normalized manifest data, or `null` when parsing failed.
  final Map<String, Object?>? manifest;

  /// Human-readable validation errors.
  final List<String> errors;

  /// Whether the manifest passed all checks.
  bool get isValid => errors.isEmpty;
}

/// Validates an NGO.Tools YAML manifest against the versioned JSON Schema.
abstract final class ManifestValidator {
  /// Validates [manifestSource] against [schemaSource].
  static ManifestValidationResult validate({
    required String manifestSource,
    required String schemaSource,
  }) {
    try {
      final manifest = _normalizeYaml(loadYaml(manifestSource));

      if (manifest is! Map<String, Object?>) {
        return const ManifestValidationResult(
          manifest: null,
          errors: ['The manifest root must be an object.'],
        );
      }

      final decodedSchema = jsonDecode(schemaSource);

      if (decodedSchema is! Map<String, Object?>) {
        return const ManifestValidationResult(
          manifest: null,
          errors: ['The JSON Schema root must be an object.'],
        );
      }

      final schema = JsonSchema.create(decodedSchema);
      final schemaResults = schema.validate(manifest, validateFormats: true);
      final errors = schemaResults.errors
          .map((error) => error.toString())
          .toList(growable: true);

      errors.addAll(_semanticErrors(manifest));

      return ManifestValidationResult(
        manifest: manifest,
        errors: List.unmodifiable(errors),
      );
    } on Object catch (error) {
      return ManifestValidationResult(
        manifest: null,
        errors: ['Unable to parse manifest or schema: $error'],
      );
    }
  }

  static List<String> _semanticErrors(Map<String, Object?> manifest) {
    final errors = <String>[];
    final localization = manifest['localization'];

    if (localization is Map<String, Object?>) {
      final defaultLocale = localization['defaultLocale'];
      final locales = localization['locales'];

      if (defaultLocale is String &&
          locales is List<Object?> &&
          !locales.contains(defaultLocale)) {
        errors.add('localization.defaultLocale must be included in locales.');
      }
    }

    final backend = manifest['backend'];

    if (backend is Map<String, Object?>) {
      final environments = backend['environments'];

      if (environments is Map<String, Object?>) {
        const expectedModes = {
          'development': 'disabled',
          'staging': 'test',
          'production': 'enforced',
        };

        for (final entry in expectedModes.entries) {
          final environment = environments[entry.key];

          if (environment is Map<String, Object?>) {
            if (environment['attestationMode'] != entry.value) {
              errors.add(
                'backend.environments.${entry.key}.attestationMode must be ${entry.value}.',
              );
            }

            _validatePublicUrl(
              environment['apiBaseUrl'],
              'backend.environments.${entry.key}.apiBaseUrl',
              errors,
            );
            final oidc = environment['oidc'];

            if (oidc is Map<String, Object?>) {
              _validatePublicUrl(
                oidc['issuer'],
                'backend.environments.${entry.key}.oidc.issuer',
                errors,
              );
            }
          }
        }
      }
    }

    final identifiers = manifest['identifiers'];
    final distribution = manifest['distribution'];

    if (identifiers is Map<String, Object?> &&
        distribution is Map<String, Object?>) {
      for (final platform in distribution.keys) {
        if (!identifiers.containsKey(platform)) {
          errors.add('identifiers.$platform is required for its distribution.');
        }
      }
    }

    return errors;
  }

  static void _validatePublicUrl(
    Object? value,
    String field,
    List<String> errors,
  ) {
    if (value is! String) {
      return;
    }

    final uri = Uri.tryParse(value);

    if (uri == null ||
        uri.userInfo.isNotEmpty ||
        uri.query.isNotEmpty ||
        uri.fragment.isNotEmpty) {
      errors.add(
        '$field must not contain credentials, a query, or a fragment.',
      );
    }
  }

  static Object? _normalizeYaml(Object? value) {
    if (value is YamlMap) {
      return <String, Object?>{
        for (final entry in value.entries)
          entry.key.toString(): _normalizeYaml(entry.value),
      };
    }

    if (value is YamlList) {
      return <Object?>[for (final item in value) _normalizeYaml(item)];
    }

    return value;
  }
}
