import 'package:cc_sdk_ui/export_cc_sdk_ui.dart';
import 'package:easy_localization/easy_localization.dart' as el;
import 'package:flutter/material.dart';
import 'package:message/cc_locale_keys.dart';

/// A state-management agnostic Login Page.
///
/// This page demonstrates how to build a UI that respects the project's
/// theme, typography, and responsiveness while remaining decoupled
/// from any specific state management (GetX/Bloc).
class CcLoginPage extends StatelessWidget {
  final VoidCallback? onLoginPressed;
  final TextEditingController emailController;
  final TextEditingController passwordController;
  final bool isLoading;
  final String? errorMessage;

  const CcLoginPage({
    super.key,
    required this.emailController,
    required this.passwordController,
    this.onLoginPressed,
    this.isLoading = false,
    this.errorMessage,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.ccColorScheme.surface,
      body: SafeArea(
        child: CcResponsiveContainer(
          alignment: Alignment.center,
          padding: EdgeInsets.all(context.respPadding(24)),
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Logo or Icon
                Icon(
                  Icons.lock_outline,
                  size: context.respIconSize(baseSize: 80),
                  color: context.ccColorScheme.primary,
                ),
                SizedBox(height: context.respPadding(32)),

                // Title
                CcText(
                  el.tr(CcLocaleKeys.auth_login),
                  textStyle: context.ccTextTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: context.ccColorScheme.onSurface,
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: context.respPadding(8)),

                // Subtitle
                CcText(
                  el.tr(CcLocaleKeys.home_welcome),
                  textStyle: context.ccTextTheme.bodyMedium?.copyWith(
                    color: context.ccColorScheme.onSurfaceVariant,
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: context.respPadding(48)),

                // Email Field
                TextField(
                  controller: emailController,
                  decoration: InputDecoration(
                    labelText: el.tr(CcLocaleKeys.auth_email),
                    prefixIcon: const Icon(Icons.email_outlined),
                  ),
                  keyboardType: TextInputType.emailAddress,
                ),
                SizedBox(height: context.respPadding(16)),

                // Password Field
                TextField(
                  controller: passwordController,
                  decoration: InputDecoration(
                    labelText: el.tr(CcLocaleKeys.auth_password),
                    prefixIcon: const Icon(Icons.lock_open_outlined),
                  ),
                  obscureText: true,
                ),

                // Error Message
                if (errorMessage != null) ...[
                  SizedBox(height: context.respPadding(16)),
                  CcText(
                    el.tr(errorMessage!),
                    textStyle: context.ccTextTheme.bodySmall?.copyWith(
                      color: context.ccColorScheme.error,
                    ),
                  ),
                ],

                SizedBox(height: context.respPadding(32)),

                // Login Button
                if (isLoading)
                  const Center(child: CircularProgressIndicator())
                else
                  CcBaseBtn(
                    onTap: onLoginPressed ?? () {},
                    title: el.tr(CcLocaleKeys.auth_login),
                  ),

                SizedBox(height: context.respPadding(16)),

                // Sign Up Link (Placeholder)
                TextButton(
                  onPressed: () {},
                  child: CcText(
                    el.tr(CcLocaleKeys.auth_no_account),
                    textStyle: context.ccTextTheme.bodyMedium?.copyWith(
                      color: context.ccColorScheme.primary,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
