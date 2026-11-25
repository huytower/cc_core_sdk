import 'package:cc_sdk_ui/export_cc_sdk_ui.dart';
import 'package:flutter/material.dart';

/// Side navigation for wide windows — the counterpart of
/// [CcCurvedNavigationBar] on compact ones.
///
/// Takes the same [CcCurvedNavigationItem]s (icons, label, badge) so a shell
/// can switch between the two from one item list, and uses the same
/// theme-aware default colors.
///
/// - [primaryIndex]: the item rendered as a round action button at the top of
///   the rail (the raised "+" of the bottom bar) instead of a destination.
/// - [extended]: icon + label side by side in a wider rail; use it on large
///   windows (≥ 1600 dp, desktop / web); tablets keep the compact rail.
///
/// The rail has no divider: it separates from the page by tone (its own
/// surface vs. the page background).
class CcNavigationRail extends StatelessWidget {
  const CcNavigationRail({
    super.key,
    required this.items,
    required this.currentIndex,
    required this.onTap,
    this.primaryIndex,
    this.extended = false,
    this.backgroundColor,
    this.activeColor,
    this.activeIconColor,
    this.inactiveColor,
    this.useSafeArea = true,
  });

  final List<CcCurvedNavigationItem> items;
  final int currentIndex;
  final ValueChanged<int> onTap;

  /// Item shown as the primary action button at the top, or null for none.
  final int? primaryIndex;

  /// Shows labels beside icons in a wider rail.
  final bool extended;

  /// Rail background. Defaults to white (light) / transparent (dark).
  final Color? backgroundColor;

  /// Brand color: primary action fill, selected icon/label, soft indicator.
  final Color? activeColor;

  /// Icon color on the filled primary action button.
  final Color? activeIconColor;

  /// Unselected icon and label color.
  final Color? inactiveColor;

  /// Pads for the leading system insets (status bar, landscape notch).
  final bool useSafeArea;

  /// Minimum compact rail width; labels wrap to two lines inside it.
  static const double railWidth = 96;

  /// The compact rail grows up to this so its longest single word fits on
  /// one line (words never break mid-word), then stops.
  static const double maxRailWidth = 128;

  /// The rail pads each destination by 8 dp on both sides.
  static const double _labelPadding = 16;

  /// Extended rail width.
  static const double extendedRailWidth = 220;

  @override
  Widget build(BuildContext context) {
    final hasDark = context.hasDarkMode;
    final active = activeColor ?? CcBaseColors.brand500;
    final inactive =
        inactiveColor ??
        (hasDark ? CcBaseColors.white50 : CcBaseColors.neutral50);
    // Icons follow the text scale (max 1.2x) so they stay inside the
    // Material indicator pill instead of growing with respDim (1.5x).
    final iconSize = 24 * CcScale.text(context.screenWidth);

    final destinationIndexes = [
      for (var i = 0; i < items.length; i++)
        if (i != primaryIndex) i,
    ];
    final selected = destinationIndexes.indexOf(currentIndex);
    final labelStyle = context.ccTextTheme.labelMedium;
    final labelWidth = _labelWidthFor(context, labelStyle);

    final rail = NavigationRail(
      selectedIndex: selected < 0 ? null : selected,
      onDestinationSelected: (i) => onTap(destinationIndexes[i]),
      extended: extended,
      // Extended: labels sit beside icons, so the icon column keeps the
      // minimum width.
      minWidth: extended ? railWidth : labelWidth + _labelPadding,
      minExtendedWidth: extendedRailWidth,
      labelType: extended
          ? NavigationRailLabelType.none
          : NavigationRailLabelType.all,
      groupAlignment: -1,
      backgroundColor:
          backgroundColor ??
          (hasDark ? CcBaseColors.transparent : CcBaseColors.white100),
      indicatorColor: active.withAlpha(36),
      selectedIconTheme: IconThemeData(color: active, size: iconSize),
      unselectedIconTheme: IconThemeData(color: inactive, size: iconSize),
      selectedLabelTextStyle: labelStyle?.copyWith(
        color: active,
        fontWeight: CcTypographyParams.bold,
      ),
      unselectedLabelTextStyle: labelStyle?.copyWith(
        color: inactive,
        fontWeight: CcTypographyParams.regular,
      ),
      leading: primaryIndex == null
          ? null
          : Padding(
              padding: EdgeInsets.only(
                top: context.respPadding(CcPaddingParams.SPACE_SM),
                bottom: context.respPadding(CcPaddingParams.SPACE_MD),
              ),
              child: _PrimaryAction(
                item: items[primaryIndex!],
                selected: currentIndex == primaryIndex,
                extended: extended,
                activeColor: active,
                activeIconColor: activeIconColor ?? CcBaseColors.white100,
                inactiveColor: inactive,
                iconSize: iconSize,
                labelWidth: labelWidth,
                onTap: () => onTap(primaryIndex!),
              ),
            ),
      destinations: [
        for (final i in destinationIndexes)
          NavigationRailDestination(
            icon: _withBadge(Icon(items[i].inactiveIcon), items[i]),
            selectedIcon: _withBadge(Icon(items[i].activeIcon), items[i]),
            label: _label(items[i].label, labelWidth),
          ),
      ],
    );

    return useSafeArea ? SafeArea(right: false, child: rail) : rail;
  }

