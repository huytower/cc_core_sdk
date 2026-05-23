// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format width=80

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:app_config/core/di/di.module.dart' as _i418;
import 'package:cc_sdk/core/di/di.module.dart' as _i915;
import 'package:cc_sdk/core/helper/device_info_service.dart' as _i474;
import 'package:cc_sdk/export_cc_sdk.dart' as _i54;
import 'package:data/core/di/di.module.dart' as _i658;
import 'package:data/domain/repositories/comment/comment_repository.dart'
    as _i683;
import 'package:data/domain/repositories/sample_code_fake_api/sample_code_fake_api_repositories.dart'
    as _i872;
import 'package:data/domain/usecases/home/get_home_data_usecase.dart' as _i5;
import 'package:data/domain/usecases/home/refresh_home_data_usecase.dart'
    as _i176;
import 'package:data/domain/usecases/home/update_home_data_usecase.dart'
    as _i15;
import 'package:features/core/di/di.module.dart' as _i102;
import 'package:get_it/get_it.dart' as _i174;
import 'package:injectable/injectable.dart' as _i526;
import 'package:theme/presentation/provider/theme_provider.dart' as _i577;

import '../../../data/datasource/route_strategy.dart' as _i278;
import '../../../examples/bloc_simple_page/cubit/simple/simple_cubit.dart'
    as _i168;
import '../../../examples/bloc_simple_page/cubit/simple/simple_cubit_interface.dart'
    as _i571;
import '../../../examples/bloc_simple_page/origin/advance/advance_bloc.dart'
    as _i74;
import '../../../examples/getx_simple_page/way_1/getx/get_view_controller.dart'
    as _i600;
import '../../../presentation/getx/comment/get_x/comment_controller.dart'
    as _i551;
import '../../../presentation/getx/web/get_x/web_controller.dart' as _i523;
import '../../../presentation/home/presentation/bloc/home_bloc.dart' as _i336;
import '../../common/managers/hive_manager.dart' as _i942;
import '../module/infrastructure_module.dart' as _i450;
import '../module/route_strategy_module.dart' as _i324;

extension GetItInjectableX on _i174.GetIt {
  // initializes the registration of main-scope dependencies inside of GetIt
  Future<_i174.GetIt> init({
    String? environment,
    _i526.EnvironmentFilter? environmentFilter,
  }) async {
    final gh = _i526.GetItHelper(this, environment, environmentFilter);
    await _i915.CcSdkPackageModule().init(gh);
    await _i658.DataPackageModule().init(gh);
    await _i418.AppConfigPackageModule().init(gh);
    await _i102.FeaturesPackageModule().init(gh);
    final routeStrategyModule = _$RouteStrategyModule();
    final infrastructureModule = _$InfrastructureModule();
    gh.factory<_i600.GetViewBinding>(() => _i600.GetViewBinding());
    gh.factory<_i551.CommentBinding>(() => _i551.CommentBinding());
    gh.factory<_i523.WebBinding>(() => _i523.WebBinding());
    gh.factory<_i523.WebController>(() => _i523.WebController());
    gh.lazySingleton<_i942.HiveManager>(
      () => _i942.HiveManager(),
      dispose: (i) => i.closeBoxes(),
    );
    gh.lazySingleton<_i577.ThemeProvider>(
      () => routeStrategyModule.provideThemeProvider(),
    );
    gh.lazySingleton<_i74.AdvanceBloc>(
      () => _i74.AdvanceBloc(),
      dispose: (i) => i.close(),
    );
    gh.lazySingleton<_i571.SimpleCubitInterface>(
      () => _i168.SimpleCubit(),
      dispose: (i) => i.close(),
    );
    gh.lazySingleton<_i278.RoutingStrategy>(
      () => _i278.AutoRouteStrategy(gh<_i577.ThemeProvider>()),
    );
    await gh.singletonAsync<_i54.CcDeviceEntity>(
      () => infrastructureModule.deviceModel(gh<_i474.DeviceInfoService>()),
      preResolve: true,
    );
    gh.lazySingleton<_i600.GetViewController>(
      () => _i600.GetViewController(
        repository: gh<_i872.SampleCodeFakeApiImpl>(),
      ),
      dispose: (i) => i.onClose(),
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

class _$RouteStrategyModule extends _i324.RouteStrategyModule {}

class _$InfrastructureModule extends _i450.InfrastructureModule {}
