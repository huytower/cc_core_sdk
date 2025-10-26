import 'package:multiple_result/multiple_result.dart';

import '../../../../core/error/failures.dart';
import '../entities/app_config_entity.dart';
import '../repositories/app_config_repository.dart';
import 'check_update_required.dart';

/// Use case for refreshing the application configuration.
class RefreshAppConfig {
  final AppConfigRepository repository;

  const RefreshAppConfig(this.repository);

  /// Refreshes the app configuration from the remote source.
  ///
  /// Returns a [Result] containing either a [Failure] or the updated [AppConfigEntity].
  Future<Result<AppConfigEntity, Failure>> call() async {
    try {
      final config = await repository.refreshConfig();
      return Success(config);
    } on Failure catch (e) {
      return Error(e);
    } catch (e) {
      return Error(ConfigFailure(message: 'Failed to refresh app config: $e'));
    }
  }
}
