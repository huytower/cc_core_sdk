import 'package:cc_sdk/export_cc_sdk.dart';
import 'package:firebase_app_check/firebase_app_check.dart';
import 'package:flutter/foundation.dart';
import 'package:injectable/injectable.dart';

/// [CcAppAttestation] backed by Firebase App Check.
///
/// Providers: Play Integrity on Android; App Attest (with DeviceCheck
/// fallback) on Apple; the debug providers in debug builds, whose debug
/// token must be registered in the Firebase Console.
@LazySingleton(as: CcAppAttestation)
class CcFirebaseAppAttestation implements CcAppAttestation {
  CcFirebaseAppAttestation(this._appCheck);

  final FirebaseAppCheck _appCheck;
  bool _activated = false;

  static const String _tag = 'CcFirebaseAppAttestation';

  @override
  Future<void> activate() async {
    if (_activated) return;
    try {
      await _appCheck.activate(
        providerAndroid: kDebugMode
            ? const AndroidDebugProvider()
            : const AndroidPlayIntegrityProvider(),
        providerApple: kDebugMode
            ? const AppleDebugProvider()
            : const AppleAppAttestWithDeviceCheckFallbackProvider(),
      );
      _activated = true;
      (kDebugMode
              ? 'App Check activated in DEBUG mode: register the debug token '
                    'in the Firebase Console.'
              : 'App Check activated')
          .Log(_tag);
    } catch (error, stackTrace) {
      'App Check activation failed: $error\n$stackTrace'.Log(_tag);
      rethrow;
    }
  }

  @override
  Future<String> statusDescription() async {
    try {
      final token = await _appCheck.getToken();
      return token != null && token.isNotEmpty
          ? 'Verified (Token present)'
          : 'Unverified (Token null/empty)';
    } catch (e) {
      return 'Failed ($e)';
    }
  }

  @override
  Future<String> getToken({bool forceRefresh = false}) async {
    try {
      return await _appCheck.getToken(forceRefresh) ?? '';
    } catch (error, stackTrace) {
      'Failed to get App Check token: $error\n$stackTrace'.Log(_tag);
      rethrow;
    }
  }

  @override
  Future<void> setTokenAutoRefresh(bool enabled) async {
    try {
      await _appCheck.setTokenAutoRefreshEnabled(enabled);
    } catch (error, stackTrace) {
      'Failed to set App Check auto-refresh: $error\n$stackTrace'.Log(_tag);
      rethrow;
    }
  }
}
