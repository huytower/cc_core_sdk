// Adapted from curved_navigation_bar_pro 2.2.3
// (https://pub.dev/packages/curved_navigation_bar_pro), MIT License,
// Copyright (c) 2026 aslamambiloly. Full notice: LICENSE in this folder.

import 'package:flutter/material.dart';

/// The selected item's circle. It pops in with an elastic scale each time it
/// is built anew, so give it a new key per selected index.
class CcCurvedBubble extends StatefulWidget {
  const CcCurvedBubble({
    super.key,
    required this.child,
    required this.radius,
    required this.color,
  });

  final Widget child;
  final double radius;
  final Color color;

  @override
  State<CcCurvedBubble> createState() => _CcCurvedBubbleState();
}

class _CcCurvedBubbleState extends State<CcCurvedBubble>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 550),
  )..forward();

  late final Animation<double> _scale = Tween<double>(
    begin: 0.55,
    end: 1.0,
  ).animate(CurvedAnimation(parent: _ctrl, curve: Curves.elasticOut));

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _scale,
      builder: (_, child) => Transform.scale(scale: _scale.value, child: child),
      child: Container(
        width: widget.radius * 2,
        height: widget.radius * 2,
        decoration: BoxDecoration(color: widget.color, shape: BoxShape.circle),
        child: Center(child: widget.child),
      ),
    );
  }
}
