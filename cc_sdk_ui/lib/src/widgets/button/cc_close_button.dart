import 'package:cc_sdk_ui/export_cc_sdk_ui.dart';
import 'package:flutter/material.dart';

/// Standardized Close Button.
///
/// If no [icon] is provided, it defaults to [Icons.close].
class CcCloseButton extends StatelessWidget {
  final Color? backgroundColor;
  final double? height, width;
  final Widget? icon;
  final VoidCallback? onTap;
  final Color? iconColor;
  final CcInteractionType interactionType;
  final bool useDebounce;

  // Backward compatibility constructor (defaults to bounce)
  const CcCloseButton({
    required this.onTap,
    this.backgroundColor,
    this.height,
    this.width,
    this.icon,
    this.iconColor,
    this.useDebounce = true,
    super.key,
  }) : interactionType = CcInteractionType.bounce;

  // Private internal constructor
  const CcCloseButton._({
    required this.interactionType,
    this.onTap,
    this.backgroundColor,
    this.height,
    this.width,
    this.icon,
    this.iconColor,
    this.useDebounce = true,
    super.key,
  });

  // Named constructors (The "API" for other developers)
  factory CcCloseButton.bouncing({
    required VoidCallback onTap,
    Color? backgroundColor,
    double? height,
    double? width,
    Widget? icon,
    Color? iconColor,
    bool useDebounce = true,
    Key? key,
  }) => CcCloseButton._(
    interactionType: CcInteractionType.bounce,
    onTap: onTap,
    backgroundColor: backgroundColor,
    height: height,
    width: width,
    icon: icon,
    iconColor: iconColor,
    useDebounce: useDebounce,
    key: key,
  );

  factory CcCloseButton.simple({
    required VoidCallback onTap,
    Color? backgroundColor,
    double? height,
    double? width,
    Widget? icon,
    Color? iconColor,
    bool useDebounce = true,
    Key? key,
  }) => CcCloseButton._(
    interactionType: CcInteractionType.tap,
    onTap: onTap,
    backgroundColor: backgroundColor,
    height: height,
    width: width,
    icon: icon,
    iconColor: iconColor,
    useDebounce: useDebounce,
    key: key,
  );

  factory CcCloseButton.static({
    Color? backgroundColor,
    double? height,
    double? width,
    Widget? icon,
    Color? iconColor,
    Key? key,
  }) => CcCloseButton._(
    interactionType: CcInteractionType.none,
    backgroundColor: backgroundColor,
    height: height,
    width: width,
    icon: icon,
    iconColor: iconColor,
    useDebounce: false,
    key: key,
  );

  @override
  Widget build(BuildContext context) {
    final double defaultSize = context.respIconSize(baseSize: 35.0);
    final double defaultIconSize = context.respIconSize(baseSize: 20.0);

    final baseButton = SizedBox(
      width: width ?? defaultSize,
      height: height ?? defaultSize,
      child: Container(
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: backgroundColor ?? Colors.transparent,
          shape: BoxShape.circle,
        ),
        child:
            icon ??
            Icon(
              Icons.close,
              size: defaultIconSize,
              color: iconColor ?? context.ccColorScheme.onSurface,
            ),
      ),
    );

    // If type is none, return the base button directly
    if (interactionType == CcInteractionType.none) {
      return Center(child: baseButton);
    }

    // Otherwise, wrap it in the interaction logic
    return Center(
      child: CcInteractionWrapper(
        onTap: onTap ?? () {},
        useDebounce: useDebounce,
        hasBouncing: interactionType == CcInteractionType.bounce,
        child: baseButton,
      ),
    );
  }
}
