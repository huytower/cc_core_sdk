import 'package:cc_library/theme/base_colors.dart';
import 'package:cc_library/widget/api/loading_icon_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class DialogUtils {
  static final RxBool _isDialogVisible = false.obs;
  
  /// Getter to check if any dialog is currently visible
  static bool get isDialogVisible => _isDialogVisible.value;
  /// show dialog confirm
  /// ex.
  /// DialogUtils.showDialogConfirm(BaseDialog(desc: 'ABC\nABC', ));
  static void showDialogConfirm(Widget child, {isAllowDismiss = true, isAutoDismiss = false, bgColorBarrier}) {
    _isDialogVisible.value = true; // notify dialog is visible

    showDialog(
      context: Get.context!,
      barrierDismissible: isAllowDismiss,
      barrierColor: bgColorBarrier ?? BaseColors.black_20,
      builder: (c) => child,
    );

    /// Logic : if auto-dismiss && dialog is showing, close it
    if (isAutoDismiss && isDialogVisible) {
      2.5.delay(() {
        Get.back();

        _isDialogVisible.value = false; // notify dialog is invisible
      });
    }
  }

  static Future<dynamic> showDialogLoading() async {
    bool rs = false;
    await showDialog<void>(
      context: Get.context!,
      barrierDismissible: false, // user must tap button!
      barrierColor: BaseColors.black_30,
      builder: (BuildContext context) {
        return WillPopScope(
          onWillPop: () async => false,
          child: const SizedBox(
            width: double.infinity,
            height: double.infinity,
            child: LoadingIconWidget(),
          ),
        );
      },
    );
    return rs;
  }
}
