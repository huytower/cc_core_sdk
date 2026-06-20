import 'package:flutter/material.dart';

import '../../core/extensions/cc_context_extension.dart';
import '../../core/extensions/common/cc_responsive_extension.dart';
import '../icon/cc_icon.dart';
import '../padding/cc_padding.dart';
import 'cc_bounce_animation.dart';
import 'cc_interaction_type.dart';

/// Refresh button with refresh icon
class CcRefreshBtn extends StatelessWidget {
  final Color? iconColor;
  final double? height, width;
  final VoidCallback? onTap;
  final CcInteractionType interactionType;

  // Backward compatibility constructor (defaults to bounce)
  const CcRefreshBtn({
    super.key,
    required this.onTap,
    this.iconColor,
    this.height,
    this.width,
  }) : interactionType = CcInteractionType.bounce;

  // Private internal constructor
  const CcRefreshBtn._({
    required this.interactionType,
    this.onTap,
    this.iconColor,
    this.height,
    this.width,
    super.key,
  });

  // Named constructors
  factory CcRefreshBtn.bouncing({
    required VoidCallback onTap,
    Color? iconColor,
    double? height,
    double? width,
    Key? key,
  }) =>
      CcRefreshBtn._(
        interactionType: CcInteractionType.bounce,
        onTap: onTap,
        iconColor: iconColor,
        height: height,
        width: width,
        key: key,
      );

  factory CcRefreshBtn.simple({
    required VoidCallback onTap,
    Color? iconColor,
    double? height,
    double? width,
    Key? key,
  }) =>
      CcRefreshBtn._(
        interactionType: CcInteractionType.tap,
        onTap: onTap,
        iconColor: iconColor,
        height: height,
        width: width,
        key: key,
      );

  factory CcRefreshBtn.static({
    Color? iconColor,
    double? height,
    double? width,
    Key? key,
  }) =>
      CcRefreshBtn._(
        interactionType: CcInteractionType.none,
        iconColor: iconColor,
        height: height,
        width: width,
        key: key,
      );

  @override
  Widget build(BuildContext context) {
    final child = CcPadding(
      CcIcon(
        icon: Icons.refresh,
        size: context.respIconSize(baseSize: 20.0),
        align: Alignment.center,
        color: iconColor ?? context.ccColorScheme.onSurface,
      ),
      context.respPadding(4),
      context.respPadding(4),
      context.respPadding(4),
      context.respPadding(4),
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
        return CcBounceAnimation(onTap: onTap ?? () {}, child: child);
    }
  }
}
