import 'package:flutter/material.dart';

import '../../core/config/tokens/cc_base_colors.dart';
import '../../core/extensions/common/cc_responsive_extension.dart';
import 'cc_bounce_animation.dart';

enum CcInteractionType {
  none,
  tap,
  bounce,
}

/// Floating action button component for common FAB usage.
/// Provides customizable icon, color, and behavior.
class CcFloatingActionButton extends StatelessWidget {
  final Widget? icon;
  final IconData? iconData;
  final Color backgroundColor;
  final Color foregroundColor;
  final String? heroTag;
  final bool mini;
  final double? elevation;
  final String? tooltip;
  final bool showing;
  final VoidCallback? onTap;
  final CcInteractionType interactionType;

  // Private internal constructor
  const CcFloatingActionButton._({
    required this.interactionType,
    this.icon,
    this.iconData,
    this.backgroundColor = CcBaseColors.neutral70,
    this.foregroundColor = Colors.white,
    this.heroTag,
    this.mini = false,
    this.elevation = 6.0,
    this.tooltip,
    this.showing = true,
    this.onTap,
    super.key,
  });

  // Named constructors
  factory CcFloatingActionButton.bouncing({
    required VoidCallback onTap,
    Widget? icon,
    IconData? iconData,
    Color backgroundColor = CcBaseColors.neutral70,
    Color foregroundColor = Colors.white,
    String? heroTag,
    bool mini = false,
    double? elevation = 6.0,
    String? tooltip,
    bool showing = true,
    Key? key,
  }) =>
      CcFloatingActionButton._(
        interactionType: CcInteractionType.bounce,
        onTap: onTap,
        icon: icon,
        iconData: iconData,
        backgroundColor: backgroundColor,
        foregroundColor: foregroundColor,
        heroTag: heroTag,
        mini: mini,
        elevation: elevation,
        tooltip: tooltip,
        showing: showing,
        key: key,
      );

  factory CcFloatingActionButton.simple({
    required VoidCallback onTap,
    Widget? icon,
    IconData? iconData,
    Color backgroundColor = CcBaseColors.neutral70,
    Color foregroundColor = Colors.white,
    String? heroTag,
    bool mini = false,
    double? elevation = 6.0,
    String? tooltip,
    bool showing = true,
    Key? key,
  }) =>
      CcFloatingActionButton._(
        interactionType: CcInteractionType.tap,
        onTap: onTap,
        icon: icon,
        iconData: iconData,
        backgroundColor: backgroundColor,
        foregroundColor: foregroundColor,
        heroTag: heroTag,
        mini: mini,
        elevation: elevation,
        tooltip: tooltip,
        showing: showing,
        key: key,
      );

  factory CcFloatingActionButton.static({
    Widget? icon,
    IconData? iconData,
    Color backgroundColor = CcBaseColors.neutral70,
    Color foregroundColor = Colors.white,
    String? heroTag,
    bool mini = false,
    double? elevation = 6.0,
    String? tooltip,
    bool showing = true,
    Key? key,
  }) =>
      CcFloatingActionButton._(
        interactionType: CcInteractionType.none,
        icon: icon,
        iconData: iconData,
        backgroundColor: backgroundColor,
        foregroundColor: foregroundColor,
        heroTag: heroTag,
        mini: mini,
        elevation: elevation,
        tooltip: tooltip,
        showing: showing,
        key: key,
      );

  @override
  Widget build(BuildContext context) {
    final effectiveIcon = icon ?? Icon(iconData ?? Icons.add);

    if (!showing) {
      return const SizedBox.shrink();
    }

    final child = DecoratedBox(
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: backgroundColor,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: elevation ?? context.respDim(6.0),
            offset: Offset(0, elevation ?? context.respDim(6.0) / 2),
          ),
        ],
      ),
      child: SizedBox(
        width: mini ? 40 : 56,
        height: mini ? 40 : 56,
        child: Center(child: effectiveIcon),
      ),
    );

    switch (interactionType) {
      case CcInteractionType.none:
        return child;
      case CcInteractionType.tap:
        return GestureDetector(
          onTap: onTap,
          behavior: HitTestBehavior.opaque,
          child: child,
        );
      case CcInteractionType.bounce:
        return CcBounceAnimation(
          onTap: onTap ?? () {},
          child: child,
        );
    }
  }
}
