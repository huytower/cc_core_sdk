import 'dart:io';

import 'package:cc_sdk_ui/core/config/tokens/cc_circular_params.dart';
import 'package:cc_sdk_ui/export_cc_sdk_ui.dart';
import 'package:easy_localization/easy_localization.dart' as el;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:theme/data/data_source/color/prj_color.dart';

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
    CcSnackBarHelper.showSnackBar(
      message: backPressMessage,
      duration: _messageDuration,
      backgroundColor: PrjColors.darkSurface,
      textColor: PrjColors.onPrimary,
      fontWeight: FontWeight.w500,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(CcCircularParams.RADIUS_MD),
      ),
      margin: const EdgeInsets.all(CcPaddingParams.PAGE_SM),
      elevation: 6,
    );
  }

  @override
  void dispose() {
    _lastBackPressedAt = null;
    super.dispose();
  }
}
