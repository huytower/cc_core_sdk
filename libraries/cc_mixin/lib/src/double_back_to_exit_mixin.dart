import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// Mixin for implementing "press back twice to exit" functionality.
///
/// Provides platform-specific back button handling:
/// - Android: Requires two back presses within 1 second to exit
/// - iOS: Respects default swipe gesture (1 swipe to exit)
///
/// Override [handleCustomNavigation] to handle custom navigation logic
/// (e.g., navigate to index 0 before allowing exit).
///
/// Override [shouldEnableDoubleBackToExit] to control when double back
/// behavior is enabled (e.g., only on index 0).
///
/// Example:
/// ```dart
/// class MyWidgetState extends State<MyWidget> with DoubleBackToExitMixin {
///   @override
///   bool handleCustomNavigation() {
///     if (currentIndex != 0) {
///       setIndex(0);
///       return true;
///     }
///     return false;
///   }
///
///   @override
///   bool get shouldEnableDoubleBackToExit => currentIndex == 0;
///
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
  bool _canPop = false;
  static const _messageDuration = Duration(seconds: 1);

  /// Message shown on first back press.
  ///
  /// Override this to provide localized message.
  String get backPressMessage => 'Press back again to exit';

  /// Enable double back behavior on iOS (default: false).
  bool get enableDoubleBackOnIOS => false;

  /// Handle custom navigation before double back logic.
  ///
  /// Return true to prevent double back logic (navigation handled),
  /// false to proceed with double back check.
  bool handleCustomNavigation() => false;

  /// Enable double back to exit behavior.
  ///
  /// Return true to require double back, false to allow single back.
  bool get shouldEnableDoubleBackToExit => true;

  /// Check if the route can pop.
  bool get canPop {
    if (Platform.isIOS && !enableDoubleBackOnIOS) return true;
    return _canPop;
  }

  /// Handle back press invocation.
  void onPopInvoked(bool didPop) {
    if (didPop) return;
    if (Platform.isIOS && !enableDoubleBackOnIOS) return;
    if (handleCustomNavigation()) return;

    if (!shouldEnableDoubleBackToExit) {
      setState(() => _canPop = true);
      Navigator.of(context).pop();
      return;
    }

    final now = DateTime.now();
    final isFirstPress =
        _lastBackPressedAt == null ||
        now.difference(_lastBackPressedAt!) > _messageDuration;

    if (isFirstPress) {
      _lastBackPressedAt = now;
      _canPop = false;
      _showBackPressMessage();
      Future.delayed(_messageDuration, () {
        if (mounted) setState(() => _canPop = true);
      });
    } else {
      setState(() => _canPop = true);
      SystemNavigator.pop();
    }
  }

  /// Show back press message to user.
  void _showBackPressMessage() {
    final scaffoldMessenger = ScaffoldMessenger.of(context);

    // Clear any existing snackbars to prevent stacking
    scaffoldMessenger.hideCurrentSnackBar();

    scaffoldMessenger.showSnackBar(
      SnackBar(
        content: Text(
          backPressMessage,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w500,
          ),
        ),
        duration: _messageDuration,
        behavior: SnackBarBehavior.floating,
        // Modern styling: rounded corners and slight margin
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        margin: const EdgeInsets.all(16),
        // Use a subtle dark theme or your primary brand color
        backgroundColor: Colors.grey[850],
        elevation: 6,
      ),
    );
  }

  @override
  void dispose() {
    _lastBackPressedAt = null;
    super.dispose();
  }
}
