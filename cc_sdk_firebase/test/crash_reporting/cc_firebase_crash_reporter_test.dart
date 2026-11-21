import 'package:cc_sdk/export_cc_sdk.dart';
import 'package:cc_sdk_firebase/export_cc_sdk_firebase.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter_test/flutter_test.dart';

/// Records every call; throws instead when [fail] is true.
class _FakeCrashlytics implements FirebaseCrashlytics {
  _FakeCrashlytics({this.fail = false});

  final bool fail;
  final List<Invocation> calls = [];

  @override
  dynamic noSuchMethod(Invocation invocation) {
    calls.add(invocation);
    if (fail) return Future<void>.error(StateError('crashlytics down'));
    return Future<void>.value();
  }
}

void main() {
  test('records non-fatal errors with the reason', () async {
    final fake = _FakeCrashlytics();
    final CcCrashReporter reporter = CcFirebaseCrashReporter(fake);

    await reporter.recordError(StateError('x'), null, reason: 'sync failed');
    await reporter.log('breadcrumb');

    expect(fake.calls.map((c) => c.memberName), [#recordError, #log]);
    expect(fake.calls.first.namedArguments[#reason], 'sync failed');
    expect(fake.calls.first.namedArguments[#fatal], false);
  });

  test('never throws when Crashlytics fails', () async {
    final CcCrashReporter reporter = CcFirebaseCrashReporter(
      _FakeCrashlytics(fail: true),
    );

    await expectLater(
      reporter.recordError(StateError('x'), null, reason: 'r'),
      completes,
    );
    await expectLater(reporter.log('m'), completes);
  });
}
