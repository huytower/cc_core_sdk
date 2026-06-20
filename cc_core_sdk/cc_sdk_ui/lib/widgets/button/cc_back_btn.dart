import 'package:flutter/material.dart';

import '../../core/extensions/cc_context_extension.dart';
import '../../core/extensions/common/cc_responsive_extension.dart';
import '../icon/cc_icon.dart';
import '../padding/cc_padding.dart';
import 'cc_bounce_animation.dart';
import 'cc_debounce_widget.dart';
import 'cc_interaction_type.dart';

class CcBackBtn extends StatelessWidget {
  final IconData? icon;
  final VoidCallback? onTap;
  final CcInteractionType interactionType;
  final bool useDebounce;

  // Backward compatibility constructor (defaults to bounce)
  const CcBackBtn({
    required this.onTap,
    this.icon,
    super.key,
    this.useDebounce = true,
  }) : interactionType = CcInteractionType.bounce;

  // Private internal constructor
  const CcBackBtn._({
    required this.interactionType,
    this.onTap,
    this.icon,
    this.useDebounce = true,
    super.key,
  });

  // Named constructors
  factory CcBackBtn.bouncing({
    required VoidCallback onTap,
    IconData? icon,
    bool useDebounce = true,
    Key? key,
  }) => CcBackBtn._(
    interactionType: CcInteractionType.bounce,
    onTap: onTap,
    icon: icon,
    useDebounce: useDebounce,
    key: key,
  );

  factory CcBackBtn.simple({
    required VoidCallback onTap,
    IconData? icon,
    bool useDebounce = true,
    Key? key,
  }) => CcBackBtn._(
    interactionType: CcInteractionType.tap,
    onTap: onTap,
    icon: icon,
    useDebounce: useDebounce,
    key: key,
  );

  factory CcBackBtn.static({IconData? icon, Key? key}) => CcBackBtn._(
    interactionType: CcInteractionType.none,
    icon: icon,
    useDebounce: false,
    key: key,
  );

  @override
  Widget build(BuildContext context) {
    final rawChild = CcPadding(
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

    Widget buildInteractive(Widget child) {
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

    final interactiveWidget = buildInteractive(rawChild);

    if (useDebounce && interactionType != CcInteractionType.none) {
      return CcDebounce(onTap: onTap, child: interactiveWidget);
    }

    return interactiveWidget;
  }
}
