import 'package:cc_sdk_ui/export_cc_sdk_ui.dart';
import 'package:flutter/material.dart';

class CcBouncing extends StatelessWidget {
  final Widget child;
  final VoidCallback? onTap;
  final bool useDebounce;
  final bool hasEnable;
  final Duration debounceDuration;
  final BorderRadius? borderRadius;

  const CcBouncing({
    super.key,
    required this.child,
    this.onTap,
    this.useDebounce = false,
    this.hasEnable = true,
    this.debounceDuration = const Duration(milliseconds: 600),
    this.borderRadius,
  });

  @override
  Widget build(BuildContext context) {
    final effectiveRadius = borderRadius ?? BorderRadius.zero;
    return CcInteractionWrapper(
      onTap: onTap ?? () {},
      useDebounce: useDebounce,
      hasBouncing: true,
      hasEnable: hasEnable,
      debounceDuration: debounceDuration,
      child: ClipRRect(borderRadius: effectiveRadius, child: child),
    );
  }
}
