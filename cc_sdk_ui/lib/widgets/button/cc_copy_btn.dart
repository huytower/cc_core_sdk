import 'package:flutter/material.dart';

import '../../export_cc_sdk_ui.dart';

class CcCopyBtn extends StatelessWidget {
  final VoidCallback? onTap;
  final Color? iconColor;
  final double? height, width;
  final double baseIconSize;

  const CcCopyBtn({
    super.key,
    this.onTap,
    this.iconColor,
    this.height,
    this.width,
    this.baseIconSize = 14.0,
  });

  factory CcCopyBtn.bouncing({
    required VoidCallback onTap,
    Color? iconColor,
    double? height,
    double? width,
    Key? key,
  }) => CcCopyBtn(
    onTap: onTap,
    iconColor: iconColor,
    height: height,
    width: width,
    key: key,
  );

  @override
  Widget build(BuildContext context) {
    return CcIconButton.bouncing(
      icon: Icon(
        Icons.copy_rounded,
        size: context.respIconSize(baseSize: baseIconSize),
        color: iconColor ?? context.ccColorScheme.onSurfaceVariant.withAlpha(80),
      ),
      onTap: onTap ?? () {},
      height: height,
      width: width,
    );
  }
}
