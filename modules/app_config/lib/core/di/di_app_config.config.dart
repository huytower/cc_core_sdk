// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format width=80

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:get_it/get_it.dart' as _i174;
import 'package:injectable/injectable.dart' as _i526;

import '../../data/datasource/local/box/app_storage/cc_app_storage.dart'
    as _i811;
import '../../data/datasource/local/box/device_info/cc_device_info.dart'
    as _i24;
import '../../data/datasource/remote/app_version_api.dart' as _i65;
import '../../data/repositories/app_config_repository_impl.dart' as _i701;
import '../../domain/repositories/app_config_repository.dart' as _i79;
import '../../domain/usecases/check_update_required.dart' as _i935;
import '../../domain/usecases/get_app_config.dart' as _i897;
import '../../domain/usecases/get_feature_flag.dart' as _i1044;
import '../../domain/usecases/refresh_app_config.dart' as _i75;
import 'module/dependencies.dart' as _i264;

extension GetItInjectableX on _i174.GetIt {
  // initializes the registration of main-scope dependencies inside of GetIt
  _i174.GetIt init({
    String? environment,
    _i526.EnvironmentFilter? environmentFilter,
  }) {
    final gh = _i526.GetItHelper(this, environment, environmentFilter);
    final appConfigDependencies = _$AppConfigDependencies();
    gh.lazySingleton<_i811.CcAppStorage>(
      () => appConfigDependencies.ccAppStorage,
    );
    gh.lazySingleton<_i24.CcDeviceInfo>(
      () => appConfigDependencies.ccDeviceInfo,
    );
    gh.lazySingleton<_i65.AppVersionAPI>(() => _i65.AppVersionAPI());
    gh.lazySingleton<_i79.AppConfigRepository>(
      () => _i701.AppConfigRepositoryImpl(gh<_i65.AppVersionAPI>()),
    );
    gh.lazySingleton<_i935.CheckUpdateRequired>(
      () => _i935.CheckUpdateRequired(gh<_i79.AppConfigRepository>()),
    );
    gh.lazySingleton<_i897.GetAppConfig>(
      () => _i897.GetAppConfig(gh<_i79.AppConfigRepository>()),
    );
    gh.lazySingleton<_i1044.GetFeatureFlag>(
      () => _i1044.GetFeatureFlag(gh<_i79.AppConfigRepository>()),
    );
    gh.lazySingleton<_i75.RefreshAppConfig>(
      () => _i75.RefreshAppConfig(gh<_i79.AppConfigRepository>()),
    );
    return this;
  }
}

class _$AppConfigDependencies extends _i264.AppConfigDependencies {}
