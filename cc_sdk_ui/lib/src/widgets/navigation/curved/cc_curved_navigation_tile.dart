// Adapted from curved_navigation_bar_pro 2.2.3
// (https://pub.dev/packages/curved_navigation_bar_pro), MIT License,
// Copyright (c) 2026 aslamambiloly. Full notice: LICENSE in this folder.

import 'package:cc_sdk_ui/src/widgets/navigation/cc_curved_navigation_item.dart';
import 'package:cc_sdk_ui/src/widgets/navigation/curved/cc_curved_bubble.dart';
import 'package:flutter/material.dart';

/// One item of the curved bar: inactive icon (hidden while selected, as the
/// bubble shows it) and label.
class CcCurvedNavigationTile extends StatelessWidget {
  const CcCurvedNavigationTile({
    super.key,
    required this.item,
    required this.isActive,
    required this.activeColor,
    required this.inactiveColor,
    required this.inactiveIconSize,
    required this.animationDuration,
    required this.activeTextStyle,
    required this.inactiveTextStyle,
    required this.barBackgroundColor,
    required this.useSafeArea,
    required this.onTap,
  });

  final CcCurvedNavigationItem item;
  final bool isActive;
  final Color activeColor;
  final Color inactiveColor;
  final double inactiveIconSize;
  final Duration animationDuration;
  final TextStyle activeTextStyle;
  final TextStyle inactiveTextStyle;
  final Color barBackgroundColor;
  final bool useSafeArea;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    Widget content = Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        AnimatedOpacity(
          opacity: isActive ? 0.0 : 1.0,
          duration: const Duration(milliseconds: 100),
          child: CcCurvedBadge(
            badgeText: item.badgeText,
            badgeColor: item.badgeColor,
            badgeTextColor: item.badgeTextColor,
            badgeWidget: item.badgeWidget,
            borderColor: barBackgroundColor,
            child: Icon(
              item.inactiveIcon,
              color: inactiveColor,
              size: inactiveIconSize,
            ),
          ),
        ),
        // Unscaled, as in the original bar: the bar height is what scales.
        const SizedBox(height: 10),
        _buildLabel(),
      ],
    );

    if (useSafeArea) {
      content = SafeArea(
        top: false,
        left: false,
        right: false,
        child: content,
      );
    }

    return Semantics(
      label: item.label,
      selected: isActive,
      button: true,
      child: GestureDetector(
        onTap: onTap,
        behavior: HitTestBehavior.opaque,
        child: content,
      ),
    );
  }

  Widget _buildLabel() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Expanded(
          child: AnimatedDefaultTextStyle(
            duration: animationDuration,
            style: isActive
                ? activeTextStyle.copyWith(color: activeColor)
                : inactiveTextStyle.copyWith(color: inactiveColor),
            child: Text(
              item.label,
              maxLines: 1,
              softWrap: false,
              overflow: TextOverflow.fade,
              textAlign: TextAlign.center,
            ),
          ),
        ),
      ],
    );
  }
}
