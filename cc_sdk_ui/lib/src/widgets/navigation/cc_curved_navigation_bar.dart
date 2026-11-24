import 'package:cc_sdk_ui/export_cc_sdk_ui.dart';
import 'package:cc_sdk_ui/src/widgets/navigation/curved/cc_curved_bar_view.dart';
import 'package:flutter/material.dart';

/// Bottom navigation bar with a curved notch and an elastic bubble under the
/// selected item (2 to 6 [items]), themed with the design-system tokens.
///
/// ```dart
/// CcCurvedNavigationBar(items: items, currentIndex: index, onTap: select)
/// ```
class CcCurvedNavigationBar extends StatelessWidget {
  const CcCurvedNavigationBar({
    super.key,
    required this.items,
    required this.currentIndex,
    required this.onTap,
    this.backgroundColor,
    this.activeColor,
    this.activeIconColor,
    this.inactiveColor,
    this.fabColor,
    this.barHeight,
    this.fabRadius,
    this.fabGap,
    this.fabSink,
    this.notchShoulderRadius,
    this.cornerRadius,
    this.contentPadding,
    this.elevation,
    this.shadowColor,
    this.animationDuration,
    this.animationCurve,
    this.activeTextStyle,
    this.inactiveTextStyle,
    this.inactiveIconSize,
    this.activeIconSize,
    this.useSafeArea = true,
  });

  /// List of navigation items to display
  final List<CcCurvedNavigationItem> items;

  /// Currently selected index
  final int currentIndex;

  /// Callback when an item is tapped
  final ValueChanged<int> onTap;

  /// Background color of the navigation bar
  final Color? backgroundColor;

  /// Color of the active item background
  final Color? activeColor;

  /// Color of the active icon
  final Color? activeIconColor;

  /// Color of inactive items
  final Color? inactiveColor;

  /// Color of the FAB (floating action button)
  final Color? fabColor;

  /// Height of the navigation bar
  final double? barHeight;

  /// Radius of the FAB
  final double? fabRadius;

  /// Gap between FAB and bar
  final double? fabGap;

  /// Sink depth of the FAB
  final double? fabSink;

  /// Radius of the notch shoulders
  final double? notchShoulderRadius;

  /// Corner radius of the bar
  final double? cornerRadius;

  /// Content padding inside the bar
  final double? contentPadding;

  /// Elevation (shadow) of the bar
  final double? elevation;

  /// Color of the shadow
  final Color? shadowColor;

  /// Duration of the animation
  final Duration? animationDuration;

  /// Curve for the animation
  final Curve? animationCurve;

  /// Text style for active labels
  final TextStyle? activeTextStyle;

  /// Text style for inactive labels
  final TextStyle? inactiveTextStyle;

  /// Size of inactive icons
  final double? inactiveIconSize;

  /// Size of active icons
  final double? activeIconSize;

  /// Whether the bar adds the system bottom inset (and a SafeArea) itself.
  /// Set to false when the caller already pads for the system bar, otherwise
  /// the inset is applied twice and the bar grows taller than intended.
  final bool useSafeArea;

  @override
  Widget build(BuildContext context) {
    final hasDark = context.hasDarkMode;

    // Theme-aware default colors
    // Use transparent in Dark Mode to avoid "black spots" on curved corners
    // when placed over gradients. Keep white in Light Mode as it works correctly.
    final themeBackgroundColor =
        backgroundColor ??
        (hasDark ? CcBaseColors.transparent : CcBaseColors.white100);
    final themeActiveColor = activeColor ?? CcBaseColors.brand500;
    final themeActiveIconColor = activeIconColor ?? CcBaseColors.white100;
    final themeInactiveColor =
        inactiveColor ??
        (hasDark ? CcBaseColors.white50 : CcBaseColors.neutral50);
    final themeFabColor = fabColor ?? CcBaseColors.brand500;
    final themeShadowColor =
        shadowColor ??
        (hasDark ? CcBaseColors.transparent : CcBaseColors.neutral10);

    return CcCurvedBarView(
      items: items,
      currentIndex: currentIndex,
      onTap: onTap,
      backgroundColor: themeBackgroundColor,
      activeColor: themeActiveColor,
      activeIconColor: themeActiveIconColor,
      inactiveColor: themeInactiveColor,
      fabColor: themeFabColor,
      barHeight: barHeight ?? context.respDim(77),
      fabRadius: fabRadius ?? context.respDim(CcCircularParams.FAB * 2 / 3),
      fabGap: fabGap ?? context.respDim(3),
      fabSink: fabSink ?? context.respDim(50),
      notchShoulderRadius:
          notchShoulderRadius ?? context.respDim(CcCircularParams.NOTCH),
      cornerRadius: cornerRadius ?? context.respDim(CcCircularParams.DIALOG),
      contentPadding: contentPadding ?? context.respPadding(8),
      elevation: elevation ?? context.respDim(14),
      shadowColor: themeShadowColor,
      animationDuration: animationDuration ?? const Duration(milliseconds: 400),
      animationCurve: animationCurve ?? Curves.easeInOutCubic,
      activeTextStyle:
          activeTextStyle ??
          context.ccTextTheme.labelMedium?.copyWith(
            fontWeight: CcTypographyParams.bold,
          ) ??
          const TextStyle(fontWeight: CcTypographyParams.bold),
      inactiveTextStyle:
          inactiveTextStyle ??
          context.ccTextTheme.labelMedium?.copyWith(
            fontWeight: CcTypographyParams.regular,
          ) ??
          const TextStyle(fontWeight: CcTypographyParams.regular),
      inactiveIconSize: inactiveIconSize ?? context.respIconSize(baseSize: 29),
      activeIconSize: activeIconSize ?? context.respIconSize(baseSize: 26),
      useSafeArea: useSafeArea,
    );
  }
}

