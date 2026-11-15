import 'package:flutter/widgets.dart';

/// Caps [child]'s width at [maxWidth] and centres it horizontally, keeping the
/// full height it is given. Narrower space passes through untouched.
///
/// Use it for a content area that should not stretch edge to edge on wide
/// windows (next to a navigation rail, on a large tablet, on the web). It does
/// not touch `MediaQuery`, so window-based scaling stays as it is; layout
/// inside should follow its own constraints (e.g. `CcAdaptiveBuilder`).
class CcMaxWidth extends StatelessWidget {
  const CcMaxWidth({
    super.key,
    required this.maxWidth,
    required this.child,
    this.gutterColor,
  });

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
