import 'package:flutter/widgets.dart';

/// Material 3 window height classes, measured in dp.
///
/// Use this for decisions that depend on vertical room — e.g. collapsing a
/// tall header on a phone in landscape or a 16:10 tablet — rather than taking
/// a fixed percentage of the screen height.
///
/// | Class     | Height     | Typical case                          |
/// |-----------|------------|---------------------------------------|
/// | compact   | < 480      | phone landscape                       |
/// | medium    | 480 – 899  | tablet landscape, phone portrait      |
/// | expanded  | ≥ 900      | tablet portrait                       |
enum CcWindowHeightClass {
  compact(0),
  medium(480),
  expanded(900);

  const CcWindowHeightClass(this.minHeight);

  /// Inclusive lower bound of this class, in dp.
  final double minHeight;

  /// Classifies a height in dp. An unbounded height maps to [expanded].
  static CcWindowHeightClass fromHeight(double height) {
    for (final heightClass in values.reversed) {
      if (height >= heightClass.minHeight) return heightClass;
    }
    return compact;
  }

  /// Classifies the current window height. Only rebuilds on size changes.
  static CcWindowHeightClass of(BuildContext context) =>
      fromHeight(MediaQuery.sizeOf(context).height);

  /// Whether this class is [other] or taller.
  bool hasAtLeast(CcWindowHeightClass other) => index >= other.index;
}

