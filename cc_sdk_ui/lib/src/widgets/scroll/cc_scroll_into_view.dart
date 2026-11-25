import 'package:flutter/material.dart';

/// Scrolls [child] fully into view when [hasActive] turns on.
///
/// Useful when focusing or editing an item brings up a keyboard or keypad
/// that shrinks the scroll viewport, so the item stays visible above it.
class CcScrollIntoView extends StatefulWidget {
  final bool hasActive;
  final Widget child;

  const CcScrollIntoView({
    super.key,
    required this.hasActive,
    required this.child,
  });

  @override
  State<CcScrollIntoView> createState() => _CcScrollIntoViewState();
}

class _CcScrollIntoViewState extends State<CcScrollIntoView> {
  static const Duration _scrollDuration = Duration(milliseconds: 250);

  @override
  void didUpdateWidget(covariant CcScrollIntoView oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.hasActive && !oldWidget.hasActive) _revealAfterLayout();
  }

  void _revealAfterLayout() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted || !widget.hasActive) return;
      Scrollable.ensureVisible(
        context,
        duration: _scrollDuration,
        curve: Curves.easeOutCubic,
        alignmentPolicy: ScrollPositionAlignmentPolicy.keepVisibleAtEnd,
      );
    });
  }

  @override
  Widget build(BuildContext context) => widget.child;
}

