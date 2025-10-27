import 'dart:async';

import 'package:cc_sdk/core/extensions/export_extensions.dart';
import 'package:flutter/services.dart';
import 'package:local_auth/local_auth.dart';
import 'package:local_auth_android/local_auth_android.dart';
import 'package:local_auth_darwin/local_auth_darwin.dart';

import '../../../domain/models/cc_biometric_auth_type.dart';

/// Data source for handling local biometric authentication
class CcBiometricAuthDatasource {
  final LocalAuthentication _auth;
  bool _canAuthenticate = false;

  /// Error code constants (matching local_auth package)
  static const String notAvailable = 'NotAvailable';
  static const String notEnrolled = 'NotEnrolled';
  static const String lockedOut = 'LockedOut';
  static const String permanentlyLockedOut = 'PermanentlyLockedOut';
  static const String passcodeNotSet = 'PasscodeNotSet';
  static const String userCanceled = 'UserCanceled';
  static const String appCanceled = 'AppCanceled';
  static const String systemCanceled = 'SystemCanceled';

  /// Get the current authentication status
  bool get canAuthenticate => _canAuthenticate;

  CcBiometricAuthDatasource() : _auth = LocalAuthentication();

  /// Initialize the biometric authentication
  Future<void> initialize() async {
    try {
      _canAuthenticate =
          await _auth.canCheckBiometrics || await _auth.isDeviceSupported();
    } on PlatformException catch (e) {
      'Biometric initialization error: ${e.message}'.Log();
      _canAuthenticate = false;
    }
  }

  /// Check if biometric authentication is available and enrolled
  Future<bool> isBiometricAvailable() async {
    try {
      return await _auth.canCheckBiometrics &&
          await _auth.isDeviceSupported() &&
          (await _auth.getAvailableBiometrics()).isNotEmpty;
    } on PlatformException {
      return false;
    }
  }

  /// Get available biometric types
  Future<List<CcBiometricAuthType>> getAvailableBiometrics() async {
    try {
      final biometrics = await _auth.getAvailableBiometrics();
      return biometrics.map((type) {
        switch (type) {
          case BiometricType.face:
            return CcBiometricAuthType.face;
          case BiometricType.fingerprint:
            return CcBiometricAuthType.fingerprint;
          default:
            return CcBiometricAuthType.none;
        }
      }).toList();
    } on PlatformException {
      return [CcBiometricAuthType.none];
    }
  }

  /// Authenticate using biometrics
  Future<bool> authenticate({
    required String localizedReason,
    String? androidSignInTitle,
    String? cancelButtonText = 'Cancel',
    bool biometricOnly = true,
    bool sensitiveTransaction = false,
  }) async {
    if (!_canAuthenticate) {
      'Biometric authentication not available'.Log();
      return false;
    }

    try {
      final result = await _auth.authenticate(
        localizedReason: localizedReason,
        biometricOnly: biometricOnly,
        sensitiveTransaction: sensitiveTransaction,
        authMessages: [
          AndroidAuthMessages(
            signInTitle: androidSignInTitle ?? 'Authentication required',
            cancelButton: cancelButtonText,
          ),
          const IOSAuthMessages(
            cancelButton: 'Cancel',
            localizedFallbackTitle:
                'Please enable biometrics for this app in Settings.',
          ),
        ],
      );

      return result;
    } on PlatformException catch (e) {
      _handleBiometricError(e);
      return false;
    }
  }

  /// Handle different biometric authentication errors
  void _handleBiometricError(PlatformException e) {
    switch (e.code) {
      case notAvailable:
        'Biometric authentication is not available on this device.'.Log();
        break;
      case notEnrolled:
        'No biometrics enrolled on this device.'.Log();
        break;
      case lockedOut:
        'Too many failed attempts. Try again later.'.Log();
        break;
      case permanentlyLockedOut:
        'Biometric authentication is permanently locked out.'.Log();
        break;
      case passcodeNotSet:
        'No passcode is set on the device.'.Log();
        break;
      case userCanceled:
        'Authentication was canceled by user.'.Log();
        break;
      case appCanceled:
        'Authentication was canceled by the app.'.Log();
        break;
      case systemCanceled:
        'Authentication was canceled by the system.'.Log();
        break;
      default:
        'Authentication error: ${e.message}'.Log();
        break;
    }
  }
}
