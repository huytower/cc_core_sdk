import 'dart:math' as math;

import 'package:cc_sdk_ui/export_cc_sdk_ui.dart';
import 'package:flutter/material.dart';

/// Responsive sizes, all driven by one curve: [CcScale].
///
/// Phones keep the original `width / 360` scaling; tablets rise smoothly to
/// the maximum at 840 dp and stay there (wider windows get more layout, not
/// bigger UI). See [CcScale] for the exact table.
extension ResponsiveExtension on BuildContext {
  /// Icon size scaled by [CcScale.dimension] (max 1.5x).
  ///
  /// ```dart
  /// final iconSize = context.respIconSize();
  /// ```
  double respIconSize({double baseSize = 24.0}) =>
      baseSize * CcScale.dimension(screenWidth);

  /// Font size scaled by [CcScale.dimension] (max 1.5x) — for text that does
  /// not come from [CcContextExtension.ccTextTheme].
  ///
  /// ```dart
  /// final fontSize = context.respFontSize(16.0);
  /// ```
  double respFontSize(double baseSize) =>
      baseSize * CcScale.dimension(screenWidth);

  /// Padding or gap scaled by [CcScale.padding] (max 2x).
  ///
  /// ```dart
  /// final padding = context.respPadding(16.0);
  /// ```
  double respPadding(double basePadding) =>
      basePadding * CcScale.padding(screenWidth);

  /// Width/height of a shape or component scaled by [CcScale.dimension]
  /// (max 1.5x).
  ///
  /// ```dart
  /// final width = context.respDim(4.0);
  /// ```
  double respDim(double baseDimension) =>
      baseDimension * CcScale.dimension(screenWidth);

  /// Height of a hero header designed as [heightFactor] of the screen height
  /// on phones.
  ///
  /// Compact windows (phones) get exactly `screenHeight * heightFactor`, as
  /// before. Wider windows are capped at the height the header has on the
  /// reference phone ([referencePhoneSize]), scaled like its content with
  /// [respDim] — so a tall 16:10 tablet no longer spends a third of the screen
  /// on the header. Landscape windows (a tablet held sideways) get exactly that
  /// content-scaled height: a screen-height percentage there would be too low
  /// for content already scaled up for the width, and it would overflow.
  double respHeaderHeight(double heightFactor) {
    final byScreen = screenHeight * heightFactor;
    if (windowSizeClass == CcWindowSizeClass.compact) return byScreen;

    final referenceHeight =
        referencePhoneSize.height *
        heightFactor /
        CcScale.dimension(referencePhoneSize.width);
    final byContent = respDim(referenceHeight);
    if (isLandscape) {
      return byContent;
    }
    return math.min(byScreen, byContent);
  }
}

/// The phone the hero headers were tuned on (390 x 844 dp).
const Size referencePhoneSize = Size(390, 844);
