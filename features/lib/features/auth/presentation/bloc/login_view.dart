import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../pages/cc_login_page.dart';
import 'login_cubit.dart';
import 'login_state.dart';

@RoutePage()
class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<LoginCubit, LoginState>(
      listener: (context, state) {
        if (state is LoginSuccess) {}
      },
      builder: (context, state) {
        return CcLoginPage(
          emailController: emailController,
          passwordController: passwordController,
          isLoading: state is LoginLoading,
          errorMessage: state is LoginError ? state.message : null,
          onLoginPressed: () {
            context.read<LoginCubit>().login(
              emailController.text,
              passwordController.text,
            );
          },
        );
      },
    );
  }
}
