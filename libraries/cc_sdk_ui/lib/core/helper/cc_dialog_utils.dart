import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../widgets/dialog/cc_base_dialog.dart';

class CcDialogUtils {
  static Future<void> showDialogConfirm({
    VoidCallback? onTapCancel,
    required VoidCallback? onTapConfirm,
    Color? bgColor,
    Color? bgColorBarrier,
    String? agreeText,
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
    try {
      await Get.dialog(
        CcBaseDialog(
          onTapCancel: onTapCancel,
          onTapConfirm: onTapConfirm,
          agreeText: agreeText,
          bgColor: bgColor,
          cancelText: cancelText,
          confirmTextColor: confirmTextColor,
          desc: desc,
          descTextColor: descTextColor,
          isCancelBtnShown: isCancelBtnShown,
          isActionBtnVisible: isActionBtnVisible,
          status: status,
        ),
        barrierDismissible: isAllowDismiss,
        barrierColor: bgColorBarrier ?? Colors.black.withOpacity(0.5),
      );

      if (isAutoDismiss) {
        await Future.delayed(const Duration(seconds: 2));
        if (Get.isDialogOpen ?? false) {
          Get.back();
        }
      }
    } catch (error, stackTrace) {
      debugPrint('Error showing confirmation dialog: $error');
      debugPrint('Stack trace: $stackTrace');
    }
  }
}
