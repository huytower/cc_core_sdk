// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:app_config/config/app_storage/cc_app_storage.dart' as _i148;
import 'package:app_config/config/app_track_log/cc_app_track_log.dart' as _i1033;
import 'package:app_config/config/device_info/cc_device_info.dart' as _i446;
import 'package:app_config/di/module/app_config_module.dart' as _i538;
import 'package:get_it/get_it.dart' as _i174;
import 'package:injectable/injectable.dart' as _i526;

extension GetItInjectableX on _i174.GetIt {
// initializes the registration of main-scope dependencies inside of GetIt
  _i174.GetIt $initAppConfigGetIt({
    String? environment,
    _i526.EnvironmentFilter? environmentFilter,
  }) {
    final gh = _i526.GetItHelper(
      this,
      environment,
      environmentFilter,
    );
    final appConfigModule = _$AppConfigModule();
    gh.lazySingleton<_i148.CcAppStorage>(() => appConfigModule.ccAppStorage);
    gh.lazySingleton<_i446.CcDeviceInfo>(() => appConfigModule.ccDeviceInfo);
    gh.lazySingleton<_i1033.CcAppTrackLog>(() => appConfigModule.ccAppTrackLog);
    return this;
  }
}

class _$AppConfigModule extends _i538.AppConfigModule {}
