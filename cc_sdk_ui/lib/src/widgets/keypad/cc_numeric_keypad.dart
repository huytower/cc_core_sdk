import 'package:flutter/material.dart';

import '../../../export_cc_sdk_ui.dart';

/// An on-screen number pad: 1–9, an optional extra key (default `000`), 0 and
/// backspace, in a 3 × 4 grid.
///
/// On phones it is a full-width strip with its own fill. From a small tablet up
/// the key height is capped and the pad is limited to [tabletMaxWidth] and
/// centred, with a transparent fill (the panel behind supplies it, see
/// [CcKeypadPanel]).
///
/// ```dart
/// CcNumericKeypad(
///   onKeyPress: (digits) => controller.append(digits),
///   onDelete: controller.backspace,
///   activeColor: context.ccColorScheme.primary,
/// )
/// ```
class CcNumericKeypad extends StatelessWidget {
  const CcNumericKeypad({
    super.key,
    required this.onKeyPress,
    required this.onDelete,
    required this.activeColor,
    this.extraKey = defaultExtraKey,
  });

  /// Called with the digits of the key pressed (`'7'`, `'0'`, `'000'`, ...).
  final ValueChanged<String> onKeyPress;

  /// Called by the backspace key.
  final VoidCallback onDelete;

  /// Colour of [extraKey]'s label.
  final Color activeColor;

  /// Text of the bottom-left key, sent to [onKeyPress] as is; `null` leaves the
  /// cell empty.
  final String? extraKey;

  /// Default [extraKey]: three zeros, for entering amounts quickly.
  static const String defaultExtraKey = '000';

  /// Width cap from a small tablet up (same as a bottom sheet's).
  static const double tabletMaxWidth = 480;

  /// Key height cap from a small tablet up, so keys do not grow with the window.
  static const double tabletKeyHeight = 36;

  static const List<List<String>> _digitRows = [
    ['1', '2', '3'],
    ['4', '5', '6'],
    ['7', '8', '9'],
  ];

  bool _hasTablet(BuildContext context) =>
      context.windowSizeClass.hasAtLeast(CcWindowSizeClass.medium);

  @override
  Widget build(BuildContext context) {
    final pad = _buildPad(context);
    if (!_hasTablet(context)) return pad;
    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: tabletMaxWidth),
        child: pad,
      ),
    );
  }

  Widget _buildPad(BuildContext context) {
    final scheme = context.ccColorScheme;
    return Container(
      padding: EdgeInsets.all(context.respPadding(CcPaddingParams.SPACE_XS)),
      decoration: BoxDecoration(
        color: _hasTablet(context)
            ? Colors.transparent
            : scheme.surfaceContainerHighest,
        border: Border(
          top: BorderSide(color: scheme.outlineVariant.withValues(alpha: 0.1)),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          for (final row in _digitRows)
            Row(
              children: [
                for (final digit in row)
                  Expanded(child: _buildTextKey(context, digit)),
              ],
            ),
          Row(
            children: [
              Expanded(
                child: extraKey == null
                    ? const SizedBox.shrink()
                    : _buildTextKey(context, extraKey!, color: activeColor),
              ),
              Expanded(child: _buildTextKey(context, '0')),
              Expanded(child: _buildDeleteKey(context)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTextKey(BuildContext context, String label, {Color? color}) {
    return _buildKey(
      context,
      onTap: () => onKeyPress(label),
      child: CcText(
        label,
        align: Alignment.center,
        textAlign: TextAlign.center,
        textStyle: context.ccTextTheme.titleMedium?.copyWith(
          fontWeight: CcTypographyParams.bold,
          color: color ?? context.ccColorScheme.onSurface,
        ),
      ),
    );
  }

  Widget _buildDeleteKey(BuildContext context) {
    return _buildKey(
      context,
      onTap: onDelete,
      child: Icon(
        Icons.backspace_outlined,
        color: context.ccColorScheme.onSurfaceVariant,
        size: context.respIconSize(baseSize: 18),
      ),
    );
  }

  Widget _buildKey(
    BuildContext context, {
    required VoidCallback onTap,
    required Widget child,
  }) {
    final scheme = context.ccColorScheme;
    final height = context.respDim(30);
    return CcInteractionWrapper(
      useDebounce: false,
      hasBouncing: true,
      onTap: onTap,
      child: Container(
        height: _hasTablet(context)
            ? height.clamp(0, tabletKeyHeight).toDouble()
            : height,
        margin: EdgeInsets.all(context.respDim(2)),
        decoration: BoxDecoration(
          color: scheme.surface,
          borderRadius: context.brMd,
          boxShadow: [
            BoxShadow(
              color: scheme.onSurface.withValues(alpha: 0.02),
              blurRadius: context.respDim(2),
              offset: Offset(0, context.respDim(1)),
            ),
          ],
        ),
        alignment: Alignment.center,
        child: child,
      ),
    );
  }
}
