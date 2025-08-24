import 'dart:developer' as developer;
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import 'app_config_base.dart';

/// Production environment configuration.
///
/// This configuration is used when the app is built for production deployment.
/// It enables production-specific settings and optimizations.
///
/// To use this configuration, set the environment to `prod`:
/// ```
/// flutter run --dart-define=ENV=prod
/// ```
///
/// Or for release builds:
/// ```
/// flutter build apk --dart-define=ENV=prod
/// ```
class AppConfigProd extends AppConfigBase {
  /// Creates a new production configuration instance.
  AppConfigProd() {
    if (kDebugMode) {
      developer.log('Initializing production configuration', name: 'AppConfigProd');
    }
  }

  @override
  bool get isLogger => false; // Disable logging in production by default

  @override
  String get baseUrl =>
      dotenv.maybeGet(
        'API_URL',
        fallback: 'https://api.production.com',
      ) ??
      "";

  @override
  bool get isEnableLoggerDio => false;

  @override
  bool get isEnvDev => false;

  @override
  bool get isEnvPro => true;

  @override
  int get versionIOS => int.tryParse(dotenv.maybeGet('IOS_VERSION', fallback: '1') ?? '1') ?? 1;

  @override
  int get versionAndroid => int.tryParse(dotenv.maybeGet('ANDROID_VERSION_CODE', fallback: '1') ?? '1') ?? 1;

  @override
  int get versionApi => int.tryParse(dotenv.maybeGet('API_VERSION', fallback: '1') ?? '1') ?? 1;

  // Production-specific configurations

  /// Display name for the production environment
  static const String environmentName = 'PRODUCTION';

  /// Whether analytics collection is enabled
  ///
  /// Can be overridden with `ENABLE_ANALYTICS=false` in .env
  bool get enableAnalytics => dotenv.maybeGet('ENABLE_ANALYTICS', fallback: 'true')?.toLowerCase() == 'true';

  /// Whether crash reporting is enabled
  ///
  /// Can be overridden with `ENABLE_CRASH_REPORTING=false` in .env
  bool get enableCrashReporting => dotenv.maybeGet('ENABLE_CRASH_REPORTING', fallback: 'true')?.toLowerCase() == 'true';

  // Security settings

  /// Whether certificate pinning is enabled for network requests
  ///
  /// Can be overridden with `ENABLE_CERT_PINNING=false` in .env
  bool get enableCertificatePinning =>
      dotenv.maybeGet('ENABLE_CERT_PINNING', fallback: 'true')?.toLowerCase() == 'true';

  @override
  Map<String, String> get apiHeaders => {
        ...super.apiHeaders,
        'X-Environment': environmentName,
        'X-App-Platform': Platform.operatingSystem,
        'X-App-Version': '${Platform.operatingSystem}-${Platform.version}',
      };

  @override
  void validate() {
    super.validate();

    if (kReleaseMode) {
      // Additional production-specific validations
      if (baseUrl.startsWith('http://') && !baseUrl.contains('localhost')) {
        throw StateError(
          'Insecure HTTP protocol detected in production environment. Use HTTPS.',
        );
      }
    }
  }

  @override
  String toString() => 'AppConfigProd('
      'baseUrl: $baseUrl, '
      'version: $versionApi, '
      'enableAnalytics: $enableAnalytics, '
      'enableCrashReporting: $enableCrashReporting'
      ')';
}
