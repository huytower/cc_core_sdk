// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'dart:async' as _i687;

import 'package:cc_sdk/core/di/module/dependencies.dart' as _i675;
import 'package:cc_sdk/core/helper/cc_network_helper.dart' as _i548;
import 'package:cc_sdk/core/helper/device_helper.dart' as _i208;
import 'package:cc_sdk/core/helper/device_info_service.dart' as _i474;
import 'package:cc_sdk/core/network/network_info.dart' as _i36;
import 'package:cc_sdk/core/utils/common/cc_device_info_service.dart' as _i252;
import 'package:cc_sdk/data/datasources/local/cc_device_local_data_source.dart'
    as _i1021;
import 'package:cc_sdk/data/datasources/remote/cc_sdk_remote_data_source.dart'
    as _i469;
import 'package:cc_sdk/data/repositories/cc_sdk_repository_impl.dart' as _i101;
import 'package:cc_sdk/domain/repositories/cc_sdk_repository.dart' as _i70;
import 'package:connectivity_plus/connectivity_plus.dart' as _i895;
import 'package:device_info_plus/device_info_plus.dart' as _i833;
import 'package:dio/dio.dart' as _i361;
import 'package:injectable/injectable.dart' as _i526;
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart'
    as _i161;
import 'package:shared_preferences/shared_preferences.dart' as _i460;

class CcSdkPackageModule extends _i526.MicroPackageModule {
// initializes the registration of main-scope dependencies inside of GetIt
  @override
  _i687.FutureOr<void> init(_i526.GetItHelper gh) async {
    final ccSdkDependencies = _$CcSdkDependencies();
    gh.factory<_i208.DeviceHelper>(() => _i208.DeviceHelper());
    await gh.singletonAsync<_i460.SharedPreferences>(
      () => ccSdkDependencies.sharedPreferences,
      preResolve: true,
    );
    gh.singleton<_i161.InternetConnection>(
        () => ccSdkDependencies.internetConnection);
    gh.singleton<_i895.Connectivity>(() => ccSdkDependencies.connectivity);
    gh.singleton<_i833.DeviceInfoPlugin>(
        () => ccSdkDependencies.deviceInfoPlugin);
    gh.singleton<_i36.NetworkInfo>(
        () => _i36.NetworkInfoImpl(gh<_i895.Connectivity>()));
    gh.lazySingleton<_i469.CCSDKRemoteDataSource>(
        () => _i469.CCSDKRemoteDataSourceImpl(dio: gh<_i361.Dio>()));
    gh.singleton<_i548.CcNetworkHelper>(
        () => _i548.CcNetworkHelper(gh<_i161.InternetConnection>()));
    gh.lazySingleton<_i474.DeviceInfoService>(
        () => _i474.DeviceInfoService(gh<_i833.DeviceInfoPlugin>()));
    gh.lazySingleton<_i252.CcDeviceInfoService>(
        () => _i252.CcDeviceInfoService(gh<_i833.DeviceInfoPlugin>()));
    gh.lazySingleton<_i1021.CcDeviceLocalDataSource>(() =>
        _i1021.CcDeviceLocalDataSourceImpl(
            deviceInfoService: gh<_i474.DeviceInfoService>()));
    gh.lazySingleton<_i70.CCSDKRepository>(() => _i101.CCSDKRepositoryImpl(
          remoteDataSource: gh<_i469.CCSDKRemoteDataSource>(),
          deviceLocalDataSource: gh<_i1021.CcDeviceLocalDataSource>(),
          networkInfo: gh<_i36.NetworkInfo>(),
        ));
  }
}

class _$CcSdkDependencies extends _i675.CcSdkDependencies {}
