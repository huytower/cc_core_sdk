import 'package:flutter/material.dart';

import '../../../export_cc_sdk_ui.dart';

/// A compact `label: value` pair in small type: the label faded, the value
/// bold, both in [color].
///
/// ```dart
/// CcStatRow(label: 'Gain', value: '+12%', color: context.ccColorScheme.primary)
/// ```
class CcStatRow extends StatelessWidget {
  const CcStatRow({
    super.key,
    required this.label,
    required this.value,
    required this.color,
  });

  final String label;
  final String value;
  final Color color;

  @override
  Widget build(BuildContext context) {
    final style = context.ccTextTheme.labelSmall;
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        CcText(
          '$label: ',
          textStyle: style?.copyWith(color: color.withValues(alpha: 0.7)),
        ),
        CcText(
          value,
          textStyle: style?.copyWith(
            color: color,
            fontWeight: CcTypographyParams.bold,
          ),
        ),
      ],
    );
  }
}
