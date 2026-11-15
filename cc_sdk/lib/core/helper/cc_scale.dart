/// The single width → scale-factor curve behind every responsive size
/// (`respDim`, `respIconSize`, `respPadding`, `respFontSize`, `ccTextTheme`).
///
/// Shape: phones keep their original `width / 360` scaling up to
/// [phoneMaxWidth]; from there the factor rises **linearly** to its maximum at
/// [expandedWidth] (840 dp) and stays flat beyond — wider windows get more
/// layout (rail, panes, columns), not bigger UI. No steps, no early caps, so a
/// 7" tablet is no longer scaled like a 10" one.
///
/// | width (dp)          | 360 | 430  | 600  | 673  | 800  | ≥ 840 |
/// |---------------------|-----|------|------|------|------|-------|
/// | [dimension]         | 1.0 | 1.19 | 1.32 | 1.38 | 1.47 | 1.5   |
/// | [padding]           | 1.0 | 1.19 | 1.53 | 1.67 | 1.92 | 2.0   |
/// | [text]              | 1.0 | 1.0  | 1.07 | 1.11 | 1.18 | 1.2   |
abstract final class CcScale {
  /// Design width every base size is expressed in.
  static const double baseWidth = 360;

  /// Up to here the original phone scaling (`width / 360`) is kept unchanged.
  static const double phoneMaxWidth = 432;

  /// The factor stops growing here (Material 3 "expanded" width class).
  static const double expandedWidth = 840;

  /// Below this, text is not scaled at all (phones).
  static const double textStartWidth = 480;

  /// Maximum factor for sizes: icons, shapes, component heights, `CcText`.
  static const double maxDimension = 1.5;

  /// Maximum factor for padding and gaps.
  static const double maxPadding = 2.0;

  /// Maximum factor for `ccTextTheme` font sizes.
  static const double maxText = 1.2;

  /// Factor for sizes (`respDim`, `respIconSize`, `respFontSize`).
  static double dimension(double width) => _curve(width, maxDimension);

  /// Factor for padding and gaps (`respPadding`, `CcSpace*`).
  static double padding(double width) => _curve(width, maxPadding);

  /// Factor for theme font sizes (`ccTextTheme`): 1.0 on phones, rising
  /// linearly from [textStartWidth] to [maxText] at [expandedWidth].
  static double text(double width) {
    if (width <= textStartWidth) return 1.0;
    if (width >= expandedWidth) return maxText;
    final t = (width - textStartWidth) / (expandedWidth - textStartWidth);
    return 1.0 + (maxText - 1.0) * t;
  }

  static double _curve(double width, double max) {
    final phone = (width / baseWidth).clamp(1.0, max);
    if (width <= phoneMaxWidth) return phone;
    if (width >= expandedWidth) return max;

    final phoneEnd = (phoneMaxWidth / baseWidth).clamp(1.0, max);
    final t = (width - phoneMaxWidth) / (expandedWidth - phoneMaxWidth);
    return phoneEnd + (max - phoneEnd) * t;
  }
}
