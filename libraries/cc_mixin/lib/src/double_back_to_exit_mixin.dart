import 'dart:io';

import 'package:easy_localization/easy_localization.dart' as el;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'double_back_to_exit_snackbar.dart';

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
  static const _doubleBackDuration = Duration(seconds: 1);

  /// Message shown on first back press.
  ///
  /// Override this to provide localized message.
  String get backPressMessage => el.tr('common.press_back_again_to_exit');

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
  ///
  /// On Android, we return false to ensure [onPopInvoked] is called with
  /// didPop=false, allowing us to intercept and handle the double-back logic.
  bool get canPop {
    if (Platform.isIOS && !enableDoubleBackOnIOS) return true;
    return false;
  }

  /// Handle back press invocation.
  void onPopInvoked(bool didPop) {
    debugPrint('DoubleBackToExitMixin: onPopInvoked(didPop: $didPop)');

    // If the system already popped the route, we don't need to do anything.
    if (didPop) {
      debugPrint('DoubleBackToExitMixin: already popped, ignoring');
      return;
    }

    // Platform-specific bypass for iOS if double-back is disabled.
    if (Platform.isIOS && !enableDoubleBackOnIOS) {
      debugPrint('DoubleBackToExitMixin: iOS bypass enabled, ignoring');
      return;
    }

    // 1. Try custom navigation first (e.g., navigate to index 0).
    if (handleCustomNavigation()) {
      debugPrint('DoubleBackToExitMixin: custom navigation handled');
      return;
    }

    // 2. If double back behavior is not enabled (e.g., current index != 0),
    // we exit/pop immediately on first press.
    if (!shouldEnableDoubleBackToExit) {
      debugPrint(
        'DoubleBackToExitMixin: double back disabled, exiting immediately',
      );
      SystemNavigator.pop();
      return;
    }

    // 3. Double-back logic for Android root navigation.
    final now = DateTime.now();
    final isFirstPress =
        _lastBackPressedAt == null ||
        now.difference(_lastBackPressedAt!) > _doubleBackDuration;

    if (isFirstPress) {
      debugPrint('DoubleBackToExitMixin: first press detected');
      _lastBackPressedAt = now;
      _showBackPressMessage();
    } else {
      debugPrint('DoubleBackToExitMixin: second press detected, exiting app');
      // Second press within the time window.
      SystemNavigator.pop();
    }
  }

  /// Show back press message to user.
  void _showBackPressMessage() {
    showDoubleBackPressSnackBar(context, backPressMessage);
  }

  @override
  void dispose() {
    _lastBackPressedAt = null;
    super.dispose();
  }
}
