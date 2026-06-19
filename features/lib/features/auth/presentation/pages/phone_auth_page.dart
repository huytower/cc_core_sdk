import 'package:auto_route/auto_route.dart';
import 'package:cc_sdk_ui/export_cc_sdk_ui.dart' hide getIt;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/di/di.dart';
import '../bloc/phone_auth_bloc.dart';
import '../bloc/phone_auth_event.dart';
import '../bloc/phone_auth_state.dart';
import 'widgets/phone_auth_card_content.dart';
import 'widgets/phone_auth_gradient_container.dart';

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
  static const String _countryCode = '+84'; // Vietnam default

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

  void _handleContinue() {
    final state = context.read<PhoneAuthBloc>().state;
    final isCodeSent = state is PhoneAuthCodeSent;

    if (!isCodeSent) {
      context.read<PhoneAuthBloc>().add(
        VerifyPhoneNumberStarted(_phoneController.text),
      );
    } else {
      context.read<PhoneAuthBloc>().add(
        SignInWithCodeStarted(_codeController.text),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<PhoneAuthBloc, PhoneAuthState>(
      listener: (context, state) {
        if (state is PhoneAuthSuccess) {
          context.router.replacePath('/main_navigation');
        }
      },
      child: PhoneAuthGradientContainer(
        child: CcKeyboardHelper.dismissOnTap(
          context: context,
          child: BlocBuilder<PhoneAuthBloc, PhoneAuthState>(
            builder: (context, state) {
              final isPortrait = CcResponsiveHelper.isPortrait(context);
              final isLoading = state is PhoneAuthLoading;
              final isCodeSent = state is PhoneAuthCodeSent;
              final errorMessage = state is PhoneAuthError
                  ? state.message
                  : null;

              return Container(
                constraints: BoxConstraints(
                  maxWidth: isPortrait
                      ? context.respDim(500)
                      : context.respDim(600),
                ),
                decoration: BoxDecoration(
                  color: context.ccColorScheme.surface,
                  borderRadius: BorderRadius.circular(
                    context.respDim(CcPaddingParams.DESC_LG),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: context.ccColorScheme.shadow.withOpacity(0.1),
                      blurRadius: context.respDim(20),
                      offset: Offset(0, context.respDim(10)),
                    ),
                  ],
                ),
                padding: EdgeInsets.all(
                  context.respPadding(CcPaddingParams.PAGE_MD),
                ),
                child: PhoneAuthCardContent(
                  isCodeSent: isCodeSent,
                  countryCode: _countryCode,
                  phoneController: _phoneController,
                  codeController: _codeController,
                  onCountryCodeTap: () {},
                  onContinue: _handleContinue,
                  isLoading: isLoading,
                  errorMessage: errorMessage,
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
