import 'package:flutter/material.dart';

import '../../core/config/tokens/cc_padding_params.dart';
import '../../core/config/tokens/cc_typography_params.dart';
import '../../core/extensions/cc_context_extension.dart';
import '../../core/extensions/common/cc_responsive_extension.dart';
import '../button/cc_interaction_wrapper.dart';
import '../container/cc_container_rounded_corner.dart';
import '../divider_line/cc_divider.dart';
import '../flex/cc_flex.dart';
import '../text/cc_text.dart';

/// Action buttons, ex. : cancel, okay .v.v.
class CcActionButtonInDialog extends StatelessWidget {
  const CcActionButtonInDialog({
    super.key,
    this.onTapCancel,
    this.onTapConfirm,
    this.hasCancelButtonShown = false,
    this.buttonBackgroundColor,
    this.agreeText,
    this.fontSize,
    this.cancelText,
    this.cancelTextColor,
    this.confirmTextColor,
    this.dividerColor,
    this.heightActionButton,
    this.heightActionButtonBar,
  });

  final VoidCallback? onTapCancel, onTapConfirm;
  final bool hasCancelButtonShown;
  final Color? buttonBackgroundColor, cancelTextColor, confirmTextColor, dividerColor;
  final double? heightActionButton, heightActionButtonBar, fontSize;
  final String? agreeText, cancelText;

  @override
  Widget build(BuildContext context) => getActionButtonsWidget(context);

  Widget getActionButtonsWidget(BuildContext context) => SizedBox(
    height: context.respPadding(heightActionButtonBar ?? 60),
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
              if (hasCancelButtonShown)
                Expanded(flex: 1, child: getCancelButtonWidget(context))
              else
                const SizedBox(),

              /// line widget
              if (hasCancelButtonShown)
                Expanded(
                  flex: 0,
                  child: CcDividerHorizontalLine(
                    color: dividerColor ?? context.ccColorScheme.outlineVariant,
                    width: 0.8,
                    height: context.respPadding(heightActionButtonBar ?? 60),
                  ),
                )
              else
                const SizedBox(),

              /// confirm button widget
              Expanded(
                flex: 1,
                child: hasCancelButtonShown
                    ? getConfirmButtonWidget(context)
                    : Container(
                        margin: EdgeInsets.symmetric(
                          horizontal: context.respPadding(
                            CcPaddingParams.PAGE_LG * 3.5,
                          ),
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
    height: context.respPadding(heightActionButton ?? 35),
    child: CcInteractionWrapper(
      onTap: onTapCancel ?? () => Navigator.of(context).pop(),
      useDebounce: true,
      hasBouncing: true,
      child: Stack(
        children: [
          CcContainerRoundedCorner(
            color: buttonBackgroundColor ?? context.ccColorScheme.primary,
          ),
          CcText(
            cancelText ?? 'Cancel',
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
    height: context.respPadding(heightActionButton ?? 35),
    child: CcInteractionWrapper(
      onTap: onTapConfirm ?? () => Navigator.of(context).pop(),
      useDebounce: true,
      hasBouncing: true,
      child: Stack(
        children: [
          CcContainerRoundedCorner(
            color: buttonBackgroundColor ?? context.ccColorScheme.primary,
          ),
          CcText(
            agreeText ?? 'OK',
            align: Alignment.center,
            color: confirmTextColor ?? context.ccColorScheme.onPrimary,
            fontWeight: CcTypographyParams.semiBold,
            fontSize: fontSize ?? 15.0,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    ),
  );
}
