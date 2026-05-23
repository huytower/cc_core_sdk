import '../../core/config/tokens/cc_padding_params.dart';
import '../../core/config/tokens/base_colors.dart';
import 'package:flutter/material.dart';

import '../inkwell/cc_inkwell.dart';
import '../text/cc_text.dart';

class SkipBtn extends StatelessWidget {
  final String text;
  final VoidCallback onTap;
  final bool isHover, isVisible;
  final Alignment align;
  final double aspectRatio, fontSize, height;
  final TextAlign textAlign;

  const SkipBtn(
    this.text, {
    super.key,
    required this.onTap,
    this.align = Alignment.centerRight,
    this.aspectRatio = 16 / 9,
    this.fontSize = 16.0,
    this.height = 44.5,
    this.isHover = true,
    required this.isVisible,
    this.textAlign = TextAlign.right,
  });

  @override
  Widget build(BuildContext context) => isVisible
      ? Container(
          height: height,
          margin: EdgeInsets.only(
            bottom: isHover ? CcPaddingParams.PAGE_LG : 0.0,
            left: isHover ? CcPaddingParams.PAGE_LG : 0.0,
            right: isHover ? CcPaddingParams.PAGE_LG : 0.0,
            top: isHover ? CcPaddingParams.PAGE_LG : 0.0,
          ),
          child: isHover
              ? CcInkWell(onTap: onTap, child: getDataWidget())
              : GestureDetector(onTap: onTap, child: getDataWidget()),
        )
      : const SizedBox();

  Widget getDataWidget() => CcText(
    text,
    align: align,
    color: BaseColors.surfaceVariant,
    fontSize: fontSize,
    fontWeight: FontWeight.w500,
    textAlign: textAlign,
  );
}
