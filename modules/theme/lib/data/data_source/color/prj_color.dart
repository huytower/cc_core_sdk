import 'package:flutter/material.dart';

/// A comprehensive color system for the application that follows Material Design 3
/// and provides semantic color mappings for text and UI elements.
///
/// ## Color System Guidelines
/// - Use semantic color names that describe the purpose, not the color itself
/// - Follow Material Design 3 color system: https://m3.material.io/styles/color/the-color-system
/// - Use 8-digit hex (AARRGGBB) for colors with opacity
/// - Group related colors together with clear documentation
///
/// ## Naming Convention
/// - `colorPurpose` - For main semantic colors
/// - `colorPurposeVariant` - For variations of the main color
/// - `onColorPurpose` - For content that appears on top of the color
/// - `colorPurposeOpacityXX` - For colors with specific opacity (XX = 05, 10, 20, etc.)
///
/// ## Usage
/// ```dart
/// Text(
///   'Hello World',
///   style: TextStyle(color: PrjColors.onSurface),
/// )
/// ```
class PrjColors {
  // ====================================
  // Primary Colors
  // ====================================

  /// Primary brand color - Deep Forest Green
  static const Color primary = Color(0xFF2E7D32); // Deep green
  static const Color onPrimary = Colors.white;
  static const Color primaryContainer = Color(0xFFA5D6A7); // Light green
  static const Color onPrimaryContainer = Color(0xFF002200); // Very dark green

  // ====================================
  // Secondary Colors
  // ====================================

  /// Secondary brand color - Earthy Brown
  static const Color secondary = Color(0xFF8D6E63); // Earthy brown
  static const Color onSecondary = Colors.white;
  static const Color secondaryContainer = Color(0xFFFFF3E0); // Light beige
  static const Color onSecondaryContainer = Color(0xFF3E2723); // Dark brown

  // ====================================
  // Semantic Colors
  // ====================================

  /// Success state color
  static const Color success = Color(0xFF28A745);
  static const Color onSuccess = Colors.white;

  /// Warning state color
  static const Color warning = Color(0xFFFFC107);
  static const Color onWarning = Color(0xFF1E1B04);

  /// Error state color
  static const Color error = Color(0xFFDC3545);
  static const Color onError = Colors.white;

  /// Info state color
  static const Color info = Color(0xFF17A2B8);
  static const Color onInfo = Colors.white;

  // ====================================
  // Background Colors
  // ====================================

  /// Default background color
  static const Color background = Colors.white;
  static const Color onBackground = Color(0xFF1A1C1E);

  /// Surface colors
  static const Color surface = Colors.white;
  static const Color onSurface = Color(0xFF1A1C1E);
  static const Color surfaceVariant = Color(0xFFF1F0F4);
  static const Color onSurfaceVariant = Color(0xFF46464F);

  /// Background variant colors
  static const Color backgroundGrey = Color(0xFFF5F5F5);

  // ====================================
  // Text Colors
  // ====================================

  /// High emphasis text
  static const Color highEmphasis = Color(0xDE000000);

  /// Medium emphasis text
  static const Color mediumEmphasis = Color(0x99000000);

  /// Disabled text
  static const Color disabled = Color(0x61000000);

  /// Hint/placeholder text
  static const Color hint = Color(0x61000000);

  // ====================================
  // Border & Divider Colors
  // ====================================

  /// Border color
  static const Color outline = Color(0xFF79747E);
  static const Color outlineVariant = Color(0xFFC4C7C5);

  /// Divider color
  static const Color divider = Color(0x1E000000);

  // ====================================
  // Functional Colors (Legacy support)
  // ====================================

  /// @deprecated Use [primary] instead
  static const Color blue = primary;

  /// @deprecated Use [secondary] instead
  static const Color pink = secondary;

  /// @deprecated Use [error] instead
  static const Color danger = error;

