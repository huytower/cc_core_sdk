import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../export_cc_sdk_ui.dart';

class CcNoteInputField extends StatelessWidget {
  const CcNoteInputField({
    super.key,
    required this.controller,
    this.hintText,
    this.prefixIcon,
    this.onCopy,
    this.onClear,
    this.onTap,
    this.maxLines = 1,
    this.margin,
    this.height,
    this.color,
    this.borderColor,
    this.showClear = true,
    this.showCopy = true,
  });

  final TextEditingController controller;
  final String? hintText;
  final Widget? prefixIcon;
  final VoidCallback? onCopy;
  final VoidCallback? onClear;
  final VoidCallback? onTap;
  final int maxLines;
  final EdgeInsetsGeometry? margin;
  final double? height;
  final Color? color;
  final Color? borderColor;
  final bool showClear;
  final bool showCopy;

  @override
  Widget build(BuildContext context) {
    final hasText = controller.text.isNotEmpty;

    return CcTextField(
      controller: controller,
      hintText: hintText,
      maxLines: maxLines,
      textAlign: TextAlign.start,
      onTap: onTap,
      margin: margin,
      height: height,
      color: color,
      borderColor: borderColor,
      prefixIcon: prefixIcon,
      suffixIcon: hasText
          ? Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (showCopy)
                  CcCopyBtn.bouncing(
                    onTap: () {
                      Clipboard.setData(
                        ClipboardData(text: controller.text),
                      );
                      onCopy?.call();
                    },
                  ),
                if (showClear && hasText) const CcSpaceXS(),
                if (showClear && hasText)
                  CcClearBtn(
                    onTap: () {
                      controller.clear();
                      onClear?.call();
                    },
                  ),
                const CcSpaceXS(),
              ],
            )
          : null,
    );
  }
}
