/// Firebase implementations of cc_sdk capability interfaces.
///
/// Consumers depend on the interfaces from `cc_sdk` (e.g. `CcAnalytics`); the
/// app registers this package's DI module so those interfaces resolve to the
/// Firebase implementations.
library;

export 'package:cc_sdk_firebase/src/analytics/cc_firebase_analytics.dart';
