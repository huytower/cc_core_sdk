import 'package:cc_library/widget/dialog/base_dialog.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

import 'global_widget_utils.dart' as DialogUtils;

/// A collection of reusable widget utilities and helper functions
/// that provide common UI functionality across the application.
///
/// This includes:
/// - Dialog utilities
/// - Common widget builders
/// - Error handling utilities
/// - UI helper functions

/// Shows a customizable confirmation dialog with optional actions.
///
/// This is a utility function that wraps the common pattern of showing a dialog
/// with confirmation and cancellation options. It handles the dialog's display
/// and user interactions.
///
/// Example usage:
/// ```dart
/// await showDialogConfirm(
///   desc: 'Are you sure you want to delete this item?',
///   onTapConfirm: () => _deleteItem(),
///   status: DialogStatus.WARNING,
/// );
/// ```
///
/// Throws [FlutterError] if there's an issue rendering the dialog.
/// Returns a [Future] that completes when the dialog is dismissed.
Future<void> showDialogConfirm({
  /// Callback when user taps the cancel button
  VoidCallback? onTapCancel,

  /// Callback when user taps the confirm button
  required VoidCallback? onTapConfirm,

  /// Background color of the dialog
  Color? bgColor,

  /// Color of the barrier (background) behind the dialog
  Color? bgColorBarrier,

  /// Text for the confirm/agree button
  String? agreeText,

  /// Text for the cancel button
  String? cancelText,

  /// Color of the confirm button text
  Color? confirmTextColor,

  /// Required description/message to display in the dialog
  required String desc,

  /// Color of the description text
  Color? descTextColor,

  /// Whether action buttons are visible
  required bool isActionBtnVisible,

  /// Whether the dialog can be dismissed by tapping outside
  required bool isAllowDismiss,

  /// Whether the dialog should auto-dismiss after a delay
  required bool isAutoDismiss,

  /// Whether to show the cancel button
  required bool isCancelBtnShown,

  /// The status/type of the dialog (affects styling)
  required DialogStatus status,
}) async {
  try {
    // Add a small delay to ensure proper widget rendering
    await 0.5.delay(() => DialogUtils.showDialogConfirm(
          onTapCancel: onTapCancel,
          onTapConfirm: onTapConfirm,
          agreeText: agreeText,
          bgColor: bgColor,
          cancelText: cancelText,
          confirmTextColor: confirmTextColor,
          desc: desc,
          descTextColor: descTextColor,
          isCancelBtnShown: isCancelBtnShown,
          isActionBtnVisible: isActionBtnVisible,
          status: status,
          isAllowDismiss: isAllowDismiss,
          isAutoDismiss: isAutoDismiss,
          bgColorBarrier: bgColorBarrier,
        ));
  } catch (error, stackTrace) {
    // Log the error and rethrow with more context
    debugPrint('Error showing confirmation dialog: $error');
    debugPrint('Stack trace: $stackTrace');
    rethrow;
  }
}
