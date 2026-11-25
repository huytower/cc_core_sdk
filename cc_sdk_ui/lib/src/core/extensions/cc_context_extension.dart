import 'package:flutter/material.dart';

import '../config/tokens/cc_border_params.dart';
import '../config/tokens/cc_border_radius.dart';
import '../layout/cc_scale.dart';
import '../layout/cc_window_height_class.dart';
import '../layout/cc_window_size_class.dart';
import 'common/cc_responsive_extension.dart';

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
  bool get hasDarkMode => Theme.of(this).brightness == Brightness.dark;

  // ==========================================================================
  // RESPONSIVE HELPERS
  // ==========================================================================

  /// Check if the current orientation is portrait.
  bool get hasPortrait =>
      MediaQuery.orientationOf(this) == Orientation.portrait;

  /// Check if the current orientation is landscape.
  bool get hasLandscape =>
      MediaQuery.orientationOf(this) == Orientation.landscape;

  /// Gets the current window width (dp).
  double get screenWidth => MediaQuery.sizeOf(this).width;

  /// Gets the current window height (dp).
  double get screenHeight => MediaQuery.sizeOf(this).height;

  /// The Material 3 width class of the current window. Branch adaptive
  /// layouts (navigation, panes, columns) on this — or, inside a pane, on
  /// the pane's constraints via `CcAdaptiveBuilder`.
  CcWindowSizeClass get windowSizeClass => CcWindowSizeClass.of(this);

  /// The Material 3 height class of the current window.
  CcWindowHeightClass get windowHeightClass => CcWindowHeightClass.of(this);

  /// A reusable vertical linear gradient using the theme's primary color.
  LinearGradient get primaryVerticalGradient =>
      verticalGradient(ccColorScheme.primary);

  /// A reusable vertical linear gradient using the provided [color].
  LinearGradient verticalGradient(Color color) => LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [color.withAlpha(10), color.withAlpha(70)],
    stops: const [0.0, 1.0],
  );

  /// A [TextTheme] copy whose font sizes are scaled to the current screen size.
  ///
  /// The base [PrjTextStyle] tokens are fixed logical pixels (e.g.
  /// [CcTypographyParams.labelMedium] = 12). On large screens those sizes look
  /// disproportionately small, so each size is multiplied by
  /// [CcScale.text]: 1.0x on phones, rising smoothly to 1.2x at 840 dp.
  /// Non-size attributes (weight, color, height, letter-spacing) are
  /// preserved.
  TextTheme get ccResponsiveTextTheme {
    final base = Theme.of(this).textTheme;
    final factor = CcScale.text(screenWidth);
    TextStyle scale(TextStyle? style) => style == null
        ? const TextStyle()
        : style.copyWith(
            fontSize: style.fontSize == null ? null : style.fontSize! * factor,
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

  // ==========================================================================
  // GRADIENT TOKENS
  // ==========================================================================

  /// A reusable glassy vertical gradient for card/container surfaces.
  LinearGradient get surfaceGradient => LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [
      ccColorScheme.onPrimary.withAlpha(15),
      ccColorScheme.primaryContainer.withAlpha(30),
      ccColorScheme.primaryContainer.withAlpha(50),
    ],
    stops: const [0.0, 0.4, 1.0],
  );

  // ==========================================================================
  // BORDER TOKENS
  // ==========================================================================

  /// A subtle border for cards and containers.
  Border get borderSubtle => Border.all(
    color: ccColorScheme.onSurface.withValues(alpha: 0.08),
    width: respDim(CcBorderParams.subtleWidth),
  );

  /// A medium-weight border for elevated components.
  Border get borderMedium => Border.all(
    color: ccColorScheme.onSurface.withValues(alpha: 0.12),
    width: respDim(CcBorderParams.mediumWidth),
  );

  /// A strong border for focused or active states.
  Border get borderStrong => Border.all(
    color: ccColorScheme.primary,
    width: respDim(CcBorderParams.strongWidth),
  );

  /// A subtle border for text field-like containers.
  Border get borderTextField =>
      Border.all(color: ccColorScheme.outlineVariant.withAlpha(10), width: 0.4);

  /// A subtle OutlineInputBorder for text fields, matching [borderTextField].
  OutlineInputBorder get inputBorderTextField => OutlineInputBorder(
    borderRadius: brMd,
    borderSide: BorderSide(
      color: ccColorScheme.outlineVariant.withAlpha(10),
      width: 0.4,
    ),
  );
}
