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
  // ORIENTATION CONTROL HELPERS
  // ==========================================================================

  /// Set orientation to landscape only.
  static Future<void> setLandscape() async {
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
    try {
      await SystemChrome.setPreferredOrientations(DeviceOrientation.values);
    } catch (e) {
      'Error setting default orientation: $e'.Log();
    }
  }

  /// Set orientation to portrait only.
  static Future<void> setPortrait() async {
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
