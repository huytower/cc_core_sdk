import 'package:cc_sdk_ui/export_cc_sdk_ui.dart';
import 'package:flutter/material.dart';

/// A horizontal stat row with a leading [icon], faded [label], and bold
/// [formattedValue] in [color].
class CcStatItem extends StatelessWidget {
  final String label;
  final String formattedValue;
  final Color color;
  final Widget icon;

  const CcStatItem({
    super.key,
    required this.label,
    required this.formattedValue,
    required this.color,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const CcSpaceXS(),
        SizedBox(
          width: context.respIconSize(baseSize: 24),
          height: context.respIconSize(baseSize: 24),
          child: icon,
        ),
        const CcSpaceMD(),
        CcText(
          label,
          textStyle: context.ccTextTheme.labelSmall?.copyWith(
            color: context.ccColorScheme.onSurfaceVariant.withAlpha(90),
          ),
        ),
        const Spacer(),
        CcText(
          formattedValue,
          align: Alignment.center,
          textAlign: TextAlign.center,
          textStyle: context.ccTextTheme.labelLarge?.copyWith(
            fontWeight: CcTypographyParams.bold,
            color: color,
          ),
        ),
      ],
    );
  }
}

