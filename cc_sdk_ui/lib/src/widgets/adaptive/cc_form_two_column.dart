import 'package:flutter/material.dart';

import '../../../export_cc_sdk_ui.dart';

/// Two-column layout for an entry form on a tablet held sideways.
///
/// - Left (3/5, or 1/2 on a small tablet): [leading] (toggles, pickers), then
///   [details] in a [CcFormCard].
/// - Right (2/5, or 1/2): [right] (value input, extra fields, submit) in a
///   [CcFormCard].
///
/// Pick it with [shouldUse]; phones and portrait tablets keep the form's
/// single column.
///
/// ```dart
/// CcFormTwoColumn.shouldUse(context)
///     ? CcFormTwoColumn(leading: [picker], details: notes, right: [amount, submit])
///     : singleColumnForm
/// ```
class CcFormTwoColumn extends StatelessWidget {
  const CcFormTwoColumn({
    super.key,
    required this.leading,
    required this.right,
    this.details,
  });

  final List<Widget> leading;
  final Widget? details;
  final List<Widget> right;

  /// Landscape window at least 600 dp wide (small tablet and up).
  static bool shouldUse(BuildContext context) => CcTwoColumn.shouldUse(context);

  /// The columns span up to this width (instead of the 840 dp content column)
  /// so the extra room of a landscape tablet is used.
  static const double maxWidth = CcTwoColumn.defaultMaxWidth;

  @override
  Widget build(BuildContext context) {
    final gap = context.respPadding(CcPaddingParams.PAGE_SM);
    final details = this.details;
    // Small (~7") tablet: even split, the 3:2 right column is too narrow.
    final even = CcTwoColumn.hasSmallTablet(context);
    return CcContentInset(
      maxWidth: maxWidth,
      child: CcContentPadding(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              flex: even ? 1 : 3,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ...leading,
                  if (details != null) ...[
                    const CcSpaceSM(),
                    Padding(
                      padding: EdgeInsets.only(left: gap),
                      child: CcFormCard(child: details),
                    ),
                  ],
                  const CcSpaceMD(),
                ],
              ),
            ),
            SizedBox(width: gap),
            Expanded(
              flex: even ? 1 : 2,
              child: Padding(
                padding: EdgeInsets.only(right: gap),
                child: CcFormCard(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: right,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
