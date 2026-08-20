import 'package:cc_sdk_ui/export_cc_sdk_ui.dart';
import 'package:flutter/material.dart';

/// A text-based button with bouncing interaction, commonly used for "See all" links.
/// State-management agnostic widget - can be used with any state management approach.
class CcTextButton extends StatelessWidget {
  final String text;
  final VoidCallback? onTap;
  final bool isEnable;

  const CcTextButton({
    super.key,
    required this.text,
    this.onTap,
    this.isEnable = true,
  });

  @override
  Widget build(BuildContext context) {
    final scheme = context.ccColorScheme;
    final buttonText = CcFormLabel(
      text: text,
      color: scheme.primary,
    );

    // If not enabled or no tap handler, return text directly
    if (!isEnable || onTap == null) {
      return buttonText;
    }

    // Otherwise, wrap in bouncing interaction
    return CcInteractBtnWrapper(
      onTap: onTap!,
      useDebounce: true,
      isBouncing: true,
      child: buttonText,
    );
  }
}
