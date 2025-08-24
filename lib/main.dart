import 'dart:developer' as developer;

import 'package:app_config/box/register_hive_adapter/register_hive_adapter.dart';
import 'package:content_locale/cc_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';

import 'core/di/dependency_register.dart';
import 'core/di/inject/inject.dart';
import 'core/runner/app_runner.dart';

/// NOTICE : there are 3 env. : FREE_FAKE_API (FREE) | UAT | PROD
/// MUST write necessary code in this file
///
Future<void> _loadEnvVars() async {
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
    developer.log('🌐 API URL: ${dotenv.get('API_URL', fallback: 'Not set')}', name: 'EnvConfig');

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
    developer.log('❌ Failed to load env variables: $e', error: e, stackTrace: stackTrace, name: 'EnvConfig');
    rethrow;
  }
}

void main() async {
  // Initialize Flutter bindings
  WidgetsFlutterBinding.ensureInitialized();

  // Load env variables
  await _loadEnvVars();

  /// where init dependency injection, ex. : @singleton, @module, @injection ...
  await initializeDependencies();

  /// manually register into memory by using get_it lib,
  /// anyway, RECOMMEND use `injectable` for auto-inject
  registerSingletonApp();

  /// region Register hive adapter.
  final appDocumentDir = await getApplicationDocumentsDirectory();
  Hive.init(appDocumentDir.path);

  await registerHiveAdapter();

  /// endregion

  /// define main support language
  await CcLocalization.setLocale('en');

  /// Run App Prj.
  runApp(const AppRunner());
}
