import 'package:cc_sdk_ui/export_cc_sdk_ui.dart';
import 'package:flutter/material.dart';

import 'expense_button.dart';
import 'income_button.dart';

class FinanceAppBar extends StatelessWidget implements PreferredSizeWidget {
  const FinanceAppBar({
    super.key,
    this.onHistoryPressed,
    this.onExpensePressed,
    this.onIncomePressed,
    this.onApprovePressed,
  });

  final VoidCallback? onHistoryPressed;
  final VoidCallback? onExpensePressed;
  final VoidCallback? onIncomePressed;
  final VoidCallback? onApprovePressed;

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: context.ccColorScheme.surface,
      elevation: 0,
      leading: IconButton(
        icon: Icon(Icons.history, color: context.ccColorScheme.onSurface),
        onPressed: onHistoryPressed ?? () {},
      ),
      title: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          ExpenseButton(onTap: onExpensePressed ?? () {}),
          const CcSpaceXS(),
          IncomeButton(onTap: onIncomePressed ?? () {}),
        ],
      ),
      centerTitle: true,
      actions: [
        IconButton(
          icon: Icon(
            Icons.check_circle,
            color: context.ccColorScheme.onSurface,
          ),
          onPressed: onApprovePressed ?? () {},
        ),
      ],
    );
  }
}
