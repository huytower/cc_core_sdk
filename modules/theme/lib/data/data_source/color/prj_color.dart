import 'package:cc_sdk_ui/core/config/tokens/base_colors.dart';
import 'package:flutter/material.dart';

/// `PrjColors` — Semantic color aliases for the application.
///
/// Purpose:
/// - Provide semantic color names used by the app (e.g. `primary`, `error`).
/// - Map those names to the design token SSOT in `cc_sdk_ui.BaseColors`.
///
/// Usage:
/// ```dart
/// // Use Theme's colorScheme in widgets
/// final cs = Theme.of(context).colorScheme;
/// final primary = cs.primary; // backed by PrjColors.primary -> BaseColors
/// ```
///
/// Note: To change brand/primitive values, update `libraries/cc_sdk_ui/lib/core/config/tokens/base_colors.dart`.
/// This keeps color changes centralized and consistent with Figma tokens.
class PrjColors {
  // ====================================
  // Primary Colors (Brand Identity)
  // ====================================

  static const Color primary = BaseColors.actionPrimary;
  static const Color onPrimary = BaseColors.textInvert;
  static const Color primaryContainer = BaseColors.brand300;
  static const Color onPrimaryContainer = BaseColors.neutral100;
  static const Color primaryPressed = BaseColors.actionPrimaryPressed;

  // ====================================
  // Secondary Colors
  // ====================================

  static const Color secondary = BaseColors.secondary500;
  static const Color onSecondary = BaseColors.textInvert;
  static const Color secondaryContainer = BaseColors.secondary800;
  static const Color onSecondaryContainer = BaseColors.textInvert;

  // ====================================
  // Semantic Colors (States)
  // ====================================

  static const Color success = BaseColors.success;
  static const Color onSuccess = BaseColors.textInvert;

  static const Color warning = BaseColors.warning;
  static const Color onWarning = BaseColors.neutral100;

  static const Color error = BaseColors.error;
  static const Color onError = BaseColors.textInvert;

  static const Color info = BaseColors.info;
  static const Color onInfo = BaseColors.textInvert;

  // ====================================
  // Background & Surface
  // ====================================

  static const Color background = BaseColors.surfaceDefault;
  static const Color onBackground = BaseColors.textPrimary;

  static const Color surface = BaseColors.surfaceDefault;
  static const Color onSurface = BaseColors.textPrimary;
  static const Color surfaceVariant = BaseColors.surfaceVariant;
  static const Color onSurfaceVariant = BaseColors.textSecondary;
  static const Color surfaceOverlay = BaseColors.surfaceOverlay;

  // ====================================
  // Text Selection
  // ====================================

  static const Color highEmphasis = BaseColors.textPrimary;
  static const Color mediumEmphasis = BaseColors.textSecondary;
  static const Color disabled = BaseColors.textDisabled;
  static const Color hint = BaseColors.textDisabled;

  // ====================================
  // Borders & Dividers
  // ====================================

  static const Color outline = BaseColors.neutral30;
  static const Color outlineVariant = BaseColors.neutral10;
  static const Color divider = BaseColors.divider;

  // Functional Aliases
  static const Color blue = BaseColors.info;
  static const Color pink = BaseColors.actionPrimary;
}

/// Extension methods for consistent opacity handling
extension PrjColorsExtension on PrjColors {
  static Color withOpacity(Color color, double opacity) =>
      color.withOpacity(opacity);
}
