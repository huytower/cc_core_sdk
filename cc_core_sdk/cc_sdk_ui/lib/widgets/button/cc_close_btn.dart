import 'package:flutter/material.dart';

import '../../core/extensions/cc_context_extension.dart';
import '../../core/extensions/common/cc_responsive_extension.dart';
import '../inkwell/cc_inkwell.dart';

/// Standardized Close Button.
///
/// If no [icon] is provided, it defaults to [Icons.close].
class CcCloseBtn extends StatelessWidget {
  final Color? bgColor;
  final double? height, width;
  final Widget? icon;
  final VoidCallback onTap;
  final Color? iconColor;

  const CcCloseBtn({
    super.key,
    this.bgColor,
    this.height,
    this.icon,
    required this.onTap,
    this.iconColor,
    this.width,
  });

  @override
  Widget build(BuildContext context) {
    final double defaultSize = context.respIconSize(baseSize: 35.0);
    final double defaultIconSize = context.respIconSize(baseSize: 20.0);

    return Center(
      child: SizedBox(
        width: width ?? defaultSize,
        height: height ?? defaultSize,
        child: CcInkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(defaultSize / 2),
          child: Container(
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: bgColor ?? Colors.transparent,
              shape: BoxShape.circle,
            ),
            child:
                icon ??
                Icon(
                  Icons.close,
                  size: defaultIconSize,
                  color: iconColor ?? context.ccColorScheme.onSurface,
                ),
          ),
        ),
      ),
    );
  }
}
