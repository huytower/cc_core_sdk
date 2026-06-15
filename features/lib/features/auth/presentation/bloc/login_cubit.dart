import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:message/cc_locale_keys.dart';

import '../../domain/usecases/login_usecase.dart';
import 'login_state.dart';

@injectable
class LoginCubit extends Cubit<LoginState> {
  final LoginUseCase _loginUseCase;

  LoginCubit(this._loginUseCase) : super(const LoginInitial());

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
}
