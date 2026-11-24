import 'package:cc_sdk_ui/export_cc_sdk_ui.dart';
import 'package:flutter/material.dart';

class CcClearButton extends StatelessWidget {
  final VoidCallback onTap;
  final double? height, width;
  final double baseIconSize;
  final Color? color;

  const CcClearButton({
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
