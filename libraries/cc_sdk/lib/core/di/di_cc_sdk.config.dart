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
import 'package:dio/dio.dart' as _i361;
import 'package:get_it/get_it.dart' as _i174;
import 'package:injectable/injectable.dart' as _i526;
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart'
    as _i161;

import '../../data/datasources/local/cc_device_local_data_source.dart' as _i627;
import '../../data/datasources/remote/cc_sdk_remote_data_source.dart' as _i536;
import '../../data/repositories/cc_sdk_repository_impl.dart' as _i489;
import '../../domain/repositories/cc_sdk_repository.dart' as _i893;
import '../helper/cc_network_helper.dart' as _i260;
import '../network/network_info.dart' as _i932;
import 'module/dependencies.dart' as _i264;

// initializes the registration of main-scope dependencies inside of GetIt
_i174.GetIt $initCcSdkDependencies(
  _i174.GetIt getIt, {
  String? environment,
  _i526.EnvironmentFilter? environmentFilter,
}) {
  final gh = _i526.GetItHelper(getIt, environment, environmentFilter);
  final ccSdkModule = _$CcSdkModule();
  gh.singleton<_i361.Dio>(() => ccSdkModule.dio);
  gh.singleton<_i161.InternetConnection>(() => ccSdkModule.internetConnection);
  gh.singleton<_i895.Connectivity>(() => ccSdkModule.connectivity);
  gh.singleton<_i833.DeviceInfoPlugin>(() => ccSdkModule.deviceInfoPlugin);
  gh.lazySingleton<_i627.CcDeviceLocalDataSource>(
    () => ccSdkModule.deviceLocalDataSource(gh<_i833.DeviceInfoPlugin>()),
  );
  gh.singleton<_i932.NetworkInfo>(
    () => ccSdkModule.networkInfo(gh<_i895.Connectivity>()),
  );
  gh.lazySingleton<_i536.CCSDKRemoteDataSource>(
    () => _i536.CCSDKRemoteDataSourceImpl(dio: gh<_i361.Dio>()),
  );
  gh.singleton<_i260.CcNetworkHelper>(
    () => ccSdkModule.networkHelper(gh<_i161.InternetConnection>()),
  );
  gh.lazySingleton<_i893.CCSDKRepository>(
    () => _i489.CCSDKRepositoryImpl(
      remoteDataSource: gh<_i536.CCSDKRemoteDataSource>(),
      deviceLocalDataSource: gh<_i627.CcDeviceLocalDataSource>(),
      networkInfo: gh<_i932.NetworkInfo>(),
    ),
  );
  return getIt;
}

class _$CcSdkModule extends _i264.CcSdkModule {}
