import 'package:flutter/material.dart';

import '../../core/extensions/cc_context_extension.dart';
import '../../core/extensions/common/cc_responsive_extension.dart';
import '../../core/helper/cc_widget_helper.dart';
import '../text/cc_text.dart';

class CcBaseBtn extends StatelessWidget {
  const CcBaseBtn({
    super.key,
    this.title,
    this.bgColor,
    this.textColor,
    this.isEnable = true,
    this.height,
    this.width,
    this.borderRadius,
    this.colorsGradient,
    this.allowShowLoading = true,
  });

  final String? title;
  final List<Color>? bgColor;
  final Color? textColor;
  final bool isEnable;
  final double? height, width;
  final BorderRadius? borderRadius;
  final List<Color>? colorsGradient;
  final bool allowShowLoading;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height ?? context.respDim(48.0),
      width: width ?? double.infinity,
      decoration: BoxDecoration(
        borderRadius: borderRadius ?? CcWidgetHelper.getBorderRoundedSM(),
        gradient: LinearGradient(
          colors:
              bgColor ??
              colorsGradient ??
              [
                context.ccColorScheme.surfaceVariant,
                context.ccColorScheme.surfaceVariant,
              ],
        ),
      ),
      child: Center(
        child: CcText(
          title ?? '',
          align: Alignment.center,
          textAlign: TextAlign.center,
          color:
              textColor ??
              (isEnable
                  ? context.ccColorScheme.onPrimary
                  : context.ccColorScheme.onSurfaceVariant),
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
