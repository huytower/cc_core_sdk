import 'package:injectable/injectable.dart';

import 'package:cc_sdk/core/config/cc_app_track_info.dart';
import '../../core/config/feature_flags.dart';
import '../../core/config/http/http_client/http_client_config.dart';
import '../../domain/entities/app_config_entity.dart';
import '../../domain/repositories/app_config_repository.dart';
import '../datasource/remote/app_version_api.dart';

@LazySingleton(as: AppConfigRepository)
class AppConfigRepositoryImpl implements AppConfigRepository {
  final AppVersionAPI _appVersionAPI;

  AppConfigRepositoryImpl(this._appVersionAPI);

  @override
  Future<AppConfigEntity> getConfig() async {
    final version = await _appVersionAPI.getCurrentVersion();
    final buildNumber = await _appVersionAPI.getBuildNumber();
    final packageName = await _appVersionAPI.getPackageName();
    final httpConfig = HttpClientConfig.httpConfig;

    return AppConfigEntity(
      appName: CcAppTrackName.appName,
      packageName: packageName,
      version: version,
      buildNumber: buildNumber,
      environment: httpConfig.environmentName,
      featureFlags: {
        'enable_logger': FeatureFlags.isEnableLogger,
        'enable_logger_dio': FeatureFlags.isEnableLoggerDio,
        'analytics_enabled': FeatureFlags.isAnalyticsEnabled,
        'crash_reporting_enabled': FeatureFlags.isCrashReportingEnabled,
      },
    );
  }

  @override
  Future<AppConfigEntity> refreshConfig() async {
    // In a real implementation, you might fetch updated config from a remote API
    // and cache it locally before returning the new state.
    return getConfig();
  }

  @override
  Future<T> getFeatureFlag<T>(String key, {required T defaultValue}) async {
    // Implementation can be expanded to check a remote config service (Firebase, etc.)
    if (T == bool) {
      if (key == 'ENABLE_LOGGER') return FeatureFlags.isEnableLogger as T;
      if (key == 'ENABLE_LOGGER_DIO')
        return FeatureFlags.isEnableLoggerDio as T;
      if (key == 'ANALYTICS_ENABLED')
        return FeatureFlags.isAnalyticsEnabled as T;
    }
    return defaultValue;
  }

  @override
  Future<bool> isUpdateRequired(String currentVersion) async {
    // This should ideally compare currentVersion with a min version from BE
    final minVersion = await getMinimumRequiredVersion();
    return _appVersionAPI.isUpdateRequired(minVersion);
  }

  @override
  Future<String> getMinimumRequiredVersion() async {
    // This would typically come from a remote configuration or API
    return '1.0.0';
  }
}
