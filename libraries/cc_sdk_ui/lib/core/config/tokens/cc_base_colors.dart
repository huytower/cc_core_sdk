import 'package:flutter/material.dart';

/// CcBaseColors: The "Single Source of Truth" (SSOT) for the UI Library theme.
///
/// This file follows the **Design Token** principle, facilitating collaboration between
/// Product Owners (PO), Designers, and Developers.
///
/// ## Color Roles (Standard Design Principles)
/// 1. **Primitives (Palette)**: Raw colors. Avoid using these directly in widgets.
/// 2. **Semantic Tokens**: Named after their purpose. Use these in widgets.
///
/// ## Best Practices
/// - All colors are [const] for performance.
/// - Opacity is handled via 8-digit hex (AARRGGBB) to ensure they are compile-time constants.
class CcBaseColors {
  // ===========================================================================
  // 1. PRIMITIVES (Figma: "Foundation" Collection)
  // ===========================================================================

  // -- Neutral Palette (Black/Gray/White)
  static const Color neutral100 = Color(0xFF000000);
  static const Color neutral90 = Color(0xE6000000); // 90%
  static const Color neutral80 = Color(0xCC000000); // 80%
  static const Color neutral70 = Color(0xB3000000); // 70%
  static const Color neutral50 = Color(0x80000000); // 50%
  static const Color neutral40 = Color(0x66000000); // 40%
  static const Color neutral30 = Color(0x4D000000); // 30%
  static const Color neutral20 = Color(0x33000000); // 20%
  static const Color neutral10 = Color(0x1A000000); // 10%
  static const Color neutral5 = Color(0x0D000000); // 5%

  static const Color white100 = Color(0xFFFFFFFF);
  static const Color white80 = Color(0xCCFFFFFF);
  static const Color white70 = Color(0xB3FFFFFF);
  static const Color white50 = Color(0x80FFFFFF);
  static const Color white40 = Color(0x66FFFFFF);
  static const Color white30 = Color(0x4DFFFFFF);
  static const Color white20 = Color(0x33FFFFFF);
  static const Color white15 = Color(0x26FFFFFF);
  static const Color white10 = Color(0x1AFFFFFF);

  static const Color gray100 = Color(0xFFE2E2E2);
  static const Color gray90 = Color(0xE5E2E2E2);
  static const Color gray80 = Color(0xCCE2E2E2);
  static const Color gray70 = Color(0xB2E2E2E2);
  static const Color gray40 = Color(0x66E2E2E2);

  // -- Brand Palette (Pink)
  static const Color brand900 = Color(0xE5D81B60); // 90%
  static const Color brand800 = Color(0xCCD81B60); // 80%
  static const Color brand700 = Color(0xB2D81B60); // 70%
  static const Color brand600 = Color(0xFFAD1457); // Darker (Pressed)
  static const Color brand500 = Color(0xFFD81B60); // Primary (100%)
  static const Color brand300 = Color(0x4CD81B60); // 30%
  static const Color brand100 = Color(0x19D81B60); // 10%

  // -- Secondary Palette (Blue)
  static const Color secondary500 = Color(0xFF2196F3);
  static const Color secondary800 = Color(0xCC1E88E5);

  // -- Status Palette
  static const Color errorRed = Color(0xFFF44336);
  static const Color successGreen = Color(0xFF4CAF50);
  static const Color warningAmber = Color(0xFFFFC107);

  // ===========================================================================
  // 2. SEMANTIC TOKENS (Figma: "Theme" Collection)
  // ===========================================================================

  // -- Actions
  static const Color actionPrimary = brand500;
  static const Color actionPrimaryPressed = brand600;
  static const Color actionDisabled = Color(0xFFE0E0E0);

  // -- Content (Text & Icons)
  static const Color textPrimary = neutral80;
  static const Color textSecondary = neutral50;
  static const Color textDisabled = neutral30;
  static const Color textInvert = white100;

  // -- Surface
  static const Color surfaceDefault = white100;
  static const Color surfaceVariant = gray100;
  static const Color surfaceOverlay = neutral50;

  // -- Feedback
  static const Color success = successGreen;
  static const Color warning = warningAmber;
  static const Color error = errorRed;
  static const Color info = secondary500;

  // -- Utils
  static const Color transparent = Color(0x00000000);
  static const Color shadow = neutral10;
  static const Color divider = gray40;
}
