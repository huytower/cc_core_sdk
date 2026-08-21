import 'package:easy_localization/easy_localization.dart' as el;
import 'package:flutter/material.dart';

import '../../export_cc_sdk_ui.dart';

class CcNameInputField extends StatelessWidget {
  const CcNameInputField({
    super.key,
    required this.controller,
    required this.labelText,
    required this.hintText,
    this.onClear,
    this.maxLength = 20,
  });

  final TextEditingController controller;
  final String labelText;
  final String hintText;
  final VoidCallback? onClear;
  final int maxLength;

  @override
  Widget build(BuildContext context) {
    final hasValue = controller.text.isNotEmpty;
    return TextField(
      controller: controller,
      maxLength: maxLength,
      decoration: InputDecoration(
        labelText: labelText,
        hintText: hintText,
        hintStyle: context.ccTextTheme.labelSmall?.copyWith(
          color: context.ccColorScheme.onSurfaceVariant.withAlpha(70),
        ),
        labelStyle: context.ccTextTheme.labelSmall?.copyWith(
          color: context.ccColorScheme.onSurfaceVariant.withAlpha(70),
        ),
        filled: true,
        fillColor: context.ccColorScheme.surfaceVariant.withAlpha(80),
        border: OutlineInputBorder(
          borderRadius: context.brMd,
          borderSide: BorderSide(
            color: context.ccColorScheme.outlineVariant.withAlpha(10),
            width: 0.4,
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: context.brMd,
          borderSide: BorderSide(
            color: context.ccColorScheme.outlineVariant.withAlpha(10),
            width: 0.4,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: context.brMd,
          borderSide: BorderSide(
            color: context.ccColorScheme.outlineVariant.withAlpha(10),
            width: 0.4,
          ),
        ),
        suffixIcon: hasValue
            ? CcIconButton.bouncing(
                width: context.respDim(20),
                height: context.respDim(20),
                icon: Icon(
                  Icons.close_rounded,
                  color: context.ccColorScheme.onSurfaceVariant.withAlpha(80),
                  size: context.respIconSize(baseSize: 14),
                ),
                onTap: () {
                  controller.clear();
                  onClear?.call();
                },
                tooltip: el.tr(CcLocaleKeys.common_clear),
              )
            : null,
      ),
    );
  }
}
