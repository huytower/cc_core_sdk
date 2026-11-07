import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/foundation.dart';

/// Centralized Helper for Google / Firebase Analytics tracking.
///
/// Provides automatic page view tracking via [navigatorObserver] and
/// marketing-focused event tracking (Sign Ups, Logins, AI Advice generation,
/// VIP upgrades, transaction events).
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
      if (kDebugMode) print('[CcAnalyticsHelper] logScreenView error: $e');
    }
  }

  /// Logs user login method (e.g. 'apple', 'google', 'phone').
  static Future<void> logLogin({required String method}) async {
    try {
      await _analytics.logLogin(loginMethod: method);
    } catch (e) {
      if (kDebugMode) print('[CcAnalyticsHelper] logLogin error: $e');
    }
  }

  /// Logs user sign up method.
  static Future<void> logSignUp({required String signUpMethod}) async {
    try {
      await _analytics.logSignUp(signUpMethod: signUpMethod);
    } catch (e) {
      if (kDebugMode) print('[CcAnalyticsHelper] logSignUp error: $e');
    }
  }

  /// Logs marketing / engagement event (e.g., 'generate_ai_advice', 'upgrade_vip', 'add_transaction').
  static Future<void> logEvent({
    required String name,
    Map<String, Object>? parameters,
  }) async {
    try {
      await _analytics.logEvent(name: name, parameters: parameters);
    } catch (e) {
      if (kDebugMode) print('[CcAnalyticsHelper] logEvent error: $e');
    }
  }

  /// Sets user ID for analytics user tracking.
  static Future<void> setUserId(String? id) async {
    try {
      await _analytics.setUserId(id: id);
    } catch (e) {
      if (kDebugMode) print('[CcAnalyticsHelper] setUserId error: $e');
    }
  }

  /// Sets custom user properties (e.g., vip_status = 'vip').
  static Future<void> setUserProperty({
    required String name,
    required String? value,
  }) async {
    try {
      await _analytics.setUserProperty(name: name, value: value);
    } catch (e) {
      if (kDebugMode) print('[CcAnalyticsHelper] setUserProperty error: $e');
    }
  }
}
