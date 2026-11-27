import 'package:flutter/material.dart';

import '../../../export_cc_sdk_ui.dart';

/// One choice in a picker list: a [leading] mark in a tinted circle, an
/// optional [overline] above the [title] and an optional value at the end, on
/// a glassy rounded tile. The selected tile is tinted, outlined and bold.
///
/// The tile has no margin; the list that holds it sets the gaps.
///
/// ```dart
/// CcOptionTile(
///   leading: const Text('🇻🇳'),
///   overline: 'VI',
///   title: 'Tiếng Việt',
///   hasSelected: true,
///   onTap: () {},
/// )
/// ```
class CcOptionTile extends StatelessWidget {
  const CcOptionTile({
    super.key,
    required this.title,
    this.overline,
    this.leading,
    this.trailingText,
    this.trailingColor,
    this.hasSelected = false,
    this.onTap,
  });

  /// Largest share of the tile width the trailing value may take.
  static const double _trailingShare = 0.4;

  final String title;

  /// Short label above the title (for example a code).
  final String? overline;

  /// Icon or emoji shown in the circle; no circle when null.
  final Widget? leading;

  /// Value at the end of the tile.
  final String? trailingText;

  /// Colour of [trailingText] while not selected; the primary colour when null.
  final Color? trailingColor;
  final bool hasSelected;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final scheme = context.ccColorScheme;
    return Semantics(
      button: true,
      selected: hasSelected,
      child: CcBouncing(
        onTap: onTap,
        borderRadius: context.brLg,
        child: Stack(
          children: [
            const Positioned.fill(child: CcGlassyGradientBackground()),
            AnimatedContainer(
              duration: const Duration(milliseconds: 150),
              constraints: BoxConstraints(minHeight: context.respDim(60)),
              padding: EdgeInsets.symmetric(
                horizontal: context.respPadding(CcPaddingParams.PAGE_XS),
                vertical: context.respPadding(CcPaddingParams.SPACE_XS),
              ),
              decoration: BoxDecoration(
                color: hasSelected
                    ? scheme.primary.withValues(alpha: 0.15)
                    : scheme.primaryContainer.withValues(alpha: 0.1),
                borderRadius: context.brLg,
                border: Border.all(
                  color: scheme.primary.withValues(alpha: hasSelected ? 1 : 0),
                ),
              ),
              child: LayoutBuilder(
                builder: (context, constraints) =>
                    _buildContent(context, constraints.maxWidth),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildContent(BuildContext context, double width) {
    return Row(
      children: [
        if (leading != null) ...[
          _buildLeading(context, leading!),
          const CcSpaceSM(),
        ],
        Expanded(child: _buildTexts(context)),
        if (trailingText != null) ...[
          const CcSpaceSM(),
          // A long value shrinks instead of overflowing or being cut off.
          ConstrainedBox(
            constraints: BoxConstraints(maxWidth: width * _trailingShare),
            child: FittedBox(
              fit: BoxFit.scaleDown,
              child: _buildTrailing(context, trailingText!),
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildLeading(BuildContext context, Widget mark) {
    final size = context.respDim(32);
    return Container(
      width: size,
      height: size,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: context.ccColorScheme.primary.withValues(alpha: 0.12),
        shape: BoxShape.circle,
      ),
      child: DefaultTextStyle.merge(
        style: context.ccTextTheme.titleMedium,
        child: mark,
      ),
    );
  }

  Widget _buildTexts(BuildContext context) {
    final scheme = context.ccColorScheme;
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (overline != null) ...[
          CcText(
            overline,
            maxLines: 1,
            textStyle: context.ccTextTheme.labelSmall?.copyWith(
              fontWeight: CcTypographyParams.bold,
              color: scheme.onSurfaceVariant.withValues(alpha: 0.7),
              letterSpacing: 0.5,
            ),
          ),
          SizedBox(height: context.respDim(2)),
        ],
        CcText(
          title,
          maxLines: 1,
          textStyle: context.ccTextTheme.bodyMedium?.copyWith(
            fontWeight: hasSelected
                ? CcTypographyParams.bold
                : CcTypographyParams.regular,
            color: hasSelected ? scheme.primary : scheme.onSurface,
          ),
        ),
      ],
    );
  }

  Widget _buildTrailing(BuildContext context, String value) {
    final scheme = context.ccColorScheme;
    return CcText(
      value,
      textStyle: context.ccTextTheme.labelMedium?.copyWith(
        fontWeight: CcTypographyParams.bold,
        color: hasSelected ? scheme.primary : trailingColor ?? scheme.primary,
      ),
    );
  }
}
