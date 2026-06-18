import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../pages/phone_auth_page.dart';
import 'phone_auth_cubit.dart';
import 'phone_auth_state.dart';

@RoutePage()
class PhoneAuthView extends StatefulWidget {
  const PhoneAuthView({super.key});

  @override
  State<PhoneAuthView> createState() => _PhoneAuthViewState();
}

class _PhoneAuthViewState extends State<PhoneAuthView> {
  final phoneController = TextEditingController();
  final codeController = TextEditingController();

  @override
  void dispose() {
    phoneController.dispose();
    codeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<PhoneAuthCubit, PhoneAuthState>(
      listener: (context, state) {
        if (state is PhoneAuthSuccess) {
          // Navigate to home or pop
          context.router.popForced();
        }
      },
      builder: (context, state) {
        return CcPhoneAuthPage(
          phoneController: phoneController,
          codeController: codeController,
          isLoading: state is PhoneAuthLoading,
          isCodeSent: state is PhoneAuthCodeSent,
          errorMessage: state is PhoneAuthError ? state.message : null,
          onVerifyPressed: () {
            context.read<PhoneAuthCubit>().verifyPhoneNumber(
              phoneController.text,
            );
          },
          onSignInPressed: () {
            context.read<PhoneAuthCubit>().signInWithCode(codeController.text);
          },
        );
      },
    );
  }
}
