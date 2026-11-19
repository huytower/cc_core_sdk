import 'package:cc_sdk/core/extensions/common/cc_logger_extension.dart';
import 'package:firebase_analytics/firebase_analytics.dart';

/// Centralized Helper for Google / Firebase Analytics tracking.
///
/// Provides automatic page view tracking via [navigatorObserver] and
/// event tracking (sign-ups, logins and app-defined custom events).
class CcAnalyticsHelper {
  CcAnalyticsHelper._();

  static final FirebaseAnalytics _analytics = FirebaseAnalytics.instance;

  /// Observer to attach to AutoRoute or MaterialApp's navigatorObservers.
  /// Automatically logs screen_view events whenever users navigate between pages.
  static FirebaseAnalyticsObserver get observer =>
      FirebaseAnalyticsObserver(analytics: _analytics);

  /// Logs a custom screen view event.
  static Future<void> logScreenView({
    required String screenName,
    String? screenClass,
  }) async {
    try {
      await _analytics.logScreenView(
        screenName: screenName,
        screenClass: screenClass ?? screenName,
      );
    } catch (e) {
      'logScreenView error: $e'.Log('CcAnalyticsHelper');
    }
  }

  /// Logs user login method (e.g. 'apple', 'google', 'phone').
  static Future<void> logLogin({required String method}) async {
    try {
      await _analytics.logLogin(loginMethod: method);
    } catch (e) {
      'logLogin error: $e'.Log('CcAnalyticsHelper');
    }
  }

  /// Logs user sign up method.
  static Future<void> logSignUp({required String signUpMethod}) async {
    try {
      await _analytics.logSignUp(signUpMethod: signUpMethod);
    } catch (e) {
      'logSignUp error: $e'.Log('CcAnalyticsHelper');
    }
  }

  /// Logs a custom event (e.g. 'share_content', 'complete_onboarding').
  static Future<void> logEvent({
    required String name,
    Map<String, Object>? parameters,
  }) async {
    try {
      await _analytics.logEvent(name: name, parameters: parameters);
    } catch (e) {
      'logEvent error: $e'.Log('CcAnalyticsHelper');
    }
  }

  /// Sets user ID for analytics user tracking.
  static Future<void> setUserId(String? id) async {
    try {
      await _analytics.setUserId(id: id);
    } catch (e) {
      'setUserId error: $e'.Log('CcAnalyticsHelper');
    }
  }

  /// Sets custom user properties (e.g. plan = 'premium').
  static Future<void> setUserProperty({
    required String name,
    required String? value,
  }) async {
    try {
      await _analytics.setUserProperty(name: name, value: value);
    } catch (e) {
      'setUserProperty error: $e'.Log('CcAnalyticsHelper');
    }
  }
}
