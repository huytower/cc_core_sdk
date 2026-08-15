import 'package:flutter/material.dart';

import '../../export_cc_sdk_ui.dart';

/// A standardized 'Clear' icon button (x inside a circle) for text fields.
class CcClearBtn extends StatelessWidget {
  final VoidCallback onTap;
  final double? height, width;
  final double baseIconSize;
  final Color? color;

  const CcClearBtn({
    required this.onTap,
    this.height,
    this.width,
    this.baseIconSize = 14.0,
    this.color,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return CcIconButton.bouncing(
      icon: Icon(
        Icons.cancel_rounded,
        size: context.respIconSize(baseSize: baseIconSize),
        color: color ?? context.ccColorScheme.onSurfaceVariant,
      ),
      onTap: onTap,
      height: height,
      width: width,
    );
  }
}
