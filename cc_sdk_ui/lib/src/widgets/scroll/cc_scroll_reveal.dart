import 'package:flutter/widgets.dart';

import '../../core/extensions/common/cc_responsive_extension.dart';
import '../adaptive/cc_content_inset.dart';

/// Scrolls a horizontal row of equal-width items so the item at an index sits
/// in the middle of the viewport.
///
/// Two steps:
/// 1. If `itemKey` is already laid out, [Scrollable.ensureVisible] centres it
///    exactly.
/// 2. Otherwise the offset is computed from `itemWidth`, `itemGap` and
///    `leadingPadding` (design sizes, scaled with `respDim` / `respPadding`
///    when a context is available), the row is animated there once, and
///    `ensureVisible` refines it after the animation.
///
/// If the scroll view is not attached yet it retries on the next frames.
///
/// ```dart
/// CcScrollReveal.reveal(
///   scrollController: rowController,
///   index: selectedIndex,
///   itemWidth: 68,
///   itemGap: 12,
///   leadingPadding: 16,
///   context: context,
/// );
/// ```
abstract final class CcScrollReveal {
  static const Duration _scrollDuration = Duration(milliseconds: 400);
  static const Duration _refineDelay = Duration(milliseconds: 450);
  static const Duration _ensureVisibleDuration = Duration(milliseconds: 350);
  static const Duration _refineDuration = Duration(milliseconds: 200);

  /// Centres the item at [index] (see the class doc).
  static void reveal({
    required ScrollController scrollController,
    required int index,
    required double itemWidth,
    required double itemGap,
    required double leadingPadding,
    GlobalKey? itemKey,
    BuildContext? context,
    int attemptsLeft = 4,
  }) {
    if (index < 0) return;

    final itemContext = itemKey?.currentContext;
    if (itemContext != null) {
      Scrollable.ensureVisible(
        itemContext,
        alignment: 0.5,
        duration: _ensureVisibleDuration,
        curve: Curves.easeOutCubic,
      );
      return;
    }

    void retry() {
      if (attemptsLeft <= 0) return;
      WidgetsBinding.instance.addPostFrameCallback(
        (_) => reveal(
          scrollController: scrollController,
          index: index,
          itemWidth: itemWidth,
          itemGap: itemGap,
          leadingPadding: leadingPadding,
          itemKey: itemKey,
          context: context,
          attemptsLeft: attemptsLeft - 1,
        ),
      );
    }

    if (!scrollController.hasClients || scrollController.positions.isEmpty) {
      retry();
      return;
    }

    final position = scrollController.positions.last;
    if (position.viewportDimension == 0.0) {
      retry();
      return;
    }

    final effectiveContext = context ?? position.context.notificationContext;

    final width = effectiveContext?.respDim(itemWidth) ?? itemWidth;
    final extent = width + (effectiveContext?.respDim(itemGap) ?? itemGap);
    // On wide windows the row starts at the content inset (it bleeds to the
    // trailing edge), so the inset is part of the leading offset.
    final leading = effectiveContext != null
        ? effectiveContext.respPadding(leadingPadding) +
              CcContentInset.read(effectiveContext)
        : leadingPadding;

    final target =
        (leading + index * extent - (position.viewportDimension - width) / 2)
            .clamp(0.0, double.infinity);

    scrollController.animateTo(
      target,
      duration: _scrollDuration,
      curve: Curves.easeOutCubic,
    );

    if (itemKey == null) return;
    Future.delayed(_refineDelay, () {
      void refine() {
        final refinedContext = itemKey.currentContext;
        if (refinedContext == null) return;
        Scrollable.ensureVisible(
          refinedContext,
          alignment: 0.5,
          duration: _refineDuration,
          curve: Curves.easeOutCubic,
        );
      }

      if (itemKey.currentContext != null) {
        refine();
      } else {
        WidgetsBinding.instance.addPostFrameCallback((_) => refine());
      }
    });
  }
}
