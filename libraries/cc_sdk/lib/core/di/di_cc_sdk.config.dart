// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format width=80

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:connectivity_plus/connectivity_plus.dart' as _i895;
import 'package:device_info_plus/device_info_plus.dart' as _i833;
import 'package:get_it/get_it.dart' as _i174;
import 'package:injectable/injectable.dart' as _i526;
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart'
    as _i161;

import '../../data/datasources/local/cc_device_local_data_source.dart' as _i627;
import '../../data/datasources/remote/cc_sdk_remote_data_source.dart' as _i536;
import '../../data/repositories/cc_sdk_repository_impl.dart' as _i489;
import '../helper/cc_network_helper.dart' as _i260;
import '../network/network_info.dart' as _i932;
import 'module/dependencies.dart' as _i264;

extension GetItInjectableX on _i174.GetIt {
  // initializes the registration of main-scope dependencies inside of GetIt
  _i174.GetIt init({
    String? environment,
    _i526.EnvironmentFilter? environmentFilter,
  }) {
    final gh = _i526.GetItHelper(this, environment, environmentFilter);
    final ccSdkDependencies = _$CcSdkDependencies();
    gh.singleton<_i161.InternetConnection>(
      () => ccSdkDependencies.internetConnection,
    );
    gh.singleton<_i895.Connectivity>(() => ccSdkDependencies.connectivity);
    gh.singleton<_i833.DeviceInfoPlugin>(
      () => ccSdkDependencies.deviceInfoPlugin,
    );
    gh.singleton<_i932.NetworkInfo>(
      () => _i932.NetworkInfoImpl(gh<_i895.Connectivity>()),
    );
    gh.lazySingleton<_i627.CcDeviceLocalDataSource>(
      () => _i627.CcDeviceLocalDataSourceImpl(
        deviceInfoPlugin: gh<_i833.DeviceInfoPlugin>(),
      ),
    );
    gh.singleton<_i260.CcNetworkHelper>(
      () => _i260.CcNetworkHelper(gh<_i161.InternetConnection>()),
    );
    gh.factory<_i489.CCSDKRepositoryImpl>(
      () => _i489.CCSDKRepositoryImpl(
        remoteDataSource: gh<_i536.CCSDKRemoteDataSource>(),
        deviceLocalDataSource: gh<_i627.CcDeviceLocalDataSource>(),
        networkInfo: gh<_i932.NetworkInfo>(),
      ),
    );
    return this;
  }
}

class _$CcSdkDependencies extends _i264.CcSdkDependencies {}
