import 'package:app_config/box/register_hive_adapter/hive_adapter.dart';
import 'package:content_locale/cc_localization.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';

import 'core/di/dependency_register.dart';
import 'core/di/inject/app_inject.dart';
import 'core/runner/app_runner.dart';

/// NOTICE : there are 3 env. : FREE_FAKE_API (FREE) | UAT | PROD
/// MUST write necessary code in this file
///
void main() async {
  /// bool allow BINDING process rule
  WidgetsFlutterBinding.ensureInitialized();

  /// where init dependency injection, ex. : @singleton, @module, @injection ...
  await initializeDependencies();

  /// region Register hive adapter.
  final appDocumentDir = await getApplicationDocumentsDirectory();
  Hive.init(appDocumentDir.path);

  await registerHiveAdapter();

  /// endregion

  /// define main support language
  await CcLocalization.setLocale('en');

  /// manually register into memory by using get_it lib,
  /// anyway, RECOMMEND use `injectable` for auto-inject
  registerSingletonApp();

  /// Run App Prj.
  runApp(const AppRunner());
}
