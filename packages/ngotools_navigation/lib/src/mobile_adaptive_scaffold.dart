import 'package:flutter/material.dart';
import 'package:ngotools_api/ngotools_api.dart';
import 'package:ngotools_auth/ngotools_auth.dart';

import 'mobile_navigation.dart';

/// Responsive navigation shell for NGO.Tools organization apps.
final class MobileAdaptiveScaffold extends StatefulWidget {
  /// Creates an adaptive shell backed by effective server access.
  const MobileAdaptiveScaffold({
    required this.items,
    required this.authStatus,
    required this.capabilities,
    this.title,
    this.breakpoint = 840,
    this.emptyBuilder,
    this.onDestinationChanged,
    super.key,
  });

  /// Candidate destinations before policy filtering.
  final List<MobileNavigationItem> items;

  /// Current authentication state.
  final MobileAuthStatus authStatus;

  /// Last effective server capability snapshot.
  final MobileRuntimeCapabilities? capabilities;

  /// Optional application title.
  final Widget? title;

  /// Minimum width at which a navigation rail is used.
  final double breakpoint;

  /// Builds content when no destination is available.
  final WidgetBuilder? emptyBuilder;

  /// Called after the selected destination changes.
  final ValueChanged<String>? onDestinationChanged;

  @override
  State<MobileAdaptiveScaffold> createState() => _MobileAdaptiveScaffoldState();
}

final class _MobileAdaptiveScaffoldState extends State<MobileAdaptiveScaffold> {
  String? _selectedId;

  @override
  void initState() {
    super.initState();
    _selectedId = _firstVisibleId(widget);
  }

  @override
  void didUpdateWidget(covariant MobileAdaptiveScaffold oldWidget) {
    super.didUpdateWidget(oldWidget);
    final visibleItems = _visibleItems(widget);

    if (visibleItems.every((item) => item.id != _selectedId)) {
      _selectedId = visibleItems.isEmpty ? null : visibleItems.first.id;
    }
  }

  @override
  Widget build(BuildContext context) {
    final visibleItems = _visibleItems(widget);

    if (visibleItems.isEmpty) {
      return Scaffold(
        appBar: widget.title == null ? null : AppBar(title: widget.title),
        body:
            widget.emptyBuilder?.call(context) ??
            const Center(child: Text('No available destinations')),
      );
    }

    final selectedIndex = visibleItems.indexWhere(
      (item) => item.id == _selectedId,
    );
    final effectiveIndex = selectedIndex < 0 ? 0 : selectedIndex;
    final selectedItem = visibleItems[effectiveIndex];

    if (visibleItems.length == 1) {
      return Scaffold(
        appBar: widget.title == null ? null : AppBar(title: widget.title),
        body: KeyedSubtree(
          key: ValueKey(selectedItem.id),
          child: selectedItem.builder(context),
        ),
      );
    }

    return LayoutBuilder(
      builder: (context, constraints) {
        final useRail = constraints.maxWidth >= widget.breakpoint;
        final navigationDestinations = visibleItems
            .map(
              (item) => NavigationDestination(
                icon: Icon(item.icon),
                selectedIcon: Icon(item.selectedIcon ?? item.icon),
                label: item.label,
              ),
            )
            .toList(growable: false);

        if (!useRail) {
          return Scaffold(
            appBar: widget.title == null ? null : AppBar(title: widget.title),
            body: KeyedSubtree(
              key: ValueKey(selectedItem.id),
              child: selectedItem.builder(context),
            ),
            bottomNavigationBar: NavigationBar(
              selectedIndex: effectiveIndex,
              onDestinationSelected: (index) => _select(visibleItems[index].id),
              destinations: navigationDestinations,
            ),
          );
        }

        return Scaffold(
          appBar: widget.title == null ? null : AppBar(title: widget.title),
          body: Row(
            children: [
              NavigationRail(
                selectedIndex: effectiveIndex,
                onDestinationSelected: (index) =>
                    _select(visibleItems[index].id),
                labelType: NavigationRailLabelType.all,
                destinations: visibleItems
                    .map(
                      (item) => NavigationRailDestination(
                        icon: Icon(item.icon),
                        selectedIcon: Icon(item.selectedIcon ?? item.icon),
                        label: Text(item.label),
                      ),
                    )
                    .toList(growable: false),
              ),
              const VerticalDivider(width: 1),
              Expanded(
                child: KeyedSubtree(
                  key: ValueKey(selectedItem.id),
                  child: selectedItem.builder(context),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void _select(String id) {
    if (id == _selectedId) {
      return;
    }

    setState(() => _selectedId = id);
    widget.onDestinationChanged?.call(id);
  }

  static List<MobileNavigationItem> _visibleItems(
    MobileAdaptiveScaffold widget,
  ) => MobileNavigationResolver.visibleItems(
    items: widget.items,
    authStatus: widget.authStatus,
    capabilities: widget.capabilities,
  );

  static String? _firstVisibleId(MobileAdaptiveScaffold widget) {
    final items = _visibleItems(widget);

    return items.isEmpty ? null : items.first.id;
  }
}
