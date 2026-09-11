import 'package:firebase_crashlytics/firebase_crashlytics.dart';

import '../config/cc_feature_flags.dart';

/// Helper for reporting *handled* errors to Firebase Crashlytics.
///
/// Catcher2 (see [CcCrashLogPaths]/`cc_catcher_bootstrap.dart`) only reports
/// errors that escape as uncaught exceptions. Errors caught inside a
/// try/catch and converted to a `Result.Error` never reach it — call this
/// helper from those catch blocks when the failure is worth surfacing in
/// Crashlytics for diagnosis (e.g. a native/platform error masked behind a
/// generic UI message).
class CcCrashReportingHelper {
  CcCrashReportingHelper._();

  /// Records a non-fatal error with Crashlytics, tagged with [reason].
  ///
  /// No-ops when [CcFeatureFlags.isCrashReportingEnabled] is false. Never
  /// throws — a failure to report must not mask the original error.
  static Future<void> recordHandledError(
    Object error,
    StackTrace? stackTrace, {
    required String reason,
  }) async {
    if (!CcFeatureFlags.isCrashReportingEnabled) return;
    try {
      await FirebaseCrashlytics.instance.recordError(
        error,
        stackTrace,
        reason: reason,
        fatal: false,
      );
    } catch (_) {
      // Best-effort — reporting must never throw into the caller's catch block.
    }
  }
}
