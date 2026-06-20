import 'package:flutter/material.dart';

import '../../core/extensions/cc_context_extension.dart';
import '../../core/extensions/common/cc_responsive_extension.dart';
import '../icon/cc_icon.dart';
import '../padding/cc_padding.dart';
import 'cc_bounce_animation.dart';
import 'cc_interaction_type.dart';

/// Download button with download icon
class CcDownloadBtn extends StatelessWidget {
  final Color? iconColor;
  final double? height, width;
  final VoidCallback? onTap;
  final CcInteractionType interactionType;

  // Backward compatibility constructor (defaults to bounce)
  const CcDownloadBtn({
    super.key,
    required this.onTap,
    this.iconColor,
    this.height,
    this.width,
  }) : interactionType = CcInteractionType.bounce;

  // Private internal constructor
  const CcDownloadBtn._({
    required this.interactionType,
    this.onTap,
    this.iconColor,
    this.height,
    this.width,
    super.key,
  });

  // Named constructors
  factory CcDownloadBtn.bouncing({
    required VoidCallback onTap,
    Color? iconColor,
    double? height,
    double? width,
    Key? key,
  }) =>
      CcDownloadBtn._(
        interactionType: CcInteractionType.bounce,
        onTap: onTap,
        iconColor: iconColor,
        height: height,
        width: width,
        key: key,
      );

  factory CcDownloadBtn.simple({
    required VoidCallback onTap,
    Color? iconColor,
    double? height,
    double? width,
    Key? key,
  }) =>
      CcDownloadBtn._(
        interactionType: CcInteractionType.tap,
        onTap: onTap,
        iconColor: iconColor,
        height: height,
        width: width,
        key: key,
      );

  factory CcDownloadBtn.static({
    Color? iconColor,
    double? height,
    double? width,
    Key? key,
  }) =>
      CcDownloadBtn._(
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
        icon: Icons.download,
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
