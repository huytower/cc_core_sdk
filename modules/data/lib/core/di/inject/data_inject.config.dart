// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format width=80

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:data/core/di/module/data_module.dart' as _i532;
import 'package:data/data/datasource/remote/comment/comment_remote.dart'
    as _i574;
import 'package:data/data/datasource/remote/crash_log/crash_log_remote.dart'
    as _i313;
import 'package:data/data/datasource/remote/sample_code_fake_api/sample_code_fake_api_remote.dart'
    as _i198;
import 'package:data/data/repositories/comment/comment_repository_impl.dart'
    as _i576;
import 'package:data/data/repositories/crash_log/crash_log_repository_impl.dart'
    as _i701;
import 'package:data/domain/repositories/comment/comment_repository.dart'
    as _i683;
import 'package:data/domain/repositories/crash_log/crash_log_repository.dart'
    as _i63;
import 'package:data/domain/repositories/sample_code_fake_api/sample_code_fake_api_repositories.dart'
    as _i872;
import 'package:data/domain/usecases/upload_pending_crash_logs_usecase.dart'
    as _i813;
import 'package:dio/dio.dart' as _i361;
import 'package:get_it/get_it.dart' as _i174;
import 'package:injectable/injectable.dart' as _i526;

extension GetItInjectableX on _i174.GetIt {
  // initializes the registration of main-scope dependencies inside of GetIt
  _i174.GetIt $initModuleGetIt({
    String? environment,
    _i526.EnvironmentFilter? environmentFilter,
  }) {
    final gh = _i526.GetItHelper(this, environment, environmentFilter);
    final dataModule = _$DataModule();
    gh.singleton<Iterable<_i361.Interceptor>>(() => dataModule.ccInterceptors);
    gh.singleton<_i361.Interceptor>(() => dataModule.ccReqInterceptors);
    gh.lazySingleton<_i198.SampleCodeFakeApiRemote>(
      () => _i198.SampleCodeFakeApiRemote(
        gh<_i361.Dio>(),
        baseUrl: gh<String>(instanceName: 'baseUrl'),
      ),
    );
    gh.factory<Map<String, dynamic>>(
      () => dataModule.wrapListResponse(gh<List<dynamic>>()),
    );
    gh.lazySingleton<_i872.SampleCodeFakeApiRepositories>(
      () => _i872.SampleCodeFakeApiImpl(
        dio: gh<_i361.Dio>(),
        remote: gh<_i198.SampleCodeFakeApiRemote>(),
      ),
    );
    gh.factory<String>(() => dataModule.baseUrl, instanceName: 'baseUrl');
    gh.singleton<_i361.Dio>(
      () => dataModule.dio(gh<String>(instanceName: 'baseUrl')),
      instanceName: 'baseDio',
    );
    gh.singleton<_i574.CommentRemote>(
      () => _i574.CommentRemote(gh<_i361.Dio>(instanceName: 'baseDio')),
    );
    gh.singleton<_i683.CommentRepository>(
      () =>
          _i576.CommentRepositoryImpl(commentRemote: gh<_i574.CommentRemote>()),
    );
    gh.lazySingleton<_i313.CrashLogRemote>(
      () => _i313.CrashLogRemote(gh<_i361.Dio>(instanceName: 'baseDio')),
    );
    gh.lazySingleton<_i63.CrashLogRepository>(
      () => _i701.CrashLogRepositoryImpl(gh<_i313.CrashLogRemote>()),
    );
    gh.lazySingleton<_i813.UploadPendingCrashLogsUseCase>(
      () => _i813.UploadPendingCrashLogsUseCase(gh<_i63.CrashLogRepository>()),
    );
    return this;
  }
}

class _$DataModule extends _i532.DataModule {}
