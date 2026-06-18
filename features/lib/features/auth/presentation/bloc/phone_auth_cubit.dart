import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:data/domain/entities/auth/cc_phone_auth_event.dart';
import 'package:data/domain/entities/auth/cc_user_entity.dart';
import 'package:message/cc_locale_keys.dart';

import '../../domain/usecases/verify_phone_number_usecase.dart';
import '../../domain/usecases/sign_in_with_phone_number_usecase.dart';
import 'phone_auth_state.dart';

@injectable
class PhoneAuthCubit extends Cubit<PhoneAuthState> {
  final VerifyPhoneNumberUseCase _verifyPhoneNumberUseCase;
  final SignInWithPhoneNumberUseCase _signInWithPhoneNumberUseCase;
  StreamSubscription? _subscription;
  String? _verificationId;

  PhoneAuthCubit(
    this._verifyPhoneNumberUseCase,
    this._signInWithPhoneNumberUseCase,
  ) : super(const PhoneAuthInitial());

  Future<void> verifyPhoneNumber(String phoneNumber) async {
    if (phoneNumber.isEmpty) {
      emit(const PhoneAuthError(CcLocaleKeys.validation_required));
      return;
    }

    emit(const PhoneAuthLoading());

    await _subscription?.cancel();
    _subscription = _verifyPhoneNumberUseCase(phoneNumber: phoneNumber).listen(
      (event) {
        if (event is CcPhoneCodeSent) {
          _verificationId = event.verificationId;
          emit(const PhoneAuthCodeSent());
        } else if (event is CcPhoneVerificationCompleted) {
          emit(PhoneAuthSuccess(event.user));
        } else if (event is CcPhoneVerificationFailed) {
          emit(PhoneAuthError(event.failure.message));
        }
      },
      onError: (error) {
        emit(const PhoneAuthError(CcLocaleKeys.app_error_general));
      },
    );
  }

  Future<void> signInWithCode(String smsCode) async {
    if (smsCode.isEmpty) {
      emit(const PhoneAuthError(CcLocaleKeys.validation_required));
      return;
    }

    if (_verificationId == null) {
      emit(const PhoneAuthError(CcLocaleKeys.app_error_general));
      return;
    }

    emit(const PhoneAuthLoading());

    final result = await _signInWithPhoneNumberUseCase(
      verificationId: _verificationId!,
      smsCode: smsCode,
    );

    result.when(
      (user) => emit(PhoneAuthSuccess(user)),
      (failure) => emit(PhoneAuthError(failure.message)),
    );
  }

  @override
  Future<void> close() {
    _subscription?.cancel();
    return super.close();
  }
}
