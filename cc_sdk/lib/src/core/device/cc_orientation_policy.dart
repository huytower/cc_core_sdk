import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

import '../extensions/common/cc_logger_extension.dart';

/// Which orientations the app allows, decided from the window size: phones
/// stay in portrait, larger screens (tablets, unfolded foldables, desktop and
/// web windows) rotate freely.
///
/// Screen size and classification live in `MediaQuery` and
/// `CcWindowSizeClass` (`cc_sdk_ui`); device information (OS, app version)
/// lives in [CcDeviceInfoService].
///
/// ```dart
/// CcOrientationPolicy.apply(MediaQuery.sizeOf(context));
/// ```
abstract final class CcOrientationPolicy {
  /// Screens whose shortest side is below this (dp) are treated as phones —
  /// including foldable cover screens. Same bound as the Material 3 medium
  /// window class (`CcWindowSizeClass.medium.minWidth` in `cc_sdk_ui`).
  static const double phoneShortestSideLimit = 600;

  /// Phones: portrait only (the phone-first layouts are designed for it).
  static const List<DeviceOrientation> phoneOrientations = [
    DeviceOrientation.portraitUp,
  ];

  /// Tablets, unfolded foldables, desktop/web windows: rotate freely.
  static const List<DeviceOrientation> largeScreenOrientations =
      DeviceOrientation.values;

  static List<DeviceOrientation>? _appliedOrientations;

  /// The orientations [apply] picks for a screen of [logicalSize] (dp).
  static List<DeviceOrientation> orientationsFor(Size logicalSize) =>
      logicalSize.shortestSide < phoneShortestSideLimit
      ? phoneOrientations
      : largeScreenOrientations;

  /// Locks phones to portrait and lets larger screens rotate.
  ///
  /// Call it at boot and whenever the window size changes (e.g. a foldable
  /// opening or closing); it only talks to the platform when the result
  /// changes. An empty size (window not laid out yet) is ignored.
  static Future<void> apply(Size logicalSize) async {
    if (logicalSize.isEmpty) return;
    final orientations = orientationsFor(logicalSize);
    if (identical(orientations, _appliedOrientations)) return;
    _appliedOrientations = orientations;
    try {
      await SystemChrome.setPreferredOrientations(orientations);
    } catch (e) {
      'Error applying orientation policy: $e'.Log();
    }
  }

  /// Forgets the last applied orientations so the next [apply] call talks to
  /// the platform again.
  @visibleForTesting
  static void reset() => _appliedOrientations = null;
}
