import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/scheduler.dart';

import '../config/tokens/cc_base_colors.dart';
import '../config/tokens/cc_circular_params.dart';
import '../extensions/cc_context_extension.dart';

/// CcWidgetHelper: Utility class for common UI-related operations and styling.
///
/// Principles:
/// - State-management agnostic.
/// - Prioritize design tokens for colors and typography.
/// - Consolidate platform and device logic into `cc_sdk` helpers.
class CcWidgetHelper {
  // ==========================================================================
  // SHADOWS & BORDERS
  // ==========================================================================

  /// MUST set these orders, to avoid transparent with drop shadow issue
  static List<BoxShadow> getBoxShadows(
    BuildContext context, {
    Color? shadowColor,
    double? x,
    double? y,
    double? blurRadius,
    double? spreadRadius,
    Color? backgroundColor,
  }) => [
    /// 2 - drop background of child widget
    BoxShadow(
      color: shadowColor ?? context.ccColorScheme.outlineVariant,
      spreadRadius: spreadRadius ?? 0.0,
      blurRadius: blurRadius ?? 3.0,
      offset: Offset(x ?? 2.0, y ?? 2.0),
    ),

    /// 1 - below background of child widget,
    BoxShadow(
      color: backgroundColor ?? CcBaseColors.white100,
      spreadRadius: 0,
      blurRadius: 0,
      offset: Offset.zero,
    ),
  ];

  static BorderRadius getCircleBorderRadius() =>
      BorderRadius.circular(CcCircularParams.CIRCLE);

  static BorderRadius getBorderRoundedLG() =>
      BorderRadius.circular(CcCircularParams.CARD);

  static BorderRadius getBorderRoundedMD() =>
      BorderRadius.circular(CcCircularParams.BUTTON);

  static BorderRadius getBorderRoundedSM() =>
      BorderRadius.circular(CcCircularParams.BUTTON);

  static BorderRadius getBorderRoundedSquareTopLeftRight() =>
      const BorderRadius.only(
        topLeft: Radius.circular(CcCircularParams.SQUARE_TOP),
        topRight: Radius.circular(CcCircularParams.SQUARE_TOP),
      );

  // ==========================================================================
  // SCROLLING HELPERS
  // ==========================================================================

  /// Scroll notification method, click
  static bool hasScrollingClickEnd(ScrollNotification scrollState) =>
      scrollState is ScrollEndNotification;

  /// Scroll notification method, click
  static bool hasScrollingClickStart(ScrollNotification scrollState) =>
      scrollState is ScrollStartNotification;

  /// Scroll notification method, while scrolling
  static bool hasScrollingToEnd(ScrollNotification scrollState) =>
      scrollState is UserScrollNotification &&
      scrollState.direction == ScrollDirection.idle;

  /// Make input scroll controller scroll to top
  /// Returns true if scroll was successful, false otherwise
  static bool scrollToTop(ScrollController scrollController) {
    try {
      if (scrollController.hasClients &&
          scrollController.position.hasContentDimensions) {
        scrollController.animateTo(
          0,
          curve: Curves.easeOut,
          duration: const Duration(milliseconds: 300),
        );
        return true;
      }
      return false;
    } catch (e) {
      return false;
    }
  }

  // ==========================================================================
  // FRAME & LIFECYCLE HELPERS
  // ==========================================================================

  /// Safely mark widget for rebuild after current frame
  /// Returns true if callback was scheduled successfully
  static bool markNeedsBuild(VoidCallback callback) {
    try {
      SchedulerBinding.instance.addPostFrameCallback((_) {
        try {
          callback();
        } catch (error, stack) {
          _report(error, stack, 'running a post-frame callback');
        }
      });
      return true;
    } catch (error, stack) {
      _report(error, stack, 'scheduling a post-frame callback');
      return false;
    }
  }

  /// Hands a caught error to [FlutterError.onError], which the app routes to
  /// its logger / crash reporter (the design system logs nothing itself).
  static void _report(Object error, StackTrace stack, String context) {
    FlutterError.reportError(
      FlutterErrorDetails(
        exception: error,
        stack: stack,
        library: 'cc_sdk_ui',
        context: ErrorDescription('while $context'),
      ),
    );
  }
}
