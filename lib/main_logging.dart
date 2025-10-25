import 'dart:developer' as developer;

import 'package:app_config/services/app_version_service.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

/// Logs the current app version and build information
Future<void> logVersionInfo() async {
  try {
    final versionService = AppVersionService();
    final version = await versionService.getCurrentVersion();
    final buildNumber = await versionService.getBuildNumber();
    final packageName = await versionService.getPackageName();
    final isPreRelease = await versionService.isPreRelease();

    developer.log(
      '📱 App Version Info\n'
      '   • Version: $version\n'
      '   • Build: $buildNumber\n'
      '   • Package: $packageName\n'
      '   • Pre-release: $isPreRelease',
      name: 'AppVersion',
    );
  } catch (e, stackTrace) {
    developer.log(
      '❌ Failed to get version info: $e',
      error: e,
      stackTrace: stackTrace,
      name: 'AppVersion',
    );
  }
}

Future<void> logEnv() async {
  try {
    // Determine the env
    const env = String.fromEnvironment('ENV', defaultValue: 'development');
    const envFile = env == 'development' ? '.env' : '.env.$env';
    const envPath = 'env/$envFile';

    developer.log('Loading env: $env from $envPath', name: 'EnvConfig');

    // Load the env variables from env/ directory
    await dotenv.load(fileName: envPath);

    // Log env info
    developer.log('✅ Running in $env env', name: 'EnvConfig');
    developer.log('🌐 API URL: ${dotenv.get('API_URL', fallback: 'Not set')}',
        name: 'EnvConfig');

    // Log all loaded variables in debug mode
    assert(() {
      final buffer = StringBuffer('📋 Loaded env variables:\n');
      dotenv.env.forEach((key, value) {
        buffer.writeln(
            '   $key: ${key.toLowerCase().contains('key') || key.toLowerCase().contains('secret') ? '***' : value}');
      });
      developer.log(buffer.toString(), name: 'EnvConfig');
      return true;
    }());
  } catch (e, stackTrace) {
    developer.log('❌ Failed to load env variables: $e',
        error: e, stackTrace: stackTrace, name: 'EnvConfig');
    rethrow;
  }
}
