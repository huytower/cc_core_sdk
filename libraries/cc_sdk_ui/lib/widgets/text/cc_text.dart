import 'package:flutter/material.dart';

class CcText extends StatelessWidget {
  final String? text;
  final Alignment? align;
  final Color? color;
  final FontWeight? fontWeight;
  final FontStyle? fontStyle;
  final int? maxLines;
  final TextOverflow? overflow;
  final double? fontSize, heightLine, marginLeft, marginRight;
  final TextAlign? textAlign;
  final TextStyle? textStyle;

  const CcText(
    this.text, {
    super.key,
    this.align,
    this.color,
    this.fontSize,
    this.fontStyle,
    this.fontWeight,
    this.heightLine,
    this.marginLeft,
    this.marginRight,
    this.maxLines,
    this.overflow,
    this.textAlign,
    this.textStyle,
  });

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: align ?? Alignment.centerLeft,
      child: Padding(
        padding: EdgeInsets.only(
          left: marginLeft ?? 0,
          right: marginRight ?? 0,
        ),
        child: RichText(
          textAlign: textAlign ?? TextAlign.left,
          maxLines: maxLines ?? 1,
          overflow: overflow ?? TextOverflow.ellipsis,
          text: TextSpan(
            text: text ?? '',
            style: textStyle ?? _getTextStyle(),
          ),
        ),
      ),
    );
  }

  TextStyle _getTextStyle() => TextStyle(
        height: heightLine ?? 1.2,
        color: color ?? Colors.white,
        fontSize: fontSize ?? 14.0,
        fontWeight: fontWeight ?? FontWeight.w400,
        fontStyle: fontStyle ?? FontStyle.normal,
      );
}
