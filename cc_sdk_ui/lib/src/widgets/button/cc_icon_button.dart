import 'package:cc_sdk_ui/export_cc_sdk_ui.dart';
import 'package:flutter/material.dart';

/// A standardized Icon Button that supports the project's interaction patterns (bounce/debounce).
class CcIconButton extends StatelessWidget {
  final Widget icon;
  final VoidCallback? onTap;
  final Color? backgroundColor;
  final double? height, width;
  final CcInteractionType interactionType;
  final bool useDebounce;
  final String? tooltip;
  final bool hasEnable;

  const CcIconButton({
    required this.icon,
    required this.onTap,
    this.backgroundColor,
    this.height,
    this.width,
    this.useDebounce = true,
    this.tooltip,
    this.hasEnable = true,
    super.key,
  }) : interactionType = CcInteractionType.bounce;

  const CcIconButton._({
    required this.icon,
    required this.interactionType,
    this.onTap,
    this.backgroundColor,
    this.height,
    this.width,
    this.useDebounce = true,
    this.tooltip,
    this.hasEnable = true,
    super.key,
  });

  factory CcIconButton.bouncing({
    required Widget icon,
    required VoidCallback onTap,
    Color? backgroundColor,
    double? height,
    double? width,
    bool useDebounce = true,
    String? tooltip,
    bool hasEnable = true,
    Key? key,
  }) => CcIconButton._(
    icon: icon,
    interactionType: CcInteractionType.bounce,
    onTap: onTap,
    backgroundColor: backgroundColor,
    height: height,
    width: width,
    useDebounce: useDebounce,
    tooltip: tooltip,
    hasEnable: hasEnable,
    key: key,
  );

  factory CcIconButton.simple({
    required Widget icon,
    required VoidCallback onTap,
    Color? backgroundColor,
    double? height,
    double? width,
    bool useDebounce = true,
    String? tooltip,
    bool hasEnable = true,
    Key? key,
  }) => CcIconButton._(
    icon: icon,
    interactionType: CcInteractionType.tap,
    onTap: onTap,
    backgroundColor: backgroundColor,
    height: height,
    width: width,
    useDebounce: useDebounce,
    tooltip: tooltip,
    hasEnable: hasEnable,
    key: key,
  );

  @override
  Widget build(BuildContext context) {
    final double defaultSize = context.respDim(30.0);

    final Widget button = Opacity(
      opacity: hasEnable ? 1.0 : 0.5,
      child: Container(
        width: width ?? defaultSize,
        height: height ?? defaultSize,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: backgroundColor ?? Colors.transparent,
          shape: BoxShape.circle,
        ),
        child: icon,
      ),
    );

    final Widget interactiveButton = CcInteractionWrapper(
      onTap: onTap ?? () {},
      useDebounce: useDebounce,
      hasBouncing: interactionType == CcInteractionType.bounce,
      hasEnable: hasEnable,
      child: button,
    );

    if (tooltip != null) {
      return Tooltip(message: tooltip!, child: interactiveButton);
    }

    return interactiveButton;
  }
}
