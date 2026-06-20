import 'dart:async';
import 'dart:convert';

import 'package:data/domain/entities/auth/cc_phone_auth_event.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:logger/logger.dart';
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
  String? _phoneNumber;
  final Logger _logger = Logger(printer: SimplePrinter());
  StreamSubscription<CcPhoneAuthEvent>? _verificationSubscription;

  PhoneAuthBloc(
    this._verifyPhoneNumberUseCase,
    this._signInWithPhoneNumberUseCase,
  ) : super(const PhoneAuthInitial()) {
    on<VerifyPhoneNumberStarted>(_onVerifyPhoneNumberStarted);
    on<SignInWithCodeStarted>(_onSignInWithCodeStarted);
    on<ResetPhoneAuthStarted>(_onResetPhoneAuthStarted);
  }

  String? get phoneNumber => _phoneNumber;

  void _onResetPhoneAuthStarted(
    ResetPhoneAuthStarted event,
    Emitter<PhoneAuthState> emit,
  ) {
    _logger.i('PhoneAuthBloc: ResetPhoneAuthStarted event received');
    _verificationId = null;
    _phoneNumber = null;
    // Cancel ongoing verification if any
    _verificationSubscription?.cancel();
    _verificationSubscription = null;
    emit(const PhoneAuthInitial());
  }

  Future<void> _onVerifyPhoneNumberStarted(
    VerifyPhoneNumberStarted event,
    Emitter<PhoneAuthState> emit,
  ) async {
    _logger.i('PhoneAuthBloc: VerifyPhoneNumberStarted event received');
    _logger.i('PhoneAuthBloc: Phone number: ${event.phoneNumber}');

    if (event.phoneNumber.isEmpty) {
      _logger.w('PhoneAuthBloc: Phone number is empty');
      emit(const PhoneAuthError(CcLocaleKeys.validation_required));
      return;
    }

    _phoneNumber = event.phoneNumber;
    _logger.i('PhoneAuthBloc: Emitting PhoneAuthLoading state');
    emit(const PhoneAuthLoading());

    try {
      _logger.i('PhoneAuthBloc: Calling verifyPhoneNumberUseCase');
      // Cancel any existing subscription before starting a new one
      _verificationSubscription?.cancel();

      _verificationSubscription = _verifyPhoneNumberUseCase(
        phoneNumber: event.phoneNumber,
      ).listen(
        (phoneEvent) {
          _logger.i('PhoneAuthBloc: Received phone event: $phoneEvent');

          // If verification was cancelled/reset, ignore the event
          if (_verificationSubscription == null) {
            _logger.i(
              'PhoneAuthBloc: Verification was cancelled, ignoring event: $phoneEvent',
            );
            return;
          }

          // If we already reached success (manually or automatically),
          // don't let background events (like timeouts) overwrite it.
          if (state is PhoneAuthSuccess) {
            _logger.i(
              'PhoneAuthBloc: Already in Success state, ignoring event: $phoneEvent',
            );
            return;
          }

          if (phoneEvent is CcPhoneCodeSent) {
            _verificationId = phoneEvent.verificationId;
            _logger.i(
              'PhoneAuthBloc: Code sent, verificationId: $_verificationId',
            );
            emit(const PhoneAuthCodeSent());
          } else if (phoneEvent is CcPhoneVerificationCompleted) {
            _logger.i('PhoneAuthBloc: Verification completed successfully');
            emit(PhoneAuthSuccess(phoneEvent.user));
          } else if (phoneEvent is CcPhoneVerificationFailed) {
            _logger.e(
              'PhoneAuthBloc: Verification failed: ${phoneEvent.failure.message}',
            );
            emit(PhoneAuthError(phoneEvent.failure.message));
          } else if (phoneEvent is CcPhoneCodeAutoRetrievalTimeout) {
            _logger.i('PhoneAuthBloc: Auto-retrieval timed out');
            // Keep the CodeSent state so the user can still enter the code manually
            emit(const PhoneAuthCodeSent());
          }
        },
        onError: (error, stackTrace) {
          _logger.e('PhoneAuthBloc: Error in stream: $error');
          _logger.e('PhoneAuthBloc: Stack trace: $stackTrace');
          if (_verificationSubscription != null) {
            emit(const PhoneAuthError(CcLocaleKeys.app_error_general));
          }
        },
      );
    } catch (e) {
      _logger.e('PhoneAuthBloc: Exception in _onVerifyPhoneNumberStarted: $e');
      emit(const PhoneAuthError(CcLocaleKeys.app_error_general));
    }
  }

  Future<void> _onSignInWithCodeStarted(
    SignInWithCodeStarted event,
    Emitter<PhoneAuthState> emit,
  ) async {
    _logger.i('PhoneAuthBloc: SignInWithCodeStarted event received');
    _logger.i('PhoneAuthBloc: SMS code: ${event.smsCode}');
    _logger.i('PhoneAuthBloc: Verification ID: $_verificationId');

    if (event.smsCode.isEmpty) {
      _logger.w('PhoneAuthBloc: SMS code is empty');
      emit(const PhoneAuthError(CcLocaleKeys.validation_required));
      return;
    }

    if (_verificationId == null) {
      _logger.w('PhoneAuthBloc: Verification ID is null');
      emit(const PhoneAuthError(CcLocaleKeys.app_error_general));
      return;
    }

    _logger.i('PhoneAuthBloc: Emitting PhoneAuthLoading state');
    emit(const PhoneAuthLoading());

    _logger.i('PhoneAuthBloc: Calling signInWithPhoneNumberUseCase');
    final result = await _signInWithPhoneNumberUseCase(
      verificationId: _verificationId!,
      smsCode: event.smsCode,
    );

    final resultStr = result.when(
      (user) => jsonEncode(user.toJson()),
      (failure) => failure.message,
    );
    _logger.i('PhoneAuthBloc: Sign in result: $resultStr');

    result.when(
      (user) {
        _logger.i('PhoneAuthBloc: Sign in successful');
        emit(PhoneAuthSuccess(user));
      },
      (failure) {
        _logger.e('PhoneAuthBloc: Sign in failed: ${failure.message}');
        emit(PhoneAuthError(failure.message));
      },
    );
  }

  @override
  Future<void> close() {
    _verificationSubscription?.cancel();
    return super.close();
  }
}
