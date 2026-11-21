import 'package:cc_sdk/export_cc_sdk.dart';
import 'package:cc_sdk_firebase/export_cc_sdk_firebase.dart';
import 'package:firebase_app_check/firebase_app_check.dart';
import 'package:flutter_test/flutter_test.dart';

import '../example/main.dart';

class _FakeAppCheck implements FirebaseAppCheck {
  @override
  dynamic noSuchMethod(Invocation invocation) =>
      invocation.memberName == #getToken
      ? Future<String?>.value('token')
      : Future<void>.value();
}

class _RecordingAnalytics extends CcNoopAnalytics {
  final events = <String>[];

  @override
  Future<void> logEvent({
    required String name,
    Map<String, Object>? parameters,
  }) async => events.add(name);
}

class _RecordingCrashReporter extends CcNoopCrashReporter {
  final reasons = <String>[];

  @override
  Future<void> recordError(
    Object error,
    StackTrace? stackTrace, {
    required String reason,
    bool fatal = false,
  }) async => reasons.add(reason);
}

// Keeps example/main.dart compiling and working. Firebase itself is replaced:
// App Check by a fake behind the real CcFirebaseAppAttestation, analytics and
// crash reporting by recording implementations of the cc_sdk interfaces.
void main() {
  late _RecordingAnalytics analytics;
  late _RecordingCrashReporter crashReporter;

  Future<void> pumpExample(WidgetTester tester) async {
    analytics = _RecordingAnalytics();
    crashReporter = _RecordingCrashReporter();
    await tester.pumpWidget(
      CcSdkFirebaseExampleApp(
        analytics: analytics,
        crashReporter: crashReporter,
        attestation: CcFirebaseAppAttestation(_FakeAppCheck()),
      ),
    );
    await tester.pump();
  }

  testWidgets('shows the App Check status', (tester) async {
    await pumpExample(tester);

    expect(find.text('App Check: Verified (Token present)'), findsOneWidget);
  });

  testWidgets('logs an event through CcAnalytics', (tester) async {
    await pumpExample(tester);

    await tester.tap(find.text('Log event'));
    await tester.pump();

    expect(analytics.events, ['example_tap']);
    expect(find.text('Event logged'), findsOneWidget);
  });

  testWidgets('reports an error through CcCrashReporter', (tester) async {
    await pumpExample(tester);

    await tester.tap(find.text('Report error'));
    await tester.pump();

    expect(crashReporter.reasons, ['Reported from the example']);
    expect(find.text('Error reported'), findsOneWidget);
  });
}
