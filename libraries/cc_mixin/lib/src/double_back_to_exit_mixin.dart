import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// Mixin for implementing "press back twice to exit" functionality.
///
/// This mixin provides a consistent way to handle back button presses
/// across Android and iOS platforms:
/// - Android: Requires two back button presses within 2 seconds to exit
/// - iOS: Respects the swipe gesture (no double-tap needed)
///
/// Usage:
/// ```dart
/// class MyWidgetState extends State<MyWidget> with DoubleBackToExitMixin {
///   @override
///   Widget build(BuildContext context) {
///     return PopScope(
///       canPop: canPop,
///       onPopInvoked: onPopInvoked,
///       child: Scaffold(...),
///     );
///   }
/// }
/// ```
mixin DoubleBackToExitMixin<T extends StatefulWidget> on State<T> {
  DateTime? _lastBackPressedAt;
  static const Duration _backPressWindow = Duration(seconds: 2);
  bool _canPop = false;

  /// Message shown when user presses back for the first time.
  String get backPressMessage => 'Press back again to exit';

  /// Whether to enable double back to exit on iOS.
  /// iOS uses swipe gesture by default, so this is typically false.
  bool get enableDoubleBackOnIOS => false;

  /// Override this to handle custom navigation before double back to exit.
  ///
  /// Return true if navigation was handled (should not proceed with double back logic),
  /// false otherwise.
  bool handleCustomNavigation() {
    print('[DoubleBackToExitMixin] handleCustomNavigation called (default: false)');
    return false;
  }

  /// Override this to check if double back to exit should be enabled.
  ///
  /// Return true if double back to exit should be enabled (e.g., on index 0),
  /// false otherwise (e.g., on other tabs).
  bool get shouldEnableDoubleBackToExit {
    print('[DoubleBackToExitMixin] shouldEnableDoubleBackToExit called (default: true)');
    return true;
  }

  /// Determines whether the route can pop.
  ///
  /// Returns false if waiting for second back press, true otherwise.
  bool get canPop {
    print('[DoubleBackToExitMixin] canPop called, returning: $_canPop');
    // iOS: Allow default behavior (swipe gesture) unless explicitly enabled
    if (Platform.isIOS && !enableDoubleBackOnIOS) {
      print('[DoubleBackToExitMixin] iOS: allowing default behavior');
      return true;
    }
    // Always intercept back press to handle custom navigation or double back logic
    return _canPop;
  }

  /// Handles the back press event.
  ///
  /// Called when a back gesture is invoked.
  void onPopInvoked(bool didPop) {
    print('[DoubleBackToExitMixin] onPopInvoked called, didPop: $didPop');
    print('[DoubleBackToExitMixin] shouldEnableDoubleBackToExit: $shouldEnableDoubleBackToExit');
    if (didPop) {
      print('[DoubleBackToExitMixin] Already popped, returning');
      return;
    }

    // iOS: Allow default behavior (swipe gesture) unless explicitly enabled
    if (Platform.isIOS && !enableDoubleBackOnIOS) {
      print('[DoubleBackToExitMixin] iOS: allowing default behavior');
      return;
    }

    // Check for custom navigation handling (only on actual back press)
    print('[DoubleBackToExitMixin] Calling handleCustomNavigation');
    if (handleCustomNavigation()) {
      print('[DoubleBackToExitMixin] Custom navigation handled, returning');
      return;
    }

    // If double back to exit is not enabled, allow pop immediately
    if (!shouldEnableDoubleBackToExit) {
      print('[DoubleBackToExitMixin] Double back not enabled, allowing pop');
      setState(() => _canPop = true);
      Navigator.of(context).pop();
      return;
    }

    final now = DateTime.now();

    if (_lastBackPressedAt == null ||
        now.difference(_lastBackPressedAt!) > _backPressWindow) {
      // First press or time window expired
      _lastBackPressedAt = now;
      _canPop = false;
      print('[DoubleBackToExitMixin] First back press, showing message');
      _showBackPressMessage();
      // Reset canPop after the window expires
      Future.delayed(const Duration(seconds: 1), () {
        if (mounted) {
          print('[DoubleBackToExitMixin] Resetting canPop to true');
          setState(() => _canPop = true);
        }
      });
    } else {
      // Second press within window - allow exit
      setState(() => _canPop = true);
      print('[DoubleBackToExitMixin] Second back press within window, exiting');
      // Use SystemNavigator.pop() to exit the app on Android
      SystemNavigator.pop();
    }
  }

  /// Shows a message to the user indicating they need to press back again.
  void _showBackPressMessage() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(backPressMessage),
        duration: const Duration(seconds: 1), // Short duration
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  @override
  void dispose() {
    _lastBackPressedAt = null;
    super.dispose();
  }
}
