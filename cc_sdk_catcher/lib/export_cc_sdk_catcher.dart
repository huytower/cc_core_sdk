/// Catcher2 capability: `CcCatcherBootstrap` (debug / release / profile
/// options) and `CcCrashReporterHandler`, which forwards uncaught errors to
/// the `CcCrashReporter` of `cc_sdk`.
library;

export 'package:cc_sdk_catcher/src/cc_catcher_bootstrap.dart';
export 'package:cc_sdk_catcher/src/cc_crash_reporter_handler.dart';
