import 'package:flutter/material.dart';

import '../../core/config/tokens/cc_border_radius.dart';
import '../../core/extensions/cc_context_extension.dart';
import '../../core/extensions/common/cc_responsive_extension.dart';

class CcGuidelineBadge extends StatefulWidget {
  const CcGuidelineBadge({
    super.key,
    this.size = 12,
    this.color,
    this.showing = true,
    this.bounceTrigger,
    this.label,
    this.onTap,
    this.onLabelTap,
    this.growRight = false,
    this.isDescriptionHidden = false,
    this.forceHideLabel = false,
    this.labelAbove = true,
    this.icon,
  });

  final double size;
  final Color? color;
  final bool showing;
  final String? label;
  final VoidCallback? onTap;
  final VoidCallback? onLabelTap;
  final IconData? icon;

  /// Whether the label bubble should align its left edge with the dot and grow
  /// to the right. Useful for badges on the left side of the screen.
  final bool growRight;

  /// Whether the descriptive text labels on guideline badges are hidden.
  final bool isDescriptionHidden;

  /// Overrides everything to never show the label text bubble.
  final bool forceHideLabel;

  /// Whether to position the label above (true) or below (false) the dot.
  final bool labelAbove;

  /// Optional trigger to perform a bounce animation. Incremented by parent to trigger.
  final int? bounceTrigger;

  @override
  State<CcGuidelineBadge> createState() => _CcGuidelineBadgeState();
}

class _CcGuidelineBadgeState extends State<CcGuidelineBadge>
    with TickerProviderStateMixin {
  late AnimationController _pulseController;
  late Animation<double> _pulseAnimation;

  late AnimationController _bounceController;
  late Animation<double> _bounceAnimation;

  @override
  void initState() {
    super.initState();
    // Pulse animation (infinite)
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    )..repeat();

    _pulseAnimation = Tween<double>(
      begin: 1.0,
      end: 2.2,
    ).animate(CurvedAnimation(parent: _pulseController, curve: Curves.easeOut));

    // Bounce animation (one-shot)
    _bounceController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );

    _bounceAnimation =
        TweenSequence<double>([
          TweenSequenceItem(tween: Tween(begin: 1.0, end: 1.6), weight: 30),
          TweenSequenceItem(tween: Tween(begin: 1.6, end: 0.8), weight: 30),
          TweenSequenceItem(tween: Tween(begin: 0.8, end: 1.2), weight: 20),
          TweenSequenceItem(tween: Tween(begin: 1.2, end: 1.0), weight: 20),
        ]).animate(
          CurvedAnimation(parent: _bounceController, curve: Curves.easeInOut),
        );
  }

  @override
  void didUpdateWidget(CcGuidelineBadge oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.bounceTrigger != null &&
        widget.bounceTrigger != oldWidget.bounceTrigger) {
      _bounceController.forward(from: 0.0);
    }
  }

  @override
  void dispose() {
    _pulseController.dispose();
    _bounceController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!widget.showing) return const SizedBox.shrink();

    final badgeColor = widget.color ?? context.ccColorScheme.primary;
    final dotSize = widget.size * 2.5;

    final dot = GestureDetector(
      onTap: widget.onTap,
      behavior: HitTestBehavior.opaque,
      child: ScaleTransition(
        scale: _bounceAnimation,
        child: SizedBox(
          width: dotSize,
          height: dotSize,
          child: Stack(
            alignment: Alignment.center,
            children: [
              // Pulse rings
              AnimatedBuilder(
                animation: _pulseAnimation,
                builder: (context, child) {
                  return Container(
                    width: widget.size * _pulseAnimation.value,
                    height: widget.size * _pulseAnimation.value,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: badgeColor.withAlpha(
                        (255 * (1.0 - _pulseController.value)).toInt(),
                      ),
                      border: Border.all(
                        color: badgeColor.withAlpha(
                          (127 * (1.0 - _pulseController.value)).toInt(),
                        ),
                        width: 1,
                      ),
                    ),
                  );
                },
              ),
              // Core dot
              Container(
                width: widget.size,
                height: widget.size,
                decoration: BoxDecoration(
                  color: badgeColor,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: badgeColor.withAlpha(100),
                      blurRadius: 4,
                      spreadRadius: 1,
                    ),
                  ],
                ),
                child: widget.icon != null
                    ? Icon(
                        widget.icon,
                        size: widget.size * 0.6,
                        color: context.ccColorScheme.onPrimary,
                      )
                    : null,
              ),
            ],
          ),
        ),
      ),
    );

    Widget? labelWidget;
    if (widget.label != null &&
        !widget.isDescriptionHidden &&
        !widget.forceHideLabel) {
      labelWidget = ConstrainedBox(
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width * 0.5,
        ),
        child: GestureDetector(
          onTap: widget.onLabelTap,
          behavior: HitTestBehavior.opaque,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            decoration: BoxDecoration(
              color: context.ccColorScheme.surface,
              borderRadius: context.brLg,
              border: Border.all(
                color: context.ccColorScheme.onSurface.withOpacity(0.08),
                width: 0.5,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.06),
                  blurRadius: 12,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Pattern from image: leading status icon
                Container(
                  width: context.respDim(12),
                  height: context.respDim(12),
                  decoration: BoxDecoration(
                    color: badgeColor,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.check,
                    size: context.respDim(8),
                    color: context.ccColorScheme.onPrimary,
                  ),
                ),
                const SizedBox(width: 8),
                // Pattern from image: descriptive text
                Flexible(
                  child: Text(
                    widget.label!,
                    style: context.ccTextTheme.labelSmall?.copyWith(
                      color: context.ccColorScheme.onSurface,
                      fontWeight: FontWeight.w500,
                      fontSize: 8.5,
                    ),
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                const SizedBox(width: 8),
                // Pattern from image: trailing dismiss icon
                Icon(
                  Icons.close,
                  size: context.respDim(10),
                  color: context.ccColorScheme.onSurface.withOpacity(0.3),
                ),
              ],
            ),
          ),
        ),
      );
    }

    final body = Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: widget.growRight
          ? CrossAxisAlignment.start
          : CrossAxisAlignment.end,
      children: [
        if (widget.labelAbove && labelWidget != null) ...[
          labelWidget,
          const SizedBox(height: 4),
        ],
        dot,
        if (!widget.labelAbove && labelWidget != null) ...[
          const SizedBox(height: 4),
          labelWidget,
        ],
      ],
    );

    if (widget.onTap != null) {
      return GestureDetector(
        onTap: widget.onTap,
        behavior: HitTestBehavior.opaque,
        child: body,
      );
    }
    return body;
  }
}
