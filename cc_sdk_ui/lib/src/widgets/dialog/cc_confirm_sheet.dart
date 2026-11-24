import 'package:flutter/material.dart';

import '../../../export_cc_sdk_ui.dart';

/// A centred confirmation bottom sheet: a round tinted [icon], a bold
/// [title], an optional [highlight] line (for example the account or item
/// concerned), the [message], an optional [extra] widget (for example a
/// link), then Cancel and the confirm button side by side.
///
/// [tone] picks error colours ([CcConfirmTone.destructive], the default) or
/// primary colours. Cancel defaults to `MaterialLocalizations`.
///
/// [show] returns `true` when confirmed and `false` when cancelled or
/// dismissed; the caller then runs the action.
///
/// ```dart
/// if (await CcConfirmSheet.show(
///   context,
///   icon: Icons.delete_outline_rounded,
///   title: 'Delete wallet?',
///   message: 'Its history is kept.',
///   confirmLabel: 'Delete',
/// )) {
///   await controller.delete(wallet);
/// }
/// ```
class CcConfirmSheet extends StatelessWidget {
  const CcConfirmSheet({
    super.key,
    required this.icon,
    required this.title,
    required this.message,
    required this.confirmLabel,
    this.cancelLabel,
    this.highlight,
    this.extra,
    this.tone = CcConfirmTone.destructive,
    this.messageMaxLines = defaultMessageMaxLines,
  });

  final IconData icon;
  final String title;
  final String message;
  final String confirmLabel;
  final String? cancelLabel;
  final String? highlight;
  final Widget? extra;
  final CcConfirmTone tone;

  /// Lines the message may take before it is cut.
  final int messageMaxLines;

  /// Default [messageMaxLines].
  static const int defaultMessageMaxLines = 6;

  /// Opens the sheet; `true` when confirmed.
  static Future<bool> show(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String message,
    required String confirmLabel,
    String? cancelLabel,
    String? highlight,
    Widget? extra,
    CcConfirmTone tone = CcConfirmTone.destructive,
    int messageMaxLines = defaultMessageMaxLines,
  }) async {
    final confirmed = await CcAdaptiveBottomSheet.show<bool>(
      context: context,
      hasScrollControlled: false,
      backgroundColor: context.ccColorScheme.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) => CcConfirmSheet(
        icon: icon,
        title: title,
        message: message,
        confirmLabel: confirmLabel,
        cancelLabel: cancelLabel,
        highlight: highlight,
        extra: extra,
        tone: tone,
        messageMaxLines: messageMaxLines,
      ),
    );
    return confirmed ?? false;
  }

  @override
  Widget build(BuildContext context) {
    final scheme = context.ccColorScheme;
    final toneColor = tone == CcConfirmTone.destructive
        ? scheme.error
        : scheme.primary;
    final label = highlight;
    // Scrolls in landscape (short window) instead of overflowing.
    return CcLandscapeScrollable(
      child: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(
            context.respPadding(CcPaddingParams.SPACE_LG),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _buildIcon(context, toneColor),
              const CcSpaceMD(),
              _buildTitle(context),
              if (label != null && label.isNotEmpty) ...[
                const CcSpaceXS(),
                _buildHighlight(context, label, toneColor),
              ],
              const CcSpaceSM(),
              _buildMessage(context),
              if (extra != null) ...[const CcSpaceSM(), extra!],
              const CcSpaceLG(),
              _buildActions(context, toneColor),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildIcon(BuildContext context, Color toneColor) {
    return Center(
      child: Container(
        padding: EdgeInsets.all(context.respDim(14)),
        decoration: BoxDecoration(
          color: toneColor.withValues(alpha: 0.12),
          shape: BoxShape.circle,
        ),
        child: Icon(
          icon,
          color: toneColor,
          size: context.respIconSize(baseSize: 28),
        ),
      ),
    );
  }

  Widget _buildTitle(BuildContext context) {
    return CcText(
      title,
      align: Alignment.center,
      textAlign: TextAlign.center,
      textStyle: context.ccTextTheme.titleLarge?.copyWith(
        fontWeight: FontWeight.bold,
        color: context.ccColorScheme.onSurface,
      ),
    );
  }

  Widget _buildHighlight(BuildContext context, String text, Color toneColor) {
    return CcText(
      text,
      align: Alignment.center,
      textAlign: TextAlign.center,
      textStyle: context.ccTextTheme.titleSmall?.copyWith(
        fontWeight: FontWeight.w600,
        color: toneColor,
      ),
    );
  }

  Widget _buildMessage(BuildContext context) {
    return CcText(
      message,
      align: Alignment.center,
      maxLines: messageMaxLines,
      textAlign: TextAlign.center,
      textStyle: context.ccTextTheme.bodyMedium?.copyWith(
        color: context.ccColorScheme.onSurfaceVariant,
      ),
    );
  }

  Widget _buildActions(BuildContext context, Color toneColor) {
    final scheme = context.ccColorScheme;
    final onTone = tone == CcConfirmTone.destructive
        ? scheme.onError
        : scheme.onPrimary;
    return Row(
      children: [
        Expanded(
          child: CcBaseButton(
            title:
                cancelLabel ??
                MaterialLocalizations.of(context).cancelButtonLabel,
            backgroundColor: [
              scheme.surfaceContainerHighest,
              scheme.surfaceContainerHighest,
            ],
            textColor: scheme.onSurface,
            onTap: () => Navigator.of(context).pop(false),
          ),
        ),
        const CcSpaceMD(),
        Expanded(
          child: CcBaseButton(
            title: confirmLabel,
            backgroundColor: [toneColor, toneColor],
            textColor: onTone,
            onTap: () => Navigator.of(context).pop(true),
          ),
        ),
      ],
    );
  }
}
