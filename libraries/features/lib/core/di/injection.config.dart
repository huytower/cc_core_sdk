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
import 'package:shared_preferences/shared_preferences.dart' as _i460;

import '../../auth/biometric/data/datasources/local/cc_biometric_auth_datasource.dart'
    as _i382;
import '../../auth/biometric/data/repositories/cc_biometric_auth_repository_impl.dart'
    as _i960;
import '../../auth/biometric/domain/repositories/cc_biometric_auth_repository.dart'
    as _i100;
import '../../auth/biometric/domain/usecases/cc_authenticate_with_biometrics.dart'
    as _i693;
import '../../auth/biometric/presentation/bloc/biometric_bloc.dart' as _i596;
import '../../counter/data/datasources/counter_local_data_source.dart' as _i276;
import '../../counter/data/repositories/counter_repository_impl.dart' as _i104;
import '../../counter/domain/repositories/counter_repository.dart' as _i532;
import '../../counter/domain/usecases/get_counter_use_case.dart' as _i571;
import '../../counter/domain/usecases/increment_counter_use_case.dart' as _i405;
import '../../counter/presentation/bloc/counter_bloc.dart' as _i595;
import 'module/external_module.dart' as _i423;

extension GetItInjectableX on _i174.GetIt {
  // initializes the registration of main-scope dependencies inside of GetIt
  Future<_i174.GetIt> init({
    String? environment,
    _i526.EnvironmentFilter? environmentFilter,
  }) async {
    final gh = _i526.GetItHelper(this, environment, environmentFilter);
    final externalModule = _$ExternalModule();
    await gh.factoryAsync<_i460.SharedPreferences>(
      () => externalModule.sharedPreferences,
      preResolve: true,
    );
    gh.lazySingleton<_i382.CcBiometricAuthDatasource>(
      () => _i382.CcBiometricAuthDatasource(),
    );
    gh.lazySingleton<_i100.CcBiometricAuthRepository>(
      () => _i960.CcBiometricAuthRepositoryImpl(
        gh<_i382.CcBiometricAuthDatasource>(),
      ),
    );
    gh.lazySingleton<_i276.CounterLocalDataSource>(
      () => _i276.CounterLocalDataSourceImpl(
        sharedPreferences: gh<_i460.SharedPreferences>(),
      ),
    );
    gh.lazySingleton<_i693.CcAuthenticateWithBiometrics>(
      () => _i693.CcAuthenticateWithBiometrics(
        gh<_i100.CcBiometricAuthRepository>(),
      ),
    );
    gh.lazySingleton<_i532.CounterRepository>(
      () => _i104.CounterRepositoryImpl(
        localDataSource: gh<_i276.CounterLocalDataSource>(),
      ),
    );
    gh.factory<_i596.BiometricBloc>(
      () => _i596.BiometricBloc(
        gh<_i693.CcAuthenticateWithBiometrics>(),
        gh<_i100.CcBiometricAuthRepository>(),
      ),
    );
    gh.lazySingleton<_i571.GetCounterUseCase>(
      () => _i571.GetCounterUseCase(gh<_i532.CounterRepository>()),
    );
    gh.lazySingleton<_i405.IncrementCounterUseCase>(
      () => _i405.IncrementCounterUseCase(gh<_i532.CounterRepository>()),
    );
    gh.factory<_i595.CounterBloc>(
      () => _i595.CounterBloc(
        getCounterUseCase: gh<_i571.GetCounterUseCase>(),
        incrementCounterUseCase: gh<_i405.IncrementCounterUseCase>(),
      ),
    );
    return this;
  }
}

class _$ExternalModule extends _i423.ExternalModule {}
