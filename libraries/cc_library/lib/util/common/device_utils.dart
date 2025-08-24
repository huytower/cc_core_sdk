import 'dart:io';

import 'package:package_info_plus/package_info_plus.dart';

/// A utility class for device-specific operations.
class DeviceUtils {
  /// Checks if the current device locale is Vietnamese.
  static bool isVietnameseLocale() => Platform.localeName.contains('VN');

  /// Checks if the device has a screen width smaller than 390 logical pixels.
  /// Typically used to identify small devices like iPhone 5/SE.
  static bool isSmallScreen(double screenWidth) => screenWidth < 390.0;

  /// Checks if the device has a larger screen, typically iPhone Pro Max models.
  ///
  /// [screenWidth] - The width of the screen in logical pixels
  /// [bottomPadding] - The bottom padding from MediaQuery
  static bool isLargeScreen({required double screenWidth, required double bottomPadding}) =>
      screenWidth >= 400.0 && bottomPadding > 20.0;

  /// Gets the application version information.
  ///
  /// Returns a formatted string with version and build number for Android/iOS,
  /// or 'unknown' for other platforms.
  static Future<String> getAppVersion() async {
    final packageInfo = await PackageInfo.fromPlatform();

    if (Platform.isAndroid || Platform.isIOS) {
      return '${packageInfo.version}(code: ${packageInfo.buildNumber})';
    }

    return 'unknown';
  }
}
