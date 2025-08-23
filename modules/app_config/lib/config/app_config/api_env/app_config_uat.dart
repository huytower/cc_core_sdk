import 'package:app_config/config/app_config/api_env/app_config_base.dart';
import 'package:app_config/config/app_config/cc_app_config.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

/// UAT environment configuration
class AppConfigUat extends AppConfigBase {
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
