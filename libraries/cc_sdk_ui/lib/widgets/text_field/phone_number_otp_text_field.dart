import 'dart:io';

import 'package:cc_sdk/core/constants/cc_number_format_params.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';

import '../../core/helper/widget_helper.dart';
import '../../core/theme/base_colors.dart';
import '../divider_line/cc_divider.dart';
import '../flex/cc_flex.dart';

class PhoneNumberAndOtpTextField extends StatelessWidget {
  const PhoneNumberAndOtpTextField(
    this.hintText, {
    Key? key,
    required this.onChanged,
    required this.onSubmit,
    this.action,
    this.colorDivider,
    required this.controller,
    this.formatter,
    this.hintStyle,
    this.isShowDivider = false,
    this.keyboardType,
    this.maxLength,
    this.textAlign = TextAlign.center,
    this.textStyle,
    this.suffix,
  }) : super(key: key);

  final Function onChanged, onSubmit;

  final bool isShowDivider;
  final int? maxLength;
  final Color? colorDivider;
  final String? formatter, hintText;

  final TextAlign? textAlign;
  final TextInputAction? action;
  final TextEditingController controller;
  final TextStyle? hintStyle, textStyle;
  final TextInputType? keyboardType;

  final Widget? suffix;

  @override
  Widget build(c) => Material(
    color: Colors.transparent,
    child: CcColStart(
      children: [
        /// Section : Edit text
        getEditTextWidget(),

        const SizedBox(height: 2),

        /// Section : Line
        isShowDivider == true
            ? CcDividerLine(
                color: colorDivider ?? BaseColors.surfaceVariant,
                height: 1,
              )
            : const SizedBox(),
      ],
    ),
  );

  Widget getEditTextWidget() => Stack(
    children: [
      /// Section : Edit text
      TextFormField(
        controller: controller,
        onChanged: (v) => onChanged(v),
        onFieldSubmitted: (v) => onSubmit(v),
        decoration: InputDecoration.collapsed(
          hintText: hintText,
          hintStyle:
              hintStyle ??
              WidgetHelper.getTextStyleRoboto(
                color: BaseColors.surfaceVariant,
                fontWeight: Platform.isAndroid
                    ? FontWeight.w400
                    : FontWeight.w500,
                fontSize: 28.0,
                heightLine: (16.0 / 28.0),
              ),
        ),

        /// Logic : max length = 12, included space
        inputFormatters: [
          LengthLimitingTextInputFormatter(maxLength ?? 12),
          MaskTextInputFormatter(
            mask: formatter ?? CcNumberFormatParams.PHONE_NUMBER_VN,
            filter: {'#': RegExp(r'[0-9]')},
          ),
        ],
        keyboardType: TextInputType.phone,
        style:
            textStyle ??
            WidgetHelper.getTextStyleRoboto(
              color: BaseColors.info,
              fontWeight: FontWeight.w600,
              fontSize: 28.0,
              heightLine: 0.9,
            ),
        textAlign: textAlign ?? TextAlign.center,
        textInputAction: action ?? TextInputAction.next,
      ),

      /// Section : Icon
      Positioned(
        bottom: 0,
        right: 0,
        top: 0,
        child: suffix ?? const SizedBox(),
      ),
    ],
  );
}
