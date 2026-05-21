import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

import '../../domain/entities/cc_biometric_auth_result.dart';
import '../../domain/models/cc_biometric_auth_type.dart';
import '../../domain/repositories/cc_biometric_auth_repository.dart';
import '../../domain/usecases/cc_authenticate_with_biometrics.dart';

part 'biometric_event.dart';
part 'biometric_state.dart';

@injectable
class BiometricBloc extends Bloc<BiometricEvent, BiometricState> {
  final CcAuthenticateWithBiometrics _authenticateWithBiometrics;
  final CcBiometricAuthRepository _repository;

  BiometricBloc(this._authenticateWithBiometrics, this._repository)
    : super(BiometricInitial()) {
    on<CheckBiometricAvailability>(_onCheckAvailability);
    on<AuthenticateWithBiometric>(_onAuthenticate);
  }

  Future<void> _onCheckAvailability(
    CheckBiometricAvailability event,
    Emitter<BiometricState> emit,
  ) async {
    emit(BiometricLoading());
    final isAvailableResult = await _repository.isBiometricAvailable();
    final typesResult = await _repository.getAvailableBiometrics();

    isAvailableResult.when((isAvailable) {
      typesResult.when(
        (types) =>
            emit(BiometricAvailable(isAvailable: isAvailable, types: types)),
        (error) => emit(BiometricError(message: error.toString())),
      );
    }, (error) => emit(BiometricError(message: error.toString())));
  }

  Future<void> _onAuthenticate(
    AuthenticateWithBiometric event,
    Emitter<BiometricState> emit,
  ) async {
    emit(BiometricLoading());
    final result = await _authenticateWithBiometrics(
      CcAuthenticateWithBiometricsParams(
        localizedReason: event.localizedReason,
      ),
    );

    result.when(
      (authResult) => emit(BiometricAuthenticated(result: authResult)),
      (error) => emit(BiometricError(message: error.toString())),
    );
  }
}
