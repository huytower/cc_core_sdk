import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:message/cc_locale_keys.dart';

import '../../domain/usecases/login_usecase.dart';
import '../../domain/usecases/login_with_google_usecase.dart';
import '../../domain/usecases/login_with_apple_usecase.dart';
import 'login_state.dart';

@injectable
class LoginCubit extends Cubit<LoginState> {
  final LoginUseCase _loginUseCase;
  final LoginWithGoogleUseCase _loginWithGoogleUseCase;
  final LoginWithAppleUseCase _loginWithAppleUseCase;

  LoginCubit(
    this._loginUseCase,
    this._loginWithGoogleUseCase,
    this._loginWithAppleUseCase,
  ) : super(const LoginInitial());

  Future<void> login(String email, String password) async {
    if (email.isEmpty || password.isEmpty) {
      emit(const LoginError(CcLocaleKeys.validation_required));
      return;
    }

    emit(const LoginLoading());

    final result = await _loginUseCase(email, password);

    result.when(
      (user) => emit(LoginSuccess(user)),
      (failure) => emit(LoginError(failure.message)),
    );
  }

  Future<void> loginWithGoogle() async {
    emit(const LoginLoading());
    final result = await _loginWithGoogleUseCase();
    result.when(
      (user) => emit(LoginSuccess(user)),
      (failure) => emit(LoginError(failure.message)),
    );
  }

  Future<void> loginWithApple() async {
    emit(const LoginLoading());
    final result = await _loginWithAppleUseCase();
    result.when(
      (user) => emit(LoginSuccess(user)),
      (failure) => emit(LoginError(failure.message)),
    );
  }
}
