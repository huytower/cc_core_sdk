import 'dart:developer' as developer;

import 'package:flutter_dotenv/flutter_dotenv.dart';

/// Handles application naming configuration with env variable fallbacks.
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
        'Failed to load app name from env',
        error: e,
        stackTrace: stackTrace,
      );
      return _defaultAppName;
    }
  }
}
