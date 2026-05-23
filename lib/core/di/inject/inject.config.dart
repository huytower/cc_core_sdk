// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format width=80

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:app_config/core/di/di_app_config.module.dart' as _i72;
import 'package:cc_sdk/core/di/di_cc_sdk.module.dart' as _i586;
import 'package:cc_sdk/export_cc_sdk.dart' as _i54;
import 'package:data/core/di/inject/data_inject.module.dart' as _i787;
import 'package:data/domain/repositories/comment/comment_repository.dart'
    as _i683;
import 'package:data/domain/repositories/sample_code_fake_api/sample_code_fake_api_repositories.dart'
    as _i872;
import 'package:data/domain/usecases/home/get_home_data_usecase.dart' as _i5;
import 'package:data/domain/usecases/home/refresh_home_data_usecase.dart'
    as _i176;
import 'package:data/domain/usecases/home/update_home_data_usecase.dart'
    as _i15;
import 'package:device_info_plus/device_info_plus.dart' as _i833;
import 'package:features/core/di/injection.module.dart' as _i168;
import 'package:get_it/get_it.dart' as _i174;
import 'package:injectable/injectable.dart' as _i526;
import 'package:theme/presentation/provider/theme_provider.dart' as _i901;

import '../../../data/datasource/route_strategy.dart' as _i602;
import '../../../presentation/getx/comment/get_x/comment_controller.dart'
    as _i551;
import '../../../presentation/getx/web/get_x/web_controller.dart' as _i523;
import '../../../presentation/home/presentation/bloc/home_bloc.dart' as _i336;
import '../../../sample_code/bloc_simple_page/cubit/simple/simple_cubit.dart'
    as _i271;
import '../../../sample_code/bloc_simple_page/cubit/simple/simple_cubit_interface.dart'
    as _i439;
import '../../../sample_code/bloc_simple_page/origin/advance/advance_bloc.dart'
    as _i403;
import '../../../sample_code/getx_simple_page/way_1/getx/get_view_controller.dart'
    as _i313;
import '../module/infrastructure_module.dart' as _i450;
import '../module/route_strategy_module.dart' as _i210;

extension GetItInjectableX on _i174.GetIt {
  // initializes the registration of main-scope dependencies inside of GetIt
  Future<_i174.GetIt> init({
    String? environment,
    _i526.EnvironmentFilter? environmentFilter,
  }) async {
    final gh = _i526.GetItHelper(this, environment, environmentFilter);
    await _i586.CcSdkPackageModule().init(gh);
    await _i787.DataPackageModule().init(gh);
    await _i72.AppConfigPackageModule().init(gh);
    await _i168.FeaturesPackageModule().init(gh);
    final infrastructureModule = _$InfrastructureModule();
    final routeStrategyModule = _$RouteStrategyModule();
    gh.factory<_i551.CommentBinding>(() => _i551.CommentBinding());
    gh.factory<_i523.WebBinding>(() => _i523.WebBinding());
    gh.factory<_i523.WebController>(() => _i523.WebController());
    gh.factory<_i313.GetViewBinding>(() => _i313.GetViewBinding());
    gh.lazySingleton<_i403.AdvanceBloc>(() => _i403.AdvanceBloc());
    gh.lazySingleton<_i439.SimpleCubitInterface>(() => _i271.SimpleCubit());
    gh.lazySingleton<_i901.ThemeProvider>(
      () => routeStrategyModule.provideThemeProvider(),
    );
    gh.lazySingleton<_i602.RoutingStrategy>(
      () => _i602.AutoRouteStrategy(gh<_i901.ThemeProvider>()),
    );
    await gh.singletonAsync<_i54.CcDeviceEntity>(
      () => infrastructureModule.deviceModel(gh<_i833.DeviceInfoPlugin>()),
      preResolve: true,
    );
    gh.lazySingleton<_i313.GetViewController>(
      () => _i313.GetViewController(
        repository: gh<_i872.SampleCodeFakeApiImpl>(),
      ),
    );
    gh.factory<_i551.CommentController>(
      () => _i551.CommentController(gh<_i683.CommentRepository>()),
    );
    gh.factory<_i336.HomeBloc>(
      () => _i336.HomeBloc(
        getHomeDataUseCase: gh<_i5.GetHomeDataUseCase>(),
        updateHomeDataUseCase: gh<_i15.UpdateHomeDataUseCase>(),
        refreshHomeDataUseCase: gh<_i176.RefreshHomeDataUseCase>(),
      ),
    );
    return this;
  }
}

class _$InfrastructureModule extends _i450.InfrastructureModule {}

class _$RouteStrategyModule extends _i210.RouteStrategyModule {}
