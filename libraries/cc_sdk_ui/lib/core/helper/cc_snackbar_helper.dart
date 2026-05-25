import 'package:flutter/material.dart';
import 'package:get/get.dart';

/// Utility class for showing snackbars with consistent styling and behavior
class CcSnackBarUtils {
  /// Shows a snackbar with the given parameters
  ///
  /// [message] - The message to display
  /// [duration] - How long the snackbar should be visible (default: 1.3s)
  /// [backgroundColor] - Background color of the snackbar
  /// [textColor] - Text color (default: white)
  /// [actionLabel] - Optional action button label
  /// [onActionPressed] - Callback when action button is pressed
  /// [onDismissed] - Callback when snackbar is dismissed
  /// Receives a [SnackBarClosedReason] indicating how the snackbar was dismissed
  static void showSnackBar({
    required String message,
    Duration? duration,
    Color? backgroundColor,
    Color? textColor,
    String? actionLabel,
    VoidCallback? onActionPressed,
    void Function(SnackBarClosedReason reason)? onDismissed,
  }) {
    final context = Get.context;
    if (context == null) return;

    final snackBar = SnackBar(
      content: Text(
        message,
        style: TextStyle(
          color: textColor ?? Colors.white,
          fontSize: 16,
          height: 1.2,
        ),
      ),
      backgroundColor: backgroundColor ?? Theme.of(context).primaryColor,
      duration: duration ?? const Duration(milliseconds: 1300),
      action: actionLabel != null
          ? SnackBarAction(
              label: actionLabel,
              onPressed: onActionPressed ?? () {},
              textColor: textColor?.withOpacity(0.8) ?? Colors.white70,
            )
          : null,
      onVisible: () {
        // Optional: Add any onVisible callbacks here
      },
      dismissDirection: DismissDirection.horizontal,
      behavior: SnackBarBehavior.floating,
      margin: const EdgeInsets.all(8.0),
    );

    // Show the snackbar
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(snackBar).closed.then((reason) {
        if (onDismissed != null) {
          onDismissed(reason);
        }
      });
  }

  /// Shows a snackbar with default error styling
  static void showErrorSnackBar({
    required String message,
    Duration? duration,
    String? actionLabel,
    VoidCallback? onActionPressed,
  }) {
    showSnackBar(
      message: message,
      duration: duration,
      backgroundColor: Colors.red.shade700,
      textColor: Colors.white,
      actionLabel: actionLabel,
      onActionPressed: onActionPressed,
    );
  }

  /// Shows a snackbar with default success styling
  static void showSuccessSnackBar({
    required String message,
    Duration? duration,
    String? actionLabel,
    VoidCallback? onActionPressed,
  }) {
    showSnackBar(
      message: message,
      duration: duration,
      backgroundColor: Colors.green.shade700,
      textColor: Colors.white,
      actionLabel: actionLabel,
      onActionPressed: onActionPressed,
    );
  }
}
