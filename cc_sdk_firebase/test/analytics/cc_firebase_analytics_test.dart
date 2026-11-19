import 'package:cc_sdk/export_cc_sdk.dart';
import 'package:cc_sdk_firebase/export_cc_sdk_firebase.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter_test/flutter_test.dart';

/// Records every call; throws instead when [fail] is true.
class _FakeFirebaseAnalytics implements FirebaseAnalytics {
  _FakeFirebaseAnalytics({this.fail = false});

  final bool fail;
  final List<Invocation> calls = [];

  @override
  dynamic noSuchMethod(Invocation invocation) {
    calls.add(invocation);
    if (fail) return Future<void>.error(StateError('analytics down'));
    return Future<void>.value();
  }
}

void main() {
  group('CcFirebaseAnalytics', () {
    test('forwards events to Firebase with the given arguments', () async {
      final fake = _FakeFirebaseAnalytics();
      final CcAnalytics analytics = CcFirebaseAnalytics(fake);

      await analytics.logEvent(name: 'share', parameters: {'type': 'pdf'});
      await analytics.logLogin(method: 'google');
      await analytics.logScreenView(screenName: 'Home');

      expect(fake.calls.map((c) => c.memberName), [
        #logEvent,
        #logLogin,
        #logScreenView,
      ]);
      expect(fake.calls.first.namedArguments[#name], 'share');
      expect(fake.calls[1].namedArguments[#loginMethod], 'google');
      // screenClass defaults to the screen name.
      expect(fake.calls[2].namedArguments[#screenClass], 'Home');
    });

    test('never throws when Firebase fails', () async {
      final CcAnalytics analytics = CcFirebaseAnalytics(
        _FakeFirebaseAnalytics(fail: true),
      );

      await expectLater(analytics.logEvent(name: 'x'), completes);
      await expectLater(analytics.logSignUp(method: 'phone'), completes);
      await expectLater(analytics.setUserId('u1'), completes);
      await expectLater(
        analytics.setUserProperty(name: 'plan', value: 'premium'),
        completes,
      );
    });

    test('CcNoopAnalytics records nothing and has no observer', () async {
      const analytics = CcNoopAnalytics();
      expect(analytics.navigatorObserver, isNull);
      await expectLater(analytics.logEvent(name: 'x'), completes);
    });
  });
}
