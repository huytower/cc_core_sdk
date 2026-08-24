import 'package:flutter/material.dart';

import '../../export_cc_sdk_ui.dart';

class CcBouncing extends StatelessWidget {
  final Widget child;
  final VoidCallback? onTap;
  final bool useDebounce;
  final bool isEnable;
  final Duration debounceDuration;
  final BorderRadius? borderRadius;

  const CcBouncing({
    super.key,
    required this.child,
    this.onTap,
    this.useDebounce = false,
    this.isEnable = true,
    this.debounceDuration = const Duration(milliseconds: 600),
    this.borderRadius,
  });

  @override
  Widget build(BuildContext context) {
    final effectiveRadius = borderRadius ?? BorderRadius.zero;
    return CcInteractBtnWrapper(
      onTap: onTap ?? () {},
      useDebounce: useDebounce,
      isBouncing: true,
      isEnable: isEnable,
      debounceDuration: debounceDuration,
      child: ClipRRect(
        borderRadius: effectiveRadius,
        child: child,
      ),
    );
  }
}
