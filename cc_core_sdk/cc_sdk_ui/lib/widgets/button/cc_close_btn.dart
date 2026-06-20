import 'package:flutter/material.dart';

import '../../core/extensions/cc_context_extension.dart';
import '../../core/extensions/common/cc_responsive_extension.dart';
import 'cc_bounce_animation.dart';

enum CcInteractionType {
  none,
  tap,
  bounce,
}

/// Standardized Close Button.
///
/// If no [icon] is provided, it defaults to [Icons.close].
class CcCloseBtn extends StatelessWidget {
  final Color? bgColor;
  final double? height, width;
  final Widget? icon;
  final VoidCallback? onTap;
  final Color? iconColor;
  final CcInteractionType interactionType;

  // Private internal constructor
  const CcCloseBtn._({
    required this.interactionType,
    this.onTap,
    this.bgColor,
    this.height,
    this.width,
    this.icon,
    this.iconColor,
    super.key,
  });

  // Named constructors (The "API" for other developers)
  factory CcCloseBtn.bouncing({
    required VoidCallback onTap,
    Color? bgColor,
    double? height,
    double? width,
    Widget? icon,
    Color? iconColor,
    Key? key,
  }) =>
      CcCloseBtn._(
        interactionType: CcInteractionType.bounce,
        onTap: onTap,
        bgColor: bgColor,
        height: height,
        width: width,
        icon: icon,
        iconColor: iconColor,
        key: key,
      );

  factory CcCloseBtn.simple({
    required VoidCallback onTap,
    Color? bgColor,
    double? height,
    double? width,
    Widget? icon,
    Color? iconColor,
    Key? key,
  }) =>
      CcCloseBtn._(
        interactionType: CcInteractionType.tap,
        onTap: onTap,
        bgColor: bgColor,
        height: height,
        width: width,
        icon: icon,
        iconColor: iconColor,
        key: key,
      );

  factory CcCloseBtn.static({
    Color? bgColor,
    double? height,
    double? width,
    Widget? icon,
    Color? iconColor,
    Key? key,
  }) =>
      CcCloseBtn._(
        interactionType: CcInteractionType.none,
        bgColor: bgColor,
        height: height,
        width: width,
        icon: icon,
        iconColor: iconColor,
        key: key,
      );

  @override
  Widget build(BuildContext context) {
    final double defaultSize = context.respIconSize(baseSize: 35.0);
    final double defaultIconSize = context.respIconSize(baseSize: 20.0);

    final child = SizedBox(
      width: width ?? defaultSize,
      height: height ?? defaultSize,
      child: Container(
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: bgColor ?? Colors.transparent,
          shape: BoxShape.circle,
        ),
        child:
            icon ??
            Icon(
              Icons.close,
              size: defaultIconSize,
              color: iconColor ?? context.ccColorScheme.onSurface,
            ),
      ),
    );

    switch (interactionType) {
      case CcInteractionType.none:
        return Center(child: child);
      case CcInteractionType.tap:
        return Center(
          child: GestureDetector(
            onTap: onTap,
            behavior: HitTestBehavior.opaque,
            child: child,
          ),
        );
      case CcInteractionType.bounce:
        return Center(
          child: CcBounceAnimation(
            onTap: onTap ?? () {},
            child: child,
          ),
        );
    }
  }
}
