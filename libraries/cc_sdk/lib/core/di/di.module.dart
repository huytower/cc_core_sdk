// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'dart:async' as _i687;

import 'package:cc_sdk/core/di/module/dependencies.dart' as _i675;
import 'package:cc_sdk/core/helper/device_helper.dart' as _i208;
import 'package:cc_sdk/core/helper/device_info_helper.dart' as _i514;
import 'package:cc_sdk/core/helper/network_helper.dart' as _i624;
import 'package:cc_sdk/core/network/network_info.dart' as _i36;
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
    gh.singleton<_i624.NetworkHelper>(
        () => _i624.NetworkHelper(gh<_i161.InternetConnection>()));
    gh.lazySingleton<_i514.DeviceInfoHelper>(
        () => _i514.DeviceInfoHelper(gh<_i833.DeviceInfoPlugin>()));
  }
}

class _$CcSdkDependencies extends _i675.CcSdkDependencies {}
