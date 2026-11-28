// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes

import 'dart:async' as _i687;

import 'package:cc_sdk/core/di/module/cc_sdk_dependencies.dart' as _i581;
import 'package:cc_sdk/src/core/device/cc_device_info_service.dart' as _i10;
import 'package:cc_sdk/src/core/helper/cc_network_helper.dart' as _i614;
import 'package:cc_sdk/src/core/network/cc_network_info.dart' as _i100;
import 'package:cc_sdk/src/core/network/cc_network_info_impl.dart' as _i989;
import 'package:connectivity_plus/connectivity_plus.dart' as _i895;
import 'package:device_info_plus/device_info_plus.dart' as _i833;
import 'package:injectable/injectable.dart' as _i526;
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart'
    as _i161;
import 'package:shared_preferences/shared_preferences.dart' as _i460;

class CcSdkPackageModule extends _i526.MicroPackageModule {
// initializes the registration of main-scope dependencies inside of GetIt
  @override
  _i687.FutureOr<void> init(_i526.GetItHelper gh) async {
    final ccSdkDependencies = _$CcSdkDependencies();
    await gh.singletonAsync<_i460.SharedPreferences>(
      () => ccSdkDependencies.sharedPreferences,
      preResolve: true,
    );
    gh.lazySingleton<_i161.InternetConnection>(
        () => ccSdkDependencies.internetConnection);
    gh.lazySingleton<_i895.Connectivity>(() => ccSdkDependencies.connectivity);
    gh.lazySingleton<_i833.DeviceInfoPlugin>(
        () => ccSdkDependencies.deviceInfoPlugin);
    gh.lazySingleton<_i100.CcNetworkInfo>(
        () => _i989.CcNetworkInfoImpl(gh<_i895.Connectivity>()));
    gh.lazySingleton<_i614.CcNetworkHelper>(
        () => _i614.CcNetworkHelper(gh<_i161.InternetConnection>()));
    gh.lazySingleton<_i10.CcDeviceInfoService>(
        () => _i10.CcDeviceInfoService(gh<_i833.DeviceInfoPlugin>()));
  }
}

class _$CcSdkDependencies extends _i581.CcSdkDependencies {}
