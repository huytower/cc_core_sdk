import 'package:flutter/material.dart';

class SettingDevice {
  static int? versionNew = 1;

  static bool isIOS = false;
  static bool isAndroid = false;

  static double iosVersion = 0;

  static double widthScreen = 0;
  static double heightScreen = 0;
  static double minScreen = 0;

  static bool hasHomeBtnIOSDevice = true;

  SettingDevice.init(BuildContext context) {
    isIOS = Theme.of(context).platform == TargetPlatform.iOS;
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

  static double getHeightKeyBoard(BuildContext context) {
    double heightKeyboard = MediaQuery.of(context).viewInsets.bottom;

    if (heightKeyboard <= 0) {
      heightKeyboard = EdgeInsets.fromWindowPadding(
              WidgetsBinding.instance.window.viewInsets,
              WidgetsBinding.instance.window.devicePixelRatio)
          .bottom;
    }

    return heightKeyboard;
  }
}
