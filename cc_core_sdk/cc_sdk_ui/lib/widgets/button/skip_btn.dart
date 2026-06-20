import 'package:cc_sdk/export_cc_sdk.dart';
import 'package:easy_localization/easy_localization.dart' as el;
import 'package:flutter/material.dart';

import '../../core/config/tokens/cc_padding_params.dart';
import '../../core/extensions/cc_context_extension.dart';
import '../../core/extensions/common/cc_responsive_extension.dart';
import '../padding/cc_padding.dart';
import '../text/cc_text.dart';
import 'cc_bounce_animation.dart';
import 'cc_interaction_type.dart';

class SkipBtn extends StatelessWidget {
  final VoidCallback onTap;
  final CcInteractionType interactionType;

  // Backward compatibility constructor (defaults to bounce)
  const SkipBtn({
    super.key,
    required this.onTap,
  }) : interactionType = CcInteractionType.bounce;

  // Private internal constructor
  const SkipBtn._({
    required this.interactionType,
    required this.onTap,
    super.key,
  });

  // Named constructors
  factory SkipBtn.bouncing({
    required VoidCallback onTap,
    Key? key,
  }) =>
      SkipBtn._(
        interactionType: CcInteractionType.bounce,
        onTap: onTap,
        key: key,
      );

  factory SkipBtn.simple({
    required VoidCallback onTap,
    Key? key,
  }) =>
      SkipBtn._(
        interactionType: CcInteractionType.tap,
        onTap: onTap,
        key: key,
      );

  factory SkipBtn.static({
    Key? key,
  }) =>
      SkipBtn._(
        interactionType: CcInteractionType.none,
        onTap: () {},
        key: key,
      );

  @override
  Widget build(BuildContext context) {
    final child = CcPadding(
      Container(
        width: context.respIconSize(baseSize: 103.0),
        height: context.respIconSize(baseSize: 76.0),
        decoration: BoxDecoration(
          color: Colors.transparent,
          borderRadius: BorderRadius.circular(
            context.respDim(CcPaddingParams.DESC_SM),
          ),
        ),
        child: Center(
          child: CcText(
            el.tr(CcLocaleKeys.common_skip),
            align: Alignment.center,
            textAlign: TextAlign.center,
            color: context.ccColorScheme.onSurfaceVariant,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      0,
      context.respPadding(CcPaddingParams.PAGE_LG),
      0,
      0,
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
          onTap: onTap,
          child: child,
        );
    }
  }
}
