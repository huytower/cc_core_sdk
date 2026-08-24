import 'package:flutter/material.dart';

import '../../export_cc_sdk_ui.dart';

class CcClearBtn extends StatelessWidget {
  final VoidCallback onTap;
  final double? height, width;
  final double baseIconSize;
  final Color? color;

  const CcClearBtn({
    super.key,
    required this.onTap,
    this.height,
    this.width,
    this.baseIconSize = 14.0,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    return CcIconButton.bouncing(
      icon: Icon(
        Icons.close_rounded,
        size: context.respIconSize(baseSize: baseIconSize),
        color: color ?? context.ccColorScheme.onSurfaceVariant.withAlpha(80),
      ),
      onTap: onTap,
      height: height,
      width: width,
    );
  }
}
