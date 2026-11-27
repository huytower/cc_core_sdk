import 'package:flutter/material.dart';

import '../../../export_cc_sdk_ui.dart';

/// The frame shared by picker and info bottom sheets: a [CcSheetHeader] (or a
/// custom [header]), the [body] on a tinted surface, and an optional action
/// row. Scrolls in landscape (a short window) instead of overflowing, and
/// keeps clear of the bottom system bar.
///
/// Actions appear when [onConfirm] is set: Cancel (unless [hasCancel] is
/// false; it closes the sheet with no result, or calls [onCancel]) and the
/// confirm button, which calls [onConfirm] — the caller closes the sheet with
/// its result. Labels
/// default to `MaterialLocalizations` (Cancel / OK).
///
/// ```dart
/// CcPickerSheetFrame(
///   title: 'Pick a year',
///   body: CcYearGrid(...),
///   onConfirm: () => Navigator.of(context).pop(selectedYear),
/// )
/// ```
class CcPickerSheetFrame extends StatelessWidget {
  const CcPickerSheetFrame({
    super.key,
    required this.body,
    this.title,
    this.icon,
    this.headerTrailing,
    this.header,
    this.onConfirm,
    this.onCancel,
    this.confirmLabel,
    this.cancelLabel,
    this.hasCancel = true,
    this.hasScrollableBody = false,
  }) : assert(
         title != null || header != null,
         'Give a title or a custom header',
       );

  final Widget body;

  /// Title of the default [CcSheetHeader].
  final String? title;

  /// Leading icon of the default header.
  final IconData? icon;

  /// Trailing widget of the default header (for example a Done button).
  final Widget? headerTrailing;

  /// Replaces the default header entirely.
  final Widget? header;

  /// Shows the action row; called by the confirm button.
  final VoidCallback? onConfirm;

  /// Called by the cancel button instead of closing with no result, for a
  /// sheet whose first button is a choice of its own. The caller closes the
  /// sheet.
  final VoidCallback? onCancel;
  final String? confirmLabel;
  final String? cancelLabel;
  final bool hasCancel;

  /// The [body] scrolls by itself (a list or `SingleChildScrollView`). The
  /// sheet is then capped at [maxHeightFactor] of the window and the body
  /// takes the room left between the header and the actions, which stay in
  /// view. Otherwise the whole sheet scrolls in landscape only.
  final bool hasScrollableBody;

  /// Share of the window height a [hasScrollableBody] sheet may take.
  static const double maxHeightFactor = 0.9;

  @override
  Widget build(BuildContext context) {
    final headerWidget =
        header ??
        CcSheetHeader(title: title!, icon: icon, trailing: headerTrailing);
    if (!hasScrollableBody) {
      return CcLandscapeScrollable(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [headerWidget, _buildTinted(context, body)],
        ),
      );
    }
    return ConstrainedBox(
      constraints: BoxConstraints(
        maxHeight: MediaQuery.sizeOf(context).height * maxHeightFactor,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          headerWidget,
          Flexible(child: _buildTinted(context, Flexible(child: body))),
        ],
      ),
    );
  }

  /// The body on the tinted surface, then the actions and the bottom inset.
  Widget _buildTinted(BuildContext context, Widget content) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: context.ccColorScheme.surfaceContainerHighest,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          content,
          if (onConfirm != null) _buildActions(context),
          SizedBox(height: MediaQuery.paddingOf(context).bottom + 4),
        ],
      ),
    );
  }

  Widget _buildActions(BuildContext context) {
    final localizations = MaterialLocalizations.of(context);
    final style = context.ccTextTheme.titleMedium?.copyWith(
      color: context.ccColorScheme.primary,
      fontWeight: CcTypographyParams.semiBold,
    );
    return Padding(
      padding: EdgeInsets.fromLTRB(
        context.respPadding(CcPaddingParams.PAGE_MD),
        0,
        context.respPadding(CcPaddingParams.PAGE_MD),
        context.respPadding(CcPaddingParams.PAGE_XS),
      ),
      // Buttons that do not fit side by side (long labels, large text) stack.
      child: OverflowBar(
        alignment: MainAxisAlignment.end,
        overflowAlignment: OverflowBarAlignment.end,
        spacing: context.respDim(8),
        children: [
          if (hasCancel)
            TextButton(
              onPressed: onCancel ?? () => Navigator.of(context).pop(),
              child: Text(
                cancelLabel ?? localizations.cancelButtonLabel,
                style: style,
              ),
            ),
          TextButton(
            onPressed: onConfirm,
            child: Text(
              confirmLabel ?? localizations.okButtonLabel,
              style: style,
            ),
          ),
        ],
      ),
    );
  }
}
