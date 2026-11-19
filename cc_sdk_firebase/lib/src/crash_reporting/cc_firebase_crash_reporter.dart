import 'package:cc_sdk/export_cc_sdk.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:injectable/injectable.dart';

/// [CcCrashReporter] backed by Firebase Crashlytics.
///
/// No-ops when `CcFeatureFlags.isCrashReportingEnabled` is false. Never
/// throws: a failure to report must not mask the original error.
@LazySingleton(as: CcCrashReporter)
class CcFirebaseCrashReporter implements CcCrashReporter {
  CcFirebaseCrashReporter(this._crashlytics);

  final FirebaseCrashlytics _crashlytics;

  @override
  Future<void> log(String message) async {
    if (!CcFeatureFlags.isCrashReportingEnabled) return;
    try {
      await _crashlytics.log(message);
    } catch (_) {
      // Best-effort.
    }
  }

  @override
  Future<void> recordError(
    Object error,
    StackTrace? stackTrace, {
    required String reason,
    bool fatal = false,
  }) async {
    if (!CcFeatureFlags.isCrashReportingEnabled) return;
    try {
      await _crashlytics.recordError(
        error,
        stackTrace,
        reason: reason,
        fatal: fatal,
      );
    } catch (_) {
      // Best-effort: reporting must never throw into the caller.
    }
  }
}
