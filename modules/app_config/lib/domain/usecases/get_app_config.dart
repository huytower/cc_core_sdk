import 'package:cc_sdk/domain/failures/app_config/app_config_failure.dart';
import 'package:cc_sdk/domain/failures/cc_failure.dart';
import 'package:injectable/injectable.dart';
import 'package:multiple_result/multiple_result.dart';

import '../entities/app_config_entity.dart';
import '../repositories/app_config_repository.dart';

/// Use case for getting the application configuration API from BE
@lazySingleton
class GetAppConfig {
  final AppConfigRepository repository;

  const GetAppConfig(this.repository);

  /// Calls the repository to get the app configuration.
  ///
  /// Returns a [Result] containing either a [Failure] or the [AppConfigEntity].
  Future<Result<AppConfigEntity, Failure>> call() async {
    try {
      final config = await repository.getConfig();
      return Success(config);
    } on Failure catch (e) {
      return Error(e);
    } catch (e) {
      return Error(ConfigFailure('Failed to get app config: $e'));
    }
  }
}
