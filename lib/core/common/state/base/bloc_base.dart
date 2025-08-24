import 'package:app_config/config/app_config/http_manager.dart';

import '../../../di/inject/inject.dart';

class BlocBase {
  var ccNativeApp = getIt<CcAppConfig>();

  //String? accessToken;
  BlocBase() {
    //accessToken = ccNativeApp.accessToken;
  }

  void dispose() {}
}
