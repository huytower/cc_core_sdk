// Adapted from curved_navigation_bar_pro 2.2.3
// (https://pub.dev/packages/curved_navigation_bar_pro), MIT License,
// Copyright (c) 2026 aslamambiloly. Full notice: LICENSE in this folder.
// Changes: no style presets or haptic options; every value comes resolved
// from CcCurvedNavigationBar.

import 'package:cc_sdk_ui/src/widgets/navigation/cc_curved_navigation_item.dart';
import 'package:cc_sdk_ui/src/widgets/navigation/curved/cc_curved_bubble.dart';
import 'package:cc_sdk_ui/src/widgets/navigation/curved/cc_curved_navigation_tile.dart';
import 'package:cc_sdk_ui/src/widgets/navigation/curved/cc_curved_notch_painter.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// Bottom bar with an animated curved notch and an elastic bubble that slides
/// to the selected item. Internal: use [CcCurvedNavigationBar].
class CcCurvedBarView extends StatefulWidget {
  const CcCurvedBarView({
    super.key,
    required this.items,
    required this.currentIndex,
    required this.onTap,
    required this.backgroundColor,
    required this.activeColor,
    required this.activeIconColor,
    required this.inactiveColor,
    required this.fabColor,
    required this.shadowColor,
    required this.barHeight,
    required this.fabRadius,
    required this.fabGap,
    required this.fabSink,
    required this.notchShoulderRadius,
    required this.cornerRadius,
    required this.contentPadding,
    required this.elevation,
    required this.animationDuration,
    required this.animationCurve,
    required this.activeTextStyle,
    required this.inactiveTextStyle,
    required this.inactiveIconSize,
    required this.activeIconSize,
    required this.useSafeArea,
  }) : assert(items.length >= 2 && items.length <= 6, '2 to 6 items'),
       assert(currentIndex >= 0 && currentIndex < items.length, 'index');

  final List<CcCurvedNavigationItem> items;
  final int currentIndex;
  final ValueChanged<int> onTap;
  final Color backgroundColor;
  final Color activeColor;
  final Color activeIconColor;
  final Color inactiveColor;
  final Color fabColor;
  final Color shadowColor;
  final double barHeight;
  final double fabRadius;
  final double fabGap;
  final double fabSink;
  final double notchShoulderRadius;
  final double cornerRadius;
  final double contentPadding;
  final double elevation;
  final Duration animationDuration;
  final Curve animationCurve;
  final TextStyle activeTextStyle;
  final TextStyle inactiveTextStyle;
  final double inactiveIconSize;
  final double activeIconSize;
  final bool useSafeArea;

  @override
  State<CcCurvedBarView> createState() => _CcCurvedBarViewState();
}

class _CcCurvedBarViewState extends State<CcCurvedBarView>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late double _fromFraction;
  late double _toFraction;

  double _indexToFraction(int index) => index / (widget.items.length - 1);

  /// Bubble position along the bar, 0 (first item) to 1 (last item).
  double get _liveFraction {
    final t = widget.animationCurve.transform(
      _controller.value.clamp(0.0, 1.0),
    );
    return _fromFraction + (_toFraction - _fromFraction) * t;
  }

  @override
  void initState() {
    super.initState();
    _fromFraction = _indexToFraction(widget.currentIndex);
    _toFraction = _fromFraction;
    _controller =
        AnimationController(vsync: this, duration: widget.animationDuration)
          ..addListener(() => setState(() {}))
          ..value = 1.0;
  }

  @override
  void didUpdateWidget(CcCurvedBarView old) {
    super.didUpdateWidget(old);
    if (old.currentIndex != widget.currentIndex) {
      _fromFraction = _liveFraction;
      _toFraction = _indexToFraction(widget.currentIndex);
      _controller
        ..value = 0.0
        ..forward();
    }
    if (old.animationDuration != widget.animationDuration) {
      _controller.duration = widget.animationDuration;
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _handleTap(int index) {
    HapticFeedback.selectionClick();
    widget.onTap(index);
  }

  @override
  Widget build(BuildContext context) {
    final bottomPadding = widget.useSafeArea
        ? (MediaQuery.maybePaddingOf(context)?.bottom ?? 0.0)
        : 0.0;
    final barHeight = widget.barHeight + bottomPadding;
    final fabRadius = widget.fabRadius;
    final sink = widget.fabSink.clamp(0.0, fabRadius);
    final fraction = _liveFraction;

    return LayoutBuilder(
      builder: (context, constraints) {
        final totalWidth = constraints.maxWidth;
        final padding = widget.contentPadding;
        final itemWidth = (totalWidth - 2 * padding) / widget.items.length;
        final rawCX =
            padding +
            fraction * (widget.items.length - 1) * itemWidth +
            itemWidth / 2;
        final bubbleCX = rawCX.clamp(fabRadius, totalWidth - fabRadius);

        return Semantics(
          container: true,
          explicitChildNodes: true,
          child: SizedBox(
            width: totalWidth,
            height: barHeight + fabRadius - sink,
            child: Stack(
              clipBehavior: Clip.none,
              children: [
                _buildBar(barHeight, bubbleCX, sink),
                _buildItems(barHeight),
                _buildBubble(bubbleCX),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildBar(double barHeight, double bubbleCX, double sink) {
    return Positioned(
      bottom: 0,
      left: 0,
      right: 0,
      height: barHeight,
      child: CustomPaint(
        painter: CcCurvedNotchPainter(
          notchCX: bubbleCX,
          notchR: widget.fabRadius + widget.fabGap,
          fabSink: sink,
          notchShoulderRadius: widget.notchShoulderRadius,
          cornerRadius: widget.cornerRadius,
          color: widget.backgroundColor,
          shadowColor: widget.shadowColor,
          elevation: widget.elevation,
        ),
      ),
    );
  }

  Widget _buildItems(double barHeight) {
    return Positioned(
      bottom: 0,
      left: 0,
      right: 0,
      height: barHeight,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: widget.contentPadding),
        child: Row(
          children: List.generate(widget.items.length, (i) {
            return Expanded(
              child: CcCurvedNavigationTile(
                item: widget.items[i],
                hasActive: i == widget.currentIndex,
                activeColor: widget.activeColor,
                inactiveColor: widget.inactiveColor,
                inactiveIconSize: widget.inactiveIconSize,
                animationDuration: widget.animationDuration,
                activeTextStyle: widget.activeTextStyle,
                inactiveTextStyle: widget.inactiveTextStyle,
                barBackgroundColor: widget.backgroundColor,
                useSafeArea: widget.useSafeArea,
                onTap: () => _handleTap(i),
              ),
            );
          }),
        ),
      ),
    );
  }

  Widget _buildBubble(double bubbleCX) {
    final item = widget.items[widget.currentIndex];
    return Positioned(
      left: bubbleCX - widget.fabRadius,
      top: 0,
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () => _handleTap(widget.currentIndex),
        child: CcCurvedBubble(
          key: ValueKey(widget.currentIndex),
          radius: widget.fabRadius,
          color: widget.fabColor,
          child: CcCurvedBadge(
            badgeText: item.badgeText,
            badgeColor: item.badgeColor,
            badgeTextColor: item.badgeTextColor,
            badgeWidget: item.badgeWidget,
            borderColor: widget.fabColor,
            child: Icon(
              item.activeIcon,
              color: widget.activeIconColor,
              size: widget.activeIconSize,
            ),
          ),
        ),
      ),
    );
  }
}
