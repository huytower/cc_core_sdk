import 'package:app_config/config/app_config/http_manager.dart';
import 'package:app_config/enum/environment.dart' as cc_env;

import 'main.dart' as runner;

void main() async {
  CcAppConfig.environment = cc_env.Environment.PROD;

  runner.main();
}
