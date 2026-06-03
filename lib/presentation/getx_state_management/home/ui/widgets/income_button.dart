import 'package:cc_sdk_ui/export_cc_sdk_ui.dart';
import 'package:easy_localization/easy_localization.dart' as el;
import 'package:flutter/material.dart';

class IncomeButton extends StatelessWidget {
  const IncomeButton({super.key, required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return CcBaseBtn(
      onTap: onTap,
      title: el.tr(CcLocaleKeys.common_income),
      width: 80,
      height: 36,
      colorsGradient: [
        context.ccColorScheme.secondary,
        context.ccColorScheme.secondaryContainer,
      ],
      textColor: context.ccColorScheme.onSecondary,
      borderRadius: BorderRadius.circular(8),
    );
  }
}
