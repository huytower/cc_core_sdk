import 'package:flutter/widgets.dart';

/// Material 3 window size classes (width), measured in logical pixels (dp).
///
/// This is the axis an adaptive layout branches on: decide navigation
/// (bottom bar / rail / drawer), pane count (single / list–detail) and grid
/// columns from the **space available**, not from the device type or
/// orientation.
///
/// | Class        | Width          | Typical device                              |
/// |--------------|----------------|---------------------------------------------|
/// | compact      | < 600          | phone portrait, foldable cover screen       |
/// | medium       | 600 – 839      | tablet portrait up to 11" (600–834 dp),     |
/// |              |                | unfolded foldable                           |
/// | expanded     | 840 – 1199     | 7–11" tablet landscape, 13" tablet portrait,|
/// |              |                | phone landscape, small web window           |
/// | large        | 1200 – 1599    | 10–13" tablet landscape, desktop / web      |
/// | extraLarge   | ≥ 1600         | wide desktop / web                          |
///
/// So a 10–11" tablet held upright (800–834 dp) is still **medium**; only a
/// 12.9–13" one is expanded in portrait. See `CcReferenceWindows` for the
/// sizes behind this table.
///
/// Prefer [fromConstraints] inside a [LayoutBuilder] (e.g. via
/// `CcAdaptiveBuilder`) so a pane reacts to its own width; use [of] only when
/// the whole window is what matters (e.g. the navigation shell).
enum CcWindowSizeClass {
  compact(0),
  medium(600),
  expanded(840),
  large(1200),
  extraLarge(1600);

  const CcWindowSizeClass(this.minWidth);

  /// Inclusive lower bound of this class, in dp.
  final double minWidth;

  /// Classifies a width in dp. An unbounded width maps to [extraLarge].
  static CcWindowSizeClass fromWidth(double width) {
    for (final windowClass in values.reversed) {
      if (width >= windowClass.minWidth) return windowClass;
    }
    return compact;
  }

  /// Classifies the current window width. Only rebuilds on size changes.
  static CcWindowSizeClass of(BuildContext context) =>
      fromWidth(MediaQuery.sizeOf(context).width);

  /// Classifies the width a parent offers, e.g. from a [LayoutBuilder].
  static CcWindowSizeClass fromConstraints(BoxConstraints constraints) =>
      fromWidth(constraints.maxWidth);

  /// Whether this class is [other] or wider.
  bool hasAtLeast(CcWindowSizeClass other) => index >= other.index;

  /// Whether this class is narrower than [other].
  bool hasBelow(CcWindowSizeClass other) => index < other.index;

  /// Picks a value for this class. Classes without a value fall back to the
  /// nearest narrower one that has a value, ending at [compact].
  T select<T>({
    required T compact,
    T? medium,
    T? expanded,
    T? large,
    T? extraLarge,
  }) {
    final byClass = [compact, medium, expanded, large, extraLarge];
    for (var i = index; i >= 0; i--) {
      final value = byClass[i];
      if (value != null) return value;
    }
    return compact;
  }
}
