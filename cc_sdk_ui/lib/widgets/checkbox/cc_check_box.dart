import 'package:flutter/material.dart';

import '../../export_cc_sdk_ui.dart';

class CcCheckBox extends StatelessWidget {
  const CcCheckBox({
    super.key,
    required this.isChecked,
    required this.onChanged,
    this.interactionType = CcInteractionType.bounce,
    this.useDebounce = true,
    this.checkedColor,
    this.uncheckedBorderColor,
  });

  final bool isChecked;
  final ValueChanged<bool> onChanged;
  final CcInteractionType interactionType;
  final bool useDebounce;
  final Color? checkedColor;
  final Color? uncheckedBorderColor;

  @override
  Widget build(BuildContext context) {
    final effectiveCheckedColor = checkedColor ?? context.ccColorScheme.primary;
    final effectiveUncheckedBorderColor =
        uncheckedBorderColor ?? context.ccColorScheme.outline;
    final baseContent = Container(
      width: context.respIconSize(baseSize: 18.0),
      height: context.respIconSize(baseSize: 18.0),
      decoration: BoxDecoration(
        color: isChecked ? effectiveCheckedColor : Colors.transparent,
        border: Border.all(
          color: isChecked
              ? effectiveCheckedColor
              : effectiveUncheckedBorderColor,
          width: 2,
        ),
        borderRadius: BorderRadius.circular(CcCircularParams.RADIUS_XS),
      ),
      child: isChecked
          ? Icon(
              Icons.check,
              size: context.respIconSize(baseSize: 16.0),
              color: context.ccColorScheme.onPrimary,
            )
          : null,
    );

    if (interactionType == CcInteractionType.none) {
      return baseContent;
    }

    return CcInteractBtnWrapper(
      onTap: () => onChanged(!isChecked),
      useDebounce: useDebounce,
      isBouncing: interactionType == CcInteractionType.bounce,
      child: baseContent,
    );
  }
}
