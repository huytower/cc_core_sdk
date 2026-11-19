// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes

import 'dart:async' as _i687;

import 'package:cc_sdk/export_cc_sdk.dart' as _i54;
import 'package:cc_sdk_firebase/src/analytics/cc_firebase_analytics.dart'
    as _i620;
import 'package:cc_sdk_firebase/src/analytics/cc_firebase_analytics_module.dart'
    as _i195;
import 'package:firebase_analytics/firebase_analytics.dart' as _i398;
import 'package:injectable/injectable.dart' as _i526;

class CcSdkFirebasePackageModule extends _i526.MicroPackageModule {
// initializes the registration of main-scope dependencies inside of GetIt
  @override
  _i687.FutureOr<void> init(_i526.GetItHelper gh) {
    final ccFirebaseAnalyticsModule = _$CcFirebaseAnalyticsModule();
    gh.lazySingleton<_i398.FirebaseAnalytics>(
        () => ccFirebaseAnalyticsModule.firebaseAnalytics);
    gh.lazySingleton<_i54.CcAnalytics>(
        () => _i620.CcFirebaseAnalytics(gh<_i398.FirebaseAnalytics>()));
  }
}

class _$CcFirebaseAnalyticsModule extends _i195.CcFirebaseAnalyticsModule {}
