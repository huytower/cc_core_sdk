import 'package:cc_sdk/export_cc_sdk.dart';
import 'package:flutter/material.dart';

/// Extension on BuildContext to easily access project-standard theme properties.
///
/// This provides a state-management and font-agnostic way for widgets in the
/// UI library to synchronize with the application's theme.
extension CcContextExtension on BuildContext {
  /// Access the Material TextTheme.
  ///
  /// The returned theme scales its font sizes up on tablet/desktop so that
  /// text keeps a consistent visual size across screen densities (a 9" tablet
  /// would otherwise render the same logical-pixel sizes far too small).
  TextTheme get ccTextTheme => ccResponsiveTextTheme;

  /// Access the Material ColorScheme.
  ColorScheme get ccColorScheme => Theme.of(this).colorScheme;

  /// Access the overall Theme.
  ThemeData get ccTheme => Theme.of(this);

  /// Check if the current theme is dark.
  bool get isDarkMode => Theme.of(this).brightness == Brightness.dark;

  // ==========================================================================
  // RESPONSIVE HELPERS
  // ==========================================================================

  /// Check if the current orientation is portrait.
  bool get isPortrait => CcResponsiveHelper.isPortrait(this);

  /// Check if the current orientation is landscape.
  bool get isLandscape => CcResponsiveHelper.isLandscape(this);

  /// Checks if the current screen is a mobile device.
  bool get isMobile => CcResponsiveHelper.isMobile(this);

  /// Checks if the current screen is a tablet device.
  bool get isTablet => CcResponsiveHelper.isTablet(this);

  /// Checks if the current screen is a desktop device.
  bool get isDesktop => CcResponsiveHelper.isDesktop(this);

  /// Checks if the current screen is a small mobile device.
  bool get isSmallMobile => CcResponsiveHelper.isSmallMobile(this);

  /// Checks if the current screen is a large mobile device.
  bool get isLargeMobile => CcResponsiveHelper.isLargeMobile(this);

  /// Gets the current screen width.
  double get screenWidth => CcResponsiveHelper.screenWidth(this);

  /// Gets the current screen height.
  double get screenHeight => CcResponsiveHelper.screenHeight(this);

  /// Gets the screen type as an enum.
  ScreenType get screenType => CcResponsiveHelper.getScreenType(this);

  /// A [TextTheme] copy whose font sizes are scaled to the current screen size.
  ///
  /// The base [CcTextStyle] tokens are fixed logical pixels (e.g.
  /// [CcTypographyParams.labelMedium] = 12). On large screens those sizes look
  /// disproportionately small, so we multiply each size by the same responsive
  /// factor used elsewhere ([CcResponsiveHelper.getResponsiveFontSize]):
  /// mobile = 1.0x, tablet = 1.2x, desktop = 1.4x. Non-size attributes
  /// (weight, color, height, letter-spacing) are preserved.
  TextTheme get ccResponsiveTextTheme {
    final base = Theme.of(this).textTheme;
    TextStyle scale(TextStyle? style) => style == null
        ? const TextStyle()
        : style.copyWith(
            fontSize: style.fontSize == null
                ? null
                : CcResponsiveHelper.getResponsiveFontSize(
                    context: this,
                    mobileFontSize: style.fontSize!,
                  ),
          );

    return base.copyWith(
      displayLarge: scale(base.displayLarge),
      displayMedium: scale(base.displayMedium),
      displaySmall: scale(base.displaySmall),
      headlineLarge: scale(base.headlineLarge),
      headlineMedium: scale(base.headlineMedium),
      headlineSmall: scale(base.headlineSmall),
      titleLarge: scale(base.titleLarge),
      titleMedium: scale(base.titleMedium),
      titleSmall: scale(base.titleSmall),
      bodyLarge: scale(base.bodyLarge),
      bodyMedium: scale(base.bodyMedium),
      bodySmall: scale(base.bodySmall),
      labelLarge: scale(base.labelLarge),
      labelMedium: scale(base.labelMedium),
      labelSmall: scale(base.labelSmall),
    );
  }
}
