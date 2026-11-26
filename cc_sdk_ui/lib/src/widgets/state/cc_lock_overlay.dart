import 'package:cc_sdk_ui/export_cc_sdk_ui.dart';
import 'package:flutter/material.dart';

/// Shows [child] as locked while [hasLocked] is true: the child is dimmed and
/// cannot be touched, and a lock badge covers its centre.
///
/// The child stays visible so the user sees what is behind the lock. Taps on
/// the locked area go to [onLockedTap] (for example, a sheet explaining how
/// to unlock it); with no [onLockedTap] they are simply swallowed. When
/// [hasLocked] is false the child is returned unchanged.
///
/// ```dart
/// CcLockOverlay(hasLocked: !hasAccess, onLockedTap: showUnlockSheet, child: form)
/// ```
class CcLockOverlay extends StatelessWidget {
  const CcLockOverlay({
    super.key,
    required this.hasLocked,
    required this.child,
    this.onLockedTap,
    this.semanticLabel,
    this.icon = Icons.lock_outline_rounded,
    this.borderRadius,
  });

  /// Whether [child] is locked.
  final bool hasLocked;

  /// The content being locked.
  final Widget child;

  /// Runs when the user taps the locked area.
  final VoidCallback? onLockedTap;

  /// Already-translated label read by screen readers for the locked area.
  final String? semanticLabel;

  /// The badge icon.
  final IconData icon;

  /// Corner radius of the scrim; defaults to `context.brLg`.
  final BorderRadius? borderRadius;

  /// Opacity applied to [child] while locked.
  static const double lockedChildOpacity = 0.5;

  @override
  Widget build(BuildContext context) {
    if (!hasLocked) return child;

    return Stack(
      children: [
        IgnorePointer(
          child: ExcludeSemantics(
            child: Opacity(opacity: lockedChildOpacity, child: child),
          ),
        ),
        Positioned.fill(child: _buildScrim(context)),
      ],
    );
  }

  Widget _buildScrim(BuildContext context) {
    final scheme = context.ccColorScheme;

    return Semantics(
      button: onLockedTap != null,
      label: semanticLabel,
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: onLockedTap,
        child: DecoratedBox(
          decoration: BoxDecoration(
            color: scheme.surface.withValues(alpha: 0.3),
            borderRadius: borderRadius ?? context.brLg,
          ),
          child: Center(child: _buildBadge(context)),
        ),
      ),
    );
  }

  Widget _buildBadge(BuildContext context) {
    final scheme = context.ccColorScheme;

    return Container(
      width: context.respDim(32),
      height: context.respDim(32),
      decoration: BoxDecoration(
        color: scheme.surface,
        shape: BoxShape.circle,
        border: Border.all(
          color: scheme.onSurfaceVariant.withValues(alpha: 0.1),
          width: context.respDim(1.5),
        ),
      ),
      child: Icon(
        icon,
        size: context.respIconSize(baseSize: 16),
        color: scheme.onSurfaceVariant.withValues(alpha: 0.6),
      ),
    );
  }
}
