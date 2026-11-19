// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes

import 'dart:async' as _i687;

import 'package:cc_sdk/export_cc_sdk.dart' as _i54;
import 'package:cc_sdk_firebase/src/ai/cc_firebase_ai_client.dart' as _i897;
import 'package:cc_sdk_firebase/src/analytics/cc_firebase_analytics.dart'
    as _i620;
import 'package:cc_sdk_firebase/src/cc_firebase_module.dart' as _i727;
import 'package:cc_sdk_firebase/src/crash_reporting/cc_firebase_crash_reporter.dart'
    as _i597;
import 'package:cc_sdk_firebase/src/security/cc_firebase_app_attestation.dart'
    as _i915;
import 'package:firebase_analytics/firebase_analytics.dart' as _i398;
import 'package:firebase_app_check/firebase_app_check.dart' as _i56;
import 'package:firebase_crashlytics/firebase_crashlytics.dart' as _i141;
import 'package:injectable/injectable.dart' as _i526;

class CcSdkFirebasePackageModule extends _i526.MicroPackageModule {
// initializes the registration of main-scope dependencies inside of GetIt
  @override
  _i687.FutureOr<void> init(_i526.GetItHelper gh) {
    final ccFirebaseModule = _$CcFirebaseModule();
    gh.lazySingleton<_i398.FirebaseAnalytics>(
        () => ccFirebaseModule.firebaseAnalytics);
    gh.lazySingleton<_i141.FirebaseCrashlytics>(
        () => ccFirebaseModule.firebaseCrashlytics);
    gh.lazySingleton<_i56.FirebaseAppCheck>(
        () => ccFirebaseModule.firebaseAppCheck);
    gh.lazySingleton<_i54.CcCrashReporter>(
        () => _i597.CcFirebaseCrashReporter(gh<_i141.FirebaseCrashlytics>()));
    gh.lazySingleton<_i54.CcAnalytics>(
        () => _i620.CcFirebaseAnalytics(gh<_i398.FirebaseAnalytics>()));
    gh.lazySingleton<_i54.CcAppAttestation>(
        () => _i915.CcFirebaseAppAttestation(gh<_i56.FirebaseAppCheck>()));
    gh.lazySingleton<_i54.CcAiClient>(
        () => _i897.CcFirebaseAiClient(gh<_i54.CcCrashReporter>()));
  }
}

class _$CcFirebaseModule extends _i727.CcFirebaseModule {}
