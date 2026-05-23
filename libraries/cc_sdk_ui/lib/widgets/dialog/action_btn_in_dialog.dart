import '../../core/config/tokens/cc_padding_params.dart';
import '../../core/config/tokens/base_colors.dart';
import '../button/cc_debounce_widget.dart';
import '../container/container_rounded_corner_widget.dart';
import '../divider_line/cc_divider.dart';
import '../text/cc_text.dart';
import 'package:easy_localization/easy_localization.dart' as el;
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../flex/cc_flex.dart';

/// Action buttons, ex. : cancel, okay .v.v.
class ActionBtnInDialog extends StatelessWidget {
  const ActionBtnInDialog({
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
  Widget build(BuildContext context) => getActionButtonsWidget();

  Widget getActionButtonsWidget() => SizedBox(
    height: heightActionBtnBar ?? 60,
    child: CcColStart(
      children: [
        /// line
        CcDividerLine(color: dividerColor ?? BaseColors.divider),

        /// cancel & confirm buttons
        Expanded(
          flex: 1,
          child: CcRowCenter(
            children: [
              /// cancel button widget
              isCancelBtnShown
                  ? Expanded(flex: 1, child: getCancelButtonWidget())
                  : const SizedBox(),

              /// line widget
              isCancelBtnShown
                  ? Expanded(
                      flex: 0,
                      child: CcDividerHorizontalLine(
                        color: dividerColor ?? BaseColors.divider,
                        width: 0.8,
                        height: heightActionBtnBar ?? 60,
                      ),
                    )
                  : const SizedBox(),

              /// confirm button widget
              Expanded(
                flex: 1,
                child: isCancelBtnShown
                    ? getConfirmButtonWidget()
                    : Container(
                        margin: const EdgeInsets.only(
                          left: (CcPaddingParams.PAGE_LG * 3.5),
                          right: (CcPaddingParams.PAGE_LG * 3.5),
                        ),
                        child: getConfirmButtonWidget(),
                      ),
              ),
            ],
          ),
        ),
      ],
    ),
  );

  /// cancel button ui
  Widget getCancelButtonWidget() => SizedBox(
    height: heightActionBtn ?? 35,
    child: CcDebounce(
      onTap: onTapCancel ?? () => Get.back(),
      child: Stack(
        children: [
          ContainerRoundedCorner(color: btnBgColor ?? BaseColors.brand700),
          CcText(
            cancelText ?? el.tr('common.cancel'),
            align: Alignment.center,
            color: cancelTextColor ?? BaseColors.textInvert,
            fontSize: fontSize ?? 14.0,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    ),
  );

  /// confirm button ui
  Widget getConfirmButtonWidget() => SizedBox(
    height: heightActionBtn ?? 35,
    child: CcDebounce(
      onTap: onTapConfirm ?? () => Get.back(),
      child: Stack(
        children: [
          ContainerRoundedCorner(color: btnBgColor ?? BaseColors.brand700),
          CcText(
            agreeText ?? el.tr('common.ok'),
            align: Alignment.center,
            color: confirmTextColor ?? BaseColors.textInvert,
            fontWeight: FontWeight.w600,
            fontSize: fontSize ?? 15.0,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    ),
  );
}
