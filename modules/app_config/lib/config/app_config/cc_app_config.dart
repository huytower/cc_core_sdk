import 'dart:developer' as developer;

import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import '../../enum/environment.dart';
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

  /// Retrieves the environment from command line arguments or defaults to FREE_FAKE_API.
  ///
  /// Supports the following environment values (case-insensitive):
  /// - 'free' or 'free_fake_api' for FREE_FAKE_API
  /// - 'uat' for UAT
  /// - 'prod' or 'production' for PROD
  ///
  /// Throws [StateError] if the environment string is invalid and [kReleaseMode] is true.
  static Environment _getEnvironmentFromArgs() {
    try {
      final env = const String.fromEnvironment('ENV', defaultValue: 'free').toLowerCase();

      // Map common aliases to environment values
      final envMap = {
        'free': Environment.FREE_FAKE_API,
        'free_fake_api': Environment.FREE_FAKE_API,
        'uat': Environment.UAT,
        'prod': Environment.PROD,
        'production': Environment.PROD,
      };

      final environment = envMap[env] ?? Environment.FREE_FAKE_API;

      if (kDebugMode) {
        developer.log('Environment set to: ${environment.name}');
      }

      return environment;
    } catch (e, stackTrace) {
      developer.log(
        'Failed to determine environment. Defaulting to FREE_FAKE_API',
        error: e,
        stackTrace: stackTrace,
      );

      if (kReleaseMode) {
        throw StateError(
          'Invalid environment configuration. Please set a valid environment (free, uat, prod)',
        );
      }

      return Environment.FREE_FAKE_API;
    }
  }
}

/// Handles application naming configuration with environment variable fallbacks.
///
/// The app name can be configured via:
/// 1. `APP_NAME` in .env file
/// 2. `--dart-define=APP_NAME=MyApp` in build arguments
/// 3. Defaults to 'MyApp' if not specified
class CcAppName {
  static const String _defaultAppName = 'MyApp';

  /// Gets the application name with fallback mechanisms.
  ///
  /// Priority:
  /// 1. `APP_NAME` from .env file
  /// 2. `--dart-define=APP_NAME` from build arguments
  /// 3. Default value ('MyApp')
  ///
  /// Returns [String] The configured application name
  static String get appName {
    try {
      return dotenv.maybeGet(
            'APP_NAME',
            fallback: const String.fromEnvironment('APP_NAME', defaultValue: _defaultAppName),
          ) ??
          _defaultAppName;
    } catch (e, stackTrace) {
      developer.log(
        'Failed to load app name from environment',
        error: e,
        stackTrace: stackTrace,
      );
      return _defaultAppName;
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

/// Manages feature flags for the application.
///
/// Feature flags can be controlled via environment variables or have default values
/// based on the current environment.
///
/// Example usage:
/// ```dart
/// if (CcAppConfigFlags.isEnableLogger) {
///   // Enable logging
/// }
/// ```
class CcAppConfigFlags {
  /// Whether general application logging is enabled.
  ///
  /// Defaults to `true` in non-production environments (UAT/FREE_FAKE_API).
  /// Can be overridden with `ENABLE_LOGGER=true` in .env file.
  static bool get isEnableLogger => _getBool('ENABLE_LOGGER', isUatEnv || isFreeEnv);

  /// Whether Dio HTTP client logging is enabled.
  ///
  /// Defaults to `true` in non-production environments (UAT/FREE_FAKE_API).
  /// Can be overridden with `ENABLE_LOGGER_DIO=true` in .env file.
  static bool get isEnableLoggerDio => _getBool('ENABLE_LOGGER_DIO', isUatEnv || isFreeEnv);

  /// Retrieves a boolean configuration value with a default fallback.
  ///
  /// [key]: The environment variable key to look up
  /// [defaultValue]: The default value to return if the key is not found or invalid
  ///
  /// Returns `true` if the environment variable is 'true' (case-insensitive),
  /// otherwise returns [defaultValue].
  static bool _getBool(String key, bool defaultValue) {
    try {
      final value = dotenv.maybeGet(key);
      if (value != null) {
        return value.toLowerCase() == 'true';
      }
      return defaultValue;
    } catch (e, stackTrace) {
      developer.log(
        'Failed to parse boolean flag: $key',
        error: e,
        stackTrace: stackTrace,
      );
      return defaultValue;
    }
  }
}

class CcAppConfigLimits {
  /// Config logger : when building an environment PROD, all values are set to false.
  static const int APP_TRACKING_LOG_LENGTH = 100;
}
