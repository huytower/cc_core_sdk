import 'package:cc_sdk/export_cc_sdk.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:injectable/injectable.dart';

/// [CcCrashReporter] backed by Firebase Crashlytics.
///
/// To turn reporting off, use Crashlytics' own collection switch
/// (`setCrashlyticsCollectionEnabled`) or register another [CcCrashReporter].
/// Never throws: a failure to report must not mask the original error.
@LazySingleton(as: CcCrashReporter)
class CcFirebaseCrashReporter implements CcCrashReporter {
  CcFirebaseCrashReporter(this._crashlytics);

  final FirebaseCrashlytics _crashlytics;

  @override
  Future<void> log(String message) async {
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
