import 'package:flutter/material.dart';

import '../../../export_cc_sdk_ui.dart';

/// A [CcNumericKeypad] with an action row above it: quick-pick suggestions
/// ([CcQuickValueChips]), clear, optional copy, and done.
///
/// Phones: a full-width panel docked at the bottom. From a small tablet up:
/// styled like a bottom sheet (rounded top corners, shadow, 80 % opaque),
/// capped at [CcNumericKeypad.tabletMaxWidth] and centred, so the keys keep a
/// normal size. Opening it hides the system keyboard.
///
/// ```dart
/// CcKeypadPanel<int>(
///   onKeyPress: controller.append,
///   onDelete: controller.backspace,
///   onClear: controller.clear,
///   onDone: controller.closeKeypad,
///   activeColor: context.ccColorScheme.primary,
///   labels: CcKeypadLabels(clear: 'Clear', copy: 'Copy', done: 'Done'),
///   suggestions: const [CcQuickValue(value: 100, label: '100')],
///   onSuggestion: controller.setValue,
/// )
/// ```
class CcKeypadPanel<T> extends StatelessWidget {
  const CcKeypadPanel({
    super.key,
    required this.onKeyPress,
    required this.onDelete,
    required this.onClear,
    required this.onDone,
    required this.activeColor,
    required this.labels,
    this.onCopy,
    this.suggestions = const [],
    this.onSuggestion,
    this.extraKey = CcNumericKeypad.defaultExtraKey,
  });

  final ValueChanged<String> onKeyPress;
  final VoidCallback onDelete;
  final VoidCallback onClear;
  final VoidCallback onDone;

  /// Shows the copy button when set.
  final VoidCallback? onCopy;

  final Color activeColor;
  final CcKeypadLabels labels;

  /// Quick-pick chips shown at the start of the action row.
  final List<CcQuickValue<T>> suggestions;
  final ValueChanged<T>? onSuggestion;

  /// See [CcNumericKeypad.extraKey].
  final String? extraKey;

  @override
  Widget build(BuildContext context) {
    _hideSystemKeyboard(context);

    final scheme = context.ccColorScheme;
    final hasTablet = context.windowSizeClass.hasAtLeast(
      CcWindowSizeClass.medium,
    );

    if (!hasTablet) {
      return DecoratedBox(
        decoration: BoxDecoration(
          color: scheme.surfaceContainerHighest,
          border: Border(
            top: BorderSide(
              color: scheme.outlineVariant.withValues(alpha: 0.1),
            ),
          ),
        ),
        child: _buildContent(context),
      );
    }

    final radius = BorderRadius.vertical(
      top: Radius.circular(context.respDim(16).clamp(0, 24).toDouble()),
    );
    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(
          maxWidth: CcNumericKeypad.tabletMaxWidth,
        ),
        child: DecoratedBox(
          decoration: BoxDecoration(
            color: scheme.surfaceContainerHighest.withValues(alpha: 0.8),
            borderRadius: radius,
            boxShadow: [
              BoxShadow(
                color: scheme.shadow.withValues(alpha: 0.12),
                blurRadius: context.respDim(12),
                offset: Offset(0, -context.respDim(2)),
              ),
            ],
          ),
          child: ClipRRect(borderRadius: radius, child: _buildContent(context)),
        ),
      ),
    );
  }

  void _hideSystemKeyboard(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!context.mounted) return;
      final currentFocus = FocusScope.of(context);
      if (!currentFocus.hasPrimaryFocus && currentFocus.focusedChild != null) {
        currentFocus.focusedChild?.unfocus();
      }
    });
  }

  Widget _buildContent(BuildContext context) {
    return CcContentPadding(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          CcSymmetricPadding(
            vertical: CcPaddingParams.SPACE_XS,
            child: _buildActionRow(context),
          ),
          CcNumericKeypad(
            onKeyPress: onKeyPress,
            onDelete: onDelete,
            activeColor: activeColor,
            extraKey: extraKey,
          ),
        ],
      ),
    );
  }

  Widget _buildActionRow(BuildContext context) {
    final iconSize = context.respIconSize(baseSize: 20);
    return Row(
      children: [
        Expanded(
          child: CcQuickValueChips<T>(
            items: suggestions,
            onSelected: (value) => onSuggestion?.call(value),
            activeColor: activeColor,
            padding: EdgeInsets.only(
              left: context.respPadding(CcPaddingParams.SPACE_SM),
            ),
          ),
        ),
        CcIconButton.bouncing(
          icon: Icon(Icons.close_rounded, color: activeColor, size: iconSize),
          onTap: onClear,
          tooltip: labels.clear,
        ),
        if (onCopy != null)
          CcIconButton.bouncing(
            icon: Icon(Icons.copy_rounded, color: activeColor, size: iconSize),
            onTap: onCopy!,
            tooltip: labels.copy,
          ),
        CcBouncing(
          onTap: onDone,
          child: CcSymmetricPadding(
            horizontal: CcPaddingParams.SPACE_XL,
            child: CcText(
              labels.done,
              textStyle: context.ccTextTheme.labelMedium?.copyWith(
                color: activeColor,
                fontWeight: CcTypographyParams.bold,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
