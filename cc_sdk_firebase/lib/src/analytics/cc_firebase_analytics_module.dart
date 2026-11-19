import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:injectable/injectable.dart';

/// Provides the Firebase SDK instance, which has no injectable constructor.
@module
abstract class CcFirebaseAnalyticsModule {
  @lazySingleton
  FirebaseAnalytics get firebaseAnalytics => FirebaseAnalytics.instance;
}
