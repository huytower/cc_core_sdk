import 'package:app_config/config/app/cc_app_config.dart';

import '../../../di/inject/inject.dart';

class BlocBase {
  var ccNativeApp = getIt<CcAppConfig>();

  //String? accessToken;
  BlocBase() {
    //accessToken = ccNativeApp.accessToken;
  }

  void dispose() {}
}
