import 'package:data/domain/entities/auth/cc_phone_auth_event.dart';
import 'package:data/domain/repositories/auth/cc_auth_repository.dart';
import 'package:injectable/injectable.dart';

@lazySingleton
class VerifyPhoneNumberUseCase {
  final CcAuthRepository _repository;

  VerifyPhoneNumberUseCase(this._repository);

  Stream<CcPhoneAuthEvent> call({required String phoneNumber}) {
    return _repository.verifyPhoneNumber(phoneNumber: phoneNumber);
  }
}
