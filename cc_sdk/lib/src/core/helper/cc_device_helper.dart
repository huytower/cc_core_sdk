import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:injectable/injectable.dart';

import '../extensions/common/cc_logger_extension.dart';
import 'cc_window_size_class.dart';

/// Utility class for screen-layout and platform helpers.
///
/// Screen size and classification live in `MediaQuery` and
/// [CcWindowSizeClass]; read them from the current [BuildContext] rather than
/// caching them in statics. Device-information queries (device ID, OS info,
/// app version) live in [CcDeviceInfoHelper].
@injectable
class CcDeviceHelper {
  // ==========================================================================
  // SCREEN LAYOUT HELPERS
  // ==========================================================================

  /// Gets the current keyboard height from [BuildContext].
  static double getHeightKeyBoard(BuildContext context) {
    double heightKeyboard = MediaQuery.viewInsetsOf(context).bottom;

    if (heightKeyboard <= 0) {
      final view = View.of(context);
      heightKeyboard = EdgeInsets.fromViewPadding(
        view.viewInsets,
        view.devicePixelRatio,
      ).bottom;
    }

    return heightKeyboard;
  }

  /// Checks if the device has a large screen (typically iPhone Pro Max models).
  static bool isLargeScreen({
    required double screenWidth,
    required double bottomPadding,
  }) => screenWidth >= 400.0 && bottomPadding > 20.0;

  /// Checks if the current device locale is Vietnamese.
  static bool isVietnameseLocale() => Platform.localeName.contains('VN');

  // ==========================================================================
  // ORIENTATION POLICY
  // ==========================================================================

  /// Screens whose shortest side is below this (dp) are treated as phones —
  /// including foldable cover screens. Same bound as the medium window class.
  static final double phoneShortestSideLimit =
      CcWindowSizeClass.medium.minWidth;

  /// Phones: portrait only (the phone-first layouts are designed for it).
  static const List<DeviceOrientation> phoneOrientations = [
    DeviceOrientation.portraitUp,
  ];

  /// Tablets, unfolded foldables, desktop/web windows: rotate freely.
  static const List<DeviceOrientation> largeScreenOrientations =
      DeviceOrientation.values;

  static List<DeviceOrientation>? _appliedOrientations;

  /// The orientations [applyOrientationPolicy] picks for a screen of
  /// [logicalSize] (dp).
  static List<DeviceOrientation> orientationsFor(Size logicalSize) =>
      logicalSize.shortestSide < phoneShortestSideLimit
      ? phoneOrientations
      : largeScreenOrientations;

  /// Locks phones to portrait and lets larger screens rotate.
  ///
  /// Call it at boot and whenever the window size changes (e.g. a foldable
  /// opening or closing); it only talks to the platform when the result
  /// changes. An empty size (window not laid out yet) is ignored.
  static Future<void> applyOrientationPolicy(Size logicalSize) async {
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

  /// Forgets the last applied policy so the next [applyOrientationPolicy]
  /// call talks to the platform again.
  @visibleForTesting
  static void resetOrientationPolicy() => _appliedOrientations = null;

  // ==========================================================================
  // ORIENTATION CONTROL HELPERS
  // ==========================================================================
  // These override the policy above until the next applyOrientationPolicy
  // call (i.e. the next window size change while the policy scope is active).

  /// Set orientation to landscape only.
  static Future<void> setLandscape() async {
    _appliedOrientations = null;
    try {
      await SystemChrome.setPreferredOrientations([
        DeviceOrientation.landscapeLeft,
        DeviceOrientation.landscapeRight,
      ]);
    } catch (e) {
      'Error setting landscape orientation $e'.Log();
    }
  }

  /// Set orientation to allow both portrait and landscape.
  static Future<void> setOrientationDefault() async {
    _appliedOrientations = null;
    try {
      await SystemChrome.setPreferredOrientations(DeviceOrientation.values);
    } catch (e) {
      'Error setting default orientation: $e'.Log();
    }
  }

  /// Set orientation to portrait only.
  static Future<void> setPortrait() async {
    _appliedOrientations = null;
    try {
      await SystemChrome.setPreferredOrientations([
        DeviceOrientation.portraitUp,
        DeviceOrientation.portraitDown,
      ]);
    } catch (e) {
      'Error setting portrait orientation: $e'.Log();
    }
  }
}
