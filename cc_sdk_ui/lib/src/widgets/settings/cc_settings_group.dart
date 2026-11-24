import 'package:flutter/material.dart';

import '../../../export_cc_sdk_ui.dart';

/// A rounded, outlined surface stacking settings rows (usually
/// [CcSettingsTile]s) with a thin divider between them.
///
/// ```dart
/// CcSettingsGroup(items: [languageTile, currencyTile, themeTile])
/// ```
class CcSettingsGroup extends StatelessWidget {
  const CcSettingsGroup({super.key, required this.items});

  final List<Widget> items;

  @override
  Widget build(BuildContext context) {
    final scheme = context.ccColorScheme;
    final lineColor = scheme.outlineVariant.withAlpha(10);
    return Container(
      decoration: BoxDecoration(
        color: scheme.surface,
        borderRadius: BorderRadius.circular(
          context.respDim(CcCircularParams.CARD),
        ),
        border: Border.all(color: lineColor),
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          for (var i = 0; i < items.length; i++) ...[
            if (i > 0) CcDividerHorizontalLine(color: lineColor),
            items[i],
          ],
        ],
      ),
    );
  }
}
