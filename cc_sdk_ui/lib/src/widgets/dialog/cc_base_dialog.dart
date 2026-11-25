import 'dart:ui';

import 'package:cc_sdk_ui/export_cc_sdk_ui.dart';
import 'package:flutter/material.dart';

/// Basic dialog is shown on UI
/// ex.
/// CcDialogHelper.showConfirmationDialog(onTapConfirm: () {}, desc: 'ABC\nABC', );
class CcBaseDialog extends StatelessWidget {
  const CcBaseDialog({
    super.key,
    this.onTapCancel,
    this.onTapConfirm,
    this.agreeText,
    this.backgroundColor,
    this.cancelText,
    this.cancelTextColor,
    this.confirmTextColor,
    required this.desc,
    this.descTextColor,
    this.dividerColor,
    this.hasActionButtonVisible = true,
    this.hasCancelButtonShown = false,
    this.maxLines = 3,
    this.status = CcDialogStatus.ERROR,
  });

  final VoidCallback? onTapCancel, onTapConfirm;

  final bool hasActionButtonVisible, hasCancelButtonShown;

  final int maxLines;

  final Color? backgroundColor, descTextColor;
  final Color? cancelTextColor, confirmTextColor, dividerColor;

  final CcDialogStatus? status;

  final String? agreeText, cancelText, desc;

  @override
  Widget build(BuildContext context) => buildDialogWidget(context);

  Widget buildActionButtonsWidget() => CcActionButtonInDialog(
    onTapCancel: onTapCancel,
    onTapConfirm: onTapConfirm,
    hasCancelButtonShown: hasCancelButtonShown,
    agreeText: agreeText,
    cancelText: cancelText,
    cancelTextColor: cancelTextColor,
    confirmTextColor: confirmTextColor,
    dividerColor: dividerColor,
  );

  Widget buildDialogBodyWidget(BuildContext context) => CcColStart(
    children: [
      /// dialog description
      buildDesc(context),

      /// action buttons
      hasActionButtonVisible ? buildActionButtonsWidget() : const SizedBox(),
    ],
  );

  Widget buildDesc(BuildContext context) => Expanded(
    child: CcRowBetween(
      children: [
        const CcSpaceLG(),
        const CcSpaceLG(),

        /// Icon : show alert icon : Error, Warning, Success mark
        buildIconAlert(context),

        const CcSpaceLG(),

        /// Text
        Expanded(
          child: CcText(
            desc,
            align: Alignment.centerLeft,
            textStyle: context.ccTextTheme.bodyMedium?.copyWith(
              color: descTextColor ?? context.ccColorScheme.onSurfaceVariant,
              height: 1.2,
            ),
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

  Widget buildDialogWidget(BuildContext context) => Dialog(
    /// border padding at presentation left & presentation right
    insetPadding: EdgeInsets.all(context.respPadding(15.0)),

    /// MUST set transparent backgroundColor to able avoid around white padding space
    backgroundColor: Colors.transparent,

    /// padding width of dialog
    child: ClipRRect(
      borderRadius: BorderRadius.circular(16.0),

      /// Logic : get corresponding dialog : include Blur effect + transparent effect
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 7, sigmaY: 7),
        child: Container(
          width: double.infinity,
          height: context.respPadding(hasActionButtonVisible ? 145 : 75),
          decoration: BoxDecoration(
            color:
                backgroundColor ??
                context.ccColorScheme.surface.withValues(alpha: 0.8),
          ),
          child: buildDialogBodyWidget(context),
        ),
      ),
    ),
  );

  Widget buildIconAlert(BuildContext context) {
    final (icon, color) = switch (status ?? CcDialogStatus.ERROR) {
      CcDialogStatus.ERROR => (Icons.error_outline, CcBaseColors.errorRed),
      CcDialogStatus.INFO => (
        Icons.announcement_outlined,
        CcBaseColors.infoBlue,
      ),
      CcDialogStatus.SUCCESS => (Icons.check_circle, CcBaseColors.successGreen),
      CcDialogStatus.WARNING => (
        Icons.warning_outlined,
        CcBaseColors.warningAmber,
      ),
    };
    return Icon(icon, size: context.respIconSize(), color: color);
  }
}
