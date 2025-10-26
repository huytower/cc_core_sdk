import 'package:cc_sdk/core/exception/error/failure.dart';
import 'package:cc_sdk/domain/repositories/cc_sdk_repository.dart';
import 'package:cc_sdk/domain/usecases/usecase.dart';
import 'package:multiple_result/multiple_result.dart';

class CheckBiometricAvailability implements UseCase<bool, NoParams> {
  final CCSDKRepository repository;

  const CheckBiometricAvailability(this.repository);

  @override
  Future<Result<bool, Failure>> call(NoParams params) async {
    return await repository.isBiometricAvailable();
  }
}
