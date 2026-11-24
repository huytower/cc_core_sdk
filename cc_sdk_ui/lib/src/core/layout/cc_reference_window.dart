import 'package:flutter/widgets.dart';

/// A named logical window size (dp) to check an adaptive layout against,
/// usually in widget tests. See [CcReferenceWindows] for the shared set.
///
/// ```dart
/// for (final window in CcReferenceWindows.all) {
///   testWidgets('no overflow on $window', (tester) async { ... });
/// }
/// ```
class CcReferenceWindow {
  const CcReferenceWindow(this.name, this.size);

  final String name;
  final Size size;

  /// The same window rotated 90°.
  CcReferenceWindow get landscape =>
      CcReferenceWindow('$name landscape', Size(size.height, size.width));

  @override
  String toString() => '$name (${size.width.toInt()}x${size.height.toInt()})';
}
