import 'dart:async';

import 'package:data/domain/entities/auth/cc_phone_auth_event.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:message/cc_locale_keys.dart';

import '../../domain/usecases/sign_in_with_phone_number_usecase.dart';
import '../../domain/usecases/verify_phone_number_usecase.dart';
import 'phone_auth_event.dart';
import 'phone_auth_state.dart';

@injectable
class PhoneAuthBloc extends Bloc<PhoneAuthEvent, PhoneAuthState> {
  final VerifyPhoneNumberUseCase _verifyPhoneNumberUseCase;
  final SignInWithPhoneNumberUseCase _signInWithPhoneNumberUseCase;
  String? _verificationId;

  PhoneAuthBloc(
    this._verifyPhoneNumberUseCase,
    this._signInWithPhoneNumberUseCase,
  ) : super(const PhoneAuthInitial()) {
    on<VerifyPhoneNumberStarted>(_onVerifyPhoneNumberStarted);
    on<SignInWithCodeStarted>(_onSignInWithCodeStarted);
  }

  Future<void> _onVerifyPhoneNumberStarted(
    VerifyPhoneNumberStarted event,
    Emitter<PhoneAuthState> emit,
  ) async {
    if (event.phoneNumber.isEmpty) {
      emit(const PhoneAuthError(CcLocaleKeys.validation_required));
      return;
    }

    emit(const PhoneAuthLoading());

    try {
      await emit.forEach(
        _verifyPhoneNumberUseCase(phoneNumber: event.phoneNumber),
        onData: (phoneEvent) {
          if (phoneEvent is CcPhoneCodeSent) {
            _verificationId = phoneEvent.verificationId;
            return const PhoneAuthCodeSent();
          } else if (phoneEvent is CcPhoneVerificationCompleted) {
            return PhoneAuthSuccess(phoneEvent.user);
          } else if (phoneEvent is CcPhoneVerificationFailed) {
            return PhoneAuthError(phoneEvent.failure.message);
          }
          return const PhoneAuthLoading();
        },
        onError: (error, stackTrace) {
          return const PhoneAuthError(CcLocaleKeys.app_error_general);
        },
      );
    } catch (e) {
      emit(const PhoneAuthError(CcLocaleKeys.app_error_general));
    }
  }

  Future<void> _onSignInWithCodeStarted(
    SignInWithCodeStarted event,
    Emitter<PhoneAuthState> emit,
  ) async {
    if (event.smsCode.isEmpty) {
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
      smsCode: event.smsCode,
    );

    result.when(
      (user) => emit(PhoneAuthSuccess(user)),
      (failure) => emit(PhoneAuthError(failure.message)),
    );
  }

  @override
  Future<void> close() {
    return super.close();
  }
}
