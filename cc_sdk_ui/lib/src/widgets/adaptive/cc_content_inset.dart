import 'package:flutter/widgets.dart';

import 'cc_max_width.dart';

/// "Capped content, bleeding carousels" for a full-width area (a page body
/// beside the navigation rail, a large tablet, the web).
///
/// Measures the width it is given and provides the horizontal inset that
/// centres [maxWidth]-wide content in it — 0 whenever the area is not wider
/// than [maxWidth] (phones, portrait tablets), so those layouts are unchanged.
/// Descendants then:
///
/// - wrap capped parts (form cards, labels, buttons) in [CcContentPadding];
/// - give horizontal carousels a start padding of `base + CcContentInset.of`
///   and an end padding of just `base`, so they start aligned with the content
///   but scroll out to the trailing edge of the screen instead of being cut at
///   the content edge.
class CcContentInset extends StatelessWidget {
  const CcContentInset({
    super.key,
    required this.child,
    this.maxWidth = CcMaxWidth.contentWidth,
  });

  final Widget child;
  final double maxWidth;

  /// The inset on each side for widgets inside this area; 0 outside one, and
  /// 0 inside a [CcContentPadding] (already applied there).
  static double of(BuildContext context) =>
      context
          .dependOnInheritedWidgetOfExactType<_CcContentInsetScope>()
          ?.inset ??
      0;

  /// Like [of], without registering a dependency — for callbacks outside
  /// `build` (e.g. scroll-to-item logic).
  static double read(BuildContext context) =>
      context.getInheritedWidgetOfExactType<_CcContentInsetScope>()?.inset ?? 0;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) => _CcContentInsetScope(
        inset: constraints.hasBoundedWidth
            ? CcMaxWidth.insetFor(constraints.maxWidth, maxWidth: maxWidth)
            : 0,
        child: child,
      ),
    );
  }
}

/// Pads [child] by the [CcContentInset] on both sides, capping it at the
/// content width, and resets the inset to 0 for everything inside — a
/// carousel within a capped card scrolls inside the card, as usual.
///
/// Always keeps the same widget shape (a 0 inset just pads by 0), so state
/// below survives the window crossing the content width.
class CcContentPadding extends StatelessWidget {
  const CcContentPadding({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: CcContentInset.of(context)),
      child: _CcContentInsetScope(inset: 0, child: child),
    );
  }
}

class _CcContentInsetScope extends InheritedWidget {
  const _CcContentInsetScope({required this.inset, required super.child});

  final double inset;

  @override
  bool updateShouldNotify(_CcContentInsetScope oldWidget) =>
      inset != oldWidget.inset;
}
