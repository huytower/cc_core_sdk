// dart format width=80
// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:data/repositories/sample_code_fake_api/sample_code_fake_api_repositories.dart' as _i821;
import 'package:get_it/get_it.dart' as _i174;
import 'package:injectable/injectable.dart' as _i526;
import 'package:internet_connection_checker/internet_connection_checker.dart' as _i973;
import 'package:mobile_flutter_template/src/core/di/module/app_module.dart' as _i460;
import 'package:mobile_flutter_template/src/core/helper/network_helper.dart' as _i803;
import 'package:mobile_flutter_template/src/presentation/app_track_log/logic/app_track_log_logic.dart' as _i93;
import 'package:mobile_flutter_template/src/presentation/base/sample_code/bloc_simple_page/cubit/simple/simple_cubit.dart'
    as _i469;
import 'package:mobile_flutter_template/src/presentation/base/sample_code/bloc_simple_page/origin/advance/advance_bloc.dart'
    as _i872;
import 'package:mobile_flutter_template/src/presentation/base/sample_code/getx_simple_page/way_1/getx/get_view_controller.dart'
    as _i430;
import 'package:mobile_flutter_template/src/presentation/base/sample_code/watch_it_simple_page/way_1/logic/component_watch_it_logic.dart'
    as _i76;
import 'package:mobile_flutter_template/src/presentation/base/sample_code/watch_it_simple_page/way_2/logic/component_watch_it_v2_logic.dart'
    as _i1030;

extension GetItInjectableX on _i174.GetIt {
// initializes the registration of main-scope dependencies inside of GetIt
  _i174.GetIt $initGetIt({
    String? environment,
    _i526.EnvironmentFilter? environmentFilter,
  }) {
    final gh = _i526.GetItHelper(
      this,
      environment,
      environmentFilter,
    );
    final appModule = _$AppModule();
    gh.singleton<_i973.InternetConnectionChecker>(() => appModule.connectionChecker);
    gh.lazySingleton<_i93.AppTrackLogLogic>(() => _i93.AppTrackLogLogic());
    gh.lazySingleton<_i469.SimpleCubit>(() => _i469.SimpleCubit());
    gh.lazySingleton<_i872.AdvanceBloc>(() => _i872.AdvanceBloc());
    gh.lazySingleton<_i76.ComponentWatchItLogic>(() => _i76.ComponentWatchItLogic());
    gh.lazySingleton<_i1030.ComponentWatchItV2Logic>(() => _i1030.ComponentWatchItV2Logic());
    gh.lazySingleton<_i430.GetViewController>(
        () => _i430.GetViewController(repository: gh<_i821.SampleCodeFakeApiImpl>()));
    gh.singleton<_i803.NetworkHelper>(() => _i803.NetworkHelper(gh<_i973.InternetConnectionChecker>()));
    return this;
  }
}

class _$AppModule extends _i460.AppModule {}
