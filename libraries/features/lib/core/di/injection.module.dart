// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'dart:async' as _i687;

import 'package:features/auth/biometric/data/datasources/local/cc_biometric_auth_datasource.dart'
    as _i820;
import 'package:features/auth/biometric/data/repositories/cc_biometric_auth_repository_impl.dart'
    as _i507;
import 'package:features/auth/biometric/domain/repositories/cc_biometric_auth_repository.dart'
    as _i85;
import 'package:features/auth/biometric/domain/usecases/cc_authenticate_with_biometrics.dart'
    as _i142;
import 'package:features/auth/biometric/presentation/bloc/biometric_bloc.dart'
    as _i18;
import 'package:features/counter/data/datasources/counter_local_data_source.dart'
    as _i785;
import 'package:features/counter/data/repositories/counter_repository_impl.dart'
    as _i784;
import 'package:features/counter/domain/repositories/counter_repository.dart'
    as _i598;
import 'package:features/counter/domain/usecases/get_counter_use_case.dart'
    as _i371;
import 'package:features/counter/domain/usecases/increment_counter_use_case.dart'
    as _i696;
import 'package:features/counter/presentation/bloc/counter_bloc.dart' as _i433;
import 'package:injectable/injectable.dart' as _i526;
import 'package:shared_preferences/shared_preferences.dart' as _i460;

class FeaturesPackageModule extends _i526.MicroPackageModule {
// initializes the registration of main-scope dependencies inside of GetIt
  @override
  _i687.FutureOr<void> init(_i526.GetItHelper gh) {
    gh.lazySingleton<_i820.CcBiometricAuthDatasource>(
        () => _i820.CcBiometricAuthDatasource());
    gh.lazySingleton<_i85.CcBiometricAuthRepository>(() =>
        _i507.CcBiometricAuthRepositoryImpl(
            gh<_i820.CcBiometricAuthDatasource>()));
    gh.lazySingleton<_i785.CounterLocalDataSource>(() =>
        _i785.CounterLocalDataSourceImpl(
            sharedPreferences: gh<_i460.SharedPreferences>()));
    gh.lazySingleton<_i142.CcAuthenticateWithBiometrics>(() =>
        _i142.CcAuthenticateWithBiometrics(
            gh<_i85.CcBiometricAuthRepository>()));
    gh.lazySingleton<_i598.CounterRepository>(() => _i784.CounterRepositoryImpl(
        localDataSource: gh<_i785.CounterLocalDataSource>()));
    gh.factory<_i18.BiometricBloc>(() => _i18.BiometricBloc(
          gh<_i142.CcAuthenticateWithBiometrics>(),
          gh<_i85.CcBiometricAuthRepository>(),
        ));
    gh.lazySingleton<_i371.GetCounterUseCase>(
        () => _i371.GetCounterUseCase(gh<_i598.CounterRepository>()));
    gh.lazySingleton<_i696.IncrementCounterUseCase>(
        () => _i696.IncrementCounterUseCase(gh<_i598.CounterRepository>()));
    gh.factory<_i433.CounterBloc>(() => _i433.CounterBloc(
          getCounterUseCase: gh<_i371.GetCounterUseCase>(),
          incrementCounterUseCase: gh<_i696.IncrementCounterUseCase>(),
        ));
  }
}
