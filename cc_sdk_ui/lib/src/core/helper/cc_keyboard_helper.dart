import 'package:flutter/widgets.dart';

/// Shows and hides the on-screen keyboard.
///
/// ```dart
/// CcKeyboardHelper.dismissOnTap(child: const MyForm());
/// ```
class CcKeyboardHelper {
  /// Shows the keyboard by giving focus to [focusNode] (a new node if null).
  ///
  /// With a [context], focus is requested in that context's focus scope;
  /// without one, in the app's root focus scope.
  static void showKeyboard({BuildContext? context, FocusNode? focusNode}) {
    focusNode ??= FocusNode();
    if (context != null) {
      FocusScope.of(context).requestFocus(focusNode);
    } else {
      FocusManager.instance.rootScope.requestFocus(focusNode);
    }
  }

  /// Hides the keyboard by removing focus.
  ///
  /// With a [context], unfocuses that context's focus scope unless it holds
  /// primary focus itself; without one, unfocuses whatever has primary focus.
  static void hideKeyboard({BuildContext? context}) {
    if (context == null) {
      FocusManager.instance.primaryFocus?.unfocus();
    } else {
      final currentFocus = FocusScope.of(context);
      if (!currentFocus.hasPrimaryFocus) {
        currentFocus.unfocus();
      }
    }
  }

  /// Wraps [child] so a tap anywhere on it hides the keyboard.
  ///
  /// [context] - Optional BuildContext to use for hiding keyboard
  /// [behavior] - HitTestBehavior for the GestureDetector
  static Widget dismissOnTap({
    required Widget child,
    BuildContext? context,
    HitTestBehavior behavior = HitTestBehavior.translucent,
  }) {
    return GestureDetector(
      onTap: () => hideKeyboard(context: context),
      behavior: behavior,
      child: child,
    );
  }
}
