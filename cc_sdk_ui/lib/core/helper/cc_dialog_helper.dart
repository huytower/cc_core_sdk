import 'dart:async';

import 'package:flutter/material.dart' as m;
import 'package:flutter/material.dart';

import '../../widgets/base/cc_keyboard_dismisser.dart';

import '../../widgets/dialog/cc_base_dialog.dart';
import '../../widgets/dialog/cc_body_modal_bottom_sheet.dart';
import '../../widgets/dialog/cc_body_show_message.dart';
import '../../widgets/state/cc_loading_icon_widget.dart';
import '../../widgets/text/cc_text.dart';
import '../extensions/cc_context_extension.dart';

/// CcDialogHelper: Standardized utility for showing dialogs, bottom sheets, and loaders.
///
/// This helper consolidates all modal-related operations into a single point of access,
/// ensuring consistent styling, behavior, and naming conventions.
class CcDialogHelper {
  // ==========================================================================
  // BOTTOM SHEETS
  // ==========================================================================

  /// Shows a modal bottom sheet with a custom widget.
  static Future<T?> showModalBottomSheet<T>(
    BuildContext context,
    Widget child, {
    bool isHasIgnore = false,
    bool enableDrag = true,
    double border = 10.0,
  }) {
    return m.showModalBottomSheet<T>(
      context: context,
      enableDrag: enableDrag,
      isDismissible: enableDrag,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(border)),
      ),
      backgroundColor: context.ccColorScheme.surface,
      isScrollControlled: true,
      builder: (context) {
        Widget body = SafeArea(child: CcBodyModalBottomSheet(w: child));

        if (isHasIgnore) {
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
    bool isOnlyConfirm = false,
    bool enableDrag = true,
    String? confirmText,
    String? cancelText,
    VoidCallback? onConfirm,
  }) async {
    return m.showModalBottomSheet<bool>(
      context: context,
      enableDrag: enableDrag,
      isDismissible: enableDrag,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(10)),
      ),
      backgroundColor: context.ccColorScheme.surface,
      builder: (innerContext) => CcBodyShowMessage(
        title: title,
        confirmText: confirmText,
        cancelText: cancelText,
        isOnlyConfirm: isOnlyConfirm,
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
      barrierColor: context.ccColorScheme.onSurface.withOpacity(0.3),
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
    Color? bgColor,
    Color? bgColorBarrier,
    String? confirmText,
    String? cancelText,
    Color? confirmTextColor,
    required String desc,
    Color? descTextColor,
    bool isActionBtnVisible = true,
    bool isAllowDismiss = true,
    bool isAutoDismiss = false,
    bool isCancelBtnShown = false,
    CcDialogStatus status = CcDialogStatus.ERROR,
  }) async {
    final dialog = CcBaseDialog(
      onTapCancel: onCancel,
      onTapConfirm: onConfirm,
      agreeText: confirmText,
      bgColor: bgColor,
      cancelText: cancelText,
      confirmTextColor: confirmTextColor,
      desc: desc,
      descTextColor: descTextColor,
      isCancelBtnShown: isCancelBtnShown,
      isActionBtnVisible: isActionBtnVisible,
      status: status,
    );

    try {
      final Future<void> dialogFuture = m.showDialog(
        context: context,
        barrierDismissible: isAllowDismiss,
        barrierColor:
            bgColorBarrier ?? context.ccColorScheme.onSurface.withOpacity(0.5),
        builder: (context) => dialog,
      );

      if (isAutoDismiss) {
        await Future.delayed(const Duration(seconds: 2));
        if (context.mounted) {
          Navigator.of(context, rootNavigator: true).pop();
        }
      }

      await dialogFuture;
    } catch (error, stackTrace) {
      debugPrint('Error showing confirmation dialog: $error');
      debugPrint('Stack trace: $stackTrace');
    }
  }
}
