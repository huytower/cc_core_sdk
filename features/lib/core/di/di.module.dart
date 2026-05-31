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
import 'package:features/features/counter/data/datasources/counter_local_data_source.dart'
    as _i19;
import 'package:features/features/counter/data/repositories/counter_repository_impl.dart'
    as _i345;
import 'package:features/features/counter/domain/repositories/counter_repository.dart'
    as _i112;
import 'package:features/features/counter/domain/usecases/decrement_counter_use_case.dart'
    as _i678;
import 'package:features/features/counter/domain/usecases/get_counter_use_case.dart'
    as _i476;
import 'package:features/features/counter/domain/usecases/increment_counter_use_case.dart'
    as _i827;
import 'package:features/features/counter/presentation/bloc/counter_bloc.dart'
    as _i8;
import 'package:features/features/web/presentation/cubit/web_cubit.dart'
    as _i312;
import 'package:injectable/injectable.dart' as _i526;
import 'package:shared_preferences/shared_preferences.dart' as _i460;

class FeaturesPackageModule extends _i526.MicroPackageModule {
// initializes the registration of main-scope dependencies inside of GetIt
  @override
  _i687.FutureOr<void> init(_i526.GetItHelper gh) {
    gh.lazySingleton<_i820.CcBiometricAuthDatasource>(
        () => _i820.CcBiometricAuthDatasource());
    gh.lazySingleton<_i312.WebCubit>(() => _i312.WebCubit());
    gh.lazySingleton<_i85.CcBiometricAuthRepository>(() =>
        _i507.CcBiometricAuthRepositoryImpl(
            gh<_i820.CcBiometricAuthDatasource>()));
    gh.lazySingleton<_i19.CounterLocalDataSource>(() =>
        _i19.CounterLocalDataSourceImpl(
            sharedPreferences: gh<_i460.SharedPreferences>()));
    gh.lazySingleton<_i112.CounterRepository>(() => _i345.CounterRepositoryImpl(
        localDataSource: gh<_i19.CounterLocalDataSource>()));
    gh.lazySingleton<_i678.DecrementCounterUseCase>(
        () => _i678.DecrementCounterUseCase(gh<_i112.CounterRepository>()));
    gh.lazySingleton<_i476.GetCounterUseCase>(
        () => _i476.GetCounterUseCase(gh<_i112.CounterRepository>()));
    gh.lazySingleton<_i827.IncrementCounterUseCase>(
        () => _i827.IncrementCounterUseCase(gh<_i112.CounterRepository>()));
    gh.lazySingleton<_i142.CcAuthenticateWithBiometrics>(() =>
        _i142.CcAuthenticateWithBiometrics(
            gh<_i85.CcBiometricAuthRepository>()));
    gh.factory<_i18.BiometricBloc>(() => _i18.BiometricBloc(
          gh<_i142.CcAuthenticateWithBiometrics>(),
          gh<_i85.CcBiometricAuthRepository>(),
        ));
    gh.factory<_i8.CounterBloc>(() => _i8.CounterBloc(
          getCounterUseCase: gh<_i476.GetCounterUseCase>(),
          incrementCounterUseCase: gh<_i827.IncrementCounterUseCase>(),
          decrementCounterUseCase: gh<_i678.DecrementCounterUseCase>(),
        ));
  }
}
