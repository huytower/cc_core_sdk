import 'package:flutter/widgets.dart';

/// Product analytics, independent of any vendor.
///
/// The SDK core only defines this contract. An implementation comes from a
/// capability package (e.g. `CcFirebaseAnalytics` in `cc_sdk_firebase`),
/// registered in DI as `CcAnalytics`; apps without analytics can register
/// [CcNoopAnalytics]. Implementations must never throw: analytics is
/// best-effort and must not break the calling flow.
///
/// ```dart
/// await analytics.logEvent(name: 'share_content', parameters: {'type': 'pdf'});
/// ```
abstract interface class CcAnalytics {
  /// Observer to add to the app's `navigatorObservers`, so screen views are
  /// logged on navigation. `null` when the implementation does not track
  /// screens automatically.
  NavigatorObserver? get navigatorObserver;

  /// Logs a screen view.
  Future<void> logScreenView({required String screenName, String? screenClass});

  /// Logs a login, with the method used (e.g. 'apple', 'google', 'phone').
  Future<void> logLogin({required String method});

  /// Logs a sign-up, with the method used.
  Future<void> logSignUp({required String method});

  /// Logs a custom event (e.g. 'share_content', 'complete_onboarding').
  Future<void> logEvent({
    required String name,
    Map<String, Object>? parameters,
  });

  /// Sets (or clears, with `null`) the user id attached to later events.
  Future<void> setUserId(String? id);

  /// Sets a user property (e.g. plan = 'premium'); `null` clears it.
  Future<void> setUserProperty({required String name, required String? value});
}
