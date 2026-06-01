import 'package:easy_localization/easy_localization.dart' as el;
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:message/cc_locale_keys.dart';

import '../../core/config/tokens/cc_padding_params.dart';
import '../../core/extensions/cc_context_extension.dart';
import '../button/cc_debounce_widget.dart';
import '../container/cc_container_rounded_corner_widget.dart';
import '../divider_line/cc_divider.dart';
import '../flex/cc_flex.dart';
import '../text/cc_text.dart';

/// Action buttons, ex. : cancel, okay .v.v.
class CcActionBtnInDialog extends StatelessWidget {
  const CcActionBtnInDialog({
    super.key,
    this.onTapCancel,
    this.onTapConfirm,
    this.isCancelBtnShown = false,
    this.btnBgColor,
    this.agreeText,
    this.fontSize,
    this.cancelText,
    this.cancelTextColor,
    this.confirmTextColor,
    this.dividerColor,
    this.heightActionBtn,
    this.heightActionBtnBar,
  });

  final VoidCallback? onTapCancel, onTapConfirm;
  final bool isCancelBtnShown;
  final Color? btnBgColor, cancelTextColor, confirmTextColor, dividerColor;
  final double? heightActionBtn, heightActionBtnBar, fontSize;
  final String? agreeText, cancelText;

  @override
  Widget build(BuildContext context) => getActionButtonsWidget(context);

  Widget getActionButtonsWidget(BuildContext context) => SizedBox(
    height: heightActionBtnBar ?? 60,
    child: CcColStart(
      children: [
        /// line
        CcDividerLine(
          color: dividerColor ?? context.ccColorScheme.outlineVariant,
        ),

        /// cancel & confirm buttons
        Expanded(
          flex: 1,
          child: CcRowCenter(
            children: [
              /// cancel button widget
              isCancelBtnShown
                  ? Expanded(flex: 1, child: getCancelButtonWidget(context))
                  : const SizedBox(),

              /// line widget
              isCancelBtnShown
                  ? Expanded(
                      flex: 0,
                      child: CcDividerHorizontalLine(
                        color:
                            dividerColor ??
                            context.ccColorScheme.outlineVariant,
                        width: 0.8,
                        height: heightActionBtnBar ?? 60,
                      ),
                    )
                  : const SizedBox(),

              /// confirm button widget
              Expanded(
                flex: 1,
                child: isCancelBtnShown
                    ? getConfirmButtonWidget(context)
                    : Container(
                        margin: const EdgeInsets.only(
                          left: (CcPaddingParams.PAGE_LG * 3.5),
                          right: (CcPaddingParams.PAGE_LG * 3.5),
                        ),
                        child: getConfirmButtonWidget(context),
                      ),
              ),
            ],
          ),
        ),
      ],
    ),
  );

  /// cancel button ui
  Widget getCancelButtonWidget(BuildContext context) => SizedBox(
    height: heightActionBtn ?? 35,
    child: CcDebounce(
      onTap: onTapCancel ?? () => Get.back(),
      child: Stack(
        children: [
          CcContainerRoundedCorner(
            color: btnBgColor ?? context.ccColorScheme.primary,
          ),
          CcText(
            cancelText ?? el.tr(CcLocaleKeys.common_cancel),
            align: Alignment.center,
            color: cancelTextColor ?? context.ccColorScheme.onPrimary,
            fontSize: fontSize ?? 14.0,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    ),
  );

  /// confirm button ui
  Widget getConfirmButtonWidget(BuildContext context) => SizedBox(
    height: heightActionBtn ?? 35,
    child: CcDebounce(
      onTap: onTapConfirm ?? () => Get.back(),
      child: Stack(
        children: [
          CcContainerRoundedCorner(
            color: btnBgColor ?? context.ccColorScheme.primary,
          ),
          CcText(
            agreeText ?? el.tr(CcLocaleKeys.common_ok),
            align: Alignment.center,
            color: confirmTextColor ?? context.ccColorScheme.onPrimary,
            fontWeight: FontWeight.w600,
            fontSize: fontSize ?? 15.0,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    ),
  );
}
