import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_udid/flutter_udid.dart';
import 'package:package_info_plus/package_info_plus.dart';

/// Utility class for device-specific operations.
///
/// Provides functionality for:
/// - Device identification (ID, device info)
/// - Screen dimensions and layout info
/// - Platform detection (iOS/Android)
/// - App version information
/// - Keyboard height detection
class DeviceUtils {
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
  ///
  /// Devices without home button include iPhone X, XS, XR, and later.
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
  ///
  /// [context] - The BuildContext from MaterialApp or widget tree
  static void init(BuildContext context) {
    isIOS = Theme.of(context).platform == TargetPlatform.iOS;
    isAndroid = Theme.of(context).platform == TargetPlatform.android;
    widthScreen = MediaQuery.of(context).size.width;
    heightScreen = MediaQuery.of(context).size.height;
    minScreen = widthScreen > heightScreen ? heightScreen : widthScreen;

    hasHomeBtnIOSDevice = true;

    // Detect iPhone models without home button
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
  ///
  /// Returns the height of the software keyboard in pixels.
  /// If keyboard is not visible, returns 0.
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
  ///
  /// Returns true if screen width is less than 390 logical pixels.
  static bool isSmallScreen(double screenWidth) => screenWidth < 390.0;

  /// Checks if the device has a large screen (typically iPhone Pro Max models).
  ///
  /// Returns true if screen width is >= 400 and has bottom padding > 20.
  ///
  /// [screenWidth] - The width of the screen in logical pixels
  /// [bottomPadding] - The bottom padding from MediaQuery
  static bool isLargeScreen({
    required double screenWidth,
    required double bottomPadding,
  }) => screenWidth >= 400.0 && bottomPadding > 20.0;

  // ==========================================================================
  // DEVICE IDENTIFICATION
  // ==========================================================================

  /// Gets the unique device identifier.
  ///
  /// On iOS: Returns identifierForVendor
  /// On Android: Returns Android ID via flutter_udid
  static Future<String> getDeviceId() async {
    var deviceInfo = DeviceInfoPlugin();

    if (Platform.isIOS || Platform.isMacOS) {
      var iosDeviceInfo = await deviceInfo.iosInfo;
      return iosDeviceInfo.identifierForVendor ?? '';
    } else {
      final String androidId = await getDeviceAndroidId();
      return androidId;
    }
  }

  /// Gets the Android device ID using flutter_udid plugin.
  static Future<String> getDeviceAndroidId() async {
    return await FlutterUdid.udid;
  }

  /// Gets comprehensive device information as a JSON string.
  ///
  /// Returns a formatted JSON string containing:
  /// - Device name
  /// - Device ID
  /// - OS name and version
  /// - App name and version
  ///
  /// The format is specific to the current platform's requirements.
  static Future<String> getDeviceInfo() async {
    var deviceInfo = DeviceInfoPlugin();

    var uri = '';
    var osName = '';

    var packageInfo = await PackageInfo.fromPlatform();

    if (Platform.isAndroid) {
      var androidInfo = await deviceInfo.androidInfo;
      final String androidId = await getDeviceAndroidId();

      osName = 'ANDROID';

      uri =
          '${'${'{\"DeviceName\":\"${androidInfo.device}\",\"DeviceID\":\"$androidId\",\"OsName\":\"$osName\",\"OsVersion\":\"${androidInfo.bootloader}\",\"AppName\":\"${packageInfo.appName}'}\",\"AppVersion\":\"${packageInfo.version}'}\",\"UserName\":\"\",\"LocationInfo\":\"\",\"Adv\":\"0\"}';
    } else if (Platform.isIOS) {
      var iosInfo = await deviceInfo.iosInfo;

      osName = 'iOS';

      uri =
          '${'${'{\"DeviceName\":\"${iosInfo.name}\",\"DeviceID\":\"${iosInfo.identifierForVendor!}\",\"OsName\":\"$osName\",\"OsVersion\":\"${iosInfo.systemVersion}\",\"AppName\":\"${packageInfo.appName}'}\",\"AppVersion\":\"${packageInfo.version}'}\",\"UserName\":\"\",\"LocationInfo\":\"\",\"Adv\":\"0\"}';
    } else {
      osName = 'other';
    }

    return uri;
  }

  /// Checks if the current device locale is Vietnamese.
  static bool isVietnameseLocale() => Platform.localeName.contains('VN');

  /// Gets the application version information.
  ///
  /// Returns a formatted string with version and build number for Android/iOS,
  /// or 'unknown' for other platforms.
  ///
  /// Example: "1.0.0(code: 1)"
  static Future<String> getAppVersion() async {
    final packageInfo = await PackageInfo.fromPlatform();

    if (Platform.isAndroid || Platform.isIOS) {
      return '${packageInfo.version}(code: ${packageInfo.buildNumber})';
    }

    return 'unknown';
  }

  /// Gets the device version for iOS devices.
  ///
  /// Checks if the iOS version is greater than iPhone 8 Plus.
  /// Returns false for Android, other platforms, or on error (simulator).
  static Future<bool> getDeviceVersion() async {
    final deviceInfo = DeviceInfoPlugin();
    try {
      if (Platform.isIOS) {
        final iosInfo = await deviceInfo.iosInfo;
        final version = double.parse(
          iosInfo.utsname.machine.split('iPhone')[1],
        );
        return version > 10.5;
      } else {
        return false;
      }
    } catch (err) {
      // Simulator or error
      return false;
    }
  }
}
