import 'cc_crash_reporter.dart';

/// [CcCrashReporter] that reports nothing: for tests and apps without a
/// crash service.
class CcNoopCrashReporter implements CcCrashReporter {
  const CcNoopCrashReporter();

  @override
  Future<void> log(String message) async {}

  @override
  Future<void> recordError(
    Object error,
    StackTrace? stackTrace, {
    required String reason,
    bool fatal = false,
  }) async {}
}

