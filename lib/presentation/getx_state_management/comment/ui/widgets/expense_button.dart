import 'package:cc_sdk_ui/export_cc_sdk_ui.dart';
import 'package:flutter/material.dart';

class ExpenseButton extends StatelessWidget {
  const ExpenseButton({super.key, required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return CcBaseBtn(
      onTap: onTap,
      title:
          'Expense', // Should be localized if possible, but keeping it for now
      width: 80,
      height: 36,
      colorsGradient: [
        context.ccColorScheme.primary,
        context.ccColorScheme.primaryContainer,
      ],
      textColor: context.ccColorScheme.onPrimary,
      borderRadius: BorderRadius.circular(8),
    );
  }
}
