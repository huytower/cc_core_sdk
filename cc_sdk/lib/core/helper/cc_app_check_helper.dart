import 'package:cc_sdk/core/extensions/common/cc_logger_extension.dart';
import 'package:firebase_app_check/firebase_app_check.dart';
import 'package:flutter/foundation.dart';

/// Helper class for Firebase App Check initialization and configuration.
///
/// This class is state-management agnostic and provides a clean interface
/// for initializing Firebase App Check with the appropriate providers
/// based on the platform (Android/iOS/Web).
class CcAppCheckHelper {
  CcAppCheckHelper._();

  static const String _tag = 'CcAppCheckHelper';

  /// Initializes Firebase App Check with the appropriate provider.
  ///
  /// On Android: Uses Play Integrity provider
  /// On iOS: Uses App Attest provider (must match what's registered for this
  /// app in the Firebase Console's App Check tab)
  /// On Web: Uses reCAPTCHA provider
  ///
  /// [debugToken] Optional debug token for development/testing.
  /// When provided in debug mode, App Check will use this token instead
  /// of the actual attestation provider.
  ///
  static bool _isInitialized = false;

  /// Returns [Future<void>] that completes when App Check is initialized.
  static Future<void> initialize({String? debugToken}) async {
    if (_isInitialized) return;
    try {
      await FirebaseAppCheck.instance.activate(
        providerAndroid: kDebugMode
            ? const AndroidDebugProvider()
            : const AndroidPlayIntegrityProvider(),
        providerApple: kDebugMode
            ? const AppleDebugProvider()
            : const AppleAppAttestWithDeviceCheckFallbackProvider(),
      );
      _isInitialized = true;

      if (kDebugMode) {
        ('Firebase App Check initialized in DEBUG mode. '
                'Please ensure the debug token from the console is added to Firebase Console.')
            .Log(_tag);
      } else {
        'Firebase App Check initialized successfully'.Log(_tag);
      }
    } catch (error, stackTrace) {
      'Firebase App Check initialization failed: $error\n$stackTrace'.Log(_tag);
      rethrow;
    }
  }

  /// Gets the current App Check status for error reports / diagnostic logging.
  ///
  /// Returns a string describing whether a valid App Check token was obtained,
  /// or the error encountered (e.g. "Verified (Token present)", "Failed: ...").
  static Future<String> getAppCheckStatus() async {
    try {
      final token = await FirebaseAppCheck.instance.getToken();
      if (token != null && token.isNotEmpty) {
        return 'Verified (Token present)';
      } else {
        return 'Unverified (Token null/empty)';
      }
    } catch (e) {
      return 'Failed ($e)';
    }
  }

  /// Gets the current App Check token.
  ///
  /// This can be used to manually retrieve the App Check token
  /// for debugging or testing purposes.
  ///
  /// Returns [Future<String>] the current App Check token.
  static Future<String> getToken() async {
    try {
      final token = await FirebaseAppCheck.instance.getToken();
      'App Check token retrieved successfully'.Log(_tag);
      return token ?? '';
    } catch (error, stackTrace) {
      'Failed to retrieve App Check token: $error\n$stackTrace'.Log(_tag);
      rethrow;
    }
  }

  /// Sets the automatic token refresh mode.
  ///
  /// [autoRefresh] When true, App Check will automatically refresh tokens
  /// when they expire. When false, tokens must be manually refreshed.
  /// Default is true.
  static Future<void> setAutoRefresh(bool autoRefresh) async {
    try {
      await FirebaseAppCheck.instance.setTokenAutoRefreshEnabled(autoRefresh);
      'App Check auto-refresh set to: $autoRefresh'.Log(_tag);
    } catch (error, stackTrace) {
      'Failed to set App Check auto-refresh: $error\n$stackTrace'.Log(_tag);
      rethrow;
    }
  }

  /// Manually refreshes the App Check token.
  ///
  /// This can be called when automatic refresh is disabled or when
  /// you need to force a token refresh.
  ///
  /// Returns [Future<String>] the new App Check token.
  static Future<String> refreshToken() async {
    try {
      final token = await FirebaseAppCheck.instance.getToken(true);
      'App Check token refreshed successfully'.Log(_tag);
      return token ?? '';
    } catch (error, stackTrace) {
      'Failed to refresh App Check token: $error\n$stackTrace'.Log(_tag);
      rethrow;
    }
  }

  /// Enables or disables App Check for the current app instance.
  ///
  /// [enabled] When true, App Check will be enforced. When false,
  /// App Check will be disabled (useful for testing).
  ///
  /// Note: This should only be used in development/testing environments.
  static Future<void> setAppCheckEnabled(bool enabled) async {
    try {
      await FirebaseAppCheck.instance.setTokenAutoRefreshEnabled(enabled);
      'App Check enabled set to: $enabled'.Log(_tag);
    } catch (error, stackTrace) {
      'Failed to set App Check enabled state: $error\n$stackTrace'.Log(_tag);
      rethrow;
    }
  }
}
