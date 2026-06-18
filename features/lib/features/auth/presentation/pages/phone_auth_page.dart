import 'package:auto_route/annotations.dart';
import 'package:cc_sdk_ui/export_cc_sdk_ui.dart' hide getIt;
import 'package:easy_localization/easy_localization.dart' as el;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/di/di.dart';
import '../bloc/phone_auth_bloc.dart';
import '../bloc/phone_auth_event.dart';
import '../bloc/phone_auth_state.dart';

@RoutePage()
class PhoneAuthPage extends StatelessWidget {
  const PhoneAuthPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => getIt<PhoneAuthBloc>(),
      child: const PhoneAuthView(),
    );
  }
}

class PhoneAuthView extends StatefulWidget {
  const PhoneAuthView({super.key});

  @override
  State<PhoneAuthView> createState() => _PhoneAuthViewState();
}

class _PhoneAuthViewState extends State<PhoneAuthView> {
  late final TextEditingController _phoneController;
  late final TextEditingController _codeController;

  @override
  void initState() {
    super.initState();
    _phoneController = TextEditingController();
    _codeController = TextEditingController();
  }

  @override
  void dispose() {
    _phoneController.dispose();
    _codeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<PhoneAuthBloc, PhoneAuthState>(
      listener: (context, state) {
        if (state is PhoneAuthSuccess) {
          // Successful auth navigation
          Navigator.of(context).pop();
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: CcText(
            el.tr(CcLocaleKeys.auth_login_phone),
            textStyle: context.ccTextTheme.titleLarge?.copyWith(
              color: context.ccColorScheme.onSurface,
            ),
          ),
          backgroundColor: context.ccColorScheme.surface,
          elevation: 0,
          leading: CcBackBtn(
            onPress: () => Navigator.of(context).pop(),
            icon: Icons.arrow_back,
          ),
        ),
        backgroundColor: context.ccColorScheme.surface,
        body: SafeArea(
          child: CcResponsiveContainer(
            padding: EdgeInsets.all(
              context.respPadding(CcPaddingParams.PAGE_MD),
            ),
            child: BlocBuilder<PhoneAuthBloc, PhoneAuthState>(
              builder: (context, state) {
                final isLoading = state is PhoneAuthLoading;
                final isCodeSent = state is PhoneAuthCodeSent;
                final errorMessage = state is PhoneAuthError
                    ? state.message
                    : null;

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    if (!isCodeSent) ...[
                      CcText(
                        el.tr(CcLocaleKeys.auth_phone_number),
                        textStyle: context.ccTextTheme.titleLarge,
                      ),
                      const CcSpaceLG(),
                      TextField(
                        controller: _phoneController,
                        style: context.ccTextTheme.bodyLarge,
                        decoration: InputDecoration(
                          labelText: el.tr(CcLocaleKeys.auth_phone_number),
                          labelStyle: context.ccTextTheme.bodyMedium,
                          prefixIcon: Icon(
                            Icons.phone,
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
                          hintText: el.tr(CcLocaleKeys.auth_phone_hint),
                          hintStyle: context.ccTextTheme.bodyMedium?.copyWith(
                            color: context.ccColorScheme.onSurfaceVariant,
                          ),
                        ),
                        keyboardType: TextInputType.phone,
                      ),
                      const CcSpaceXL(),
                      if (isLoading)
                        const Center(child: CircularProgressIndicator())
                      else
                        CcBaseBtn(
                          onTap: () => context.read<PhoneAuthBloc>().add(
                            VerifyPhoneNumberStarted(_phoneController.text),
                          ),
                          title: el.tr(CcLocaleKeys.auth_send_code),
                        ),
                    ] else ...[
                      CcText(
                        el.tr(CcLocaleKeys.auth_enter_code),
                        textStyle: context.ccTextTheme.titleLarge,
                      ),
                      const CcSpaceLG(),
                      TextField(
                        controller: _codeController,
                        style: context.ccTextTheme.bodyLarge,
                        decoration: InputDecoration(
                          labelText: el.tr(CcLocaleKeys.auth_enter_code),
                          labelStyle: context.ccTextTheme.bodyMedium,
                          prefixIcon: Icon(
                            Icons.lock_outline,
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
                        keyboardType: TextInputType.number,
                      ),
                      const CcSpaceXL(),
                      if (isLoading)
                        const Center(child: CircularProgressIndicator())
                      else
                        CcBaseBtn(
                          onTap: () => context.read<PhoneAuthBloc>().add(
                            SignInWithCodeStarted(_codeController.text),
                          ),
                          title: el.tr(CcLocaleKeys.auth_verify),
                        ),
                    ],
                    if (errorMessage != null) ...[
                      const CcSpaceLG(),
                      CcText(
                        el.tr(errorMessage),
                        textStyle: context.ccTextTheme.bodySmall?.copyWith(
                          color: context.ccColorScheme.error,
                        ),
                      ),
                    ],
                  ],
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
