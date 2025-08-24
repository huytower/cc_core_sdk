import 'package:flutter_dotenv/flutter_dotenv.dart';

import 'app_config_base.dart';

class AppConfigProd extends AppConfigBase {
  @override
  bool get isLogger => false; // Disable logging in production by default

  @override
  String get baseUrl => dotenv.get('API_URL', fallback: 'https://api.production.com');

  @override
  bool get isEnableLoggerDio => false;

  @override
  bool get isEnvDev => false;

  @override
  bool get isEnvPro => true;

  // Production-specific configurations
  static const String environmentName = 'PRODUCTION';

  // Production feature flags
  static const bool enableAnalytics = true;
  static const bool enableCrashReporting = true;

  // Security settings
  static const bool enableCertificatePinning = true;
}
