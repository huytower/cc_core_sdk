import 'package:cc_sdk/export_cc_sdk.dart';
import 'package:flutter/widgets.dart';

import '../../core/config/tokens/cc_padding_params.dart';
import '../../core/extensions/common/cc_responsive_extension.dart';
import 'cc_max_width.dart';

/// Left / right layout for a page on a tablet held sideways, so the width is
/// used instead of one stretched (or centred) column.
///
/// The left column ([leftFlex] = 3) holds the primary content, the right one
/// ([rightFlex] = 2) the secondary content or actions. Both stack their
/// children top-aligned. The whole block is capped at [maxWidth] and centred,
/// so the page background and header stay full-bleed.
///
/// Branch with [shouldUse]; below that threshold (phones — portrait only —
/// and portrait tablets) keep the page's single column. It is meant to sit
/// inside a scroll view (its height follows its content).
class CcTwoColumn extends StatelessWidget {
  const CcTwoColumn({
    super.key,
    required this.left,
    required this.right,
    this.leftFlex = 3,
    this.rightFlex = 2,
    this.gap,
    this.maxWidth = defaultMaxWidth,
  });

  final List<Widget> left;
  final List<Widget> right;
  final int leftFlex;
  final int rightFlex;

  /// Space between the columns; defaults to the medium spacing token. Use 0
  /// when the children already carry their own horizontal padding.
  final double? gap;

  /// The block spans up to this width (wider than the 840 dp content column,
  /// so the extra room of a landscape tablet is actually used).
  final double maxWidth;

  static const double defaultMaxWidth = 1200;

  /// Landscape window at least 600 dp wide (small tablet and up).
  static bool shouldUse(BuildContext context) =>
      MediaQuery.orientationOf(context) == Orientation.landscape &&
      CcWindowSizeClass.of(context).isAtLeast(CcWindowSizeClass.medium);

  @override
  Widget build(BuildContext context) {
    final columnGap = gap ?? context.respPadding(CcPaddingParams.SPACE_MD);
    return CcMaxWidth(
      maxWidth: maxWidth,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: leftFlex,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: left,
            ),
          ),
          SizedBox(width: columnGap),
          Expanded(
            flex: rightFlex,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: right,
            ),
          ),
        ],
      ),
    );
  }
}
