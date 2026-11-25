import 'package:flutter/widgets.dart';

/// Tells pages whether a [CcNavigationRail] sits on their leading edge, so
/// edges that touch it can adapt — e.g. a hero header squares the corner next
/// to the rail instead of rounding it into a floating card.
///
/// The navigation shell places it around the page content (always present,
/// so switching layouts does not change the tree shape).
class CcNavigationRailScope extends InheritedWidget {
  const CcNavigationRailScope({
    super.key,
    required this.railVisible,
    required super.child,
  });

  final bool railVisible;

  /// Whether a rail is beside the calling widget's page; false outside a
  /// scope (phones, pushed routes).
  static bool railVisibleOf(BuildContext context) =>
      context
          .dependOnInheritedWidgetOfExactType<CcNavigationRailScope>()
          ?.railVisible ??
      false;

  @override
  bool updateShouldNotify(CcNavigationRailScope oldWidget) =>
      railVisible != oldWidget.railVisible;
}

