import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../../../export_cc_sdk_ui.dart';

/// Top-level app shell that picks its navigation from the window size:
///
/// - below [railFrom] (phones, 7–11" tablets upright): a
///   [CcCurvedNavigationBar] at the bottom;
/// - from [railFrom] up (tablets held sideways, a 13" iPad upright, desktop):
///   a [CcNavigationRail] beside the content, with labels from
///   [extendedRailFrom].
///
/// Both are built from the same [destinations], [currentIndex] and colours.
/// The content keeps its state when the window crosses [railFrom] (rotation,
/// split screen), and is wrapped in [CcNavigationRailScope] so pages can
/// square the edge that touches the rail.
///
/// The bottom bar pads for the system bottom inset itself: a gesture indicator
/// (inset up to [maxGestureInset]) only gets [gestureInsetCap], so the bar
/// stays compact; a 3-button bar keeps its whole inset.
///
/// The SDK holds no state management: pass [navigationBuilder] to wrap the bar
/// and the rail in the app's own rebuild (e.g. GetX `Obx`, a `BlocBuilder`)
/// when badges change.
///
/// ```dart
/// CcAdaptiveNavigationScaffold(
///   destinations: items,
///   currentIndex: index,
///   onSelect: (i) => setState(() => index = i),
///   primaryIndex: 1,
///   body: pages[index],
/// )
/// ```
class CcAdaptiveNavigationScaffold extends StatefulWidget {
  const CcAdaptiveNavigationScaffold({
    super.key,
    required this.destinations,
    required this.currentIndex,
    required this.onSelect,
    required this.body,
    this.primaryIndex,
    this.hasNavigation = true,
    this.navigationBuilder,
    this.railFrom = CcWindowSizeClass.expanded,
    this.extendedRailFrom = CcWindowSizeClass.extraLarge,
    this.activeColor,
    this.activeIconColor,
    this.inactiveColor,
    this.fabColor,
    this.navigationBackgroundColor,
    this.systemBarBackgroundColor,
    this.barHeight,
  });

  /// Shared by the bottom bar and the rail.
  final List<CcCurvedNavigationItem> destinations;
  final int currentIndex;
  final ValueChanged<int> onSelect;

  /// The page of the current destination.
  final Widget body;

  /// Shown as the rail's round primary action (the bottom bar's raised item).
  final int? primaryIndex;

  /// False hides the bar and the rail (for example during a splash).
  final bool hasNavigation;

  /// Wraps the bar or the rail, e.g. in the app's reactive rebuild.
  final Widget Function(Widget navigation)? navigationBuilder;

  /// Smallest window class that shows the rail instead of the bottom bar.
  final CcWindowSizeClass railFrom;

  /// Smallest window class whose rail shows labels beside the icons.
  final CcWindowSizeClass extendedRailFrom;

  final Color? activeColor;
  final Color? activeIconColor;
  final Color? inactiveColor;
  final Color? fabColor;
  final Color? navigationBackgroundColor;

  /// Fill behind the bottom bar's system inset. Defaults to white in a light
  /// theme and transparent in a dark one.
  final Color? systemBarBackgroundColor;

  /// Bottom bar height; defaults to the bar's own.
  final double? barHeight;

  /// Bottom insets up to this size (dp) come from a gesture indicator (iOS
  /// home indicator, Android gesture pill); larger ones from a 3-button bar.
  static const double maxGestureInset = 34;

  /// Padding kept under the bar for a gesture indicator.
  static const double gestureInsetCap = 22;

  /// The padding the bottom bar keeps for a system bottom inset of
  /// [systemInset] dp (see the class doc).
  static double bottomPaddingFor(double systemInset) =>
      systemInset <= maxGestureInset
      ? math.min(systemInset, gestureInsetCap)
      : systemInset;

  @override
  State<CcAdaptiveNavigationScaffold> createState() =>
      _CcAdaptiveNavigationScaffoldState();
}

class _CcAdaptiveNavigationScaffoldState
    extends State<CcAdaptiveNavigationScaffold> {
  /// Keeps the page's state when the layout switches between bar and rail.
  final GlobalKey _contentKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    final windowClass = context.windowSizeClass;
    final hasRail =
        widget.hasNavigation && windowClass.hasAtLeast(widget.railFrom);
    final hasBottomBar = widget.hasNavigation && !hasRail;

    return Scaffold(
      body: Row(
        children: [
          if (hasRail)
            _wrap(
              CcNavigationRail(
                items: widget.destinations,
                currentIndex: widget.currentIndex,
                onTap: widget.onSelect,
                primaryIndex: widget.primaryIndex,
                extended: windowClass.hasAtLeast(widget.extendedRailFrom),
                backgroundColor: widget.navigationBackgroundColor,
                activeColor: widget.activeColor,
                activeIconColor: widget.activeIconColor,
                inactiveColor: widget.inactiveColor,
              ),
            ),
          Expanded(
            child: CcNavigationRailScope(
              railVisible: hasRail,
              child: KeyedSubtree(key: _contentKey, child: widget.body),
            ),
          ),
        ],
      ),
      bottomNavigationBar: hasBottomBar
          ? _wrap(_buildBottomBar(context))
          : null,
    );
  }

  Widget _wrap(Widget navigation) =>
      widget.navigationBuilder?.call(navigation) ?? navigation;

  Widget _buildBottomBar(BuildContext context) {
    final systemInset = MediaQuery.paddingOf(context).bottom;
    final background =
        widget.systemBarBackgroundColor ??
        (context.hasDarkMode
            ? CcBaseColors.transparent
            : CcBaseColors.white100);
    return ColoredBox(
      color: background,
      child: Padding(
        padding: EdgeInsets.only(
          bottom: CcAdaptiveNavigationScaffold.bottomPaddingFor(systemInset),
        ),
        child: CcCurvedNavigationBar(
          items: widget.destinations,
          currentIndex: widget.currentIndex,
          onTap: widget.onSelect,
          backgroundColor: widget.navigationBackgroundColor,
          activeColor: widget.activeColor,
          activeIconColor: widget.activeIconColor,
          inactiveColor: widget.inactiveColor,
          fabColor: widget.fabColor,
          barHeight: widget.barHeight,
          // The padding above already covers the system inset.
          useSafeArea: false,
        ),
      ),
    );
  }
}
