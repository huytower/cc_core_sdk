// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format width=80

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:cc_sdk/export_cc_sdk.dart' as _i54;
import 'package:data/data/datasource/local/home/home_local_datasource.dart'
    as _i199;
import 'package:data/data/datasource/remote/home/home_remote_datasource.dart'
    as _i67;
import 'package:data/domain/repositories/home/home_repository.dart' as _i515;
import 'package:data/domain/repositories/sample_code_fake_api/sample_code_fake_api_repositories.dart'
    as _i872;
import 'package:data/domain/usecases/home/get_home_data_usecase.dart' as _i5;
import 'package:data/domain/usecases/home/refresh_home_data_usecase.dart'
    as _i176;
import 'package:data/domain/usecases/home/update_home_data_usecase.dart'
    as _i15;
import 'package:device_info_plus/device_info_plus.dart' as _i833;
import 'package:get_it/get_it.dart' as _i174;
import 'package:injectable/injectable.dart' as _i526;
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart'
    as _i161;
import 'package:mobile_flutter_template/core/di/module/infrastructure_module.dart'
    as _i809;
import 'package:mobile_flutter_template/presentation/home/di/home_dependency_module.dart'
    as _i283;
import 'package:mobile_flutter_template/presentation/home/presentation/bloc/home_bloc.dart'
    as _i1047;
import 'package:mobile_flutter_template/sample_code/bloc_simple_page/cubit/simple/simple_cubit.dart'
    as _i576;
import 'package:mobile_flutter_template/sample_code/bloc_simple_page/cubit/simple/simple_cubit_interface.dart'
    as _i312;
import 'package:mobile_flutter_template/sample_code/bloc_simple_page/origin/advance/advance_bloc.dart'
    as _i98;
import 'package:mobile_flutter_template/sample_code/getx_simple_page/way_1/getx/get_view_controller.dart'
    as _i866;

extension GetItInjectableX on _i174.GetIt {
  // initializes the registration of main-scope dependencies inside of GetIt
  Future<_i174.GetIt> $initGetIt({
    String? environment,
    _i526.EnvironmentFilter? environmentFilter,
  }) async {
    final gh = _i526.GetItHelper(this, environment, environmentFilter);
    final infrastructureModule = _$InfrastructureModule();
    final homeDependencyModule = _$HomeDependencyModule();
    gh.singleton<_i161.InternetConnection>(
      () => infrastructureModule.connectionChecker,
    );
    gh.singleton<_i833.DeviceInfoPlugin>(
      () => infrastructureModule.deviceInfoPlugin,
    );
    await gh.singletonAsync<_i54.CcDeviceEntity>(
      () => infrastructureModule.deviceModel,
      preResolve: true,
    );
    gh.lazySingleton<_i199.HomeLocalDataSource>(
      () => homeDependencyModule.homeLocalDataSource,
    );
    gh.lazySingleton<_i67.HomeRemoteDataSource>(
      () => homeDependencyModule.homeRemoteDataSource,
    );
    gh.lazySingleton<_i515.HomeRepository>(
      () => homeDependencyModule.homeRepository,
    );
    gh.lazySingleton<_i5.GetHomeDataUseCase>(
      () => homeDependencyModule.getHomeDataUseCase,
    );
    gh.lazySingleton<_i15.UpdateHomeDataUseCase>(
      () => homeDependencyModule.updateHomeDataUseCase,
    );
    gh.lazySingleton<_i176.RefreshHomeDataUseCase>(
      () => homeDependencyModule.refreshHomeDataUseCase,
    );
    gh.lazySingleton<_i98.AdvanceBloc>(() => _i98.AdvanceBloc());
    gh.lazySingleton<_i312.SimpleCubitInterface>(() => _i576.SimpleCubit());
    gh.lazySingleton<_i866.GetViewController>(
      () => _i866.GetViewController(
        repository: gh<_i872.SampleCodeFakeApiImpl>(),
      ),
    );
    gh.factory<_i1047.HomeBloc>(
      () => _i1047.HomeBloc(
        getHomeDataUseCase: gh<_i5.GetHomeDataUseCase>(),
        updateHomeDataUseCase: gh<_i15.UpdateHomeDataUseCase>(),
        refreshHomeDataUseCase: gh<_i176.RefreshHomeDataUseCase>(),
      ),
    );
    return this;
  }
}

class _$InfrastructureModule extends _i809.InfrastructureModule {}

class _$HomeDependencyModule extends _i283.HomeDependencyModule {}
