import 'package:app_config/enum/environment.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import 'api_env/app_config_base.dart';
import 'api_env/app_config_free.dart';
import 'api_env/app_config_prod.dart';
import 'api_env/app_config_uat.dart';

final isFreeEnv = CcAppConfig.environment == Environment.FREE_FAKE_API;
final isUatEnv = CcAppConfig.environment == Environment.UAT;

/// Application Configs., save all static vars for application
/// ex. boolean var., update status var., .v.v.
class CcAppConfig {
  /// App configuration instance based on current environment
  static AppConfigBase get instance {
    switch (environment) {
      case Environment.FREE_FAKE_API:
        return AppConfigFree();
      case Environment.UAT:
        return AppConfigUat();
      case Environment.PROD:
        return AppConfigProd();
    }
  }

  /// Current environment, defaults to FREE_FAKE_API
  /// Can be set via `--dart-define=ENV=uat` or `--dart-define=ENV=prod`
  static Environment _environment = _getEnvironmentFromArgs();
  
  static Environment get environment => _environment;
  
  static set environment(Environment env) {
    _environment = env;
  }
  
  static Environment _getEnvironmentFromArgs() {
    try {
      const env = String.fromEnvironment('ENV', defaultValue: 'free');
      return Environment.values.firstWhere(
        (e) => e.name.toLowerCase() == env.toLowerCase(),
        orElse: () => Environment.FREE_FAKE_API,
      );
    } catch (_) {
      return Environment.FREE_FAKE_API;
    }
  }
}

class CcAppName {
  /// App name, can be overridden via `APP_NAME` in .env file
  static String get appName {
    try {
      return dotenv.env['APP_NAME'] ?? const String.fromEnvironment('APP_NAME', defaultValue: 'MyApp');
    } catch (_) {
      return 'MyApp';
    }
  }
}

class CcAppHostUrlName {
  /// API base URL for networking services
  /// Can be overridden via `API_URL` in .env file
  static String get baseUrl {
    try {
      return dotenv.env['API_URL'] ?? String.fromEnvironment('API_URL', defaultValue: AppConfigFree().baseUrl);
    } catch (_) {
      return AppConfigFree().baseUrl;
    }
  }
}

/// Feature flags for the application
class CcAppConfigFlags {
  static bool get isEnableLogger => _getBool('ENABLE_LOGGER', isUatEnv || isFreeEnv);
  static bool get isEnableLoggerDio => _getBool('ENABLE_LOGGER_DIO', isUatEnv || isFreeEnv);

  static bool _getBool(String key, bool defaultValue) {
    try {
      return dotenv.env[key]?.toLowerCase() == 'true' || defaultValue;
    } catch (_) {
      return defaultValue;
    }
  }
}

class CcAppConfigLimits {
  /// Config logger : when building an environment PROD, all values are set to false.
  static const int APP_TRACKING_LOG_LENGTH = 100;
}
