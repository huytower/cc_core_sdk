import 'package:flutter/widgets.dart';

import 'cc_analytics.dart';

/// [CcAnalytics] that records nothing: for tests and apps without analytics.
class CcNoopAnalytics implements CcAnalytics {
  const CcNoopAnalytics();

  @override
  NavigatorObserver? get navigatorObserver => null;

  @override
  Future<void> logScreenView({
    required String screenName,
    String? screenClass,
  }) async {}

  @override
  Future<void> logLogin({required String method}) async {}

  @override
  Future<void> logSignUp({required String method}) async {}

  @override
  Future<void> logEvent({
    required String name,
    Map<String, Object>? parameters,
  }) async {}

  @override
  Future<void> setUserId(String? id) async {}

  @override
  Future<void> setUserProperty({
    required String name,
    required String? value,
  }) async {}
}

