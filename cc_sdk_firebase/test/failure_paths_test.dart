import 'package:cc_sdk/export_cc_sdk.dart';
import 'package:cc_sdk_firebase/export_cc_sdk_firebase.dart';
import 'package:firebase_app_check/firebase_app_check.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter_test/flutter_test.dart';

/// App Check whose calls fail until [healthy] is set; records every call.
class _FlakyAppCheck implements FirebaseAppCheck {
  bool healthy = false;
  final calls = <Invocation>[];

  @override
  dynamic noSuchMethod(Invocation invocation) {
    calls.add(invocation);
    if (invocation.memberName == #getToken) {
      return healthy
          ? Future<String?>.value('token')
          : Future<String?>.error(StateError('app check down'));
    }
    return healthy
        ? Future<void>.value()
        : Future<void>.error(StateError('app check down'));
  }
}

class _RecordingCrashlytics implements FirebaseCrashlytics {
  final calls = <Invocation>[];

  @override
  dynamic noSuchMethod(Invocation invocation) {
    calls.add(invocation);
    return Future<void>.value();
  }
}

void main() {
  group('CcFirebaseAppAttestation', () {
    test('a failed activate rethrows and is tried again next time', () async {
      final appCheck = _FlakyAppCheck();
      final attestation = CcFirebaseAppAttestation(appCheck);

      await expectLater(attestation.activate(), throwsStateError);

      appCheck.healthy = true;
      await attestation.activate();
      await attestation.activate();

      final activations = appCheck.calls.where(
        (call) => call.memberName == #activate,
      );
      expect(activations, hasLength(2));
    });

    test('getToken rethrows so the caller can decide', () async {
      final attestation = CcFirebaseAppAttestation(_FlakyAppCheck());

      await expectLater(attestation.getToken(), throwsStateError);
    });

    test('setTokenAutoRefresh forwards the flag', () async {
      final appCheck = _FlakyAppCheck()..healthy = true;

      await CcFirebaseAppAttestation(appCheck).setTokenAutoRefresh(false);

      final call = appCheck.calls.single;
      expect(call.memberName, #setTokenAutoRefreshEnabled);
      expect(call.positionalArguments, [false]);
    });
  });

  group('CcFirebaseCrashReporter.log', () {
    tearDown(() => CcSdkConfig.configure(const CcSdkConfig()));

    test('forwards the breadcrumb to Crashlytics', () async {
      final crashlytics = _RecordingCrashlytics();

      await CcFirebaseCrashReporter(crashlytics).log('opened cart');

      expect(crashlytics.calls.single.memberName, #log);
      expect(crashlytics.calls.single.positionalArguments, ['opened cart']);
    });

    test('sends nothing when crash reporting is disabled', () async {
      CcSdkConfig.configure(const CcSdkConfig(enableCrashReporting: false));
      final crashlytics = _RecordingCrashlytics();

      await CcFirebaseCrashReporter(crashlytics).log('opened cart');

      expect(crashlytics.calls, isEmpty);
    });
  });
}
