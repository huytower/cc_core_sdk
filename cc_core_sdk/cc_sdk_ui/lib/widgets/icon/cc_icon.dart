import 'package:flutter/material.dart';

import '../../core/extensions/cc_context_extension.dart';
import '../../core/extensions/common/cc_responsive_extension.dart';
import '../button/cc_bounce_animation.dart';
import '../button/cc_interaction_type.dart';
import '../padding/cc_padding.dart';

class CcIcon extends StatelessWidget {
  final IconData icon;
  final double? size;
  final Color? color;
  final Alignment? align;

  const CcIcon({
    super.key,
    required this.icon,
    this.size,
    this.color,
    this.align,
  });

  @override
  Widget build(BuildContext context) => Align(
    alignment: align ?? Alignment.center,
    child: CcPadding(
      Icon(
        icon,
        size: size ?? context.respIconSize(baseSize: 20.0),
        color: color ?? context.ccColorScheme.onSurface,
      ),
      context.respPadding(8),
      context.respPadding(8),
      context.respPadding(8),
      context.respPadding(8),
    ),
  );
}

class CcMediaIcon extends StatelessWidget {
  final bool isVisible;
  final Color color;
  final IconData icon;
  final double? iconSize;
  final VoidCallback? onTap;
  final CcInteractionType interactionType;

  // Backward compatibility constructor (defaults to bounce)
  const CcMediaIcon({
    super.key,
    this.onTap,
    required this.isVisible,
    required this.icon,
    this.iconSize,
    required this.color,
  }) : interactionType = CcInteractionType.bounce;

  // Private internal constructor
  const CcMediaIcon._({
    required this.interactionType,
    this.onTap,
    required this.isVisible,
    required this.icon,
    this.iconSize,
    required this.color,
    super.key,
  });

  // Named constructors
  factory CcMediaIcon.bouncing({
    VoidCallback? onTap,
    required bool isVisible,
    required IconData icon,
    double? iconSize,
    required Color color,
    Key? key,
  }) =>
      CcMediaIcon._(
        interactionType: CcInteractionType.bounce,
        onTap: onTap,
        isVisible: isVisible,
        icon: icon,
        iconSize: iconSize,
        color: color,
        key: key,
      );

  factory CcMediaIcon.simple({
    VoidCallback? onTap,
    required bool isVisible,
    required IconData icon,
    double? iconSize,
    required Color color,
    Key? key,
  }) =>
      CcMediaIcon._(
        interactionType: CcInteractionType.tap,
        onTap: onTap,
        isVisible: isVisible,
        icon: icon,
        iconSize: iconSize,
        color: color,
        key: key,
      );

  factory CcMediaIcon.static({
    required bool isVisible,
    required IconData icon,
    double? iconSize,
    required Color color,
    Key? key,
  }) =>
      CcMediaIcon._(
        interactionType: CcInteractionType.none,
        isVisible: isVisible,
        icon: icon,
        iconSize: iconSize,
        color: color,
        key: key,
      );

  @override
  Widget build(BuildContext context) {
    final child = Stack(
      children: [
        isVisible
            ? CcIcon(
                icon: icon,
                size: iconSize ?? context.respIconSize(baseSize: 20.0),
                color: color,
                align: Alignment.center,
              )
            : const SizedBox(width: 35),
      ],
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
