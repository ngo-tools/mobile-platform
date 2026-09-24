import 'package:flutter/widgets.dart';
import 'package:ngotools_api/ngotools_api.dart';
import 'package:ngotools_auth/ngotools_auth.dart';

import 'mobile_route_requirement.dart';

/// One declarative destination in an organization app.
final class MobileNavigationItem {
  /// Creates an immutable destination.
  const MobileNavigationItem({
    required this.id,
    required this.label,
    required this.icon,
    required this.builder,
    this.selectedIcon,
    this.requirement,
  });

  /// Stable identifier used for selection and deep links.
  final String id;

  /// Localized label shown in navigation controls.
  final String label;

  /// Default navigation icon.
  final IconData icon;

  /// Optional selected navigation icon.
  final IconData? selectedIcon;

  /// Builds the destination content.
  final WidgetBuilder builder;

  /// Access policy for this destination.
  final MobileRouteRequirement? requirement;
}

/// Applies the same server-backed policy to menus and direct route access.
abstract final class MobileNavigationResolver {
  /// Returns only destinations currently allowed for the user.
  static List<MobileNavigationItem> visibleItems({
    required Iterable<MobileNavigationItem> items,
    required MobileAuthStatus authStatus,
    required MobileRuntimeCapabilities? capabilities,
  }) => List.unmodifiable(
    items.where(
      (item) =>
          accessFor(
            item: item,
            authStatus: authStatus,
            capabilities: capabilities,
          ) ==
          MobileRouteAccess.allowed,
    ),
  );

  /// Evaluates a destination for menu selection or a direct link.
  static MobileRouteAccess accessFor({
    required MobileNavigationItem item,
    required MobileAuthStatus authStatus,
    required MobileRuntimeCapabilities? capabilities,
  }) => (item.requirement ?? MobileRouteRequirement()).evaluate(
    authStatus: authStatus,
    capabilities: capabilities,
  );
}
