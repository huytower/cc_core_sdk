import 'package:flutter/material.dart';
import 'package:get/get.dart';

/// Utility class for showing snackbars with consistent styling and behavior
class CcSnackBarHelper {
  /// Shows a snackbar with the given parameters
  ///
  /// [message] - The message to display
  /// [duration] - How long the snackbar should be visible (default: 1.3s)
  /// [backgroundColor] - Background color of the snackbar
  /// [textColor] - Text color (default: theme onSurface)
  /// [actionLabel] - Optional action button label
  /// [onActionPressed] - Callback when action button is pressed
  /// [onDismissed] - Callback when snackbar is dismissed
  /// Receives a [SnackBarClosedReason] indicating how the snackbar was dismissed
  /// [shape] - Shape of the snackbar (default: null)
  /// [margin] - Margin around the snackbar (default: 8.0)
  /// [elevation] - Elevation of the snackbar (default: null)
  /// [fontWeight] - Font weight of the text (default: normal)
  static void showSnackBar({
    required String message,
    Duration? duration,
    Color? backgroundColor,
    Color? textColor,
    String? actionLabel,
    VoidCallback? onActionPressed,
    void Function(SnackBarClosedReason reason)? onDismissed,
    ShapeBorder? shape,
    EdgeInsetsGeometry? margin,
    double? elevation,
    FontWeight? fontWeight,
  }) {
    final context = Get.context;
    if (context == null) return;

    final theme = Theme.of(context);
    final snackBar = SnackBar(
      content: Text(
        message,
        style: theme.textTheme.bodyLarge?.copyWith(
          color: textColor ?? theme.colorScheme.onSurface,
          height: 1.2,
          fontWeight: fontWeight ?? FontWeight.normal,
        ),
      ),
      backgroundColor: backgroundColor ?? theme.colorScheme.surface,
      duration: duration ?? const Duration(milliseconds: 1300),
      action: actionLabel != null
          ? SnackBarAction(
              label: actionLabel,
              onPressed: onActionPressed ?? () {},
              textColor:
                  textColor?.withOpacity(0.8) ??
                  theme.colorScheme.primary.withOpacity(0.8),
            )
          : null,
      onVisible: () {
        // Optional: Add any onVisible callbacks here
      },
      dismissDirection: DismissDirection.horizontal,
      behavior: SnackBarBehavior.floating,
      margin: margin ?? const EdgeInsets.all(8.0),
      shape: shape,
      elevation: elevation,
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
    final context = Get.context;
    if (context == null) return;

    showSnackBar(
      message: message,
      duration: duration,
      backgroundColor: Theme.of(context).colorScheme.error,
      textColor: Theme.of(context).colorScheme.onError,
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
    final context = Get.context;
    if (context == null) return;

    showSnackBar(
      message: message,
      duration: duration,
      backgroundColor: Theme.of(context).colorScheme.primary,
      textColor: Theme.of(context).colorScheme.onPrimary,
      actionLabel: actionLabel,
      onActionPressed: onActionPressed,
    );
  }
}
