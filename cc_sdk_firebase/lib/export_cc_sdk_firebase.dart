/// Firebase implementations of cc_sdk capability interfaces.
///
/// Consumers depend on the interfaces from `cc_sdk` (e.g. `CcAnalytics`); the
/// app registers this package's DI module so those interfaces resolve to the
/// Firebase implementations.
library;

export 'package:cc_sdk_firebase/src/ai/cc_firebase_ai_client.dart';
export 'package:cc_sdk_firebase/src/analytics/cc_firebase_analytics.dart';
export 'package:cc_sdk_firebase/src/crash_reporting/cc_firebase_crash_reporter.dart';
export 'package:cc_sdk_firebase/src/security/cc_firebase_app_attestation.dart';
