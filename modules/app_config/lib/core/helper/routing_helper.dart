import 'dart:async';

import 'package:get/get.dart';

/// [RoutingHelper] provides a centralized way to manage navigation using GetX.
///
/// Priority:
/// - HIGH: Basic navigation (to, back, redirect).
/// - MEDIUM: Auth-related navigation (after login, logout).
/// - LOW: Specialized transitions.
class RoutingHelper {
  // Private constructor for Singleton pattern
  RoutingHelper._internal();

  /// Single instance of [RoutingHelper]
  static final RoutingHelper instance = RoutingHelper._internal();

  // ===========================================================================
  // 1. BASIC NAVIGATION (High Priority)
  // ===========================================================================

  /// Navigates to a new page by its [routeName].
  ///
  /// Equivalent to `Navigator.pushNamed`.
  void navigateTo(String routeName, {dynamic arguments}) {
    Get.toNamed(routeName, arguments: arguments);
  }

  /// Navigates to a new page and replaces the current one.
  ///
  /// Equivalent to `Navigator.pushReplacementNamed`.
  void replaceWith(String routeName, {dynamic arguments}) {
    Get.offNamed(routeName, arguments: arguments);
  }

  /// Clears the entire navigation stack and opens the [routeName].
  ///
  /// Commonly used for moving to Home after Login or Login after Logout.
  void clearStackAndNavigateTo(String routeName, {dynamic arguments}) {
    Get.offAllNamed(routeName, arguments: arguments);
  }

  /// Goes back to the previous page.
  ///
  /// Equivalent to `Navigator.pop`.
  void goBack<T>({T? result}) {
    Get.back(result: result);
  }

  // ===========================================================================
  // 2. AUTHENTICATION NAVIGATION (Medium Priority)
  // ===========================================================================

  /// Handles navigation logic after a successful login.
  ///
  /// [onAction] can be used to perform extra logic (like saving tokens)
  /// before moving to the Home screen.
  Future<void> navigateAfterLogin({
    String targetRoute = "/home",
    FutureOr<void> Function()? onAction,
  }) async {
    // 1. Perform any pending actions (e.g., refreshing user profile)
    await onAction?.call();

    // 2. Move to Home and clear login stack
    Get.offAllNamed(targetRoute);
  }

  /// Handles the logout navigation flow.
  ///
  /// Typically clears all user data and takes them back to the login/logout screen.
  Future<void> navigateToLogout({String logoutRoute = '/logout'}) async {
    // Small delay allows for any cleanup or smooth UI transition
    await Future.delayed(const Duration(milliseconds: 300));

    // Clear everything and go to logout/login page
    Get.offAllNamed(logoutRoute);
  }
}
