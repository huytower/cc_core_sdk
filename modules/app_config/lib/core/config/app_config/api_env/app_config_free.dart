import 'package:flutter_dotenv/flutter_dotenv.dart';

import '../cc_app_config.dart';
import 'app_config_base.dart';

/// Free tier environment configuration with mock APIs
class AppConfigFree extends AppConfigBase {
  bool _isLogger = true;
  bool _isEnableLoggerDio = CcAppConfigFlags.isEnableLogger;

  @override
  bool get isLogger => _isLogger;

  @override
  set isLogger(bool value) => _isLogger = value;

  @override
  bool get isEnableLoggerDio => _isEnableLoggerDio;

  @override
  set isEnableLoggerDio(bool value) => _isEnableLoggerDio = value;

  @override
  String get baseUrl => dotenv.get('API_URL', fallback: 'https://jsonplaceholder.typicode.com');

  @override
  int get maxRetries => 1; // Fewer retries for free tier

  @override
  int get retryDelayMs => 500; // Shorter delay for free tier

  @override
  bool get isEnvDev => true;

  @override
  bool get isEnvPro => false;

  // Free tier specific configurations
  static const String environmentName = 'FREE_FAKE_API';

  @override
  Map<String, String> get apiHeaders => {
        ...super.apiHeaders,
        'X-Environment': 'FREE',
        'X-Mock-Data': 'true',
      };
}