  /// @deprecated Use [onSurfaceVariant] instead
  static const Color grey = onSurfaceVariant;
}

/// Extension methods for PrjColors to provide additional functionality
/// and backward compatibility with legacy code.
extension PrjColorsExtension on PrjColors {
  // ====================================
  // Opacity Helpers
  // ====================================

  /// Returns a color with the given opacity
  static Color withOpacity(Color color, double opacity) {
    return color.withOpacity(opacity);
  }

  // ====================================
  // Legacy Color Getters (for backward compatibility)
  // ====================================

  /// @deprecated Use [PrjColors.primary] instead
  static Color get pinkPrimary => PrjColors.secondary;

  /// @deprecated Use [PrjColors.onSurface] with opacity instead
  static Color get blackNormal => PrjColors.mediumEmphasis;

  /// @deprecated Use [PrjColors.onSurface] instead
  static Color get black => PrjColors.onBackground;

  /// @deprecated Use [PrjColors.surfaceVariant] instead
  static Color get grayNormal => PrjColors.surfaceVariant;

  // ====================================
  // Opacity Constants
  // ====================================

  /// Opacity levels for consistent transparency
  static const double opacity05 = 0.05;
  static const double opacity10 = 0.1;
  static const double opacity20 = 0.2;
  static const double opacity30 = 0.3;
  static const double opacity40 = 0.4;
  static const double opacity50 = 0.5;
  static const double opacity60 = 0.6;
  static const double opacity70 = 0.7;
  static const double opacity80 = 0.8;
  static const double opacity90 = 0.9;
}

/// A simplified version of PrjColors for legacy support.
/// @deprecated Use [PrjColors] instead for better semantic color support.
@Deprecated('Use PrjColors instead for better semantic color support')
class PrjColorsSimple {
  // Primary colors
  static const Color primary = PrjColors.primary;
  static const Color primaryVariant = PrjColors.primaryContainer;
  static const Color secondary = PrjColors.secondary;
  static const Color secondaryVariant = PrjColors.secondaryContainer;

  // State colors
  static const Color error = PrjColors.error;
  static const Color warning = PrjColors.warning;

  // Neutral colors
  static const Color black = PrjColors.onBackground;
  static const Color white = Colors.white;
  static const Color transparent = Colors.transparent;

  // Opacity variants
  static Color black_5 = PrjColors.onBackground.withOpacity(0.05);
  static Color black_10 = PrjColors.onBackground.withOpacity(0.1);
  static Color black_20 = PrjColors.onBackground.withOpacity(0.2);
  static Color black_30 = PrjColors.onBackground.withOpacity(0.3);
  static Color black_40 = PrjColors.onBackground.withOpacity(0.4);
  static Color black_50 = PrjColors.onBackground.withOpacity(0.5);
  static Color black_70 = PrjColors.onBackground.withOpacity(0.7);

  static Color white_10 = Colors.white.withOpacity(0.1);
  static Color white_20 = Colors.white.withOpacity(0.2);
  static Color white_30 = Colors.white.withOpacity(0.3);
  static Color white_40 = Colors.white.withOpacity(0.4);
  static Color white_50 = Colors.white.withOpacity(0.5);
  static Color white_70 = Colors.white.withOpacity(0.7);
  static Color white_80 = Colors.white.withOpacity(0.8);

  // Legacy colors (mapped to new colors)
  static const Color primaryDart = Color(0xFF001B3F);
  static const Color primaryLight = Color(0xFFD6E2FF);
  static const Color divider = PrjColors.divider;
  static const Color disable = PrjColors.disabled;
  static const Color notice = PrjColors.error;
  static const Color focus = Color(0x1500c44b);

  // Deprecated colors (mapped to new colors)
  static const Color blue = PrjColors.primary;
  static const Color gray = PrjColors.onSurfaceVariant;
  static const Color pink = PrjColors.secondary;
  static const Color red = PrjColors.error;
}
