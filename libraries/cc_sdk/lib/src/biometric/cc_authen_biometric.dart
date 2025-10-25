import 'dart:async';

import 'package:flutter/services.dart';
import 'package:local_auth/local_auth.dart';
import 'package:local_auth_android/local_auth_android.dart';
import 'package:local_auth_darwin/local_auth_darwin.dart';

import '../../core/extensions/utils/logger_extension.dart';

class CcAuthenBiometric {
  final LocalAuthentication _auth = LocalAuthentication();
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

  /// Get the list of available biometric types
  Future<List<BiometricType>> get availableBiometrics async {
    try {
      return await _auth.getAvailableBiometrics();
    } on PlatformException {
      return [];
    }
  }

  /// Check if strong biometrics (Face ID, fingerprint, etc.) are available
  Future<bool> hasStrongBiometrics() async {
    final biometrics = await availableBiometrics;
    return biometrics.contains(BiometricType.strong) ||
        biometrics.contains(BiometricType.face);
  }

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
          (await availableBiometrics).isNotEmpty;
    } on PlatformException {
      return false;
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
      // Check available biometrics first
      final biometrics = await availableBiometrics;
      if (biometrics.isEmpty) {
        'No biometrics enrolled on this device'.Log();
        return false;
      }

      // Check for strong biometrics if required
      if (biometricOnly && !await hasStrongBiometrics()) {
        'Strong biometric authentication not available'.Log();
        return false;
      }

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

  /// Check available biometric types
  Future<List<BiometricType>> getAvailableBiometrics() async {
    try {
      return await _auth.getAvailableBiometrics();
    } on PlatformException {
      return <BiometricType>[];
    }
  }

  /// Check if device supports biometric authentication
  Future<bool> isDeviceSupported() async {
    try {
      return await _auth.isDeviceSupported();
    } on PlatformException {
      return false;
    }
  }
}
