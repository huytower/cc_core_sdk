import 'package:flutter/material.dart';

import '../../export_cc_sdk_ui.dart';

/// A reusable glassmorphic input bar container with a double-border effect.
///
/// Refactored from QuickEntrySection to be a reusable engine component.
/// It provides a primary-tinted inner glow and a semi-transparent outer border.
class CcGlassyInputBar extends StatelessWidget {
  const CcGlassyInputBar({
    super.key,
    required this.child,
    this.height,
    this.innerHeight,
    this.innerRadius,
    this.outerRadius,
  });

  /// The content to display inside the input bar.
  final Widget child;

  /// Total height of the outer container. Defaults to `context.respDim(65)`.
  final double? height;

  /// Height of the inner glowing bar. Defaults to `context.respDim(45)`.
  final double? innerHeight;

  /// Border radius for the inner bar. Defaults to `context.brMd`.
  final BorderRadius? innerRadius;

  /// Border radius for the outer bar. Defaults to `context.brLg`.
  final BorderRadius? outerRadius;

  @override
  Widget build(BuildContext context) {
    final scheme = context.ccColorScheme;
    final isDark = context.isDarkMode;

    final outerHeight = height ?? context.respDim(55);
    final innerBarHeight = innerHeight ?? context.respDim(35);
    final ir = innerRadius ?? context.brMd;
    final or = outerRadius ?? context.brLg;

    return DecoratedBox(
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: scheme.shadow.withValues(alpha: 0.06),
            blurRadius: context.respDim(24),
            offset: Offset(0, context.respDim(10)),
            spreadRadius: context.respDim(-4),
          ),
        ],
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Widget A: Inner glowing bar
          _buildInnerBorder(context, isDark, innerBarHeight, ir),
          // Widget B: Outer container border
          _buildOuterBorder(context, isDark, outerHeight, or),
          // Widget C: Content
          child,
        ],
      ),
    );
  }

  Widget _buildInnerBorder(
    BuildContext context,
    bool isDark,
    double height,
    BorderRadius radius,
  ) {
    final scheme = context.ccColorScheme;

    return CcPadding(
      Container(
        height: height,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: isDark
                ? [
                    scheme.onPrimary.withValues(alpha: 0.15),
                    scheme.onPrimary.withValues(alpha: 0.08),
                  ]
                : [
                    scheme.onPrimary.withValues(alpha: 0.55),
                    scheme.onPrimary.withValues(alpha: 0.35),
                  ],
          ),
          borderRadius: radius,
          boxShadow: [
            BoxShadow(
              color: scheme.primary.withValues(alpha: 0.1),
              blurRadius: context.respDim(12),
              offset: Offset(context.respDim(4), context.respDim(4)),
            ),
          ],
        ),
      ),
      0,
      8,
      8,
      0,
    );
  }

  Widget _buildOuterBorder(
    BuildContext context,
    bool isDark,
    double height,
    BorderRadius radius,
  ) {
    final scheme = context.ccColorScheme;

    return Container(
      height: height,
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.transparent,
        borderRadius: radius,
        border: Border.all(
          color: scheme.onPrimary.withValues(alpha: 0.3),
          width: context.respDim(1),
        ),
      ),
    );
  }
}
