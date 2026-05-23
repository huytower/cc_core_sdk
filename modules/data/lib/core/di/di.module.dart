// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'dart:async' as _i687;

import 'package:data/core/di/module/data_module.dart' as _i532;
import 'package:data/data/datasource/local/home/home_local_datasource.dart'
    as _i199;
import 'package:data/data/datasource/local/home/home_local_datasource_impl.dart'
    as _i419;
import 'package:data/data/datasource/remote/comment/comment_remote.dart'
    as _i574;
import 'package:data/data/datasource/remote/crash_log/crash_log_remote.dart'
    as _i313;
import 'package:data/data/datasource/remote/home/home_remote.dart' as _i516;
import 'package:data/data/datasource/remote/home/home_remote_datasource.dart'
    as _i67;
import 'package:data/data/datasource/remote/home/home_remote_datasource_impl.dart'
    as _i848;
import 'package:data/data/datasource/remote/sample_code_fake_api/sample_code_fake_api_remote.dart'
    as _i198;
import 'package:data/data/repositories/comment/comment_repository_impl.dart'
    as _i576;
import 'package:data/data/repositories/crash_log/crash_log_repository_impl.dart'
    as _i701;
import 'package:data/data/repositories/home/home_repository_impl.dart' as _i114;
import 'package:data/domain/repositories/comment/comment_repository.dart'
    as _i683;
import 'package:data/domain/repositories/crash_log/crash_log_repository.dart'
    as _i63;
import 'package:data/domain/repositories/home/home_repositories.dart' as _i2;
import 'package:data/domain/repositories/home/home_repository.dart' as _i515;
import 'package:data/domain/repositories/sample_code_fake_api/sample_code_fake_api_repositories.dart'
    as _i872;
import 'package:data/domain/usecases/home/get_home_data_usecase.dart' as _i5;
import 'package:data/domain/usecases/home/refresh_home_data_usecase.dart'
    as _i176;
import 'package:data/domain/usecases/home/update_home_data_usecase.dart'
    as _i15;
import 'package:data/domain/usecases/upload_pending_crash_logs_usecase.dart'
    as _i813;
import 'package:dio/dio.dart' as _i361;
import 'package:injectable/injectable.dart' as _i526;
import 'package:shared_preferences/shared_preferences.dart' as _i460;

class DataPackageModule extends _i526.MicroPackageModule {
// initializes the registration of main-scope dependencies inside of GetIt
  @override
  _i687.FutureOr<void> init(_i526.GetItHelper gh) {
    final dataModule = _$DataModule();
    gh.singleton<Iterable<_i361.Interceptor>>(() => dataModule.ccInterceptors);
    gh.singleton<_i361.Interceptor>(() => dataModule.ccReqInterceptors);
    gh.lazySingleton<_i198.SampleCodeFakeApiRemote>(
        () => _i198.SampleCodeFakeApiRemote(
              gh<_i361.Dio>(),
              baseUrl: gh<String>(instanceName: 'baseUrl'),
            ));
    gh.factory<Map<String, dynamic>>(
        () => dataModule.wrapListResponse(gh<List<dynamic>>()));
    gh.lazySingleton<_i872.SampleCodeFakeApiRepositories>(
        () => _i872.SampleCodeFakeApiImpl(
              dio: gh<_i361.Dio>(),
              remote: gh<_i198.SampleCodeFakeApiRemote>(),
            ));
    gh.factory<String>(
      () => dataModule.baseUrl,
      instanceName: 'baseUrl',
    );
    gh.lazySingleton<_i67.HomeRemoteDataSource>(
        () => const _i848.HomeRemoteDataSourceImpl());
    gh.lazySingleton<_i199.HomeLocalDataSource>(
        () => _i419.HomeLocalDataSourceImpl(gh<_i460.SharedPreferences>()));
    gh.singleton<_i361.Dio>(
      () => dataModule.dio(gh<String>(instanceName: 'baseUrl')),
      instanceName: 'baseDio',
    );
    gh.factory<_i516.HomeRemote>(
        () => _i516.HomeRemote(gh<_i361.Dio>(instanceName: 'baseDio')));
    gh.singleton<_i574.CommentRemote>(
        () => _i574.CommentRemote(gh<_i361.Dio>(instanceName: 'baseDio')));
    gh.singleton<_i683.CommentRepository>(() =>
        _i576.CommentRepositoryImpl(commentRemote: gh<_i574.CommentRemote>()));
    gh.lazySingleton<_i515.HomeRepository>(() => _i114.HomeRepositoryImpl(
          localDataSource: gh<_i199.HomeLocalDataSource>(),
          remoteDataSource: gh<_i67.HomeRemoteDataSource>(),
        ));
    gh.factory<_i2.HomeRepositoriesImpl>(() => _i2.HomeRepositoriesImpl(
          dio: gh<_i361.Dio>(),
          homeRemote: gh<_i516.HomeRemote>(),
        ));
    gh.lazySingleton<_i313.CrashLogRemote>(
        () => _i313.CrashLogRemote(gh<_i361.Dio>(instanceName: 'baseDio')));
    gh.lazySingleton<_i5.GetHomeDataUseCase>(
        () => _i5.GetHomeDataUseCase(gh<_i515.HomeRepository>()));
    gh.lazySingleton<_i176.RefreshHomeDataUseCase>(
        () => _i176.RefreshHomeDataUseCase(gh<_i515.HomeRepository>()));
    gh.lazySingleton<_i15.UpdateHomeDataUseCase>(
        () => _i15.UpdateHomeDataUseCase(gh<_i515.HomeRepository>()));
    gh.lazySingleton<_i63.CrashLogRepository>(
        () => _i701.CrashLogRepositoryImpl(gh<_i313.CrashLogRemote>()));
    gh.lazySingleton<_i813.UploadPendingCrashLogsUseCase>(() =>
        _i813.UploadPendingCrashLogsUseCase(gh<_i63.CrashLogRepository>()));
  }
}

class _$DataModule extends _i532.DataModule {}
