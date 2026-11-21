import 'package:catcher_2/model/platform_type.dart';
import 'package:catcher_2/model/report.dart';
import 'package:catcher_2/model/report_handler.dart';
import 'package:cc_sdk/export_cc_sdk.dart';

/// Catcher2 [ReportHandler] that forwards uncaught errors to a
/// [CcCrashReporter].
///
/// ```dart
/// Catcher2Options(SilentReportMode(), [CcCrashReporterHandler(reporter)]);
/// ```
class CcCrashReporterHandler extends ReportHandler {
  CcCrashReporterHandler(this._reporter);

  final CcCrashReporter _reporter;

  @override
  Future<bool> handle(Report report, _) async {
    await _reporter.recordError(
      report.error,
      report.stackTrace,
      reason: 'Caught by Catcher2',
    );
    return true;
  }

  @override
  List<PlatformType> getSupportedPlatforms() => [
    PlatformType.android,
    PlatformType.iOS,
  ];
}
