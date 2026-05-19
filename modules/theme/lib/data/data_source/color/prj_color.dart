import 'package:cc_sdk_ui/core/theme/base_colors.dart';
import 'package:flutter/material.dart';

/// A comprehensive color system for the application that follows Material Design 3
/// and provides semantic color mappings for text and UI elements.
///
/// Inherits from [BaseColors] (UI SDK) as the Single Source of Truth.
class PrjColors {
  // ====================================
  // Primary Colors (Brand Identity)
  // ====================================

  static const Color primary = BaseColors.actionPrimary;
  static const Color onPrimary = BaseColors.textInvert;
  static const Color primaryContainer = BaseColors.brand300;
  static const Color onPrimaryContainer = BaseColors.neutral100;

  // ====================================
  // Secondary Colors
  // ====================================

  static const Color secondary = BaseColors.secondary500;
  static const Color onSecondary = BaseColors.textInvert;
  static const Color secondaryContainer = BaseColors.secondary800;

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
