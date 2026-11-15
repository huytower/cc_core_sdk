import 'package:flutter/widgets.dart';

/// Caps [child]'s width at [maxWidth] and centres it horizontally, keeping the
/// full height it is given. Narrower space passes through untouched.
///
/// The app's pattern on wide windows (beside the navigation rail, large
/// tablets, the web) is **full-bleed background, capped content**: headers and
/// page backgrounds span the whole width, while the foreground — titles,
/// forms, lists — stops at [contentWidth] and is centred. Wrap the foreground
/// in [CcMaxWidth.content]; for a scroll view that should stay scrollable
/// edge to edge, pad it with [insetFor] instead.
///
/// It does not touch `MediaQuery`, so window-based scaling stays as it is;
/// layout inside should follow its own constraints (e.g. `CcAdaptiveBuilder`).
class CcMaxWidth extends StatelessWidget {
  const CcMaxWidth({
    super.key,
    required this.maxWidth,
    required this.child,
    this.gutterColor,
  });

  /// Caps [child] at [contentWidth].
  const CcMaxWidth.content({super.key, required this.child, this.gutterColor})
    : maxWidth = contentWidth;

  /// Width page content is designed for, in dp: the lower bound of the
  /// Material 3 "expanded" window class. Phones and tablets in portrait are
  /// narrower, so they are never affected.
  static const double contentWidth = 840;

  /// Horizontal inset that centres content of [maxWidth] inside
  /// [availableWidth]; 0 when there is no extra room. Use it as a scroll
  /// view's padding so the view stays scrollable across the full width.
  static double insetFor(
    double availableWidth, {
    double maxWidth = contentWidth,
  }) => availableWidth > maxWidth ? (availableWidth - maxWidth) / 2 : 0;

  final double maxWidth;
  final Widget child;

  /// Paints the space on either side when the child is capped.
  final Color? gutterColor;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth <= maxWidth) return child;

        final capped = Center(
          child: SizedBox(
            width: maxWidth,
            height: constraints.hasBoundedHeight ? constraints.maxHeight : null,
            child: child,
          ),
        );
        final color = gutterColor;
        return color == null ? capped : ColoredBox(color: color, child: capped);
      },
    );
  }
}
