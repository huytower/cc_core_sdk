// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format width=80

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:dio/dio.dart' as _i361;
import 'package:get_it/get_it.dart' as _i174;
import 'package:injectable/injectable.dart' as _i526;
import 'package:shared_preferences/shared_preferences.dart' as _i460;

import '../../../data/datasource/local/home/home_local_datasource.dart'
    as _i773;
import '../../../data/datasource/local/home/home_local_datasource_impl.dart'
    as _i61;
import '../../../data/datasource/remote/comment/comment_remote.dart' as _i791;
import '../../../data/datasource/remote/crash_log/crash_log_remote.dart'
    as _i1016;
import '../../../data/datasource/remote/home/home_remote.dart' as _i65;
import '../../../data/datasource/remote/home/home_remote_datasource.dart'
    as _i165;
import '../../../data/datasource/remote/home/home_remote_datasource_impl.dart'
    as _i198;
import '../../../data/datasource/remote/sample_code_fake_api/sample_code_fake_api_remote.dart'
    as _i480;
import '../../../data/repositories/comment/comment_repository_impl.dart'
    as _i1070;
import '../../../data/repositories/crash_log/crash_log_repository_impl.dart'
    as _i1006;
import '../../../data/repositories/home/home_repository_impl.dart' as _i82;
import '../../../domain/repositories/comment/comment_repository.dart' as _i10;
import '../../../domain/repositories/crash_log/crash_log_repository.dart'
    as _i625;
import '../../../domain/repositories/home/home_repositories.dart' as _i159;
import '../../../domain/repositories/home/home_repository.dart' as _i212;
import '../../../domain/repositories/sample_code_fake_api/sample_code_fake_api_repositories.dart'
    as _i293;
import '../../../domain/usecases/home/get_home_data_usecase.dart' as _i658;
import '../../../domain/usecases/home/refresh_home_data_usecase.dart' as _i24;
import '../../../domain/usecases/home/update_home_data_usecase.dart' as _i196;
import '../../../domain/usecases/upload_pending_crash_logs_usecase.dart'
    as _i804;
import '../module/data_module.dart' as _i909;

extension GetItInjectableX on _i174.GetIt {
  // initializes the registration of main-scope dependencies inside of GetIt
  _i174.GetIt init({
    String? environment,
    _i526.EnvironmentFilter? environmentFilter,
  }) {
    final gh = _i526.GetItHelper(this, environment, environmentFilter);
    final dataModule = _$DataModule();
    gh.singleton<Iterable<_i361.Interceptor>>(() => dataModule.ccInterceptors);
    gh.singleton<_i361.Interceptor>(() => dataModule.ccReqInterceptors);
    gh.lazySingleton<_i480.SampleCodeFakeApiRemote>(
      () => _i480.SampleCodeFakeApiRemote(
        gh<_i361.Dio>(),
        baseUrl: gh<String>(instanceName: 'baseUrl'),
      ),
    );
    gh.factory<Map<String, dynamic>>(
      () => dataModule.wrapListResponse(gh<List<dynamic>>()),
    );
    gh.lazySingleton<_i293.SampleCodeFakeApiRepositories>(
      () => _i293.SampleCodeFakeApiImpl(
        dio: gh<_i361.Dio>(),
        remote: gh<_i480.SampleCodeFakeApiRemote>(),
      ),
    );
    gh.factory<String>(() => dataModule.baseUrl, instanceName: 'baseUrl');
    gh.lazySingleton<_i165.HomeRemoteDataSource>(
      () => const _i198.HomeRemoteDataSourceImpl(),
    );
    gh.factory<_i159.HomeRepositoriesImpl>(
      () => _i159.HomeRepositoriesImpl(
        dio: gh<_i361.Dio>(),
        homeRemote: gh<_i65.HomeRemote>(),
      ),
    );
    gh.lazySingleton<_i773.HomeLocalDataSource>(
      () => _i61.HomeLocalDataSourceImpl(gh<_i460.SharedPreferences>()),
    );
    gh.singleton<_i361.Dio>(
      () => dataModule.dio(gh<String>(instanceName: 'baseUrl')),
      instanceName: 'baseDio',
    );
    gh.singleton<_i791.CommentRemote>(
      () => _i791.CommentRemote(gh<_i361.Dio>(instanceName: 'baseDio')),
    );
    gh.singleton<_i10.CommentRepository>(
      () => _i1070.CommentRepositoryImpl(
        commentRemote: gh<_i791.CommentRemote>(),
      ),
    );
    gh.lazySingleton<_i212.HomeRepository>(
      () => _i82.HomeRepositoryImpl(
        localDataSource: gh<_i773.HomeLocalDataSource>(),
        remoteDataSource: gh<_i165.HomeRemoteDataSource>(),
      ),
    );
    gh.lazySingleton<_i1016.CrashLogRemote>(
      () => _i1016.CrashLogRemote(gh<_i361.Dio>(instanceName: 'baseDio')),
    );
    gh.lazySingleton<_i658.GetHomeDataUseCase>(
      () => _i658.GetHomeDataUseCase(gh<_i212.HomeRepository>()),
    );
    gh.lazySingleton<_i24.RefreshHomeDataUseCase>(
      () => _i24.RefreshHomeDataUseCase(gh<_i212.HomeRepository>()),
    );
    gh.lazySingleton<_i196.UpdateHomeDataUseCase>(
      () => _i196.UpdateHomeDataUseCase(gh<_i212.HomeRepository>()),
    );
    gh.lazySingleton<_i625.CrashLogRepository>(
      () => _i1006.CrashLogRepositoryImpl(gh<_i1016.CrashLogRemote>()),
    );
    gh.lazySingleton<_i804.UploadPendingCrashLogsUseCase>(
      () => _i804.UploadPendingCrashLogsUseCase(gh<_i625.CrashLogRepository>()),
    );
    return this;
  }
}

class _$DataModule extends _i909.DataModule {}
