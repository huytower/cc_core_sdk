import 'package:app_config/box/register_hive_adapter/register_hive_adapter.dart';
import 'package:content_locale/cc_localization.dart' as localization;
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';

import 'core/di/dependency_register.dart';
import 'core/di/inject/inject.dart';
import 'core/runner/app_runner.dart';
import 'main_logging.dart';

/// NOTICE : there are 3 env. : FREE_FAKE_API (FREE) | UAT | PROD
/// MUST write necessary code in this file
///
void main() async {
  // Initialize Flutter bindings
  WidgetsFlutterBinding.ensureInitialized();

  // Load env variables
  await logEnv();
  await logVersionInfo();

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

  // Initialize localization with debug logging disabled
  await localization.CcLocalization.initialize();

  /// Run App Prj.
  runApp(
    localization.CcLocalization.wrapWithLocalization(
      child: const AppRunner(),
    ),
  );
}
