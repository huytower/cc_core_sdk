import 'package:flutter/material.dart';

import '../../../export_cc_sdk_ui.dart';

/// A glassy card for a list item that can be edited in place: a [header] over
/// a column of [stats]. In edit mode ([hasEditMode]) it shows a delete badge
/// on the top-left corner (unless [hasDeletable] is false) and an edit badge,
/// with an optional [dragHandle] before it, on the top-right corner.
///
/// ```dart
/// CcEditableListItem(
///   header: Text(item.name),
///   stats: [CcStatRow(label: 'Total', value: '12', color: color)],
///   hasEditMode: isReordering,
///   onEdit: () => edit(item),
///   onDelete: () => delete(item),
/// )
/// ```
class CcEditableListItem extends StatelessWidget {
  const CcEditableListItem({
    super.key,
    required this.header,
    required this.stats,
    required this.onEdit,
    required this.onDelete,
    this.hasEditMode = false,
    this.hasDeletable = true,
    this.dragHandle,
  });

  final Widget header;
  final List<Widget> stats;
  final VoidCallback onEdit;
  final VoidCallback onDelete;
  final bool hasEditMode;
  final bool hasDeletable;

  /// Shown next to the edit badge in edit mode (for example a
  /// `ReorderableDragStartListener`).
  final Widget? dragHandle;

  @override
  Widget build(BuildContext context) {
    final scheme = context.ccColorScheme;

    return Stack(
      clipBehavior: Clip.none,
      children: [
        const Positioned.fill(child: CcGlassyGradientBackground()),
        Container(
          padding: EdgeInsets.all(context.respDim(12)),
          decoration: BoxDecoration(
            borderRadius: context.brLg,
            border: context.borderSubtle,
            boxShadow: [
              BoxShadow(
                color: scheme.onSurface.withValues(alpha: 0.04),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              header,
              const CcSpaceMD(),
              Column(children: stats),
            ],
          ),
        ),
        if (hasEditMode) ..._buildEditBadges(context),
      ],
    );
  }

  List<Widget> _buildEditBadges(BuildContext context) {
    final scheme = context.ccColorScheme;
    final offset = context.respDim(-6);
    return [
      if (hasDeletable)
        Positioned(
          top: offset,
          left: offset,
          child: CcEditBadge(
            icon: Icons.remove,
            color: scheme.error,
            foregroundColor: scheme.onError,
            onTap: onDelete,
          ),
        ),
      Positioned(
        top: offset,
        right: offset,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (dragHandle != null) ...[dragHandle!, const CcSpaceXS()],
            CcEditBadge(
              icon: Icons.edit,
              color: scheme.primary,
              foregroundColor: scheme.onPrimary,
              onTap: onEdit,
            ),
          ],
        ),
      ),
    ];
  }
}
