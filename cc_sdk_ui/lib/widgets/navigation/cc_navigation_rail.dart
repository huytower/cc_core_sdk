import 'package:cc_sdk_ui/export_cc_sdk_ui.dart';
import 'package:flutter/material.dart';

/// Side navigation for wide windows — the counterpart of
/// [CcCurvedNavigationBar] on compact ones.
///
/// Takes the same [CcCurvedNavigationItem]s (icons, label, badge) so a shell
/// can switch between the two from one item list, and uses the same
/// theme-aware default colors.
class CcNavigationRail extends StatelessWidget {
  const CcNavigationRail({
    super.key,
    required this.items,
    required this.currentIndex,
    required this.onTap,
    this.backgroundColor,
    this.activeColor,
    this.activeIconColor,
    this.inactiveColor,
    this.useSafeArea = true,
  });

  final List<CcCurvedNavigationItem> items;
  final int currentIndex;
  final ValueChanged<int> onTap;

  /// Rail background. Defaults to white (light) / transparent (dark).
  final Color? backgroundColor;

  /// Selected indicator and selected label color.
  final Color? activeColor;

  /// Icon color on top of the selected indicator.
  final Color? activeIconColor;

  /// Unselected icon and label color.
  final Color? inactiveColor;

  /// Pads for the leading system inset (status bar, landscape notch).
  final bool useSafeArea;

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDarkMode;
    final active = activeColor ?? CcBaseColors.brand500;
    final inactive =
        inactiveColor ??
        (isDark ? CcBaseColors.white50 : CcBaseColors.neutral50);
    final iconSize = context.respIconSize();

    final rail = NavigationRail(
      selectedIndex: currentIndex,
      onDestinationSelected: onTap,
      labelType: NavigationRailLabelType.all,
      groupAlignment: 0,
      backgroundColor:
          backgroundColor ??
          (isDark ? CcBaseColors.transparent : CcBaseColors.white100),
      indicatorColor: active,
      selectedIconTheme: IconThemeData(
        color: activeIconColor ?? CcBaseColors.white100,
        size: iconSize,
      ),
      unselectedIconTheme: IconThemeData(color: inactive, size: iconSize),
      selectedLabelTextStyle: context.ccTextTheme.labelMedium?.copyWith(
        color: active,
        fontWeight: CcTypographyParams.bold,
      ),
      unselectedLabelTextStyle: context.ccTextTheme.labelMedium?.copyWith(
        color: inactive,
        fontWeight: CcTypographyParams.regular,
      ),
      destinations: [
        for (final item in items)
          NavigationRailDestination(
            icon: _withBadge(Icon(item.inactiveIcon), item),
            selectedIcon: _withBadge(Icon(item.activeIcon), item),
            label: Text(item.label),
          ),
      ],
    );

    return useSafeArea ? SafeArea(right: false, child: rail) : rail;
  }

  Widget _withBadge(Widget icon, CcCurvedNavigationItem item) {
    final badgeWidget = item.badgeWidget;
    if (badgeWidget != null) {
      return Stack(
        clipBehavior: Clip.none,
        children: [
          icon,
          Positioned(top: -2, right: -2, child: badgeWidget),
        ],
      );
    }
    final badgeText = item.badgeText;
    if (badgeText != null) {
      return Badge(
        label: Text(badgeText),
        backgroundColor: item.badgeColor,
        textColor: item.badgeTextColor,
        child: icon,
      );
    }
    return icon;
  }
}
