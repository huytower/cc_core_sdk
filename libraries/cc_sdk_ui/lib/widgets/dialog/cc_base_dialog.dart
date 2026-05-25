import 'dart:ui';

import 'package:cc_sdk/core/extensions/common/cc_when_expression.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../core/config/tokens/cc_base_colors.dart';
import '../../core/config/tokens/cc_padding_params.dart';
import '../flex/cc_flex.dart';
import '../space/cc_space.dart';
import '../text/cc_text.dart';
import 'cc_action_btn_in_dialog.dart';

/// Popular widgets :
/// Basic dialog is shown on UI
/// ex.
/// CcDialogUtils.showDialogConfirm(CcBaseDialog(desc: 'ABC\nABC', ));
class CcBaseDialog extends StatelessWidget {
  const CcBaseDialog({
    Key? key,
    this.onTapCancel,
    this.onTapConfirm,
    this.agreeText,
    this.bgColor,
    this.cancelText,
    this.cancelTextColor,
    this.confirmTextColor,
    required this.desc,
    this.descTextColor,
    this.dividerColor,
    this.isActionBtnVisible = true,
    this.isCancelBtnShown = false,
    this.maxLines = 3,
    this.status = CcDialogStatus.ERROR,
  }) : super(key: key);

  final VoidCallback? onTapCancel, onTapConfirm;

  final bool isActionBtnVisible, isCancelBtnShown;

  final int maxLines;

  final Color? bgColor, descTextColor;
  final Color? cancelTextColor, confirmTextColor, dividerColor;

  final CcDialogStatus? status;

  final String? agreeText, cancelText, desc;

  @override
  Widget build(BuildContext context) => buildDialogWidget();

  Widget buildActionButtonsWidget() => CcActionBtnInDialog(
    onTapCancel: onTapCancel,
    onTapConfirm: onTapConfirm,
    isCancelBtnShown: isCancelBtnShown,
    agreeText: agreeText,
    cancelText: cancelText,
    cancelTextColor: cancelTextColor,
    confirmTextColor: confirmTextColor,
    dividerColor: dividerColor,
  );

  Widget buildDialogBodyWidget() => CcColStart(
    children: [
      /// dialog description
      buildDesc(),

      /// action buttons
      isActionBtnVisible ? buildActionButtonsWidget() : const SizedBox(),
    ],
  );

  Widget buildDesc() => Expanded(
    child: CcRowBetween(
      children: [
        const CcSpaceLG(),
        const CcSpaceLG(),

        /// Icon : show alert icon : Error, Warning, Success mark
        buildIconAlert(),

        const CcSpaceLG(),

        /// Text
        Expanded(
          child: CcText(
            desc,
            align: Alignment.centerLeft,
            color: descTextColor ?? CcBaseColors.textSecondary,
            fontSize: 13.0,
            heightLine: 1.2,
            maxLines: maxLines,
            marginLeft: CcPaddingParams.PAGE_MD,
            marginRight: CcPaddingParams.PAGE_MD,
            textAlign: TextAlign.start,
          ),
        ),

        const CcSpaceSM(),
      ],
    ),
  );

  Widget buildDialogWidget() => Dialog(
    /// border padding at presentation left & presentation right
    insetPadding: const EdgeInsets.only(
      bottom: 27.0,
      left: 15.0,
      right: 15.0,
      top: 15.0,
    ),

    /// MUST set transparent bgColor to able avoid around white padding space
    backgroundColor: Colors.transparent,

    /// padding width of dialog
    child: ClipRRect(
      borderRadius: BorderRadius.circular(16.0),

      /// Logic : get corresponding dialog : include Blur effect + transparent effect
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 7, sigmaY: 7),
        child: Container(
          width: Get.width,
          height: isActionBtnVisible ? 145 : 75,
          decoration: BoxDecoration(color: bgColor ?? CcBaseColors.white80),
          child: buildDialogBodyWidget(),
        ),
      ),
    ),
  );

  Widget buildIconAlert() => ccWhen(
    variable: status,
    conditions: {
      CcDialogStatus.ERROR: () =>
          const Icon(Icons.error_outline, size: 24, color: Colors.redAccent),
      CcDialogStatus.INFO: () =>
          const Icon(Icons.announcement_outlined, size: 24, color: Colors.grey),
      CcDialogStatus.SUCCESS: () =>
          const Icon(Icons.check_circle, size: 24, color: Colors.green),
      CcDialogStatus.WARNING: () =>
          const Icon(Icons.warning_outlined, size: 24, color: Colors.yellow),
    },
  );
}

enum CcDialogStatus { ERROR, INFO, SUCCESS, WARNING }
