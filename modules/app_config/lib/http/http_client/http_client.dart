import 'dart:developer' as developer;

import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import '../../enum/environment.dart';
import '../env/base.dart';
import '../env/free.dart';
import '../env/prod.dart';
import '../env/uat.dart';

final isFreeEnv = HttpClient.environment == Environment.FREE_FAKE_API;
final isUatEnv = HttpClient.environment == Environment.UAT;

/// Application Configs., save all static vars for application
/// ex. boolean var., update status var., .v.v.
class HttpClient {
  /// App configuration instance based on current env
  static HttpBase get instance {
    switch (environment) {
      case Environment.FREE_FAKE_API:
        return HttpFree();
      case Environment.UAT:
        return HttpUat();
      case Environment.PROD:
        return const HttpProd();
    }
  }

  /// Current env, defaults to FREE_FAKE_API
  /// Can be set via `--dart-define=ENV=uat` or `--dart-define=ENV=prod`
  static Environment environment = _getEnvironmentFromArgs();

  /// Retrieves the env from command line arguments or defaults to FREE_FAKE_API.
  ///
  /// Supports the following env values (case-insensitive):
  /// - 'free' or 'free_fake_api' for FREE_FAKE_API
  /// - 'uat' for UAT
  /// - 'prod' or 'production' for PROD
  ///
  /// Throws [StateError] if the env string is invalid and [kReleaseMode] is true.
  static Environment _getEnvironmentFromArgs() {
    try {
      final env = const String.fromEnvironment('ENV', defaultValue: 'free').toLowerCase();

      // Map common aliases to env values
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
        'Failed to determine env. Defaulting to FREE_FAKE_API',
        error: e,
        stackTrace: stackTrace,
      );

      if (kReleaseMode) {
        throw StateError(
          'Invalid env configuration. Please set a valid env (free, uat, prod)',
        );
      }

      return Environment.FREE_FAKE_API;
    }
  }
}

class CcAppHostUrlName {
  /// API base URL for networking services
  /// Can be overridden via `API_URL` in .env file
  static String get baseUrl {
    try {
      return dotenv.env['API_URL'] ?? String.fromEnvironment('API_URL', defaultValue: HttpFree().baseUrl);
    } catch (_) {
      return HttpFree().baseUrl;
    }
  }
}

/// Manages feature flags for the application.
///
/// Feature flags can be controlled via env variables or have default values
/// based on the current env.
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
  /// [key]: The env variable key to look up
  /// [defaultValue]: The default value to return if the key is not found or invalid
  ///
  /// Returns `true` if the env variable is 'true' (case-insensitive),
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
  /// Config logger : when building an env PROD, all values are set to false.
  static const int APP_TRACKING_LOG_LENGTH = 100;
}
