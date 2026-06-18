import 'package:auto_route/auto_route.dart';
import 'package:cc_sdk_ui/export_cc_sdk_ui.dart' hide getIt;
import 'package:easy_localization/easy_localization.dart' as el;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/di/di.dart';
import '../../../../core/navigation/features_router.gr.dart';
import '../bloc/login_bloc.dart';
import '../bloc/login_event.dart';
import '../bloc/login_state.dart';

@RoutePage()
class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => getIt<LoginBloc>(),
      child: const LoginView(),
    );
  }
}

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  late final TextEditingController _emailController;
  late final TextEditingController _passwordController;

  @override
  void initState() {
    super.initState();
    _emailController = TextEditingController();
    _passwordController = TextEditingController();
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<LoginBloc, LoginState>(
      listener: (context, state) {
        if (state is LoginSuccess) {
          // Navigate to main navigation shell using shared route path
          // Using hardcoded path string to avoid cross-module import dependency
          context.router.replacePath('/main_navigation');
        }
      },
      child: Scaffold(
        backgroundColor: context.ccColorScheme.surface,
        body: SafeArea(
          child: CcResponsiveContainer(
            alignment: Alignment.center,
            padding: EdgeInsets.all(
              context.respPadding(CcPaddingParams.PAGE_MD),
            ),
            child: SingleChildScrollView(
              child: BlocBuilder<LoginBloc, LoginState>(
                builder: (context, state) {
                  final isLoading = state is LoginLoading;
                  final errorMessage = state is LoginError
                      ? state.message
                      : null;

                  return Column(
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
                        controller: _emailController,
                        style: context.ccTextTheme.bodyLarge,
                        decoration: InputDecoration(
                          labelText: el.tr(CcLocaleKeys.auth_email),
                          labelStyle: context.ccTextTheme.bodyMedium,
                          prefixIcon: Icon(
                            Icons.email_outlined,
                            color: context.ccColorScheme.primary,
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: context.ccColorScheme.outlineVariant,
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: context.ccColorScheme.primary,
                            ),
                          ),
                        ),
                        keyboardType: TextInputType.emailAddress,
                      ),
                      const CcSpaceLG(),

                      // Password Field
                      TextField(
                        controller: _passwordController,
                        style: context.ccTextTheme.bodyLarge,
                        decoration: InputDecoration(
                          labelText: el.tr(CcLocaleKeys.auth_password),
                          labelStyle: context.ccTextTheme.bodyMedium,
                          prefixIcon: Icon(
                            Icons.lock_open_outlined,
                            color: context.ccColorScheme.primary,
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: context.ccColorScheme.outlineVariant,
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: context.ccColorScheme.primary,
                            ),
                          ),
                        ),
                        obscureText: true,
                      ),

                      // Error Message
                      if (errorMessage != null) ...[
                        const CcSpaceLG(),
                        CcText(
                          el.tr(errorMessage),
                          textStyle: context.ccTextTheme.bodySmall?.copyWith(
                            color: context.ccColorScheme.error,
                          ),
                        ),
                      ],

                      SizedBox(
                        height: context.respPadding(CcPaddingParams.PAGE_LG),
                      ),

                      // Login Button
                      if (isLoading)
                        const Center(child: CircularProgressIndicator())
                      else
                        CcBaseBtn(
                          onTap: () => context.read<LoginBloc>().add(
                            LoginStarted(
                              email: _emailController.text,
                              password: _passwordController.text,
                            ),
                          ),
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
                            icon: Icons.g_mobiledata,
                            onTap: () => context.read<LoginBloc>().add(
                              const LoginWithGoogleStarted(),
                            ),
                          ),
                          _SocialButton(
                            icon: Icons.apple,
                            onTap: () => context.read<LoginBloc>().add(
                              const LoginWithAppleStarted(),
                            ),
                          ),
                          _SocialButton(
                            icon: Icons.phone_android,
                            onTap: () =>
                                context.router.push(const PhoneAuthRoute()),
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
                  );
                },
              ),
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
