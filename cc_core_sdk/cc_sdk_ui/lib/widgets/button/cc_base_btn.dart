import 'package:flutter/material.dart';

import '../../core/extensions/cc_context_extension.dart';
import '../../core/extensions/common/cc_responsive_extension.dart';
import '../../core/helper/cc_widget_helper.dart';
import '../text/cc_text.dart';
import 'cc_bounce_animation.dart';
import 'cc_interaction_type.dart';

class CcBaseBtn extends StatelessWidget {
  final String? title;
  final List<Color>? bgColor;
  final Color? textColor;
  final bool isEnable;
  final double? height, width;
  final BorderRadius? borderRadius;
  final List<Color>? colorsGradient;
  final bool allowShowLoading;
  final VoidCallback? onTap;
  final CcInteractionType interactionType;

  // Backward compatibility constructor (defaults to bounce)
  const CcBaseBtn({
    super.key,
    this.title,
    this.bgColor,
    this.textColor,
    this.isEnable = true,
    this.height,
    this.width,
    this.borderRadius,
    this.colorsGradient,
    this.allowShowLoading = true,
    this.onTap,
  }) : interactionType = CcInteractionType.bounce;

  // Private internal constructor
  const CcBaseBtn._({
    required this.interactionType,
    this.title,
    this.bgColor,
    this.textColor,
    this.isEnable = true,
    this.height,
    this.width,
    this.borderRadius,
    this.colorsGradient,
    this.allowShowLoading = true,
    this.onTap,
    super.key,
  });

  // Named constructors
  factory CcBaseBtn.bouncing({
    Key? key,
    String? title,
    List<Color>? bgColor,
    Color? textColor,
    bool isEnable = true,
    double? height,
    double? width,
    BorderRadius? borderRadius,
    List<Color>? colorsGradient,
    bool allowShowLoading = true,
    VoidCallback? onTap,
  }) =>
      CcBaseBtn._(
        interactionType: CcInteractionType.bounce,
        title: title,
        bgColor: bgColor,
        textColor: textColor,
        isEnable: isEnable,
        height: height,
        width: width,
        borderRadius: borderRadius,
        colorsGradient: colorsGradient,
        allowShowLoading: allowShowLoading,
        onTap: onTap,
        key: key,
      );

  factory CcBaseBtn.simple({
    Key? key,
    String? title,
    List<Color>? bgColor,
    Color? textColor,
    bool isEnable = true,
    double? height,
    double? width,
    BorderRadius? borderRadius,
    List<Color>? colorsGradient,
    bool allowShowLoading = true,
    VoidCallback? onTap,
  }) =>
      CcBaseBtn._(
        interactionType: CcInteractionType.tap,
        title: title,
        bgColor: bgColor,
        textColor: textColor,
        isEnable: isEnable,
        height: height,
        width: width,
        borderRadius: borderRadius,
        colorsGradient: colorsGradient,
        allowShowLoading: allowShowLoading,
        onTap: onTap,
        key: key,
      );

  factory CcBaseBtn.static({
    Key? key,
    String? title,
    List<Color>? bgColor,
    Color? textColor,
    bool isEnable = true,
    double? height,
    double? width,
    BorderRadius? borderRadius,
    List<Color>? colorsGradient,
    bool allowShowLoading = true,
  }) =>
      CcBaseBtn._(
        interactionType: CcInteractionType.none,
        title: title,
        bgColor: bgColor,
        textColor: textColor,
        isEnable: isEnable,
        height: height,
        width: width,
        borderRadius: borderRadius,
        colorsGradient: colorsGradient,
        allowShowLoading: allowShowLoading,
        key: key,
      );

  @override
  Widget build(BuildContext context) {
    final child = Container(
      height: height ?? context.respDim(48.0),
      width: width ?? double.infinity,
      decoration: BoxDecoration(
        borderRadius: borderRadius ?? CcWidgetHelper.getBorderRoundedSM(),
        gradient: LinearGradient(
          colors:
              bgColor ??
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
              (isEnable
                  ? context.ccColorScheme.onPrimary
                  : context.ccColorScheme.onSurfaceVariant),
          fontWeight: FontWeight.bold,
        ),
      ),
    );

    switch (interactionType) {
      case CcInteractionType.none:
        return child;
      case CcInteractionType.tap:
        return GestureDetector(
          onTap: isEnable ? onTap : null,
          behavior: HitTestBehavior.opaque,
          child: child,
        );
      case CcInteractionType.bounce:
        return CcBounceAnimation(
          onTap: isEnable ? (onTap ?? () {}) : () {},
          child: child,
        );
    }
  }
}
