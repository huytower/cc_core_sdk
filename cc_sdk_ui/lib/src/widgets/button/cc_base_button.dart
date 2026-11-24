import 'package:cc_sdk_ui/export_cc_sdk_ui.dart';
import 'package:flutter/material.dart';

class CcBaseButton extends StatelessWidget {
  final String? title;
  final List<Color>? backgroundColor;
  final Color? textColor;
  final bool hasEnable;
  final double? height, width;
  final BorderRadius? borderRadius;
  final List<Color>? colorsGradient;
  final bool allowShowLoading;
  final VoidCallback? onTap;
  final CcInteractionType interactionType;
  final bool useDebounce;

  // Backward compatibility constructor (defaults to bounce)
  const CcBaseButton({
    super.key,
    this.title,
    this.backgroundColor,
    this.textColor,
    this.hasEnable = true,
    this.height,
    this.width,
    this.borderRadius,
    this.colorsGradient,
    this.allowShowLoading = true,
    this.onTap,
    this.useDebounce = true,
  }) : interactionType = CcInteractionType.bounce;

  // Private internal constructor
  const CcBaseButton._({
    required this.interactionType,
    this.title,
    this.backgroundColor,
    this.textColor,
    this.hasEnable = true,
    this.height,
    this.width,
    this.borderRadius,
    this.colorsGradient,
    this.allowShowLoading = true,
    this.onTap,
    this.useDebounce = true,
    super.key,
  });

  // Named constructors
  factory CcBaseButton.bouncing({
    Key? key,
    String? title,
    List<Color>? backgroundColor,
    Color? textColor,
    bool hasEnable = true,
    double? height,
    double? width,
    BorderRadius? borderRadius,
    List<Color>? colorsGradient,
    bool allowShowLoading = true,
    VoidCallback? onTap,
    bool useDebounce = true,
  }) => CcBaseButton._(
    interactionType: CcInteractionType.bounce,
    title: title,
    backgroundColor: backgroundColor,
    textColor: textColor,
    hasEnable: hasEnable,
    height: height,
    width: width,
    borderRadius: borderRadius,
    colorsGradient: colorsGradient,
    allowShowLoading: allowShowLoading,
    onTap: onTap,
    useDebounce: useDebounce,
    key: key,
  );

  factory CcBaseButton.simple({
    Key? key,
    String? title,
    List<Color>? backgroundColor,
    Color? textColor,
    bool hasEnable = true,
    double? height,
    double? width,
    BorderRadius? borderRadius,
    List<Color>? colorsGradient,
    bool allowShowLoading = true,
    VoidCallback? onTap,
    bool useDebounce = true,
  }) => CcBaseButton._(
    interactionType: CcInteractionType.tap,
    title: title,
    backgroundColor: backgroundColor,
    textColor: textColor,
    hasEnable: hasEnable,
    height: height,
    width: width,
    borderRadius: borderRadius,
    colorsGradient: colorsGradient,
    allowShowLoading: allowShowLoading,
    onTap: onTap,
    useDebounce: useDebounce,
    key: key,
  );

  factory CcBaseButton.static({
    Key? key,
    String? title,
    List<Color>? backgroundColor,
    Color? textColor,
    bool hasEnable = true,
    double? height,
    double? width,
    BorderRadius? borderRadius,
    List<Color>? colorsGradient,
    bool allowShowLoading = true,
  }) => CcBaseButton._(
    interactionType: CcInteractionType.none,
    title: title,
    backgroundColor: backgroundColor,
    textColor: textColor,
    hasEnable: hasEnable,
    height: height,
    width: width,
    borderRadius: borderRadius,
    colorsGradient: colorsGradient,
    allowShowLoading: allowShowLoading,
    useDebounce: false,
    key: key,
  );

  @override
  Widget build(BuildContext context) {
    final baseContent = Container(
      height: height ?? context.respDim(48.0),
      width: width ?? double.infinity,
      decoration: BoxDecoration(
        borderRadius: borderRadius ?? CcWidgetHelper.getBorderRoundedSM(),
        gradient: LinearGradient(
          colors:
              backgroundColor ??
              colorsGradient ??
              [
                context.ccColorScheme.surfaceVariant,
                context.ccColorScheme.surfaceVariant,
              ],
        ),
      ),
      child: Center(
        child: CcText(
          title ?? '',
          align: Alignment.center,
          textAlign: TextAlign.center,
          color:
              textColor ??
              (hasEnable
                  ? context.ccColorScheme.onPrimary
                  : context.ccColorScheme.onSurfaceVariant),
          fontWeight: CcTypographyParams.bold,
        ),
      ),
    );

    // If type is none or not enabled, return the base content directly
    if (interactionType == CcInteractionType.none || !hasEnable) {
      return baseContent;
    }

    // Otherwise, wrap it in the interaction logic
    return CcInteractionWrapper(
      onTap: onTap ?? () {},
      useDebounce: useDebounce,
      hasBouncing: interactionType == CcInteractionType.bounce,
      child: baseContent,
    );
  }
}
