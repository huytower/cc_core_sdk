import 'package:app_config/data/datasource/local/box/register_hive_adapter.dart';
import 'package:catcher_2/catcher_2.dart';
import 'package:cc_sdk_ui/export_cc_sdk_ui.dart';
import 'package:flutter/material.dart';
import 'package:hive_ce/hive_ce.dart';
import 'package:path_provider/path_provider.dart';

import 'core/crash_reporting/crash_log_dev_overlay.dart';
import 'core/crash_reporting/crash_log_startup.dart';
import 'core/di/inject/inject.dart';
import 'core/runner/app_runner.dart';
import 'main_logging.dart';

/// NOTICE : there are 3 env. : FREE_FAKE_API (FREE) | UAT | PROD
/// MUST write necessary code in this file
void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await logEnv();
  await logVersionInfo();

  await initializeDependencies();

  final appDocumentDir = await getApplicationDocumentsDirectory();
  Hive.init(appDocumentDir.path);
  await registerHiveAdapter();

  await CcLocalization.initialize();

  await uploadPendingCrashLogsOnStartup();

  final logFile = await CcCrashLogPaths.resolveLogFile();

  final rootWidget = CrashLogDevOverlay(
    child: CcLocalization.wrapWithLocalization(child: const AppRunner()),
  );

  Catcher2(
    rootWidget: rootWidget,
    ensureInitialized: false,
    debugConfig: CcCatcherBootstrap.debugOptions(logFile),
    releaseConfig: CcCatcherBootstrap.releaseOptions(logFile),
    profileConfig: CcCatcherBootstrap.profileOptions(logFile),
  );
}
