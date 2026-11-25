import 'dart:async';

import 'package:cc_sdk_ui/export_cc_sdk_ui.dart';
import 'package:flutter/material.dart' as m;
import 'package:flutter/material.dart';

/// CcDialogHelper: Standardized utility for showing dialogs, bottom sheets, and loaders.
///
/// This helper consolidates all modal-related operations into a single point of access,
/// ensuring consistent styling, behavior, and naming conventions.
class CcDialogHelper {
  // ==========================================================================
  // BOTTOM SHEETS
  // ==========================================================================

  /// Shows a modal bottom sheet with a custom widget. Narrowed and centred
  /// from a small tablet up, like [CcAdaptiveBottomSheet].
  static Future<T?> showModalBottomSheet<T>(
    BuildContext context,
    Widget child, {
    bool hasIgnore = false,
    bool enableDrag = true,
    double border = 10.0,
  }) {
    return CcAdaptiveBottomSheet.show<T>(
      context: context,
      hasDrag: enableDrag,
      hasDismissible: enableDrag,
      // The body below adds its own SafeArea.
      hasSafeArea: false,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(border)),
      ),
      backgroundColor: context.ccColorScheme.surface,
      builder: (context) {
        Widget body = SafeArea(child: CcBodyModalBottomSheet(w: child));

        if (hasIgnore) {
          return body;
        }
        return CcKeyboardDismisser(child: body);
      },
    );
  }

  static Future<bool?> showMessageBottomSheet({
    required BuildContext context,
    String title = '',
    String content = '',
    Widget? customWidget,
    bool hasOnlyConfirm = false,
    bool enableDrag = true,
    String? confirmText,
    String? cancelText,
    VoidCallback? onConfirm,
  }) async {
    return CcAdaptiveBottomSheet.show<bool>(
      context: context,
      hasDrag: enableDrag,
      hasDismissible: enableDrag,
      hasSafeArea: false,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(10)),
      ),
      backgroundColor: context.ccColorScheme.surface,
      // Landscape (a tablet held sideways): the default 9/16-height cap is
      // too short for longer messages, so let the sheet use the height it
      // needs and scroll past it. Portrait keeps the default behaviour.
      hasScrollControlled:
          MediaQuery.orientationOf(context) == Orientation.landscape,
      builder: (innerContext) => CcLandscapeScrollable(
        child: CcBodyShowMessage(
          title: title,
          confirmText: confirmText,
          cancelText: cancelText,
          hasOnlyConfirm: hasOnlyConfirm,
          onConfirm: () {
            Navigator.of(innerContext).pop(true);
            onConfirm?.call();
          },
          child:
              customWidget ??
              CcText(
                content,
                align: Alignment.center,
                maxLines: 5,
                textAlign: TextAlign.center,
                textStyle: innerContext.ccTextTheme.bodyMedium?.copyWith(
                  color: innerContext.ccColorScheme.onSurfaceVariant,
                  height: 1.4,
                ),
              ),
        ),
      ),
    );
  }

  /// Shows a persistent loading indicator as a bottom sheet.
  static Future<void> showLoadingBottomSheet(BuildContext context) async {
    await m.showModalBottomSheet<void>(
      context: context,
      isDismissible: false,
      enableDrag: false,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      barrierColor: context.ccColorScheme.onSurface.withValues(alpha: 0.3),
      builder: (context) => const PopScope(
        canPop: false,
        child: SizedBox(
          width: double.infinity,
          height: double.infinity,
          child: CcLoadingIconWidget(),
        ),
      ),
    );
  }

  // ==========================================================================
  // DIALOGS
  // ==========================================================================

  /// Shows a project-standard confirmation dialog.
  static Future<void> showConfirmationDialog({
    required BuildContext context,
    VoidCallback? onCancel,
    required VoidCallback? onConfirm,
    Color? backgroundColor,
    Color? barrierBackgroundColor,
    String? confirmText,
    String? cancelText,
    Color? confirmTextColor,
    required String desc,
    Color? descTextColor,
    bool hasActionButtonVisible = true,
    bool hasAllowDismiss = true,
    bool hasAutoDismiss = false,
    bool hasCancelButtonShown = false,
    CcDialogStatus status = CcDialogStatus.ERROR,
  }) async {
    final dialog = CcBaseDialog(
      onTapCancel: onCancel,
      onTapConfirm: onConfirm,
      agreeText: confirmText,
      backgroundColor: backgroundColor,
      cancelText: cancelText,
      confirmTextColor: confirmTextColor,
      desc: desc,
      descTextColor: descTextColor,
      hasCancelButtonShown: hasCancelButtonShown,
      hasActionButtonVisible: hasActionButtonVisible,
      status: status,
    );

    try {
      final Future<void> dialogFuture = m.showDialog(
        context: context,
        barrierDismissible: hasAllowDismiss,
        barrierColor:
            barrierBackgroundColor ??
            context.ccColorScheme.onSurface.withValues(alpha: 0.5),
        builder: (context) => dialog,
      );

      if (hasAutoDismiss) {
        await Future.delayed(const Duration(seconds: 2));
        if (context.mounted) {
          Navigator.of(context, rootNavigator: true).pop();
        }
      }

      await dialogFuture;
    } catch (error, stackTrace) {
      // Reaches FlutterError.onError, which the app routes to its logger.
      FlutterError.reportError(
        FlutterErrorDetails(
          exception: error,
          stack: stackTrace,
          library: 'cc_sdk_ui',
          context: ErrorDescription('while showing a confirmation dialog'),
        ),
      );
    }
  }
}
