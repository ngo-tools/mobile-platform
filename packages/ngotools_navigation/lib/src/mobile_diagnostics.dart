import 'package:flutter/material.dart';
import 'package:ngotools_api/ngotools_api.dart';
import 'package:ngotools_auth/ngotools_auth.dart';
import 'package:ngotools_mobile_core/ngotools_mobile_core.dart';

/// Sanitized support context without identity, token, or response data.
final class MobileDiagnosticsSnapshot {
  /// Creates a diagnostics snapshot from approved runtime fields.
  MobileDiagnosticsSnapshot._({
    required this.appId,
    required this.environment,
    required this.environmentId,
    required this.apiHost,
    required this.configRevision,
    required this.authStatus,
    required this.capabilitySchemaVersion,
    required Iterable<String> features,
    required this.permissionCount,
    required this.importTypeCount,
  }) : features = List.unmodifiable(features.toList()..sort());

  /// Creates a sanitized snapshot from platform configuration and state.
  factory MobileDiagnosticsSnapshot.fromRuntime({
    required String appId,
    required MobileEnvironmentConfiguration environment,
    required MobileAuthStatus authStatus,
    required MobileRuntimeCapabilities? capabilities,
  }) => MobileDiagnosticsSnapshot._(
    appId: appId,
    environment: environment.environment.name,
    environmentId: environment.id,
    apiHost: environment.apiBaseUrl.host,
    configRevision: environment.configRevision,
    authStatus: authStatus.name,
    capabilitySchemaVersion: capabilities?.schemaVersion,
    features: capabilities?.features ?? const {},
    permissionCount: capabilities?.permissions.length ?? 0,
    importTypeCount: capabilities?.importTypes.length ?? 0,
  );

  /// Public application registration identifier.
  final String appId;

  /// Selected deployment environment.
  final String environment;

  /// Public environment registration identifier.
  final String environmentId;

  /// API hostname without path, query, or credentials.
  final String apiHost;

  /// Public configuration revision.
  final String configRevision;

  /// Token-free authentication status.
  final String authStatus;

  /// Capability schema version, when loaded.
  final int? capabilitySchemaVersion;

  /// Sorted effective feature names.
  final List<String> features;

  /// Number of effective permissions, without their names.
  final int permissionCount;

  /// Number of known import types, without payload details.
  final int importTypeCount;

  /// Stable text suitable for a user-initiated support report.
  String toSupportText() => [
    'app_id=$appId',
    'environment=$environment',
    'environment_id=$environmentId',
    'api_host=$apiHost',
    'config_revision=$configRevision',
    'auth_status=$authStatus',
    'capability_schema=${capabilitySchemaVersion ?? 'not_loaded'}',
    'features=${features.join(',')}',
    'permission_count=$permissionCount',
    'import_type_count=$importTypeCount',
  ].join('\n');

  @override
  String toString() => toSupportText();
}

/// Localized labels for the diagnostics view.
final class MobileDiagnosticsLabels {
  /// Creates labels supplied by the host application's localization layer.
  const MobileDiagnosticsLabels({
    required this.title,
    required this.description,
    required this.app,
    required this.environment,
    required this.environmentId,
    required this.apiHost,
    required this.configRevision,
    required this.authStatus,
    required this.capabilitySchema,
    required this.features,
    required this.permissionCount,
    required this.importTypeCount,
    required this.notLoaded,
    required this.none,
  });

  /// English diagnostics labels.
  static const english = MobileDiagnosticsLabels(
    title: 'Diagnostics',
    description: 'Non-sensitive support information for this app.',
    app: 'App',
    environment: 'Environment',
    environmentId: 'Environment ID',
    apiHost: 'API host',
    configRevision: 'Configuration revision',
    authStatus: 'Authentication status',
    capabilitySchema: 'Capability schema',
    features: 'Features',
    permissionCount: 'Permission count',
    importTypeCount: 'Import type count',
    notLoaded: 'Not loaded',
    none: 'None',
  );

  /// German diagnostics labels.
  static const german = MobileDiagnosticsLabels(
    title: 'Diagnose',
    description: 'Nicht sensible Supportinformationen für diese App.',
    app: 'App',
    environment: 'Umgebung',
    environmentId: 'Umgebungs-ID',
    apiHost: 'API-Host',
    configRevision: 'Konfigurationsrevision',
    authStatus: 'Anmeldestatus',
    capabilitySchema: 'Capability-Schema',
    features: 'Features',
    permissionCount: 'Anzahl Berechtigungen',
    importTypeCount: 'Anzahl Importtypen',
    notLoaded: 'Nicht geladen',
    none: 'Keine',
  );

  final String title;
  final String description;
  final String app;
  final String environment;
  final String environmentId;
  final String apiHost;
  final String configRevision;
  final String authStatus;
  final String capabilitySchema;
  final String features;
  final String permissionCount;
  final String importTypeCount;
  final String notLoaded;
  final String none;
}

/// Read-only diagnostics content built from [MobileDiagnosticsSnapshot].
final class MobileDiagnosticsView extends StatelessWidget {
  /// Creates a token- and PII-free diagnostics view.
  const MobileDiagnosticsView({
    required this.snapshot,
    required this.labels,
    super.key,
  });

  /// Sanitized diagnostics data.
  final MobileDiagnosticsSnapshot snapshot;

  /// Host-localized labels.
  final MobileDiagnosticsLabels labels;

  @override
  Widget build(BuildContext context) => SelectionArea(
    child: ListView(
      padding: const EdgeInsets.all(24),
      children: [
        Semantics(
          header: true,
          child: Text(
            labels.title,
            style: Theme.of(context).textTheme.headlineSmall,
          ),
        ),
        const SizedBox(height: 8),
        Text(labels.description),
        const SizedBox(height: 24),
        _DiagnosticRow(label: labels.app, value: snapshot.appId),
        _DiagnosticRow(label: labels.environment, value: snapshot.environment),
        _DiagnosticRow(
          label: labels.environmentId,
          value: snapshot.environmentId,
        ),
        _DiagnosticRow(label: labels.apiHost, value: snapshot.apiHost),
        _DiagnosticRow(
          label: labels.configRevision,
          value: snapshot.configRevision,
        ),
        _DiagnosticRow(label: labels.authStatus, value: snapshot.authStatus),
        _DiagnosticRow(
          label: labels.capabilitySchema,
          value:
              snapshot.capabilitySchemaVersion?.toString() ?? labels.notLoaded,
        ),
        _DiagnosticRow(
          label: labels.features,
          value: snapshot.features.isEmpty
              ? labels.none
              : snapshot.features.join(', '),
        ),
        _DiagnosticRow(
          label: labels.permissionCount,
          value: snapshot.permissionCount.toString(),
        ),
        _DiagnosticRow(
          label: labels.importTypeCount,
          value: snapshot.importTypeCount.toString(),
        ),
      ],
    ),
  );
}

final class _DiagnosticRow extends StatelessWidget {
  const _DiagnosticRow({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.symmetric(vertical: 8),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Text(label, style: Theme.of(context).textTheme.labelLarge),
        ),
        const SizedBox(width: 16),
        Expanded(child: Text(value, textAlign: TextAlign.end)),
      ],
    ),
  );
}
