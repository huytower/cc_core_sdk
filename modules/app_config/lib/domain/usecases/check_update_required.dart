import 'package:cc_sdk/core/failure/app_config/app_config_failure.dart';
import 'package:cc_sdk/core/failure/failure.dart';
import 'package:injectable/injectable.dart';
import 'package:multiple_result/multiple_result.dart';

import '../repositories/app_config_repository.dart';

/// Use case for checking if an app update is required.
@lazySingleton
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
      return Error(ConfigFailure('Failed to check update requirement: $e'));
    }
  }
}
