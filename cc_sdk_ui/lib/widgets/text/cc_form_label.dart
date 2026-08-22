import 'package:cc_sdk_ui/export_cc_sdk_ui.dart';
import 'package:flutter/material.dart';

/// Reusable form label component.
/// State-management agnostic widget - can be used with any state management approach.
class CcFormLabel extends StatelessWidget {
  final String text;
  final Color? color;
  final Alignment? align;
  final TextAlign? textAlign;

  const CcFormLabel({
    super.key,
    required this.text,
    this.color,
    this.align,
    this.textAlign,
  });

  @override
  Widget build(BuildContext context) {
    return CcText(
      text,
      align: align,
      textAlign: textAlign,
      textStyle: context.ccTextTheme.labelMedium?.copyWith(
        color: color ?? context.ccColorScheme.onSurfaceVariant,
        fontWeight: FontWeight.bold,
      ),
    );
  }
}
