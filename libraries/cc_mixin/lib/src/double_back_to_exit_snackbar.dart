import 'package:cc_sdk_ui/core/config/tokens/cc_circular_params.dart';
import 'package:cc_sdk_ui/core/config/tokens/cc_padding_params.dart';
import 'package:cc_sdk_ui/core/extensions/cc_context_extension.dart';
import 'package:cc_sdk_ui/core/extensions/common/cc_responsive_extension.dart';
import 'package:cc_sdk_ui/core/helper/cc_snackbar_helper.dart';
import 'package:flutter/material.dart';

void showDoubleBackPressSnackBar(BuildContext context, String message) {
  CcSnackBarHelper.showSnackBar(
    context: context,
    message: message,
    duration: const Duration(seconds: 1),
    backgroundColor: context.ccColorScheme.inverseSurface,
    textColor: context.ccColorScheme.onInverseSurface,
    fontWeight: FontWeight.w500,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(CcCircularParams.RADIUS_MD),
    ),
    margin: EdgeInsets.all(context.respPadding(CcPaddingParams.PAGE_SM)),
    elevation: 6,
  );
}