  /// Width for compact-rail labels: wide enough for the longest single word
  /// of any label (measured in the bold, selected style with the user's text
  /// scale), so a long word such as "Notifications" is never split across lines; multi-word
  /// labels still wrap to two lines. Clamped to [railWidth]..[maxRailWidth].
  double _labelWidthFor(BuildContext context, TextStyle? style) {
    final painter = TextPainter(
      textDirection: Directionality.of(context),
      textScaler: MediaQuery.textScalerOf(context),
      maxLines: 1,
    );
    final boldStyle = style?.copyWith(fontWeight: CcTypographyParams.bold);
    var widest = 0.0;
    for (final item in items) {
      for (final word in item.label.split(RegExp(r'\s+'))) {
        if (word.isEmpty) continue;
        painter
          ..text = TextSpan(text: word, style: boldStyle)
          ..layout();
        if (painter.width > widest) widest = painter.width;
      }
    }
    painter.dispose();
    return (widest.ceilToDouble() + 2).clamp(
      railWidth - _labelPadding,
      maxRailWidth - _labelPadding,
    );
  }

  /// Compact rail: at most two centred lines within [labelWidth].
  /// Extended rail: one line.
  Widget _label(String text, double labelWidth) {
    if (extended) {
      return Text(text, maxLines: 1, overflow: TextOverflow.ellipsis);
    }
    return SizedBox(
      width: labelWidth,
      child: Text(
        text,
        maxLines: 2,
        textAlign: TextAlign.center,
        overflow: TextOverflow.ellipsis,
      ),
    );
  }

  static Widget _withBadge(Widget icon, CcCurvedNavigationItem item) {
    final badgeWidget = item.badgeWidget;
    if (badgeWidget != null) {
      return Stack(
        clipBehavior: Clip.none,
        children: [
          icon,
          Positioned(top: -2, right: -2, child: badgeWidget),
        ],
      );
    }
    final badgeText = item.badgeText;
    if (badgeText != null) {
      return Badge(
        label: Text(badgeText),
        backgroundColor: item.badgeColor,
        textColor: item.badgeTextColor,
        child: icon,
      );
    }
    return icon;
  }
}

/// The rail's primary action: a round button (compact) or a pill with label
/// (extended). Filled when its destination is open, tonal otherwise.
class _PrimaryAction extends StatelessWidget {
  const _PrimaryAction({
    required this.item,
    required this.selected,
    required this.extended,
    required this.activeColor,
    required this.activeIconColor,
    required this.inactiveColor,
    required this.iconSize,
    required this.labelWidth,
    required this.onTap,
  });

  final CcCurvedNavigationItem item;
  final bool selected;
  final bool extended;
  final Color activeColor;
  final Color activeIconColor;
  final Color inactiveColor;
  final double iconSize;
  final double labelWidth;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final fill = selected ? activeColor : activeColor.withAlpha(36);
    final foreground = selected ? activeIconColor : activeColor;
    final size = iconSize * 2;
    final icon = CcNavigationRail._withBadge(
      Icon(
        selected ? item.activeIcon : item.inactiveIcon,
        color: foreground,
        size: iconSize,
      ),
      item,
    );
    final labelStyle = context.ccTextTheme.labelMedium?.copyWith(
      color: selected ? activeColor : inactiveColor,
      fontWeight: selected
          ? CcTypographyParams.bold
          : CcTypographyParams.regular,
    );

    final button = Material(
      color: fill,
      shape: extended ? const StadiumBorder() : const CircleBorder(),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: SizedBox(
          height: size,
          width: extended ? CcNavigationRail.extendedRailWidth - 32 : size,
          child: extended
              ? Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    icon,
                    const CcSpaceSM(),
                    Flexible(
                      child: Text(
                        item.label,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: labelStyle?.copyWith(color: foreground),
                      ),
                    ),
                  ],
                )
              : Center(child: icon),
        ),
      ),
    );

    return Semantics(
      button: true,
      selected: selected,
      child: extended
          ? button
          : Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                button,
                const CcSpaceXS(),
                // The label is part of the tap target, like a destination.
                GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTap: onTap,
                  child: SizedBox(
                    width: labelWidth,
                    child: Text(
                      item.label,
                      maxLines: 2,
                      textAlign: TextAlign.center,
                      overflow: TextOverflow.ellipsis,
                      style: labelStyle,
                    ),
                  ),
                ),
              ],
            ),
    );
  }
}
