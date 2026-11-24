import 'package:flutter/material.dart';

import '../../../export_cc_sdk_ui.dart';

/// The faintly tinted, rounded card that holds a form's fields. On wide
/// windows it stops at the content width ([CcContentPadding]); carousels
/// inside it scroll within the card.
///
/// ```dart
/// CcFormCard(child: Column(children: [nameField, noteField]))
/// ```
class CcFormCard extends StatelessWidget {
  const CcFormCard({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    final scheme = context.ccColorScheme;
    return CcContentPadding(
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: scheme.primaryContainer.withAlpha(5),
          borderRadius: context.brLg,
          border: Border.all(
            color: scheme.onSurface.withValues(alpha: 0.01),
            width: context.respDim(1),
          ),
        ),
        child: CcPadding(child, 6, 12, 12, 6),
      ),
    );
  }
}
