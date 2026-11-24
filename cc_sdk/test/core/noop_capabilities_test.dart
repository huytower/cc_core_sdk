import 'package:cc_sdk/export_cc_sdk.dart';
import 'package:flutter_test/flutter_test.dart';

// The no-op implementations let an app run without a vendor capability
// package: every call completes, nothing is sent, and "off" answers come back.
void main() {
  test('CcNoopAnalytics accepts every call and has no observer', () async {
    const CcAnalytics analytics = CcNoopAnalytics();

    expect(analytics.navigatorObserver, isNull);
    await analytics.logScreenView(screenName: 'home');
    await analytics.logLogin(method: 'password');
    await analytics.logSignUp(method: 'password');
    await analytics.logEvent(name: 'tap', parameters: {'id': 1});
    await analytics.setUserId('user-1');
    await analytics.setUserProperty(name: 'plan', value: 'free');
  });

  test('CcNoopCrashReporter accepts every call', () async {
    const CcCrashReporter reporter = CcNoopCrashReporter();

    await reporter.log('message');
    await reporter.recordError(
      StateError('x'),
      StackTrace.current,
      reason: 'test',
      fatal: true,
    );
  });

  test('CcNoopFeedbackReporter reports that nothing was sent', () async {
    const CcFeedbackReporter reporter = CcNoopFeedbackReporter();

    expect(await reporter.send(const CcFeedback(text: 'Nice')), isFalse);
  });

  test('CcNoopAppAttestation is disabled and has no token', () async {
    const CcAppAttestation attestation = CcNoopAppAttestation();

    await attestation.activate();
    await attestation.setTokenAutoRefresh(true);
    expect(await attestation.statusDescription(), 'Disabled');
    expect(await attestation.getToken(forceRefresh: true), isEmpty);
  });

  test('CcNoopSpeechRecognizer never starts listening', () async {
    const CcSpeechRecognizer recognizer = CcNoopSpeechRecognizer();

    final started = await recognizer.startListening(onResult: (_, _) {});

    expect(started, isFalse);
    expect(recognizer.hasListening, isFalse);
    await recognizer.stopListening();
  });

  test('CcNoopLocationService has no permission and no position', () async {
    final CcLocationService location = CcNoopLocationService();

    expect(await location.requestPermission(), isFalse);
    expect(await location.hasPermission(), isFalse);
    expect(await location.getCurrentPosition(), isNull);
    expect(await location.getLastKnownPosition(), isNull);
    expect(
      await location.countryCodeAt(
        const CcGeoPosition(latitude: 0, longitude: 0),
      ),
      isNull,
    );
    expect(location.lastPosition.value, isNull);
  });

  test('CcFeedbackLabels.english fills every caption', () {
    const labels = CcFeedbackLabels.english;

    expect(
      [
        labels.title,
        labels.rating,
        labels.praise,
        labels.criticism,
        labels.text,
        labels.none,
        labels.noText,
        labels.notRated,
      ].every((label) => label.isNotEmpty),
      isTrue,
    );
  });
}
