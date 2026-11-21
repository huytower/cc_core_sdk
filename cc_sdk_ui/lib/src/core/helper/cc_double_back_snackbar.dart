import 'package:cc_sdk_ui/export_cc_sdk_ui.dart';
import 'package:flutter/material.dart';

/// Shows the "press back again to exit" hint with design-system styling.
///
/// Use it from `DoubleBackToExitMixin.showBackPressHint` (`cc_mixin`).
///
/// ```dart
/// @override
/// void showBackPressHint(BuildContext context, String message) =>
///     showDoubleBackPressSnackBar(context, message);
/// ```
void showDoubleBackPressSnackBar(BuildContext context, String message) {
  CcSnackBarHelper.showSnackBar(
    context: context,
    message: message,
    duration: const Duration(seconds: 1),
    backgroundColor: context.ccColorScheme.inverseSurface,
    textColor: context.ccColorScheme.onInverseSurface,
    fontWeight: CcTypographyParams.medium,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(CcCircularParams.RADIUS_MD),
    ),
    margin: EdgeInsets.all(context.respPadding(CcPaddingParams.PAGE_SM)),
    elevation: 6,
  );
}
