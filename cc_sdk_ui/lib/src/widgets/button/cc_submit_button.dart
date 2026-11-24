import 'package:flutter/material.dart';

import '../../../export_cc_sdk_ui.dart';

/// The main call-to-action of a form: a centred, rounded button that shows a
/// spinner while [hasSubmitting], is disabled unless [hasEnabled], and can
/// carry a [badge], a [leadingIcon] or a [gradient] fill.
///
/// ```dart
/// CcSubmitButton(
///   text: 'Save',
///   hasSubmitting: state.hasSaving,
///   hasEnabled: state.hasValid,
///   onTap: controller.save,
///   activeColor: context.ccColorScheme.primary,
/// )
/// ```
class CcSubmitButton extends StatelessWidget {
  const CcSubmitButton({
    super.key,
    required this.text,
    required this.hasSubmitting,
    required this.hasEnabled,
    required this.onTap,
    required this.activeColor,
    this.badge,
    this.widthFactor = 0.6,
    this.height,
    this.textStyle,
    this.leadingIcon,
    this.leadingIconSize = 20,
    this.gradient,
    this.gradientForegroundColor,
  });

  final String text;
  final bool hasSubmitting;
  final bool hasEnabled;
  final VoidCallback onTap;

  /// Solid fill of the button (when no [gradient] applies).
  final Color activeColor;

  /// Widget pinned just outside the bottom-right corner (a count, a lock).
  final Widget? badge;

  /// Fraction of the available width the button takes.
  final double widthFactor;

  /// Button height. Defaults to `context.respDim(40)`.
  final double? height;

  /// Label style. Defaults to `context.ccTextTheme.titleMedium`.
  final TextStyle? textStyle;

  /// Decorative icon left of [text]; part of the label, same colour.
  final IconData? leadingIcon;

  /// Base size for [leadingIcon], scaled with `context.respIconSize`.
  final double leadingIconSize;

  /// Fill painted instead of [activeColor] while the button is enabled.
  final Gradient? gradient;

  /// Label / icon colour on top of [gradient]. Defaults to `onPrimary`.
  final Color? gradientForegroundColor;

  @override
  Widget build(BuildContext context) {
    final scheme = context.ccColorScheme;
    final baseStyle = textStyle ?? context.ccTextTheme.titleMedium;
    final borderRadius = BorderRadius.circular(12);
    final hasGradient = gradient != null && hasEnabled;
    final foreground = hasGradient
        ? gradientForegroundColor ?? scheme.onPrimary
        : scheme.onPrimary;
    return Center(
      child: FractionallySizedBox(
        widthFactor: widthFactor,
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            Container(
              width: double.infinity,
              height: height ?? context.respDim(40),
              decoration: hasGradient
                  ? BoxDecoration(
                      gradient: gradient,
                      borderRadius: borderRadius,
                    )
                  : null,
              child: ElevatedButton(
                onPressed: hasEnabled && !hasSubmitting ? onTap : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: hasGradient
                      ? Colors.transparent
                      : activeColor,
                  disabledBackgroundColor: hasGradient
                      ? Colors.transparent
                      : null,
                  shadowColor: hasGradient ? Colors.transparent : null,
                  padding: EdgeInsets.symmetric(
                    horizontal: context.respPadding(CcPaddingParams.SPACE_SM),
                  ),
                  shape: RoundedRectangleBorder(borderRadius: borderRadius),
                ),
                child: hasSubmitting
                    ? SizedBox(
                        width: context.respDim(20),
                        height: context.respDim(20),
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor: AlwaysStoppedAnimation<Color>(foreground),
                        ),
                      )
                    : _buildLabel(context, foreground, baseStyle),
              ),
            ),
            if (badge != null)
              Positioned(bottom: -10, right: -10, child: badge!),
          ],
        ),
      ),
    );
  }

  /// `[leadingIcon] [text]`. Only the text scales down (a narrow
  /// [widthFactor] or a long translation); the icon keeps its size. Plain
  /// [Text] because `CcText` wraps its content in an [Align], which fights the
  /// [Flexible] / [FittedBox] sizing; the style still comes from the theme.
  Widget _buildLabel(
    BuildContext context,
    Color foreground,
    TextStyle? baseStyle,
  ) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        if (leadingIcon != null) ...[
          Icon(
            leadingIcon,
            size: context.respIconSize(baseSize: leadingIconSize),
            color: foreground,
          ),
          const CcSpaceXS(),
        ],
        Flexible(
          child: FittedBox(
            fit: BoxFit.scaleDown,
            child: Text(
              text,
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: baseStyle?.copyWith(
                color: foreground,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
