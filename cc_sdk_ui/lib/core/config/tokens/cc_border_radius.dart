import 'package:flutter/material.dart';

import '../../../core/extensions/common/cc_responsive_extension.dart';

/// CcBorderRadius: Responsive border-radius design tokens.
///
/// Purpose:
/// - Replace ad-hoc `BorderRadius.circular(context.respDim(N))` usages with
///   semantic, project-wide consistent radii.
/// - Keep radii responsive (scaled by [BuildContext.respDim]) so they adapt to
///   screen size like every other dimension in the design system.
///
/// Usage:
/// ```dart
/// decoration: BoxDecoration(
///   borderRadius: context.brCard,
/// ),
/// ```
abstract class CcBorderRadius {
  // ==========================================================================
  // PRIMITIVE RADII (responsive)
  // ==========================================================================

  /// Extra-small radius. Use for chips, tiny indicators.
  static BorderRadius xs(BuildContext context) =>
      BorderRadius.circular(context.respDim(4));

  /// Small radius. Use for buttons, inputs, tile accents.
  static BorderRadius sm(BuildContext context) =>
      BorderRadius.circular(context.respDim(8));

  /// Medium radius. Use for medium tiles, secondary cards.
  static BorderRadius md(BuildContext context) =>
      BorderRadius.circular(context.respDim(12));

  /// Large radius. The default card / container / dialog radius.
  static BorderRadius lg(BuildContext context) =>
      BorderRadius.circular(context.respDim(16));

  /// Extra-large radius. Use for hero banners, pills, large surfaces.
  static BorderRadius xl(BuildContext context) =>
      BorderRadius.circular(context.respDim(24));

  /// Extra-extra-large radius. Use for fully-rounded large surfaces.
  static BorderRadius xxl(BuildContext context) =>
      BorderRadius.circular(context.respDim(32));

  // ==========================================================================
  // SEMANTIC RADII
  // ==========================================================================

  /// Standard radius for cards and rounded containers.
  static BorderRadius card(BuildContext context) => lg(context);

  /// Radius for dialogs and bottom sheets.
  static BorderRadius dialog(BuildContext context) => lg(context);

  /// Radius for buttons.
  static BorderRadius button(BuildContext context) => sm(context);

  /// Radius for text input fields.
  static BorderRadius input(BuildContext context) => sm(context);

  /// Radius for pills / chips / rounded tags.
  static BorderRadius pill(BuildContext context) => xl(context);

  /// Fully rounded (circle) radius. Use with [CcCircularParams.CIRCLE] sizing.
  static BorderRadius circle(BuildContext context) =>
      BorderRadius.circular(context.respDim(45));
}

/// Extension on [BuildContext] to access project-standard [BorderRadius] tokens.
///
/// This provides a clean, responsive way to apply semantic rounding to widgets.
extension CcBorderRadiusContextExtension on BuildContext {
  // ==========================================================================
  // PRIMITIVE RADII
  // ==========================================================================

  /// Extra-small radius (4pt responsive).
  BorderRadius get brXs => CcBorderRadius.xs(this);

  /// Small radius (8pt responsive).
  BorderRadius get brSm => CcBorderRadius.sm(this);

  /// Medium radius (12pt responsive).
  BorderRadius get brMd => CcBorderRadius.md(this);

  /// Large radius (16pt responsive).
  BorderRadius get brLg => CcBorderRadius.lg(this);

  /// Extra-large radius (24pt responsive).
  BorderRadius get brXl => CcBorderRadius.xl(this);

  /// Extra-extra-large radius (32pt responsive).
  BorderRadius get brXxl => CcBorderRadius.xxl(this);

  // ==========================================================================
  // SEMANTIC RADII
  // ==========================================================================

  /// Standard radius for cards and rounded containers.
  BorderRadius get brCard => CcBorderRadius.card(this);

  /// Radius for dialogs and bottom sheets.
  BorderRadius get brDialog => CcBorderRadius.dialog(this);

  /// Radius for buttons.
  BorderRadius get brButton => CcBorderRadius.button(this);

  /// Radius for text input fields.
  BorderRadius get brInput => CcBorderRadius.input(this);

  /// Radius for pills / chips / rounded tags.
  BorderRadius get brPill => CcBorderRadius.pill(this);

  /// Fully rounded (circle) radius.
  BorderRadius get brCircle => CcBorderRadius.circle(this);
}
