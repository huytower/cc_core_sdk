// Adapted from curved_navigation_bar_pro 2.2.3
// (https://pub.dev/packages/curved_navigation_bar_pro), MIT License,
// Copyright (c) 2026 aslamambiloly. Full notice: LICENSE in this folder.

import 'package:cc_sdk_ui/src/core/config/tokens/cc_base_colors.dart';
import 'package:cc_sdk_ui/src/core/config/tokens/cc_typography_params.dart';
import 'package:cc_sdk_ui/src/core/extensions/common/cc_responsive_extension.dart';
import 'package:flutter/material.dart';

/// Puts a badge ([badgeWidget], a count, or a "•" dot) on the top right of
/// [child]; returns [child] alone when there is no badge.
class CcCurvedBadge extends StatelessWidget {
  const CcCurvedBadge({
    super.key,
    required this.child,
    required this.borderColor,
    this.badgeText,
    this.badgeColor,
    this.badgeTextColor,
    this.badgeWidget,
  });

  final Widget child;
  final Color borderColor;
  final String? badgeText;
  final Color? badgeColor;
  final Color? badgeTextColor;
  final Widget? badgeWidget;

  @override
  Widget build(BuildContext context) {
    final text = badgeText;
    final custom = badgeWidget;
    if (custom == null && (text == null || text.isEmpty)) return child;

    return Stack(
      clipBehavior: Clip.none,
      children: [
        child,
        Positioned(
          top: custom != null ? -2 : -4,
          right: custom != null ? -2 : -6,
          child: custom ?? _buildTextBadge(context, text!),
        ),
      ],
    );
  }

  Widget _buildTextBadge(BuildContext context, String text) {
    final hasDot = text == '•';
    return Container(
      padding: hasDot
          ? EdgeInsets.zero
          : const EdgeInsets.symmetric(horizontal: 4.5, vertical: 2),
      constraints: BoxConstraints(
        minWidth: hasDot ? 8 : 16,
        minHeight: hasDot ? 8 : 16,
      ),
      decoration: BoxDecoration(
        color: badgeColor ?? CcBaseColors.errorRed,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: borderColor, width: 1.5),
      ),
      child: hasDot
          ? const SizedBox.shrink()
          : Center(
              widthFactor: 1,
              heightFactor: 1,
              child: Text(
                text,
                style: TextStyle(
                  color: badgeTextColor ?? CcBaseColors.white100,
                  fontSize: context.respFontSize(9),
                  fontWeight: CcTypographyParams.bold,
                  height: 1.0,
                ),
              ),
            ),
    );
  }
}

