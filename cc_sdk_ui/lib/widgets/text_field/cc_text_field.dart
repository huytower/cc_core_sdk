import 'package:flutter/material.dart';

import '../../core/config/tokens/cc_base_colors.dart';
import '../../core/config/tokens/cc_padding_params.dart';
import '../../core/extensions/cc_context_extension.dart';
import '../../core/extensions/common/cc_responsive_extension.dart';

class CcTextField extends StatelessWidget {
  const CcTextField({
    super.key,
    required this.controller,
    this.hintText,
    this.obscureText = false,
    this.keyboardType = TextInputType.text,
    this.prefixIcon,
    this.suffixIcon,
    this.onChanged,
    this.validator,
    this.maxLines = 1,
    this.onTap,
    this.margin,
    this.onSubmitted,
    this.textInputAction,
    this.enabled = true,
    this.height,
    this.borderRadius = 12.0,
    this.borderWidth = 1.0,
  });

  final TextEditingController controller;
  final String? hintText;
  final bool obscureText;
  final TextInputType keyboardType;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final Function(String)? onChanged;
  final String? Function(String?)? validator;
  final int? maxLines;
  final VoidCallback? onTap;
  final EdgeInsetsGeometry? margin;
  final Function(String)? onSubmitted;
  final TextInputAction? textInputAction;
  final bool enabled;
  final double? height;
  final double borderRadius;
  final double borderWidth;

  @override
  Widget build(BuildContext context) {
    final effectiveHeight = height ?? context.respDim(46);
    return Container(
      margin:
          margin ??
          EdgeInsets.only(bottom: context.respPadding(CcPaddingParams.PAGE_MD)),
      height: effectiveHeight,
      decoration: BoxDecoration(
        color: CcBaseColors.white100,
        borderRadius: BorderRadius.circular(borderRadius),
        border: Border.all(
          color: CcBaseColors.neutral10.withOpacity(0.5),
          width: borderWidth,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      alignment: Alignment.center,
      child: TextFormField(
        controller: controller,
        obscureText: obscureText,
        keyboardType: keyboardType,
        onChanged: onChanged,
        validator: validator,
        maxLines: maxLines,
        onTap: onTap,
        onFieldSubmitted: onSubmitted,
        textInputAction: textInputAction,
        enabled: enabled,
        textAlignVertical: TextAlignVertical.center,
        style: context.ccTextTheme.bodyMedium?.copyWith(
          height: 1.0,
          color: context.ccColorScheme.onSurface,
        ),
        decoration: InputDecoration(
          hintText: hintText,
          hintStyle: context.ccTextTheme.bodyMedium?.copyWith(
            color: context.ccColorScheme.onSurfaceVariant.withAlpha(50),
          ),
          prefixIcon: prefixIcon,
          suffixIcon: suffixIcon,
          isDense: true,
          contentPadding: EdgeInsets.symmetric(
            horizontal: context.respPadding(CcPaddingParams.PAGE_SM),
            vertical:
                (effectiveHeight -
                        (context.ccTextTheme.bodyMedium?.fontSize ?? 14)) /
                    2 -
                borderWidth,
          ),
          border: InputBorder.none,
          errorStyle: const TextStyle(height: 0, fontSize: 0),
        ),
      ),
    );
  }
}
