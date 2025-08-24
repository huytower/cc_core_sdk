import 'package:flutter_dotenv/flutter_dotenv.dart';

import '../../feature_flags.dart';
import 'base.dart';

/// UAT env configuration
class HttpUat extends HttpBase {
  bool _isLogger = true;
  bool _isEnableLoggerDio = FeatureFlags.isEnableLogger;

  @override
  bool get isLogger => _isLogger;

  set isLogger(bool value) => _isLogger = value;

  @override
  bool get isEnableLoggerDio => _isEnableLoggerDio;

  set isEnableLoggerDio(bool value) => _isEnableLoggerDio = value;

  @override
  String get baseUrl => dotenv.get('API_URL', fallback: 'https://api.uat.yourdomain.com');

  @override
  int get apiTimeoutSeconds => 60; // Longer timeout for UAT

  @override
  int get maxRetries => 3; // More retries for UAT

  @override
  int get retryDelayMs => 2000; // Longer delay between retries for UAT

  @override
  bool get isEnvDev => false;

  @override
  bool get isEnvPro => false;

  // UAT-specific configurations
  static const String environmentName = 'UAT';

  // UAT-specific feature flags
  static const bool enableExperimentalFeatures = true;

  @override
  Map<String, String> get apiHeaders => {
        ...super.apiHeaders,
        'X-Environment': 'UAT',
        'X-Debug-Mode': 'true',
      };
}
