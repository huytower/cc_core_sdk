// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:data/config/di/module/data_module.dart' as _i291;
import 'package:data/datasource/remote/sample_code_fake_api/sample_code_fake_api_remote.dart' as _i326;
import 'package:data/helper/session_helper.dart' as _i29;
import 'package:data/repositories/sample_code_fake_api/sample_code_fake_api_repositories.dart' as _i821;
import 'package:dio/dio.dart' as _i361;
import 'package:get_it/get_it.dart' as _i174;
import 'package:injectable/injectable.dart' as _i526;

extension GetItInjectableX on _i174.GetIt {
// initializes the registration of main-scope dependencies inside of GetIt
  _i174.GetIt $initModuleGetIt({
    String? environment,
    _i526.EnvironmentFilter? environmentFilter,
  }) {
    final gh = _i526.GetItHelper(
      this,
      environment,
      environmentFilter,
    );
    final dataModule = _$DataModule();
    gh.singleton<_i29.SessionHelper>(() => _i29.SessionHelper());
    gh.factory<String>(
      () => dataModule.baseUrlOther,
      instanceName: 'baseUrlOther',
    );
    gh.factory<String>(
      () => dataModule.baseUrl,
      instanceName: 'baseUrl',
    );
    gh.singleton<_i361.Dio>(() => dataModule.dio(gh<String>(instanceName: 'baseUrl')));
    gh.lazySingleton<_i326.SampleCodeFakeApiRemote>(() => _i326.SampleCodeFakeApiRemote(
          gh<_i361.Dio>(),
          baseUrl: gh<String>(instanceName: 'baseUrl'),
        ));
    gh.lazySingleton<_i821.SampleCodeFakeApiRepositories>(() => _i821.SampleCodeFakeApiImpl(
          dio: gh<_i361.Dio>(),
          remote: gh<_i326.SampleCodeFakeApiRemote>(),
        ));
    return this;
  }
}

class _$DataModule extends _i291.DataModule {}
