import 'package:catcher_2/model/platform_type.dart';
import 'package:catcher_2/model/report.dart';
import 'package:cc_sdk/export_cc_sdk.dart';
import 'package:cc_sdk_catcher/export_cc_sdk_catcher.dart';
import 'package:flutter_test/flutter_test.dart';

class _RecordingReporter implements CcCrashReporter {
  final List<(Object, StackTrace?, String)> errors = [];

  @override
  Future<void> log(String message) async {}

  @override
  Future<void> recordError(
    Object error,
    StackTrace? stackTrace, {
    required String reason,
    bool fatal = false,
  }) async => errors.add((error, stackTrace, reason));
}

void main() {
  test('forwards the uncaught error to the crash reporter', () async {
    final reporter = _RecordingReporter();
    final handler = CcCrashReporterHandler(reporter);
    final error = StateError('boom');
    final stack = StackTrace.current;

    final handled = await handler.handle(
      Report(
        error,
        stack,
        DateTime(2026),
        const {},
        const {},
        const {},
        null,
        PlatformType.android,
        null,
      ),
      null,
    );

    expect(handled, isTrue);
    expect(reporter.errors.single.$1, error);
    expect(reporter.errors.single.$2, stack);
    expect(reporter.errors.single.$3, 'Caught by Catcher2');
  });
}
