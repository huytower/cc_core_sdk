import 'package:flutter/material.dart';
import '../../core/helper/widget_helper.dart';
import '../../core/theme/base_colors.dart';

/// A customized InkWell that respects design standards and fixes common focus issues.
class CcInkWell extends StatelessWidget {
  final Widget? child;
  final VoidCallback onTap;
  final VoidCallback? onLongPress;
  final BorderRadius? borderRadius;
  final Color? splashColor;
  final double? width;
  final double? height;

  const CcInkWell({
    super.key,
    this.child,
    required this.onTap,
    this.onLongPress,
    this.borderRadius,
    this.splashColor,
    this.width,
    this.height,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        onLongPress: onLongPress,
        splashColor: splashColor ?? BaseColors.neutral5,
        borderRadius: borderRadius ?? WidgetHelper.getBorderRoundedSmall(),
        /// Prevents common focus issues in lists
        canRequestFocus: false,
        child: SizedBox(
          width: width,
          height: height,
          child: child,
        ),
      ),
    );
  }
}


/// Helper widget for circular ink well button with rounded corners
class ButtonInkWellCircleWidget extends StatelessWidget {
  const ButtonInkWellCircleWidget({
    Key? key,
    required this.onTap,
    required this.child,
    this.borderRadius,
  }) : super(key: key);

  final VoidCallback onTap;
  final Widget child;
  final BorderRadius? borderRadius;

  @override
  Widget build(BuildContext context) {
    return CcInkWell(
      onTap: onTap,
      borderRadius: borderRadius ?? WidgetHelper.getCircleBorderRadius(),
      child: child,
    );
  }
}

/// Helper widget for clipped ink well button with aspect ratio
class ButtonInkWellClipWidget extends StatelessWidget {
  const ButtonInkWellClipWidget({
    Key? key,
    required this.aspectRatio,
    required this.onTap,
    required this.child,
  }) : super(key: key);

  final double aspectRatio;
  final VoidCallback onTap;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: WidgetHelper.getCircleBorderRadius(),
      child: AspectRatio(
        aspectRatio: aspectRatio,
        child: CcInkWell(
          onTap: onTap,
          borderRadius: WidgetHelper.getCircleBorderRadius(),
          child: child,
        ),
      ),
    );
  }
}

