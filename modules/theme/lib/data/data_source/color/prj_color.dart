import 'package:cc_sdk_ui/core/config/tokens/cc_base_colors.dart';
import 'package:flutter/material.dart';

/// PrjColors: Maps the UI Library's design tokens to the application's specific
/// color requirements.
///
/// ## Principles
/// - Avoid defining raw hex codes here.
/// - Map those names to the design token SSOT in `cc_sdk_ui.CcBaseColors`.
///
/// ## Usage (App Side)
/// ```dart
/// final cs = Theme.of(context).colorScheme;
/// final primary = cs.primary; // backed by PrjColors.primary -> CcBaseColors
/// ```
///
/// Note: To change brand/primitive values, update `libraries/cc_sdk_ui/lib/core/config/tokens/cc_base_colors.dart`.
abstract final class PrjColors {
  PrjColors._();

  // -- Brand/Primary
  static const Color primary = CcBaseColors.actionPrimary;
  static const Color onPrimary = CcBaseColors.textInvert;
  static const Color primaryContainer = CcBaseColors.brand300;
  static const Color onPrimaryContainer = CcBaseColors.neutral100;
  static const Color primaryPressed = CcBaseColors.actionPrimaryPressed;

  // -- Secondary
  static const Color secondary = CcBaseColors.secondary500;
  static const Color onSecondary = CcBaseColors.textInvert;
  static const Color secondaryContainer = CcBaseColors.secondary800;
  static const Color onSecondaryContainer = CcBaseColors.textInvert;

  // -- Status/Feedback
  static const Color success = CcBaseColors.success;
  static const Color onSuccess = CcBaseColors.textInvert;

  static const Color warning = CcBaseColors.warning;
  static const Color onWarning = CcBaseColors.neutral100;

  static const Color error = CcBaseColors.error;
  static const Color onError = CcBaseColors.textInvert;

  static const Color info = CcBaseColors.info;
  static const Color onInfo = CcBaseColors.textInvert;

  // -- Surfaces
  static const Color background = CcBaseColors.surfaceDefault;
  static const Color onBackground = CcBaseColors.textPrimary;

  static const Color surface = CcBaseColors.surfaceDefault;
  static const Color onSurface = CcBaseColors.textPrimary;
  static const Color surfaceVariant = CcBaseColors.surfaceVariant;
  static const Color onSurfaceVariant = CcBaseColors.textSecondary;
  static const Color surfaceOverlay = CcBaseColors.surfaceOverlay;

  // -- Text Emphasis
  static const Color highEmphasis = CcBaseColors.textPrimary;
  static const Color mediumEmphasis = CcBaseColors.textSecondary;
  static const Color disabled = CcBaseColors.textDisabled;
  static const Color hint = CcBaseColors.textDisabled;

  // -- Borders/Dividers
  static const Color outline = CcBaseColors.neutral30;
  static const Color outlineVariant = CcBaseColors.neutral10;
  static const Color divider = CcBaseColors.divider;

  // -- Common/Utils
  static const Color blue = CcBaseColors.info;
  static const Color pink = CcBaseColors.actionPrimary;
}
