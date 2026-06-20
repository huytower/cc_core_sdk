import 'package:flutter/material.dart';

import '../../core/extensions/cc_context_extension.dart';
import '../../core/extensions/common/cc_responsive_extension.dart';
import '../icon/cc_icon.dart';
import '../padding/cc_padding.dart';
import 'cc_bounce_animation.dart';

enum CcInteractionType { none, tap, bounce }

class CcBackBtn extends StatelessWidget {
  final IconData? icon;
  final VoidCallback? onTap;
  final CcInteractionType interactionType;

  // Private internal constructor
  const CcBackBtn._({
    required this.interactionType,
    this.onTap,
    this.icon,
    super.key,
  });

  // Named constructors
  factory CcBackBtn.bouncing({
    required VoidCallback onTap,
    IconData? icon,
    Key? key,
  }) => CcBackBtn._(
    interactionType: CcInteractionType.bounce,
    onTap: onTap,
    icon: icon,
    key: key,
  );

  factory CcBackBtn.simple({
    required VoidCallback onTap,
    IconData? icon,
    Key? key,
  }) => CcBackBtn._(
    interactionType: CcInteractionType.tap,
    onTap: onTap,
    icon: icon,
    key: key,
  );

  factory CcBackBtn.static({IconData? icon, Key? key}) => CcBackBtn._(
    interactionType: CcInteractionType.none,
    icon: icon,
    key: key,
  );

  @override
  Widget build(BuildContext context) {
    final child = CcPadding(
      CcIcon(
        icon: icon ?? Icons.arrow_back,
        size: context.respIconSize(baseSize: 20.0),
        align: Alignment.center,
        color: context.ccColorScheme.onSurface,
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
