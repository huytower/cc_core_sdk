import 'package:flutter/material.dart';

import '../../core/config/tokens/cc_base_colors.dart';
import '../../core/helper/cc_widget_helper.dart';
import '../flex/cc_flex.dart';
import '../inkwell/cc_inkwell.dart';
import '../text/cc_text.dart';

class CcBaseBtn extends StatelessWidget {
  const CcBaseBtn({
    super.key,
    required this.onTap,
    this.title,
    this.bgColor,
    this.textColor,
    this.isEnable = true,
    this.height,
    this.width,
    this.borderRadius,
    this.colorsGradient,
  });

  final VoidCallback onTap;
  final String? title;
  final List<Color>? bgColor;
  final Color? textColor;
  final bool isEnable;
  final double? height, width;
  final BorderRadius? borderRadius;
  final List<Color>? colorsGradient;

  @override
  Widget build(BuildContext context) {
    return CcInkWell(
      onTap: isEnable ? onTap : () {},
      borderRadius: borderRadius ?? CcWidgetHelper.getBorderRoundedSmall(),
      child: Container(
        height: height ?? 48,
        width: width ?? double.infinity,
        decoration: BoxDecoration(
          borderRadius: borderRadius ?? CcWidgetHelper.getBorderRoundedSmall(),
          gradient: LinearGradient(
            colors:
                bgColor ??
                colorsGradient ??
                const [CcBaseColors.neutral70, CcBaseColors.neutral70],
          ),
        ),
        child: Center(
          child: CcText(
            title ?? '',
            color: isEnable ? textColor : CcBaseColors.textInvert,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
