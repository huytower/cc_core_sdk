import 'package:flutter/material.dart';

// This widget handles the animation and the debounce logic
class CcInteractionWrapper extends StatefulWidget {
  final Widget child;
  final VoidCallback onTap;
  final bool useDebounce;
  final bool isBouncing;

  const CcInteractionWrapper({
    super.key,
    required this.child,
    required this.onTap,
    required this.useDebounce,
    required this.isBouncing,
  });

  @override
  State<CcInteractionWrapper> createState() => _CcInteractionWrapperState();
}

class _CcInteractionWrapperState extends State<CcInteractionWrapper>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  bool _isDebouncing = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 100),
      lowerBound: 0.0,
      upperBound: 0.05,
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _handleTap() async {
    if (widget.useDebounce && _isDebouncing) return;

    if (widget.isBouncing) {
      _controller.forward().then((_) => _controller.reverse());
    }

    if (widget.useDebounce) {
      setState(() => _isDebouncing = true);
      Future.delayed(const Duration(milliseconds: 600), () {
        if (mounted) setState(() => _isDebouncing = false);
      });
    }

    widget.onTap();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _handleTap,
      behavior: HitTestBehavior.opaque,
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          return Transform.scale(
            scale: widget.isBouncing ? (1.0 - _controller.value) : 1.0,
            child: child,
          );
        },
        child: widget.child,
      ),
    );
  }
}
