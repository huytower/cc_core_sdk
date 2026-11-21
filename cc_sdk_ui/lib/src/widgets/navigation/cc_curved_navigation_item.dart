import 'package:flutter/widgets.dart';

/// One destination of [CcCurvedNavigationBar] and [CcNavigationRail].
///
/// ```dart
/// CcCurvedNavigationItem(
///   inactiveIcon: Icons.home_outlined,
///   activeIcon: Icons.home_rounded,
///   label: 'Home',
/// )
/// ```
@immutable
class CcCurvedNavigationItem {
  const CcCurvedNavigationItem({
    required this.inactiveIcon,
    required this.activeIcon,
    required this.label,
    this.badgeText,
    this.badgeColor,
    this.badgeTextColor,
    this.badgeWidget,
  });

  /// Icon to show when item is inactive
  final IconData inactiveIcon;

  /// Icon to show when item is active
  final IconData activeIcon;

  /// Label text for the item
  final String label;

  /// Optional badge text (e.g., "3", "99+", "•")
  final String? badgeText;

  /// Optional custom badge color
  final Color? badgeColor;

  /// Optional custom badge text color
  final Color? badgeTextColor;

  /// Optional custom badge widget (overrides text-based badge)
  final Widget? badgeWidget;
}
