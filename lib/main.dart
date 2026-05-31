import 'dart:developer' as developer;

import 'package:app_config/data/datasource/local/box/register_hive_adapter.dart';
import 'package:catcher_2/catcher_2.dart';
import 'package:cc_sdk_ui/export_cc_sdk_ui.dart';
import 'package:flutter/material.dart';
import 'package:hive_ce/hive_ce.dart';
import 'package:path_provider/path_provider.dart';

import 'core/di/di.dart';
import 'core/logging/init_logger.dart';
import 'core/runner/app_runner.dart';

/// The entry point of the application.
///
/// Sequence:
/// 1. Initialize Flutter & Environment
/// 2. Setup Dependency Injection
/// 3. Initialize Local Storage (Hive)
/// 4. Initialize Localization
/// 5. Start App via Catcher2 (Global Error Handling)
void main() async {
  try {
    WidgetsFlutterBinding.ensureInitialized();

    await logEnv();
    await logVersionInfo();

    await initializeDependencies();

    final appDocumentDir = await getApplicationDocumentsDirectory();
    Hive.init(appDocumentDir.path);
    await registerHiveAdapter();

    await CcLocalization.initialize();

    /// NOTICE: TEMP DISABLE, enable when BE support api logging
    // await uploadPendingCrashLogsOnStartup();

    _runApplication();
  } catch (error, stackTrace) {
    developer.log(
      'FATAL BOOTSTRAP ERROR',
      error: error,
      stackTrace: stackTrace,
    );
    // Minimal fallback: if the app fails to start, we must at least show something.
    runApp(ErrorPage(message: error.toString()));
  }
}

/// Configures and launches the application shell.
void _runApplication() async {
  final logFile = await CcCrashLogPaths.resolveLogFile();

  Catcher2(
    rootWidget: const AppRunner(),
    ensureInitialized: false,
    debugConfig: CcCatcherBootstrap.debugOptions(logFile),
    releaseConfig: CcCatcherBootstrap.releaseOptions(logFile),
    profileConfig: CcCatcherBootstrap.profileOptions(logFile),
  );
}
