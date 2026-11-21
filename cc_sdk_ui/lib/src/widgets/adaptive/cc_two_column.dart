import 'package:flutter/widgets.dart';

import '../../core/config/tokens/cc_padding_params.dart';
import '../../core/extensions/common/cc_responsive_extension.dart';
import '../../core/layout/cc_window_size_class.dart';
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

  /// Shortest side below which a two-column window is a small (~7") tablet.
  static const double smallTabletMaxShortestSide = 720;

  /// [shouldUse] on a small (~7") tablet: the columns are narrow, so they
  /// split the width evenly (1:1) instead of [leftFlex]:[rightFlex].
  static bool isSmallTablet(BuildContext context) =>
      shouldUse(context) &&
      MediaQuery.sizeOf(context).shortestSide < smallTabletMaxShortestSide;

  @override
  Widget build(BuildContext context) {
    final columnGap = gap ?? context.respPadding(CcPaddingParams.SPACE_MD);
    final even = isSmallTablet(context);
    return CcMaxWidth(
      maxWidth: maxWidth,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: even ? 1 : leftFlex,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: left,
            ),
          ),
          SizedBox(width: columnGap),
          Expanded(
            flex: even ? 1 : rightFlex,
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
