// Minimal example of cc_sdk_firebase: the Firebase implementations of the
// cc_sdk capability interfaces, wired by hand so every hop is visible.
//
// Running it needs a Firebase project: add google-services.json /
// GoogleService-Info.plist to a host app as usual. In a real app the same
// wiring comes from DI: add ExternalModule(CcSdkFirebasePackageModule) to
// externalPackageModulesBefore and inject CcAnalytics, CcCrashReporter,
// CcAppAttestation and CcAiClient.
//
// The page below depends on the cc_sdk interfaces only, so the app (and its
// tests) can swap Firebase for the no-op implementations.
import 'package:cc_sdk/export_cc_sdk.dart';
import 'package:cc_sdk_firebase/export_cc_sdk_firebase.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_app_check/firebase_app_check.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/material.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  final attestation = CcFirebaseAppAttestation(FirebaseAppCheck.instance);
  // Not awaited: App Check must not delay the first frame.
  attestation.activate().ignore();

  runApp(
    CcSdkFirebaseExampleApp(
      analytics: CcFirebaseAnalytics(FirebaseAnalytics.instance),
      crashReporter: CcFirebaseCrashReporter(FirebaseCrashlytics.instance),
      attestation: attestation,
    ),
  );
}

class CcSdkFirebaseExampleApp extends StatelessWidget {
  const CcSdkFirebaseExampleApp({
    super.key,
    required this.analytics,
    required this.crashReporter,
    required this.attestation,
  });

  final CcAnalytics analytics;
  final CcCrashReporter crashReporter;
  final CcAppAttestation attestation;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'cc_sdk_firebase example',
      navigatorObservers: [?analytics.navigatorObserver],
      home: ExampleCapabilitiesPage(
        analytics: analytics,
        crashReporter: crashReporter,
        attestation: attestation,
      ),
    );
  }
}

class ExampleCapabilitiesPage extends StatefulWidget {
  const ExampleCapabilitiesPage({
    super.key,
    required this.analytics,
    required this.crashReporter,
    required this.attestation,
  });

  final CcAnalytics analytics;
  final CcCrashReporter crashReporter;
  final CcAppAttestation attestation;

  @override
  State<ExampleCapabilitiesPage> createState() =>
      _ExampleCapabilitiesPageState();
}

class _ExampleCapabilitiesPageState extends State<ExampleCapabilitiesPage> {
  String _appCheck = '…';
  String _lastAction = '';

  @override
  void initState() {
    super.initState();
    _refreshAppCheck();
  }

  Future<void> _refreshAppCheck() async {
    final status = await widget.attestation.statusDescription();
    if (mounted) setState(() => _appCheck = status);
  }

  Future<void> _logEvent() async {
    await widget.analytics.logEvent(
      name: 'example_tap',
      parameters: {'source': 'example'},
    );
    if (mounted) setState(() => _lastAction = 'Event logged');
  }

  Future<void> _reportError() async {
    try {
      throw StateError('Example error');
    } catch (error, stack) {
      await widget.crashReporter.recordError(
        error,
        stack,
        reason: 'Reported from the example',
      );
    }
    if (mounted) setState(() => _lastAction = 'Error reported');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Firebase capabilities')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Text('App Check: $_appCheck'),
          FilledButton(onPressed: _logEvent, child: const Text('Log event')),
          OutlinedButton(
            onPressed: _reportError,
            child: const Text('Report error'),
          ),
          Text(_lastAction),
        ],
      ),
    );
  }
}
