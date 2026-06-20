import 'package:cc_sdk/export_cc_sdk.dart';
import 'package:easy_localization/easy_localization.dart' as el;
import 'package:flutter/material.dart';

import '../../core/extensions/cc_context_extension.dart';
import 'cc_base_btn.dart';
import 'cc_bounce_animation.dart';
import 'cc_interaction_type.dart';

class NextBtn extends StatelessWidget {
  final VoidCallback onTap;
  final String? title;
  final bool isEnable;
  final CcInteractionType interactionType;

  // Backward compatibility constructor (defaults to bounce)
  const NextBtn({
    super.key,
    required this.onTap,
    this.title,
    this.isEnable = true,
  }) : interactionType = CcInteractionType.bounce;

  // Private internal constructor
  const NextBtn._({
    required this.interactionType,
    required this.onTap,
    this.title,
    this.isEnable = true,
    super.key,
  });

  // Named constructors
  factory NextBtn.bouncing({
    required VoidCallback onTap,
    String? title,
    bool isEnable = true,
    Key? key,
  }) =>
      NextBtn._(
        interactionType: CcInteractionType.bounce,
        onTap: onTap,
        title: title,
        isEnable: isEnable,
        key: key,
      );

  factory NextBtn.simple({
    required VoidCallback onTap,
    String? title,
    bool isEnable = true,
    Key? key,
  }) =>
      NextBtn._(
        interactionType: CcInteractionType.tap,
        onTap: onTap,
        title: title,
        isEnable: isEnable,
        key: key,
      );

  factory NextBtn.static({
    String? title,
    bool isEnable = true,
    Key? key,
  }) =>
      NextBtn._(
        interactionType: CcInteractionType.none,
        onTap: () {},
        title: title,
        isEnable: isEnable,
        key: key,
      );

  @override
  Widget build(BuildContext context) {
    final child = CcBaseBtn(
      isEnable: isEnable,
      title: title ?? el.tr(CcLocaleKeys.common_next),
      bgColor: isEnable
          ? [context.ccColorScheme.primary, context.ccColorScheme.primary]
          : null, // Fallback to surfaceVariant in CcBaseBtn
      textColor: isEnable
          ? context.ccColorScheme.onPrimary
          : null, // Fallback to onSurfaceVariant in CcBaseBtn
    );

    switch (interactionType) {
      case CcInteractionType.none:
        return child;
      case CcInteractionType.tap:
        return GestureDetector(
          onTap: isEnable ? onTap : null,
          behavior: HitTestBehavior.opaque,
          child: child,
        );
      case CcInteractionType.bounce:
        return CcBounceAnimation(
          onTap: isEnable ? onTap : () {},
          child: child,
        );
    }
  }
}
