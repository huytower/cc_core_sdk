import 'package:cc_sdk/export_cc_sdk.dart';
import 'package:easy_localization/easy_localization.dart' as el;
import 'package:flutter/material.dart';

import '../../core/extensions/cc_context_extension.dart';
import 'cc_base_btn.dart';
import 'cc_interaction_type.dart';

class CcNextBtn extends StatelessWidget {
  final VoidCallback onTap;
  final String? title;
  final bool isEnable;
  final CcInteractionType interactionType;

  // Backward compatibility constructor (defaults to bounce)
  const CcNextBtn({
    super.key,
    required this.onTap,
    this.title,
    this.isEnable = true,
  }) : interactionType = CcInteractionType.bounce;

  // Private internal constructor
  const CcNextBtn._({
    required this.interactionType,
    required this.onTap,
    this.title,
    this.isEnable = true,
    super.key,
  });

  // Named constructors
  factory CcNextBtn.bouncing({
    required VoidCallback onTap,
    String? title,
    bool isEnable = true,
    Key? key,
  }) => CcNextBtn._(
    interactionType: CcInteractionType.bounce,
    onTap: onTap,
    title: title,
    isEnable: isEnable,
    key: key,
  );

  factory CcNextBtn.simple({
    required VoidCallback onTap,
    String? title,
    bool isEnable = true,
    Key? key,
  }) => CcNextBtn._(
    interactionType: CcInteractionType.tap,
    onTap: onTap,
    title: title,
    isEnable: isEnable,
    key: key,
  );

  factory CcNextBtn.static({String? title, bool isEnable = true, Key? key}) =>
      CcNextBtn._(
        interactionType: CcInteractionType.none,
        onTap: () {},
        title: title,
        isEnable: isEnable,
        key: key,
      );

  @override
  Widget build(BuildContext context) {
    return CcBaseBtn(
      onTap: onTap,
      isEnable: isEnable,
      title: title ?? el.tr(CcLocaleKeys.common_next),
      bgColor: isEnable
          ? [context.ccColorScheme.primary, context.ccColorScheme.primary]
          : null, // Fallback to surfaceVariant in CcBaseBtn
      textColor: isEnable
          ? context.ccColorScheme.onPrimary
          : null, // Fallback to onSurfaceVariant in CcBaseBtn
    );
  }
}
