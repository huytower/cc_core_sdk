import 'package:multiple_result/multiple_result.dart';

import '../../../../core/error/failures.dart';
import '../repositories/app_config_repository.dart';

/// Use case for checking if an app update is required.
class CheckUpdateRequired {
  final AppConfigRepository repository;

  const CheckUpdateRequired(this.repository);

  /// Checks if an update is required for the given [currentVersion].
  ///
  /// Returns a [Result] containing either a [Failure] or a [bool] indicating if an update is required.
  Future<Result<bool, Failure>> call(String currentVersion) async {
    try {
      final isRequired = await repository.isUpdateRequired(currentVersion);
      return Success(isRequired);
    } on Failure catch (e) {
      return Error(e);
    } catch (e) {
      return Error(
          ConfigFailure(message: 'Failed to check update requirement: $e'));
    }
  }
}

/// Failure specific to configuration operations.
class ConfigFailure extends Failure {
  final String message;

  const ConfigFailure({required this.message}) : super(message: '');

  @override
  List<Object> get props => [message];
}
