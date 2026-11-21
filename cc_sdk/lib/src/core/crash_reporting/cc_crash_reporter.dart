/// Crash and error reporting, independent of any vendor.
///
/// The SDK core only defines this contract. An implementation comes from a
/// capability package (e.g. `CcFirebaseCrashReporter` in `cc_sdk_firebase`),
/// registered in DI as `CcCrashReporter`; apps without a crash service can
/// register [CcNoopCrashReporter]. Implementations must never throw: a
/// failure to report must not mask the original error.
///
/// Uncaught errors reach it through the app's error hook (for example
/// `CcCrashReporterHandler`, wired by `CcCatcherBootstrap`, both in
/// `cc_sdk_catcher`). Errors caught in a try/catch and turned into a
/// `Result.Error` do not: call [recordError] from those catch blocks when the
/// failure is worth diagnosing.
///
/// ```dart
/// } catch (e, st) {
///   crashReporter.recordError(e, st, reason: 'sync failed');
/// }
/// ```
abstract interface class CcCrashReporter {
  /// Adds a breadcrumb message to the next crash report.
  Future<void> log(String message);

  /// Records an error, tagged with [reason]; non-fatal unless [fatal].
  Future<void> recordError(
    Object error,
    StackTrace? stackTrace, {
    required String reason,
    bool fatal = false,
  });
}

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
