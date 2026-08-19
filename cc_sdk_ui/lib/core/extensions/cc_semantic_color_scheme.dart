import 'package:cc_sdk_ui/core/config/tokens/cc_base_colors.dart';
import 'package:flutter/material.dart';

extension CcSemanticColorScheme on ColorScheme {
  Color get investment => CcBaseColors.yellow600;

  Color get investmentSecondary =>
      CcBaseColors.yellow600.withValues(alpha: 0.8);

  Color get debtLoan => CcBaseColors.violet600;

  Color get debtLoanSecondary =>
      CcBaseColors.violet600.withValues(alpha: 0.8);
}
