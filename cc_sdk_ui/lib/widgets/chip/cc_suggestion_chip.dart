import 'package:flutter/material.dart';

import '../../core/config/tokens/cc_border_radius.dart';
import '../../core/extensions/cc_context_extension.dart';
import '../../core/extensions/common/cc_responsive_extension.dart';
import '../inkwell/cc_inkwell.dart';
import '../space/cc_space.dart';
import '../text/cc_text.dart';

/// A tappable, dismissible tinted-background suggestion row — icon + one-line
/// label + optional trailing "×" — used across "prefill on tap" AI-suggestion
/// affordances (merchant/location match, budget estimate, etc).
///
/// This component is project-blind and state-agnostic.
///
/// Usage:
/// ```dart
/// CcSuggestionChip(
///   label: 'Like last time: Coffee · 30,000đ',
///   accentColor: Colors.orange,
///   onTap: applySuggestion,
///   onDismiss: dismissSuggestion,
/// )
/// ```
class CcSuggestionChip extends StatelessWidget {
  const CcSuggestionChip({
    super.key,
    required this.label,
    required this.accentColor,
    this.icon = Icons.auto_awesome,
    this.onTap,
    this.onDismiss,
  });

  final String label;
  final Color accentColor;
  final IconData icon;
  final VoidCallback? onTap;
  final VoidCallback? onDismiss;

  @override
  Widget build(BuildContext context) {
    final scheme = context.ccColorScheme;

    return CcInkWell(
      onTap: onTap,
      borderRadius: context.brMd,
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: context.respDim(10),
          vertical: context.respDim(8),
        ),
        decoration: BoxDecoration(
          color: accentColor.withAlpha(15),
          borderRadius: context.brMd,
        ),
        child: Row(
          children: [
            Icon(
              icon,
              size: context.respIconSize(baseSize: 16),
              color: accentColor,
            ),
            const CcSpaceXS(),
            Expanded(
              child: CcText(
                label,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                textStyle: context.ccTextTheme.labelMedium?.copyWith(
                  color: accentColor,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            if (onDismiss != null)
              CcInkWell(
                onTap: onDismiss,
                borderRadius: context.brSm,
                child: Icon(
                  Icons.close,
                  size: context.respIconSize(baseSize: 16),
                  color: scheme.onSurfaceVariant,
                ),
              ),
          ],
        ),
      ),
    );
  }
}
