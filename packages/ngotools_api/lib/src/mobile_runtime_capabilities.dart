/// Effective server-side access for the authenticated tenant user.
final class MobileRuntimeCapabilities {
  /// Creates a deeply immutable capability snapshot.
  MobileRuntimeCapabilities({
    required this.schemaVersion,
    required Iterable<String> features,
    required Iterable<String> permissions,
    required this.importsEnabled,
    required Map<String, MobileImportCapability> importTypes,
  }) : features = Set.unmodifiable(features),
       permissions = Set.unmodifiable(permissions),
       importTypes = Map.unmodifiable(importTypes);

  /// Version of the server capability schema.
  final int schemaVersion;

  /// Effective Marketplace features.
  final Set<String> features;

  /// Effective user permissions.
  final Set<String> permissions;

  /// Whether imports are available at all.
  final bool importsEnabled;

  /// Import capabilities keyed by stable import type.
  final Map<String, MobileImportCapability> importTypes;

  /// Whether [feature] is currently enabled.
  bool hasFeature(String feature) => features.contains(feature);

  /// Whether [permission] is currently granted.
  bool hasPermission(String permission) => permissions.contains(permission);

  /// Whether the server currently permits [importType].
  bool canImport(String importType) =>
      importsEnabled && (importTypes[importType]?.available ?? false);
}

/// Effective server-side access for one import type.
final class MobileImportCapability {
  /// Creates an immutable import capability.
  MobileImportCapability({
    required this.key,
    required this.supported,
    required this.requiredFeature,
    required this.featureEnabled,
    required this.permissionGranted,
    required this.available,
    required Iterable<String> requires,
    required this.batchImportSupported,
    required Iterable<MobileCapabilityBlocker> blockers,
    this.label,
    this.maxBatchSize,
  }) : requires = Set.unmodifiable(requires),
       blockers = List.unmodifiable(blockers);

  /// Stable server-provided import type key.
  final String key;

  /// Optional localized label.
  final String? label;

  /// Whether this client and server support the import type.
  final bool supported;

  /// Feature required by this import type.
  final String requiredFeature;

  /// Whether the required feature is active.
  final bool featureEnabled;

  /// Whether the user has the required permission.
  final bool permissionGranted;

  /// Authoritative server decision for current availability.
  final bool available;

  /// Additional features required by this import type.
  final Set<String> requires;

  /// Whether batches are accepted for this import type.
  final bool batchImportSupported;

  /// Reasons why this import type is unavailable.
  final List<MobileCapabilityBlocker> blockers;

  /// Maximum supported batch size, when constrained by the server.
  final int? maxBatchSize;
}

/// A stable reason why a capability is unavailable.
final class MobileCapabilityBlocker {
  /// Creates an immutable capability blocker.
  const MobileCapabilityBlocker({required this.code, required this.message});

  /// Stable blocker code.
  final String code;

  /// Human-readable blocker description.
  final String message;
}
