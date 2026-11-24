import 'package:flutter/material.dart';

import '../../core/layout/cc_window_size_class.dart';

/// A modal bottom sheet that stays a sensible size on tablets.
///
/// Phones (window < 600 dp) get the normal full-width sheet. From a small
/// tablet up, Material's default 640 dp cap is too wide for short, list-like
/// sheets, so the sheet is narrowed to `tabletMaxWidth` and centred. Pass a
/// larger `tabletMaxWidth` for sheets that lay content out in columns.
///
/// Defaults suit sheets whose content draws its own surface (transparent
/// background, kept clear of the system bars). Pass `backgroundColor: null` to
/// use the theme's sheet colour.
///
/// ```dart
/// final picked = await CcAdaptiveBottomSheet.show<int>(
///   context: context,
///   builder: (_) => const MyPickerSheet(),
/// );
/// ```
abstract final class CcAdaptiveBottomSheet {
  /// Default width of the sheet from a small tablet up.
  static const double defaultTabletMaxWidth = 480;

  /// Shows [builder] in a modal bottom sheet (see the class doc).
  static Future<T?> show<T>({
    required BuildContext context,
    required WidgetBuilder builder,
    double tabletMaxWidth = defaultTabletMaxWidth,
    Color? backgroundColor = Colors.transparent,
    Color? barrierColor,
    ShapeBorder? shape,
    bool hasScrollControlled = true,
    bool hasDismissible = true,
    bool hasDrag = true,
    bool hasSafeArea = true,
  }) {
    return showModalBottomSheet<T>(
      context: context,
      isScrollControlled: hasScrollControlled,
      useSafeArea: hasSafeArea,
      isDismissible: hasDismissible,
      enableDrag: hasDrag,
      backgroundColor: backgroundColor,
      barrierColor: barrierColor,
      shape: shape,
      constraints: constraintsFor(context, tabletMaxWidth: tabletMaxWidth),
      builder: builder,
    );
  }

  /// The width cap [show] applies: `tabletMaxWidth` from a small tablet up,
  /// none (Material's default) on phones.
  static BoxConstraints? constraintsFor(
    BuildContext context, {
    double tabletMaxWidth = defaultTabletMaxWidth,
  }) {
    final hasTablet = CcWindowSizeClass.of(
      context,
    ).hasAtLeast(CcWindowSizeClass.medium);
    return hasTablet ? BoxConstraints(maxWidth: tabletMaxWidth) : null;
  }
}
