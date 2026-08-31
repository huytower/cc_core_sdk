import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../core/config/tokens/cc_border_radius.dart';
import '../../core/extensions/cc_context_extension.dart';

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
  });

  final double size;
  final Color? color;
  final bool showing;
  final String? label;
  final VoidCallback? onTap;
  final VoidCallback? onLabelTap;

  /// Whether the label bubble should align its left edge with the dot and grow
  /// to the right. Useful for badges on the left side of the screen.
  final bool growRight;

  /// Whether the descriptive text labels on guideline badges are hidden.
  final bool isDescriptionHidden;

  /// Overrides everything to never show the label text bubble.
  final bool forceHideLabel;

  /// Optional trigger to perform a bounce animation.
  final RxInt? bounceTrigger;

  @override
  State<CcGuidelineBadge> createState() => _CcGuidelineBadgeState();
}

class _CcGuidelineBadgeState extends State<CcGuidelineBadge>
    with TickerProviderStateMixin {
  late AnimationController _pulseController;
  late Animation<double> _pulseAnimation;

  late AnimationController _bounceController;
  late Animation<double> _bounceAnimation;
  Worker? _worker;

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

    _setupWorker();
  }

  void _setupWorker() {
    _worker?.dispose();
    if (widget.bounceTrigger != null) {
      _worker = ever(widget.bounceTrigger!, (_) {
        if (mounted) {
          _bounceController.forward(from: 0.0);
        }
      });
    }
  }

  @override
  void didUpdateWidget(CcGuidelineBadge oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.bounceTrigger != oldWidget.bounceTrigger) {
      _setupWorker();
    }
  }

  @override
  void dispose() {
    _pulseController.dispose();
    _bounceController.dispose();
    _worker?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!widget.showing) return const SizedBox.shrink();

    final badgeColor = widget.color ?? context.ccColorScheme.primary;
    final dotSize = widget.size * 2.5;

    return GestureDetector(
      onTap: widget.onTap,
      child: Stack(
        clipBehavior: Clip.none,
        alignment: widget.growRight
            ? Alignment.bottomLeft
            : Alignment.bottomRight,
        children: [
          // 1. The pulsing dot (anchor)
          ScaleTransition(
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
                  ),
                ],
              ),
            ),
          ),
          // 2. The label bubble (positioned explicitly relative to the dot)
          if (widget.label != null &&
              !widget.isDescriptionHidden &&
              !widget.forceHideLabel)
            Positioned(
              bottom: dotSize - 4,
              left: widget.growRight ? 0 : null,
              right: !widget.growRight ? 0 : null,
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  maxWidth: MediaQuery.of(context).size.width * 0.5,
                ),
                child: GestureDetector(
                  onTap: () {
                    if (widget.onLabelTap != null) {
                      widget.onLabelTap!();
                    } else {
                      // Fallback to controller if available
                      try {
                        final guideline = Get.find<dynamic>();
                        if (guideline.isDescriptionHidden != null) {
                          guideline.isDescriptionHidden.value = true;
                        }
                      } catch (_) {
                        // Controller not found or state not available
                      }
                    }
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: badgeColor.withOpacity(0.8),
                      borderRadius: context.brLg,
                      border: Border.all(
                        color: context.ccColorScheme.onPrimary.withOpacity(0.5),
                        width: 0.5,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.12),
                          blurRadius: 8,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Text(
                      widget.label!,
                      style: context.ccTextTheme.labelSmall?.copyWith(
                        color: context.ccColorScheme.onPrimary,
                        fontWeight: FontWeight.bold,
                        fontSize: 8,
                      ),
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                      textAlign: widget.growRight
                          ? TextAlign.left
                          : TextAlign.right,
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
