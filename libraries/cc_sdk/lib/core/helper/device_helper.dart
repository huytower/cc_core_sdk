import 'dart:io';

import 'package:flutter/material.dart';

/// Utility class for screen-layout and platform helpers.
///
/// Device-information queries (device ID, OS info, app version) have been
/// consolidated into [DeviceInfoHelper] which reuses the DI-registered
/// [DeviceInfoPlugin] singleton.
class DeviceHelper {
  // ==========================================================================
  // SCREEN & LAYOUT PROPERTIES
  // ==========================================================================

  /// Current screen width in logical pixels.
  static double widthScreen = 0;

  /// Current screen height in logical pixels.
  static double heightScreen = 0;

  /// Minimum dimension of the screen (width or height, whichever is smaller).
  static double minScreen = 0;

  /// Whether the current iOS device has a home button.
  static bool hasHomeBtnIOSDevice = true;

  /// Whether the current platform is iOS.
  static bool isIOS = false;

  /// Whether the current platform is Android.
  static bool isAndroid = false;

  /// iOS version (only applicable on iOS devices).
  static double iosVersion = 0;

  /// Device version tracking (legacy field).
  static int? versionNew = 1;

  // ==========================================================================
  // INITIALIZATION
  // ==========================================================================

  /// Initializes device properties from the given [BuildContext].
  ///
  /// Must be called once during app initialization to populate screen
  /// dimensions and platform information.
  static void init(BuildContext context) {
    isIOS = Theme.of(context).platform == TargetPlatform.iOS;
    isAndroid = Theme.of(context).platform == TargetPlatform.android;
    widthScreen = MediaQuery.of(context).size.width;
    heightScreen = MediaQuery.of(context).size.height;
    minScreen = widthScreen > heightScreen ? heightScreen : widthScreen;

    hasHomeBtnIOSDevice = true;

    bool isIphoneXs = widthScreen == 414.0 && heightScreen == 896.0;
    bool isIphoneXsMax = widthScreen == 1242 && heightScreen == 2688;
    bool isIphoneXr = widthScreen == 828 && heightScreen == 1792;

    if (isIphoneXs || isIphoneXsMax || isIphoneXr) {
      hasHomeBtnIOSDevice = false;
    }
  }

  // ==========================================================================
  // SCREEN LAYOUT HELPERS
  // ==========================================================================

  /// Gets the current keyboard height from [BuildContext].
  static double getHeightKeyBoard(BuildContext context) {
    double heightKeyboard = MediaQuery.of(context).viewInsets.bottom;

    if (heightKeyboard <= 0) {
      heightKeyboard = EdgeInsets.fromWindowPadding(
        WidgetsBinding.instance.window.viewInsets,
        WidgetsBinding.instance.window.devicePixelRatio,
      ).bottom;
    }

    return heightKeyboard;
  }

  /// Checks if the device has a small screen (iPhone 5/SE size).
  static bool isSmallScreen(double screenWidth) => screenWidth < 390.0;

  /// Checks if the device has a large screen (typically iPhone Pro Max models).
  static bool isLargeScreen({
    required double screenWidth,
    required double bottomPadding,
  }) => screenWidth >= 400.0 && bottomPadding > 20.0;

  /// Checks if the current device locale is Vietnamese.
  static bool isVietnameseLocale() => Platform.localeName.contains('VN');
}
