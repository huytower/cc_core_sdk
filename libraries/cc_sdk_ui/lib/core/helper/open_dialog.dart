import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../widgets/base/cc_keyboard_dismisser.dart';
import '../../widgets/dialog/body_modal_bottom_sheet.dart';
import '../../widgets/dialog/body_show_message.dart';
import '../../widgets/state/loading_icon_widget.dart';

class OpenDialog {
  static Future<dynamic> showBottomSheet(
    BuildContext contextReq,
    Widget w, {
    bool isHasIgnore = false,
    bool enableDrag = true,
    double? heightModal,
    double border = 10.0,
  }) {
    var promise = Completer();
    showModalBottomSheet(
      enableDrag: enableDrag,
      isDismissible: enableDrag,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(border)),
      ),
      backgroundColor: Colors.white,
      context: contextReq,
      isScrollControlled: true,
      builder: (context) {
        Widget child = SafeArea(child: BodyModalBottomSheet(w: w));

        if (isHasIgnore) {
          return child;
        }
        return CcKeyboardDismisser(child: child);
      },
    ).then((x) {
      if (x == null) {
        return promise.complete(x);
      }
      return promise.complete(x);
    });
    return promise.future;
  }

  static Future<bool> showDialogMessage({
    Widget? w,
    bool isExistOK = false,
    bool isDrag = true,
    String content = '',
    String title = '',
    Function? onCloseDialog,
    Function? onTapOK,
  }) async {
    bool rs = false;
    await showModalBottomSheet(
      enableDrag: isDrag,
      isDismissible: isDrag,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(10)),
      ),
      backgroundColor: Colors.white,
      context: Get.context!,
      isScrollControlled: true,
      builder: (context) {
        return SafeArea(
          child: BodyShowMessage(
            title: title,
            content: content,
            onTabOK: () {
              rs = true;

              if (onTapOK != null) {
                onTapOK();

                return;
              }

              /// Feature : exit app
              exit(0);
            },
            isExistOK: isExistOK,
            child:
                w ??
                Text(
                  content,
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 17),
                ),
          ),
        );
      },
    );
    if (onCloseDialog != null) {
      onCloseDialog();
    }
    return rs;
  }

  static Future<dynamic> showDialogLoading() async {
    bool rs = false;
    await showDialog<void>(
      context: Get.context!,
      barrierDismissible: false, // user must tap button!
      barrierColor: Colors.grey.withOpacity(0.3),
      builder: (BuildContext context) {
        return const PopScope(
          canPop: false,
          child: SizedBox(
            width: double.infinity,
            height: double.infinity,
            child: LoadingIconWidget(),
          ),
        );
      },
    );
    return rs;
  }

  static Future<dynamic> showDialogCustomer(Widget w) async {
    bool rs = false;
    await showDialog<void>(
      context: Get.context!,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return w;
      },
    );
    return rs;
  }

  static Future<dynamic> showDialogBottomSheetCustomer(
    Widget? w, {
    BuildContext? context,
    Color? backgroundColor,
    Color? barrierColor,
    Widget Function(BuildContext)? builder,
  }) async {
    // bool rs = false;
    var result = await showModalBottomSheet(
      isScrollControlled: true,
      context: context ?? Get.context!,
      backgroundColor: backgroundColor ?? Colors.white,
      barrierColor: barrierColor ?? const Color(0x80000000),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: builder ?? (BuildContext context) => w!,
    );
    return result;
  }
}
