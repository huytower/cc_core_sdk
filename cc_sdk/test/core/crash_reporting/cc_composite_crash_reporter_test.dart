import 'package:cc_sdk/export_cc_sdk.dart';
import 'package:flutter_test/flutter_test.dart';

class _Recording implements CcCrashReporter {
  final List<String> reasons = [];
  final List<String> logs = [];

  @override
  Future<void> log(String message) async => logs.add(message);

  @override
  Future<void> recordError(
    Object error,
    StackTrace? stackTrace, {
    required String reason,
    bool fatal = false,
  }) async => reasons.add(reason);
}

class _Throwing implements CcCrashReporter {
  @override
  Future<void> log(String message) => throw StateError('log');

  @override
  Future<void> recordError(
    Object error,
    StackTrace? stackTrace, {
    required String reason,
    bool fatal = false,
  }) => throw StateError('record');
}

void main() {
  test('forwards errors and breadcrumbs to every reporter', () async {
    final a = _Recording();
    final b = _Recording();
    final reporter = CcCompositeCrashReporter([a, b]);

    await reporter.log('step');
    await reporter.recordError(Exception('x'), null, reason: 'why');

    expect(a.logs, ['step']);
    expect(b.reasons, ['why']);
  });

  test('a throwing reporter neither stops the others nor throws', () async {
    final ok = _Recording();
    final reporter = CcCompositeCrashReporter([_Throwing(), ok]);

    await reporter.recordError(Exception('x'), null, reason: 'why');

    expect(ok.reasons, ['why']);
  });
}
