import 'package:cc_sdk_ui/export_cc_sdk_ui.dart';
import 'package:easy_localization/easy_localization.dart' as el;
import 'package:flutter/material.dart';

/// A state-management agnostic Login Page.
///
/// This page demonstrates how to build a UI that respects the project's
/// theme, typography, and responsiveness while remaining decoupled
/// from any specific state management (GetX/Bloc).
class CcLoginPage extends StatelessWidget {
  final VoidCallback? onLoginPressed;
  final VoidCallback? onGoogleLoginPressed;
  final VoidCallback? onAppleLoginPressed;
  final VoidCallback? onPhoneLoginPressed;
  final TextEditingController emailController;
  final TextEditingController passwordController;
  final bool isLoading;
  final String? errorMessage;

  const CcLoginPage({
    super.key,
    required this.emailController,
    required this.passwordController,
    this.onLoginPressed,
    this.onGoogleLoginPressed,
    this.onAppleLoginPressed,
    this.onPhoneLoginPressed,
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
          padding: EdgeInsets.all(context.respPadding(CcPaddingParams.PAGE_MD)),
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
                const CcSpaceHeader(),

                // Title
                CcText(
                  el.tr(CcLocaleKeys.auth_login),
                  textStyle: context.ccTextTheme.headlineMedium?.copyWith(
                    fontWeight: CcTypographyParams.bold,
                    color: context.ccColorScheme.onSurface,
                  ),
                  textAlign: TextAlign.center,
                ),
                const CcSpaceSM(),

                // Subtitle
                CcText(
                  el.tr(CcLocaleKeys.home_welcome),
                  textStyle: context.ccTextTheme.bodyMedium?.copyWith(
                    color: context.ccColorScheme.onSurfaceVariant,
                  ),
                  textAlign: TextAlign.center,
                ),
                const CcSpaceHeader(),

                // Email Field
                TextField(
                  controller: emailController,
                  decoration: InputDecoration(
                    labelText: el.tr(CcLocaleKeys.auth_email),
                    prefixIcon: const Icon(Icons.email_outlined),
                  ),
                  keyboardType: TextInputType.emailAddress,
                ),
                const CcSpaceLG(),

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
                  const CcSpaceLG(),
                  CcText(
                    el.tr(errorMessage!),
                    textStyle: context.ccTextTheme.bodySmall?.copyWith(
                      color: context.ccColorScheme.error,
                    ),
                  ),
                ],

                SizedBox(height: context.respPadding(CcPaddingParams.PAGE_LG)),

                // Login Button
                if (isLoading)
                  const Center(child: CircularProgressIndicator())
                else
                  CcBaseBtn(
                    onTap: onLoginPressed ?? () {},
                    title: el.tr(CcLocaleKeys.auth_login),
                  ),

                const CcSpaceXL(),

                // Divider
                Row(
                  children: [
                    Expanded(
                      child: Divider(
                        color: context.ccColorScheme.outlineVariant,
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: context.respPadding(
                          CcPaddingParams.PAGE_SM,
                        ),
                      ),
                      child: CcText(
                        el.tr(CcLocaleKeys.common_or),
                        textStyle: context.ccTextTheme.labelMedium,
                      ),
                    ),
                    Expanded(
                      child: Divider(
                        color: context.ccColorScheme.outlineVariant,
                      ),
                    ),
                  ],
                ),

                const CcSpaceXL(),

                // Social Login Buttons
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _SocialButton(
                      icon: Icons
                          .g_mobiledata, // Replace with real asset if available
                      onTap: onGoogleLoginPressed,
                    ),
                    _SocialButton(
                      icon: Icons.apple,
                      onTap: onAppleLoginPressed,
                    ),
                    _SocialButton(
                      icon: Icons.phone_android,
                      onTap: onPhoneLoginPressed,
                    ),
                  ],
                ),

                const CcSpaceLG(),

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

class _SocialButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback? onTap;

  const _SocialButton({required this.icon, this.onTap});

  @override
  Widget build(BuildContext context) {
    return CcInkWell(
      onTap: onTap ?? () {},
      borderRadius: BorderRadius.circular(
        context.respDim(CcPaddingParams.DESC_MD),
      ),
      child: Container(
        padding: EdgeInsets.all(context.respPadding(CcPaddingParams.DESC_MD)),
        decoration: BoxDecoration(
          border: Border.all(color: context.ccColorScheme.outlineVariant),
          borderRadius: BorderRadius.circular(
            context.respDim(CcPaddingParams.DESC_MD),
          ),
        ),
        child: Icon(
          icon,
          size: context.respIconSize(baseSize: 32),
          color: context.ccColorScheme.onSurface,
        ),
      ),
    );
  }
}
