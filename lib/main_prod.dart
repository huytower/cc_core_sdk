import 'package:app_config/core/config/http/http_client/http_client_config.dart';
import 'package:app_config/core/enum/environment.dart' as cc_env;

import 'main.dart' as runner;

void main() async {
  HttpClientConfig.environment = cc_env.Environment.PROD;

  runner.main();
}
