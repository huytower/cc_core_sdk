import 'package:flutter/material.dart';

import '../../extensions/cc_context_extension.dart';

/// Semantic design tokens for the branded page gradient background.
///
/// Mirrors the [CcTextStyle] ThemeExtension pattern: the SDK defines the token
/// *shape*, while each app supplies concrete values via its [PrjColors] and
/// registers [CcGradientColors.light]/[CcGradientColors.dark] in its themes.
///
/// This keeps the gradient theme-aware — the same [BgGradientWidget] resolves
/// to the correct light/dark colors through [BuildContext.ccGradientColors],
/// so callers never hardcode `onPrimary` or any fixed color.
class CcGradientColors extends ThemeExtension<CcGradientColors> {
  /// Color at the top of the gradient (usually a faint brand tint).
  final Color top;

  /// Color at the bottom of the gradient (usually the surface/background).
  final Color bottom;

  const CcGradientColors({required this.top, required this.bottom});

  /// Light theme gradient tokens.
  ///
  /// Concrete values are injected by the app (e.g. [PrjColors.gradientTop]).
  factory CcGradientColors.light({required Color top, required Color bottom}) =>
      CcGradientColors(top: top, bottom: bottom);

  /// Dark theme gradient tokens.
  ///
  /// Concrete values are injected by the app (e.g. [PrjColors.darkGradientTop]).
  factory CcGradientColors.dark({required Color top, required Color bottom}) =>
      CcGradientColors(top: top, bottom: bottom);

  @override
  CcGradientColors copyWith({Color? top, Color? bottom}) =>
      CcGradientColors(top: top ?? this.top, bottom: bottom ?? this.bottom);

  @override
  CcGradientColors lerp(ThemeExtension<CcGradientColors>? other, double t) {
    if (other is! CcGradientColors) return this;
    return CcGradientColors(
      top: Color.lerp(top, other.top, t) ?? top,
      bottom: Color.lerp(bottom, other.bottom, t) ?? bottom,
    );
  }
}

/// Convenience accessor for [CcGradientColors] from a [BuildContext].
extension CcGradientColorsExtension on BuildContext {
  /// The current [CcGradientColors] token, falling back to the active
  /// [ColorScheme] (primary → surface) when no extension is registered.
  CcGradientColors get ccGradientColors =>
      Theme.of(this).extension<CcGradientColors>() ??
      CcGradientColors(
        top: ccColorScheme.primary,
        bottom: ccColorScheme.surface,
      );
}
