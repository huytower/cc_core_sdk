import 'package:cc_sdk/export_cc_sdk.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/widgets.dart';
import 'package:injectable/injectable.dart';

/// [CcAnalytics] backed by Google Analytics for Firebase.
///
/// Every call is best-effort: a failure is logged with `.Log()` and never
/// thrown to the caller.
@LazySingleton(as: CcAnalytics)
class CcFirebaseAnalytics implements CcAnalytics {
  CcFirebaseAnalytics(this._analytics);

  final FirebaseAnalytics _analytics;

  static const String _tag = 'CcFirebaseAnalytics';

  @override
  NavigatorObserver get navigatorObserver =>
      FirebaseAnalyticsObserver(analytics: _analytics);

  @override
  Future<void> logScreenView({
    required String screenName,
    String? screenClass,
  }) => _guard(
    'logScreenView',
    () => _analytics.logScreenView(
      screenName: screenName,
      screenClass: screenClass ?? screenName,
    ),
  );

  @override
  Future<void> logLogin({required String method}) =>
      _guard('logLogin', () => _analytics.logLogin(loginMethod: method));

  @override
  Future<void> logSignUp({required String method}) =>
      _guard('logSignUp', () => _analytics.logSignUp(signUpMethod: method));

  @override
  Future<void> logEvent({
    required String name,
    Map<String, Object>? parameters,
  }) => _guard(
    'logEvent',
    () => _analytics.logEvent(name: name, parameters: parameters),
  );

  @override
  Future<void> setUserId(String? id) =>
      _guard('setUserId', () => _analytics.setUserId(id: id));

  @override
  Future<void> setUserProperty({
    required String name,
    required String? value,
  }) => _guard(
    'setUserProperty',
    () => _analytics.setUserProperty(name: name, value: value),
  );

  Future<void> _guard(String action, Future<void> Function() call) async {
    try {
      await call();
    } catch (e) {
      '$action error: $e'.Log(_tag);
    }
  }
}
