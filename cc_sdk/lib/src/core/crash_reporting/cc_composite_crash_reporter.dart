import 'cc_crash_reporter.dart';

/// [CcCrashReporter] that sends every call to each of [reporters], in order.
///
/// Use it when an app reports to more than one service, e.g. Crashlytics and a
/// chat alert. A reporter that throws (which a well-behaved one never does) is
/// skipped, so it cannot stop the others or reach the caller.
///
/// ```dart
/// CcCompositeCrashReporter([crashlyticsReporter, slackReporter]);
/// ```
class CcCompositeCrashReporter implements CcCrashReporter {
  const CcCompositeCrashReporter(this.reporters);

  final List<CcCrashReporter> reporters;

  @override
  Future<void> log(String message) =>
      _each((reporter) => reporter.log(message));

  @override
  Future<void> recordError(
    Object error,
    StackTrace? stackTrace, {
    required String reason,
    bool fatal = false,
  }) => _each(
    (reporter) =>
        reporter.recordError(error, stackTrace, reason: reason, fatal: fatal),
  );

  Future<void> _each(Future<void> Function(CcCrashReporter) call) async {
    await Future.wait(
      reporters.map((reporter) async {
        try {
          await call(reporter);
        } catch (_) {
          // Best-effort: one failing reporter must not hide the error.
        }
      }),
    );
  }
}
